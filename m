Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD455227
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231138; cv=none; b=DQVZ367tnhNRKADCmjUoAc9vvdbGZPf5+fmPJ7NqKLO8Uv2YNKWsOGzRq4wqeKWPQe5E5NgGTundcuEjPAS6i+O6uIz2qWkdbPp6qngM+Jy8EDdTXvXq79jYU/TuFzMsWvH3z9lVJH3+bm+xOMhtk3NGGGv5lyl9hpDdYyuTiLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231138; c=relaxed/simple;
	bh=7qWZuJ/B/xqgiF5dU7dcYwgc101VynO0g6eidTsKKIQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qaSdXGR3G564r8Ojj2tKHevfovyWxOWjA8ZmjkpVDnjJtK1MirrP5Q231qfis8867a8GXETo2aSILDsdFl5KfAHwoimTYokBFcauFQsQYvZHUQK1MxJK+mm66gALbQXleXJTkc12fmSxsG25/JiLA/jP17fuhkO0sytk2gDIwfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R+8qLCjr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R+8qLCjr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764DAC113CC;
	Tue, 16 Apr 2024 01:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231138;
	bh=7qWZuJ/B/xqgiF5dU7dcYwgc101VynO0g6eidTsKKIQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=R+8qLCjrGu6dOgIi2UciyInV1AsuCfc2zARGsMHV6Rpg9g+i1URrwM+DL/cij37D1
	 cY8/fDnmwqBn8PbGU70v1I5cu8LQqLkT0CZh4fSduf6c8VNObRuuV1sPPK5o2OtnNh
	 R3WbvEuUkdWgU9f9EnlL3A0gdk6LGX82mRLbGqbyuFMaGTKcRyixzA2ZF4UmygqRZq
	 qkClVDQEDoIHJY8R27qxchVexNoVkOtn2RDwukhYlRYJEu+ipqAlXX1LvrGAYDRO6J
	 DKl26YzqKKvVAnFMUdfr95Xb4CjiXQPoFj78Nxm6lBnrS+gt0s9gB3y4FxBBvZBBdf
	 ph0pZA+dp5Lpg==
