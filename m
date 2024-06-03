Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB75823A0
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442428; cv=none; b=OGrJeQC0vRtG+aPIKwvO/mWK20y2kQGpJIdkg1ZQ4GDGxyJWMzUnIpSRU8JrymW7B4XeWFLVBVzsTv3YXSd1l6dFEXqlc0rpnnsnk9h2pt8NE7MJX27XF/G56+wZfRpPwLHw38tKFn+po0wzZDYAV0xcBekxu1fFTlA4LKye3FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442428; c=relaxed/simple;
	bh=XWgYJUNywu8VBj5Ondlre47Onaar6+kPSXbwOWbXvUA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b/5S0rxwqwydelVsQy+KaChnz4wI4mDCtUYGmsqGsEjIcrWi6HKhOhi78yohtqdO5OAWK6u1fBjUu8ZB6F4AAccVlnCyJfv7aGWh9txCUeC2HXPOuV+Mc0moZ+UmgNg744ho8zHDOiTnDbIb3Y3iW/uycp3KSrzg88asANpmSzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZS+8FqK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZS+8FqK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D64C2BD10;
	Mon,  3 Jun 2024 19:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442428;
	bh=XWgYJUNywu8VBj5Ondlre47Onaar6+kPSXbwOWbXvUA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZS+8FqK5g2GivOnz5gwkPNue83XT9zJJQSWTZaIBGiC+m5mvnby0QrTKIc6Q5KwSr
	 fC83oQT5/RKmEydZT5zzv4gs9Y3kesVqu8511VX7OkZaUQ3ZaXpM0FoIeOWiu/c3qk
	 31JW3z7iARVFhL3Ta7pTavs1yT0MqH18doq3fQg3sjn0ac/wolHrkQve1BiwVYBMSR
	 KUDE8jrwnwIpe49qgy4DruGWHW0S1VVCGAQpYTC8P3+OeANJiuik+AyKQmjw4+cvaQ
	 HN4/VuJt7p7LMEbW7WcjbBmxsFibQpg8NrPAWaIdeFhL+YYFBc+c5Q0Xq9ZIokrl2S
	 TBkCOAqN1ImGw==
Date: Mon, 03 Jun 2024 12:20:28 -0700
Subject: [PATCH 109/111] xfs: xfs_btree_bload_prep_block() should use
 __GFP_NOFAIL
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
 Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171744041003.1443973.9101006640339720347.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 3aca0676a1141c4d198f8b3c934435941ba84244

This was missed in the conversion from KM* flags.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 10634530f7ba ("xfs: convert kmem_zalloc() to kzalloc()")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_btree_staging.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index 52410fe4f..2f5b1d0b6 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -303,7 +303,7 @@ xfs_btree_bload_prep_block(
 
 		/* Allocate a new incore btree root block. */
 		new_size = bbl->iroot_size(cur, level, nr_this_block, priv);
-		ifp->if_broot = kzalloc(new_size, GFP_KERNEL);
+		ifp->if_broot = kzalloc(new_size, GFP_KERNEL | __GFP_NOFAIL);
 		ifp->if_broot_bytes = (int)new_size;
 
 		/* Initialize it and send it out. */

