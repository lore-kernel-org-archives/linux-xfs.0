Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3566545C6FD
	for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 06:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792046084; cv=none; b=j39AQymHgy6bWv0rTdqQVa/oFsSYZ1MgETnpRpVImO1k4si84aM44tEDfYjTiHqwu/2QEfBtqKYG7QlqugZpV3KWDT+Jwy3g2IJFLPP6TbpcsFgnpsukqNWXC6ID7xu3ZJBjVwWAHYrM8IAf/sDzLP4V5PiZudfPQM2qKDdNsWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792046084; c=relaxed/simple;
	bh=ZIQx4DbBKrjIOua+PdAUw+hWiL1A092PUHTHlyRKTS4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=EIrYgkfqPJq8VA2cROkDChknY82jA3zw3QsMJeHCFCOv9gqC6QimMXAeorH5SoHqEuZloFrYMzuMFd5x2awWAOp+VlTJz+PHHlPJgMJvq6GHn9qAjBXSXzsN5PSFxdRqtT7mSUeiN7VR1pFD8ypUww3hrxw/so/I7uSl4R2ncq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=UpzrGtar; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="UpzrGtar"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261015063441epoutp04bb05f39f14d3d1a8b5d63687c75365b6~eoGqSN7UV0365203652epoutp04u
	for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 06:34:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261015063441epoutp04bb05f39f14d3d1a8b5d63687c75365b6~eoGqSN7UV0365203652epoutp04u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792046081;
	bh=bL5Nu/Md4og0oL68BsiqS1awnjOjJA16s5cOiChD2MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UpzrGtarkfPRMAuqGAnE/92r3QN3j+L7UewMZBHMYkPzrsHkgy8fmM9DX9K2EkCiw
	 wIjG9p9W7BdbM22yVdXXrO5c3/m6CxwAJFBgEKDSdKQuQQPGirw/wQ+4ElUk3AYexM
	 UQesJ8EMN6XvYkk2EoIHOtuDSlm5F3PzmSn2lSh4=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20261015063440epcas5p4b57d49826feb1c7a64c47003705f1aae~eoGpzjRZi1948319483epcas5p4W;
	Thu, 15 Oct 2026 06:34:40 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.92]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4j4ywc0pp7z6B9mJ; Thu, 15 Oct
	2026 06:34:40 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20261015063439epcas5p2f20546eb3add7059ceb61c10cda5d904~eoGol2pzZ2703227032epcas5p2Z;
	Thu, 15 Oct 2026 06:34:39 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261015063437epsmtip1fe2e6298f8e2e7409f236fadf76e7d33~eoGmumzU41280112801epsmtip1B;
	Thu, 15 Oct 2026 06:34:37 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v6 6/8] xfs: support write streams on realtime volumes
Date: Thu, 15 Oct 2026 12:02:44 +0530
Message-Id: <20261015063246.103433-7-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261015063246.103433-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261015063439epcas5p2f20546eb3add7059ceb61c10cda5d904
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261015063439epcas5p2f20546eb3add7059ceb61c10cda5d904
References: <20261015063246.103433-1-joshi.k@samsung.com>
	<CGME20261015063439epcas5p2f20546eb3add7059ceb61c10cda5d904@epcas5p2.samsung.com>

From: Anuj Gupta <anuj20.g@samsung.com>

Enable write streams on non-zoned realtime volumes that have realtime
groups, partitioning RTGs among the streams as the AG side does.

Stream based RTG selection applies to the first allocation of a file;
later ones keep using the adjacent-allocation hint so the file stays
contiguous.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/xfs/xfs_inode.c   |  4 ++--
 fs/xfs/xfs_ioctl.c   |  3 ++-
 fs/xfs/xfs_rtalloc.c | 28 ++++++++++++++++++++++++++++
 fs/xfs/xfs_super.c   |  7 +++++++
 4 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e36812103054..ea7c42e2b3a5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -57,7 +57,7 @@ xfs_inode_max_write_streams(
 
 	if (xfs_inode_is_filestream(ip))
 		return 0;
-	if (XFS_IS_REALTIME_INODE(ip))
+	if (XFS_IS_REALTIME_INODE(ip) && xfs_has_zoned(ip->i_mount))
 		return 0;
 	return write_stream_pool_count(&xfs_inode_buftarg(ip)->bt_stream_pool);
 }
