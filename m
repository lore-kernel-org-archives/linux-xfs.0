Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2093264F2
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291889; cv=none; b=t6mNdih0uIOFYYqcyVDACGUNU9E5UFWseGnn2ZlrE9D99laQhjyh1NB7qejd9wycbFIvB5gvQDSRTEkcUO73a0zWGeTT7hbbMGbJUmS8Dd3LB6YpRrQ3GTvrtnDLbWelcWInClhZXpVKErSnh3hF1a2stGcct91n1NKDOgR4aXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291889; c=relaxed/simple;
	bh=McbFJjlnBD3s7GE85X21dqa9hZuj1j/iQ6TneRqZ6Zk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=olQ3sixNeE6fOe+1muVwkBsYLSbmr9u7sSQCPgjQzqCNeG1piTT3gx5pVQXx+L81qofFcME5eTwBShbJwyuaK0kxVVNfLSfYuIRzwNxUjhjrT0kcOcV4zhxtYY3S+G9AbMxYAfxK7KDGr6/T1nUiRY9UGPd9tz9w9SrK+5yUAE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RD9b5Xbc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RD9b5Xbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E141EC4CEF7;
	Mon, 23 Mar 2026 18:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291888;
	bh=McbFJjlnBD3s7GE85X21dqa9hZuj1j/iQ6TneRqZ6Zk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RD9b5Xbc+Oxuhm9cjI+R4YRTC0JzT/ZGB66UWMSNdDek98XzPWNIBt6garz2C+2Lo
	 zyuucBrnPwpm7ABfq0sSbGxPlznGp8gWnVefPTrImDsBG/ZPO6bt99vDkBhf9BzMMk
	 2kJ1WtwT5DaugpyDoBXgtjV5B7sZg1wxr+eBYs1umDO2VBclUyT8cY4PFzMxIOF3FZ
	 kprOattu/7l/pJImle+QuecUpCTnxL5E6XfLwjQlHCD7aspxISQ6bVBo1brMYNWIv/
	 Bqvj2dZ52fADNEwLC4FIAdR6RFhIFYokf6ZCBDPcz96xzDcYWv5mtphfpBk+ncQ/do
	 BJG/D3zrQC98Q==
Date: Mon, 23 Mar 2026 11:51:28 -0700
Subject: [PATCH 39/40] xfs: Remove redundant NULL check after __GFP_NOFAIL
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, hch@lst.de, hongao@uniontech.com,
 linux-xfs@vger.kernel.org
Message-ID: <177429121457.2266274.4931675600736029930.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: hongao <hongao@uniontech.com>

Source kernel commit: 281cb17787d4284a7790b9cbd80fded826ca7739

kzalloc() is called with __GFP_NOFAIL, so a NULL return is not expected.
Drop the redundant !map check in xfs_dabuf_map().
Also switch the nirecs-sized allocation to kcalloc().

Signed-off-by: hongao <hongao@uniontech.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_da_btree.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 969bfc9dee909d..2fce657af5d0b6 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -2712,12 +2712,8 @@ xfs_dabuf_map(
 	 * larger one that needs to be free by the caller.
 	 */
 	if (nirecs > 1) {
-		map = kzalloc(nirecs * sizeof(struct xfs_buf_map),
-				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
-		if (!map) {
-			error = -ENOMEM;
-			goto out_free_irecs;
-		}
+		map = kcalloc(nirecs, sizeof(struct xfs_buf_map),
+			      GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 		*mapp = map;
 	}
 

