Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB60E2EFDA4
	for <linux-xfs@vger.kernel.org>; Thu,  4 Dec 2025 21:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764884631; cv=none; b=RUueI7QIeuHddpen77252zB045J7LoZTrUQ0kCA1pjs+W9gxPA+cc2sK3X54d2vNyj50m34ikc9VGYnt3RR1agKtF9XKCF2oSbik07LXvH43hFdcw1i68vgAHE0NIrqhNFKEnJPysE+8tpXpgIM8LmMGrD3DNga+6rnFPYXIhjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764884631; c=relaxed/simple;
	bh=GiF9NO6BtfdbfxYQJh7dXC+Z5ojJ4310WrS0wFaGrW4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=WWXn6avmaqbJhsWNx2yQkH5POt3nFQlxmOXszy1sWhbuGzCgs/eLXKFr/0kXDynFp8YEoDn4Hq+QKO1re6X662Isq4mkssZ/B+SbhdMEdSIpyW6HrN0b1/siE3/uDY7E9QdAzdJdk1rNZ8Xij/MUUQyXVmAJ1opBepnX32jcd90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OkPTMYzO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OkPTMYzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640CEC4CEFB;
	Thu,  4 Dec 2025 21:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764884631;
	bh=GiF9NO6BtfdbfxYQJh7dXC+Z5ojJ4310WrS0wFaGrW4=;
	h=Date:From:To:Cc:Subject:From;
	b=OkPTMYzOQEVGcoZz6ISXU/kEHHpI4vtXJ5vnsgxE56Yj2wrba8YqMqKHxWjcF7ddn
	 EKSdXSEDrbehQFIZfG8NPJBZGWMQNRvunlky5R03F/Uhvo1Vwa4jXb8IXgfbMkK3cW
	 WvOJOMlLDgopjTzqdI7kn6kNKPvAoMptFV0giTW/fmMXl4TDKRFndMTRFxuoPevpe9
	 eFv1VabQMsUzSZ84XNgKhYiNCMDc1qLAEnu5VQRshHGbKzOfGHxRGRlNVj0lNbV5Ja
	 XrUyzOBGueQEKDI3nOwLw+ieMeYIgaC0O9w4VDYFz5f2k0655vRHMA1mmdov7u+4Hi
	 keMouAwmPoU0A==
Date: Thu, 4 Dec 2025 13:43:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: fix a UAF problem in xattr repair
Message-ID: <20251204214350.GM89472@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

The xchk_setup_xattr_buf function can allocate a new value buffer, which
means that any reference to ab->value before the call could become a
dangling pointer.  Fix this by moving an assignment to after the buffer
setup.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: e47dcf113ae348 ("xfs: repair extended attributes")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/attr_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index c7eb94069cafcd..09d63aa10314b0 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -333,7 +333,6 @@ xrep_xattr_salvage_remote_attr(
 		.attr_filter		= ent->flags & XFS_ATTR_NSP_ONDISK_MASK,
 		.namelen		= rentry->namelen,
 		.name			= rentry->name,
-		.value			= ab->value,
 		.valuelen		= be32_to_cpu(rentry->valuelen),
 	};
 	unsigned int			namesize;
@@ -363,6 +362,7 @@ xrep_xattr_salvage_remote_attr(
 		error = -EDEADLOCK;
 	if (error)
 		return error;
+	args.value = ab->value;
 
 	/* Look up the remote value and stash it for reconstruction. */
 	error = xfs_attr3_leaf_getvalue(leaf_bp, &args);
