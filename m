Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D77391
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 01:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710818; cv=none; b=Vsjss4L6ZE1qUHm7vwdUYMkobtERk4CBAyLb1zdq5LH+08+tqNUDr5NRm6GLaMhi0qupOJGBoxe9RPxuJ4VVB0Ioy+J8RLWFZdW6WL68eOxpJRwTJCDSZlIGyzSlfFBtuSxro3YCPhJbY3XSUP4W+KyVj5HUQ+8Ih0Qrc/8u+IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710818; c=relaxed/simple;
	bh=zKKfDBA/1+ra28LA2fpJU4pkWTO04QB/Sc0Gyve5JfU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h9xeKukKM0WSYItw7qcFs7/WIhZf3W4r2iRaZSVRm4thEvvLrSGe896bZC4fIvA3E5igd2PznHl0DH6eSbAqfMghuKHVuEs23Qa+IZcBu06+tEbPFysUpOOhOrlsalUOLahqQVG9hrDS8y5ISeXChWTxChaTTZ5ucjqNJJRicyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fpUfAxzj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fpUfAxzj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DF0C433C7;
	Wed, 10 Apr 2024 01:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710818;
	bh=zKKfDBA/1+ra28LA2fpJU4pkWTO04QB/Sc0Gyve5JfU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fpUfAxzj1rMgugcyOOEOmknD/LFp1ynh2JutFtmQMIT515l1baVXuAnYLr2Nxf3wU
	 OODxwwQxUe4SiQ+YoZGg9CZ9l2IR6OWNgBXtqvTzcKn7mAvpHB6zuR+utxV9EuQHl+
	 Akucg9Vky8BLwRIqDxi5rUVSUzU3CpxdybxXDOnADEKkxU1HI+XT6US6JriPKSCvhA
	 nVPQGJFvzKRD9ofpXuvCo42w8U/VI4tj58inkINwcNP287PxV7s81Co70XDMXhh4Bw
	 lPbwhIcAI1ZO59A3AsJrd96R/jwfzHi/dJTpIgtkoyI5Ojd8477JSkw97OOzSzCgfy
	 4emtD7YpqcuSg==
Date: Tue, 09 Apr 2024 18:00:17 -0700
Subject: [PATCH 26/32] xfs: split out handle management helpers a bit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270969991.3631889.18004647832726113704.stgit@frogsfrogsfrogs>
In-Reply-To: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_fs.h |    4 ++
 fs/xfs/xfs_handle.c    |   92 ++++++++++++++++++++++++++++++++----------------
 2 files changed, 64 insertions(+), 32 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 7486dcba8c218..51aa4774f57a2 100644
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
index a0015dc8cff1a..abeca486a2c91 100644
--- a/fs/xfs/xfs_handle.c
+++ b/fs/xfs/xfs_handle.c
@@ -30,6 +30,35 @@
 
 #include <linux/namei.h>
 
+static size_t
+xfs_filehandle_init(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	uint32_t		gen,
+	struct xfs_handle	*handle)
+{
+	memcpy(&handle->ha_fsid, mp->m_fixedfsid, sizeof(struct xfs_fsid));
+
+	handle->ha_fid.fid_len = sizeof(struct xfs_fid) -
+				 sizeof(handle->ha_fid.fid_len);
+	handle->ha_fid.fid_pad = 0;
+	handle->ha_fid.fid_gen = gen;
+	handle->ha_fid.fid_ino = ino;
+
+	return sizeof(struct xfs_handle);
+}
+
+static size_t
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
@@ -84,20 +113,11 @@ xfs_find_handle(
 
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
@@ -126,6 +146,32 @@ xfs_handle_acceptable(
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
+	if (handle->ha_fid.fid_len !=
+	    sizeof(handle->ha_fid) - sizeof(handle->ha_fid.fid_len))
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
@@ -136,29 +182,13 @@ xfs_handle_to_dentry(
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