Date: Mon, 15 Apr 2024 18:32:17 -0700
Subject: [PATCH 24/31] xfs: split out handle management helpers a bit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323028178.251715.1138981542263287166.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Split out the functions that generate file/fs handles and map them back
into dentries in preparation for the GETPARENTS ioctl next.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h |    4 +-
 fs/xfs/xfs_handle.c    |   98 +++++++++++++++++++++++++++++++++---------------
 2 files changed, 70 insertions(+), 32 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 5a00146bcf68d..0e91e748b1403 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -633,7 +633,9 @@ typedef struct xfs_fsop_attrmulti_handlereq {
 /*
  * per machine unique filesystem identifier types.
  */
-typedef struct { __u32 val[2]; } xfs_fsid_t; /* file system id type */
+typedef struct xfs_fsid {
+	__u32	val[2];			/* file system id type */
+} xfs_fsid_t;
 
 typedef struct xfs_fid {
 	__u16	fid_len;		/* length of remainder	*/
diff --git a/fs/xfs/xfs_handle.c b/fs/xfs/xfs_handle.c
index 13c2479a3053f..b9f4d9860682a 100644
--- a/fs/xfs/xfs_handle.c
+++ b/fs/xfs/xfs_handle.c
@@ -30,6 +30,42 @@
 
 #include <linux/namei.h>
 
+static inline size_t
+xfs_filehandle_fid_len(void)
+{
+	struct xfs_handle	*handle = NULL;
+
+	return sizeof(struct xfs_fid) - sizeof(handle->ha_fid.fid_len);
+}
+
+static inline size_t
+xfs_filehandle_init(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	uint32_t		gen,
+	struct xfs_handle	*handle)
+{
+	memcpy(&handle->ha_fsid, mp->m_fixedfsid, sizeof(struct xfs_fsid));
+
+	handle->ha_fid.fid_len = xfs_filehandle_fid_len();
+	handle->ha_fid.fid_pad = 0;
+	handle->ha_fid.fid_gen = gen;
+	handle->ha_fid.fid_ino = ino;
+
+	return sizeof(struct xfs_handle);
+}
+
+static inline size_t
+xfs_fshandle_init(
+	struct xfs_mount	*mp,
+	struct xfs_handle	*handle)
+{
+	memcpy(&handle->ha_fsid, mp->m_fixedfsid, sizeof(struct xfs_fsid));
+	memset(&handle->ha_fid, 0, sizeof(handle->ha_fid));
+
+	return sizeof(struct xfs_fsid);
+}
+
 /*
  * xfs_find_handle maps from userspace xfs_fsop_handlereq structure to
  * a file or fs handle.
@@ -84,20 +120,11 @@ xfs_find_handle(
 
 	memcpy(&handle.ha_fsid, ip->i_mount->m_fixedfsid, sizeof(xfs_fsid_t));
 
-	if (cmd == XFS_IOC_PATH_TO_FSHANDLE) {
-		/*
-		 * This handle only contains an fsid, zero the rest.
-		 */
-		memset(&handle.ha_fid, 0, sizeof(handle.ha_fid));
-		hsize = sizeof(xfs_fsid_t);
-	} else {
-		handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
-					sizeof(handle.ha_fid.fid_len);
-		handle.ha_fid.fid_pad = 0;
-		handle.ha_fid.fid_gen = inode->i_generation;
-		handle.ha_fid.fid_ino = ip->i_ino;
-		hsize = sizeof(xfs_handle_t);
-	}
+	if (cmd == XFS_IOC_PATH_TO_FSHANDLE)
+		hsize = xfs_fshandle_init(ip->i_mount, &handle);
+	else
+		hsize = xfs_filehandle_init(ip->i_mount, ip->i_ino,
+				inode->i_generation, &handle);
 
 	error = -EFAULT;
 	if (copy_to_user(hreq->ohandle, &handle, hsize) ||
@@ -126,6 +153,31 @@ xfs_handle_acceptable(
 	return 1;
 }
 
+/* Convert handle already copied to kernel space into a dentry. */
+static struct dentry *
+xfs_khandle_to_dentry(
+	struct file		*file,
+	struct xfs_handle	*handle)
+{
+	struct xfs_fid64        fid = {
+		.ino		= handle->ha_fid.fid_ino,
+		.gen		= handle->ha_fid.fid_gen,
+	};
+
+	/*
+	 * Only allow handle opens under a directory.
+	 */
+	if (!S_ISDIR(file_inode(file)->i_mode))
+		return ERR_PTR(-ENOTDIR);
+
+	if (handle->ha_fid.fid_len != xfs_filehandle_fid_len())
+		return ERR_PTR(-EINVAL);
+
+	return exportfs_decode_fh(file->f_path.mnt, (struct fid *)&fid, 3,
+			FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG,
+			xfs_handle_acceptable, NULL);
+}
+
 /*
  * Convert userspace handle data into a dentry.
  */
@@ -136,29 +188,13 @@ xfs_handle_to_dentry(
 	u32			hlen)
 {
 	xfs_handle_t		handle;
-	struct xfs_fid64	fid;
-
-	/*
-	 * Only allow handle opens under a directory.
-	 */
-	if (!S_ISDIR(file_inode(parfilp)->i_mode))
-		return ERR_PTR(-ENOTDIR);
 
 	if (hlen != sizeof(xfs_handle_t))
 		return ERR_PTR(-EINVAL);
 	if (copy_from_user(&handle, uhandle, hlen))
 		return ERR_PTR(-EFAULT);
-	if (handle.ha_fid.fid_len !=
-	    sizeof(handle.ha_fid) - sizeof(handle.ha_fid.fid_len))
-		return ERR_PTR(-EINVAL);
 
-	memset(&fid, 0, sizeof(struct fid));
-	fid.ino = handle.ha_fid.fid_ino;
-	fid.gen = handle.ha_fid.fid_gen;
-
-	return exportfs_decode_fh(parfilp->f_path.mnt, (struct fid *)&fid, 3,
-			FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG,
-			xfs_handle_acceptable, NULL);
+	return xfs_khandle_to_dentry(parfilp, &handle);
 }
 
 STATIC struct dentry *

