Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374172EBB9E
	for <linux-xfs@vger.kernel.org>; Wed,  8 Oct 2025 16:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759942635; cv=none; b=QOJj7rgSQnMY6uFiG+OoFzo+LWSh1aLQXsJHALsi8Sw6ULpQBp/kwWlcBOcQXiGeL5MER97Qk/VR2NWOUHCJu4lGZwmYsMSkoFWWjB6cHQZUmzZgvR+BB3Ny32a+dBhDAsojQ8vxVL0yakp4E2nz/8W1wP7MdK5IvkqhCpxGIpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759942635; c=relaxed/simple;
	bh=g6M0yvtvlx+xLVtxsIbaDtLZc/e93gPnTNgI9DInJnM=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CSghmqzpEUKCeT/HtkkHxWz9eAw6lpstkrNZqtBdS7RNF/WPq13nx4VwUtCdI8E+8UHP6BMYNU4aHBmxSTgRDdLrEjjEYk4yZtU2x68yeHvvzOJZ9nD6eid/1TmjmGgRd2dsQNg/4qhlFzYkyLfq0cObsOwSvZd9rgtUDVszL/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D570C4CEF4;
	Wed,  8 Oct 2025 16:57:10 +0000 (UTC)
Date: Wed, 8 Oct 2025 18:57:08 +0200
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, hch@lst.de, pchelkin@ispras.ru, 
	pranav.tyagi03@gmail.com, sandeen@redhat.com
Subject: [PATCH 11/11] [PATCH] xfs: do not propagate ENODATA disk errors into
 xattr code
Message-ID: <egf2wwoev2eqhveoa3tq3vajlkiunk5pit3twasdcjh4ru7s2x@zf73kamzjz76>
References: <cover.1759941416.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1759941416.patch-series@thinky>

Source kernel commit: ae668cd567a6a7622bc813ee0bb61c42bed61ba7

ENODATA (aka ENOATTR) has a very specific meaning in the xfs xattr code;
namely, that the requested attribute name could not be found.

However, a medium error from disk may also return ENODATA. At best,
this medium error may escape to userspace as "attribute not found"
when in fact it's an IO (disk) error.

At worst, we may oops in xfs_attr_leaf_get() when we do:

error = xfs_attr_leaf_hasname(args, &bp);
if (error == -ENOATTR)  {
xfs_trans_brelse(args->trans, bp);
return error;
}

because an ENODATA/ENOATTR error from disk leaves us with a null bp,
and the xfs_trans_brelse will then null-deref it.

As discussed on the list, we really need to modify the lower level
IO functions to trap all disk errors and ensure that we don't let
unique errors like this leak up into higher xfs functions - many
like this should be remapped to EIO.

However, this patch directly addresses a reported bug in the xattr
code, and should be safe to backport to stable kernels. A larger-scope
patch to handle more unique errors at lower levels can follow later.

(Note, prior to 07120f1abdff we did not oops, but we did return the
wrong error code to userspace.)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_attr_remote.c | 7 +++++++
 libxfs/xfs_da_btree.c    | 6 ++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index a048aa5f2c..82217baf40 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -434,6 +434,13 @@
 					0, &bp, &xfs_attr3_rmt_buf_ops);
 			if (xfs_metadata_is_sick(error))
 				xfs_dirattr_mark_sick(args->dp, XFS_ATTR_FORK);
+			/*
+			 * ENODATA from disk implies a disk medium failure;
+			 * ENODATA for xattrs means attribute not found, so
+			 * disambiguate that here.
+			 */
+			if (error == -ENODATA)
+				error = -EIO;
 			if (error)
 				return error;
 
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 38f345a923..af3fcdf5e4 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -2829,6 +2829,12 @@
 			&bp, ops);
 	if (xfs_metadata_is_sick(error))
 		xfs_dirattr_mark_sick(dp, whichfork);
+	/*
+	 * ENODATA from disk implies a disk medium failure; ENODATA for
+	 * xattrs means attribute not found, so disambiguate that here.
+	 */
+	if (error == -ENODATA && whichfork == XFS_ATTR_FORK)
+		error = -EIO;
 	if (error)
 		goto out_free;
 
