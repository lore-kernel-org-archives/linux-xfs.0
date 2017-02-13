Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35262 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752562AbdBMTni (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Feb 2017 14:43:38 -0500
Date: Mon, 13 Feb 2017 11:43:37 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs: fix inode uid/gid initialization
Message-ID: <20170213194337.GA9852@infradead.org>
References: <1487008001.3125.41.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487008001.3125.41.camel@HansenPartnership.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, Seth Forshee <seth.forshee@canonical.com>

On Mon, Feb 13, 2017 at 09:46:41AM -0800, James Bottomley wrote:
> I was debugging a creation failure using a vfs shifting patch set and
> discovered that xfs itself doesn't actually respect the superblock
> namespace in a couple of places (these showed up as files with the
> wrong ownership in my tests).

Can you submit your test case to xfstests?  I would be good to have
testing for this in the regular test runs.

> The fix is to convert xfs away from hand
> rolling inode_init_owner() and to use the i_uid/gid_read/write
> functions.

What about the various quota users of xfs_kuid_to_uid/gid in
the create / symlink path?  I suspect they should be handle the same.

Also with your patch the di_uid/gid fields should probably just
go away as they are pointless now.  Something like the patch below,
although it still doesn't take care of the quota issues pointed out
above.

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index d93f9d918cfc..dfe9b02a62bd 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -233,8 +233,8 @@ xfs_inode_from_disk(
 	}
 
 	to->di_format = from->di_format;
-	to->di_uid = be32_to_cpu(from->di_uid);
-	to->di_gid = be32_to_cpu(from->di_gid);
+	i_uid_write(inode, be32_to_cpu(from->di_uid));
+	i_gid_write(inode, be32_to_cpu(from->di_gid));
 	to->di_flushiter = be16_to_cpu(from->di_flushiter);
 
 	/*
@@ -286,8 +286,8 @@ xfs_inode_to_disk(
 
 	to->di_version = from->di_version;
 	to->di_format = from->di_format;
-	to->di_uid = cpu_to_be32(from->di_uid);
-	to->di_gid = cpu_to_be32(from->di_gid);
+	to->di_uid = cpu_to_be32(i_uid_read(inode));
+	to->di_gid = cpu_to_be32(i_gid_read(inode));
 	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
 	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 6848a0afbce7..a4c5502351c4 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -31,8 +31,6 @@ struct xfs_icdinode {
 	__int8_t	di_version;	/* inode version */
 	__int8_t	di_format;	/* format of di_c data */
 	__uint16_t	di_flushiter;	/* incremented on flush */
-	__uint32_t	di_uid;		/* owner's user id */
-	__uint32_t	di_gid;		/* owner's group id */
 	__uint16_t	di_projid_lo;	/* lower part of owner's project id */
 	__uint16_t	di_projid_hi;	/* higher part of owner's project id */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index de32f0fe47c8..3b0b09a6b15d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -814,18 +814,10 @@ xfs_ialloc(
 	if (ip->i_d.di_version == 1)
 		ip->i_d.di_version = 2;
 
-	inode->i_mode = mode;
+	inode_init_owner(inode, pip ? VFS_I(pip) : NULL, mode);
 	set_nlink(inode, nlink);
-	ip->i_d.di_uid = xfs_kuid_to_uid(current_fsuid());
-	ip->i_d.di_gid = xfs_kgid_to_gid(current_fsgid());
 	xfs_set_projid(ip, prid);
 
-	if (pip && XFS_INHERIT_GID(pip)) {
-		ip->i_d.di_gid = pip->i_d.di_gid;
-		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(mode))
-			inode->i_mode |= S_ISGID;
-	}
-
 	/*
 	 * If the group ID of the new file does not match the effective group
 	 * ID or one of the supplementary group IDs, the S_ISGID bit is cleared
@@ -833,7 +825,7 @@ xfs_ialloc(
 	 */
 	if ((irix_sgid_inherit) &&
 	    (inode->i_mode & S_ISGID) &&
-	    (!in_group_p(xfs_gid_to_kgid(ip->i_d.di_gid))))
+	    (!in_group_p(inode->i_gid)))
 		inode->i_mode &= ~S_ISGID;
 
 	ip->i_d.di_size = 0;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index d90e7811ccdd..ed9529e3babf 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -335,8 +335,8 @@ xfs_inode_to_log_dinode(
 
 	to->di_version = from->di_version;
 	to->di_format = from->di_format;
-	to->di_uid = from->di_uid;
-	to->di_gid = from->di_gid;
+	to->di_uid = i_uid_read(inode);
+	to->di_gid = i_gid_read(inode);
 	to->di_projid_lo = from->di_projid_lo;
 	to->di_projid_hi = from->di_projid_hi;
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index c67cfb451fd3..92bb1317536a 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1333,8 +1333,8 @@ xfs_ioctl_setattr(
 	 * because the i_*dquot fields will get updated anyway.
 	 */
 	if (XFS_IS_QUOTA_ON(mp)) {
-		code = xfs_qm_vop_dqalloc(ip, ip->i_d.di_uid,
-					 ip->i_d.di_gid, fa->fsx_projid,
+		code = xfs_qm_vop_dqalloc(ip, i_uid_read(VFS_I(ip)),
+					 i_gid_read(VFS_I(ip)), fa->fsx_projid,
 					 XFS_QMOPT_PQUOTA, &udqp, NULL, &pdqp);
 		if (code)
 			return code;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 22c16155f1b4..c3807a7ae466 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -643,8 +643,8 @@ xfs_setattr_nonsize(
 		 */
 		ASSERT(udqp == NULL);
 		ASSERT(gdqp == NULL);
-		error = xfs_qm_vop_dqalloc(ip, xfs_kuid_to_uid(uid),
-					   xfs_kgid_to_gid(gid),
+		error = xfs_qm_vop_dqalloc(ip, from_kuid(inode->i_sb->s_user_ns, uid),
+					   from_kgid(inode->i_sb->s_user_ns, gid),
 					   xfs_get_projid(ip),
 					   qflags, &udqp, &gdqp, NULL);
 		if (error)
@@ -714,8 +714,8 @@ xfs_setattr_nonsize(
 				olddquot1 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_udquot, udqp);
 			}
-			ip->i_d.di_uid = xfs_kuid_to_uid(uid);
 			inode->i_uid = uid;
+
 		}
 		if (!gid_eq(igid, gid)) {
 			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_GQUOTA_ON(mp)) {
@@ -726,7 +726,6 @@ xfs_setattr_nonsize(
 				olddquot2 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_gdquot, gdqp);
 			}
-			ip->i_d.di_gid = xfs_kgid_to_gid(gid);
 			inode->i_gid = gid;
 		}
 	}
@@ -1213,9 +1212,6 @@ xfs_setup_inode(
 	/* make the inode look hashed for the writeback code */
 	hlist_add_fake(&inode->i_hash);
 
-	inode->i_uid    = xfs_uid_to_kuid(ip->i_d.di_uid);
-	inode->i_gid    = xfs_gid_to_kgid(ip->i_d.di_gid);
-
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFBLK:
 	case S_IFCHR:
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 66e881790c17..bcfc7f38e8e2 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -88,8 +88,8 @@ xfs_bulkstat_one_int(
 	buf->bs_projid_lo = dic->di_projid_lo;
 	buf->bs_projid_hi = dic->di_projid_hi;
 	buf->bs_ino = ino;
-	buf->bs_uid = dic->di_uid;
-	buf->bs_gid = dic->di_gid;
+	buf->bs_uid = i_uid_read(inode);
+	buf->bs_gid = i_gid_read(inode);
 	buf->bs_size = dic->di_size;
 
 	buf->bs_nlink = inode->i_nlink;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b669b123287b..0f3692123267 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -341,18 +341,18 @@ xfs_qm_dqattach_locked(
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (XFS_IS_UQUOTA_ON(mp) && !ip->i_udquot) {
-		error = xfs_qm_dqattach_one(ip, ip->i_d.di_uid, XFS_DQ_USER,
-						flags & XFS_QMOPT_DQALLOC,
-						&ip->i_udquot);
+		error = xfs_qm_dqattach_one(ip, i_uid_read(VFS_I(ip)),
+				XFS_DQ_USER, flags & XFS_QMOPT_DQALLOC,
+				&ip->i_udquot);
 		if (error)
 			goto done;
 		ASSERT(ip->i_udquot);
 	}
 
 	if (XFS_IS_GQUOTA_ON(mp) && !ip->i_gdquot) {
-		error = xfs_qm_dqattach_one(ip, ip->i_d.di_gid, XFS_DQ_GROUP,
-						flags & XFS_QMOPT_DQALLOC,
-						&ip->i_gdquot);
+		error = xfs_qm_dqattach_one(ip, i_gid_read(VFS_I(ip)),
+				XFS_DQ_GROUP, flags & XFS_QMOPT_DQALLOC,
+				&ip->i_gdquot);
 		if (error)
 			goto done;
 		ASSERT(ip->i_gdquot);
@@ -1210,14 +1210,14 @@ xfs_qm_dqusage_adjust(
 	 * and quotaoffs don't race. (Quotachecks happen at mount time only).
 	 */
 	if (XFS_IS_UQUOTA_ON(mp)) {
-		error = xfs_qm_quotacheck_dqadjust(ip, ip->i_d.di_uid,
+		error = xfs_qm_quotacheck_dqadjust(ip, i_uid_read(VFS_I(ip)),
 						   XFS_DQ_USER, nblks, rtblks);
 		if (error)
 			goto error0;
 	}
 
 	if (XFS_IS_GQUOTA_ON(mp)) {
-		error = xfs_qm_quotacheck_dqadjust(ip, ip->i_d.di_gid,
+		error = xfs_qm_quotacheck_dqadjust(ip, i_gid_read(VFS_I(ip)),
 						   XFS_DQ_GROUP, nblks, rtblks);
 		if (error)
 			goto error0;
@@ -1650,7 +1650,7 @@ xfs_qm_vop_dqalloc(
 	xfs_ilock(ip, lockflags);
 
 	if ((flags & XFS_QMOPT_INHERIT) && XFS_INHERIT_GID(ip))
-		gid = ip->i_d.di_gid;
+		gid = i_gid_read(VFS_I(ip));
 
 	/*
 	 * Attach the dquot(s) to this inode, doing a dquot allocation
@@ -1665,7 +1665,7 @@ xfs_qm_vop_dqalloc(
 	}
 
 	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp)) {
-		if (ip->i_d.di_uid != uid) {
+		if (i_uid_read(VFS_I(ip)) != uid) {
 			/*
 			 * What we need is the dquot that has this uid, and
 			 * if we send the inode to dqget, the uid of the inode
@@ -1701,7 +1701,7 @@ xfs_qm_vop_dqalloc(
 		}
 	}
 	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
-		if (ip->i_d.di_gid != gid) {
+		if (i_gid_read(VFS_I(ip)) != gid) {
 			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, NULL, gid,
 						 XFS_DQ_GROUP,
@@ -1835,7 +1835,7 @@ xfs_qm_vop_chown_reserve(
 			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
 
 	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
-	    ip->i_d.di_uid != be32_to_cpu(udqp->q_core.d_id)) {
+	    i_uid_read(VFS_I(ip)) != be32_to_cpu(udqp->q_core.d_id)) {
 		udq_delblks = udqp;
 		/*
 		 * If there are delayed allocation blocks, then we have to
@@ -1848,7 +1848,7 @@ xfs_qm_vop_chown_reserve(
 		}
 	}
 	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
-	    ip->i_d.di_gid != be32_to_cpu(gdqp->q_core.d_id)) {
+	    i_gid_read(VFS_I(ip)) != be32_to_cpu(gdqp->q_core.d_id)) {
 		gdq_delblks = gdqp;
 		if (delblks) {
 			ASSERT(ip->i_gdquot);
@@ -1945,14 +1945,14 @@ xfs_qm_vop_create_dqattach(
 
 	if (udqp && XFS_IS_UQUOTA_ON(mp)) {
 		ASSERT(ip->i_udquot == NULL);
-		ASSERT(ip->i_d.di_uid == be32_to_cpu(udqp->q_core.d_id));
+		ASSERT(i_uid_read(VFS_I(ip)) == be32_to_cpu(udqp->q_core.d_id));
 
 		ip->i_udquot = xfs_qm_dqhold(udqp);
 		xfs_trans_mod_dquot(tp, udqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
 	if (gdqp && XFS_IS_GQUOTA_ON(mp)) {
 		ASSERT(ip->i_gdquot == NULL);
-		ASSERT(ip->i_d.di_gid == be32_to_cpu(gdqp->q_core.d_id));
+		ASSERT(i_uid_read(VFS_I(ip)) == be32_to_cpu(gdqp->q_core.d_id));
 		ip->i_gdquot = xfs_qm_dqhold(gdqp);
 		xfs_trans_mod_dquot(tp, gdqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
