Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5C919581F
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548093; cv=none; b=ggtZbOBn7UlxCPOk9ETnNDfdqu894cDXOywit+bb7LstmA5zk3i7qQuy+pBC36N5r0utV8J2JrmOX8luhmQTKIetonuYtNOtECNJnKBYB1odaFtz3O1lAaJGk6e1kgkhaEJHdR7jTmDZVkPh3O4lYimCYXbGqPa43Pe4hOW893U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548093; c=relaxed/simple;
	bh=RIiq8wv6cT21v+OF5Npukq//GNb2e8AddT2Ptw9IdAg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vun4k1Z83maEIXsMv/oN9X6b3ifLjeNgaL5IqzabapL7RBiTEmLxd+9NJbnYmYOjGH/0Qo3VHE09uJZIxZNJ34TK/HDXb9f5H7N3iYF+fKPSvgz3lcYbLe4UxlAXwzPN/9JAr6iXiMIs4nFXwAVlXpFc1dK5wAaPUq2UsxFMyaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XvhcJYU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XvhcJYU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889B9C4CEC3;
	Mon, 21 Oct 2024 22:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548092;
	bh=RIiq8wv6cT21v+OF5Npukq//GNb2e8AddT2Ptw9IdAg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XvhcJYU5w4X0pEdNx4bzFmjH4WE4HTJfn/gQmaqqwskYEOgykRau3Shwv5ae1MmSH
	 4ws/LP93dVw9HhqEe2mOApio2bRObrqw3TshwaB+mB8PQ1oGHUBxR/eyEbD97cAOsf
	 YvskawurngnQ1DLudxFaWOBpkIYj/podTKEMKod8E1SblC15XJl3rs8WD3Y65ReANj
	 PwV56Kr8j+llxQX8PW21CJS7uTVShoj+YHc/bd0IXdAcwAH93JXiNKgLZtotE/+JU7
	 Wbnj4s9J0Y8eqZ4xEbhB9nw/1OT7Ye0guF8yJvOas0iVDOM2aFBBve6Tl7hCZZS1mp
	 1ig8ME8KAmTqQ==
Date: Mon, 21 Oct 2024 15:01:32 -0700
Subject: [PATCH 10/37] xfs: assert a valid limit in xfs_rtfind_forw
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783623.34558.992158853295468624.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 6d2db12d56a389b3e8efa236976f8dc3a8ae00f0

Protect against developers passing stupid limits when refactoring the
RT code once again.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rtbitmap.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index c7613f2de7b0a0..f578b0d34b36d3 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -313,6 +313,8 @@ xfs_rtfind_forw(
 	xfs_rtword_t		incore;
 	unsigned int		word;	/* word number in the buffer */
 
+	ASSERT(start <= limit);
+
 	/*
 	 * Compute and read in starting bitmap block for starting block.
 	 */