@@ -75,7 +75,7 @@ xfs_inode_set_write_stream(
 	if (!fd_file(f))
 		return -EBADF;
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	if (XFS_IS_REALTIME_INODE(ip)) {
+	if (XFS_IS_REALTIME_INODE(ip) && xfs_has_zoned(ip->i_mount)) {
 		error = -EINVAL;
 		goto out_unlock;
 	}
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index bc6957ad06cb..4c0aff34e3c3 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -559,7 +559,8 @@ xfs_ioctl_setattr_xflags(
 
 	/* refuse a filestream/realtime flag change while a stream is attached */
 	if (READ_ONCE(VFS_I(ip)->i_write_stream) &&
-	    ((fa->fsx_xflags & FS_XFLAG_FILESTREAM) || rtflag))
+	    ((fa->fsx_xflags & FS_XFLAG_FILESTREAM) ||
+	     rtflag != XFS_IS_REALTIME_INODE(ip)))
 		return -EINVAL;
 
 	if (rtflag != XFS_IS_REALTIME_INODE(ip)) {
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 84efe5a8fb11..c7c3098182bb 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -2160,6 +2160,29 @@ xfs_rtallocate_align(
 	return 0;
 }
 
+static xfs_rtblock_t
+xfs_bmap_write_stream_rtbno(
+	struct xfs_inode	*ip,
+	unsigned int		stream_id)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	unsigned int		nr_rtgs = mp->m_sb.sb_rgcount;
+	unsigned int		nr_streams =
+		write_stream_pool_count(&mp->m_rtdev_targp->bt_stream_pool);
+	unsigned int		set_size = nr_rtgs / nr_streams;
+	xfs_rgnumber_t		start_rgno, target_rgno;
+	xfs_ino_t		ino = I_INO(ip);
+
+	stream_id -= 1;	/* convert from 1-based to 0-based */
+	start_rgno = stream_id * set_size;
+	if (stream_id == nr_streams - 1)
+		set_size = nr_rtgs - start_rgno;
+	target_rgno = start_rgno + do_div(ino, set_size);
+
+	return (xfs_rtblock_t)target_rgno <<
+		mp->m_groups[XG_TYPE_RTG].blklog;
+}
+
 int
 xfs_bmap_rtalloc(
 	struct xfs_bmalloca	*ap)
@@ -2174,10 +2197,13 @@ xfs_bmap_rtalloc(
 	bool			noalign = false;
 	bool			initial_user_data =
 		ap->datatype & XFS_ALLOC_INITIAL_USER_DATA;
+	unsigned int		stream_id;
 	int			error;
 
 	ASSERT(!xfs_has_zoned(ap->tp->t_mountp));
 
+	stream_id = READ_ONCE(VFS_I(ap->ip)->i_write_stream);
+
 retry:
 	error = xfs_rtallocate_align(ap, &ralen, &raminlen, &prod, &noalign);
 	if (error)
@@ -2185,6 +2211,8 @@ xfs_bmap_rtalloc(
 
 	if (xfs_bmap_adjacent(ap))
 		bno_hint = ap->blkno;
+	else if (stream_id && xfs_has_rtgroups(ap->ip->i_mount))
+		bno_hint = xfs_bmap_write_stream_rtbno(ap->ip, stream_id);
 
 	if (xfs_has_rtgroups(ap->ip->i_mount)) {
 		error = xfs_rtallocate_rtgs(ap->tp, bno_hint, raminlen, ralen,
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 443b3d847150..5c92f8ebd8a7 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -637,6 +637,13 @@ xfs_setup_devices(
 		if (error)
 			return error;
 		xfs_update_bdi_rahead(mp);
+
+		if (xfs_has_rtgroups(mp) && !xfs_has_zoned(mp)) {
+			error = xfs_buftarg_init_streams(mp->m_rtdev_targp,
+					mp->m_sb.sb_rgcount);
+			if (error)
+				return error;
+		}
 	}
 
 	return 0;
-- 
2.25.1

