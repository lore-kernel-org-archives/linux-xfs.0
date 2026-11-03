Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793705715;
	b=gWqmKbngLNaLA6P6HvRFdpi4vGWcQnBxQd6Ppia3OD+l/VRa4CBCtfuF4XSXIaK0kXn8
	 PVhXJ7uc9j1YNBsC5QN6uk5VhwzD3vSVyr66xLyxwb5R5PMRgh7Q7PmhbPAgP87AgyI63
	 euze38je8cqB7duCosOeSXUL+q6oOoaYuFpF7GBqiw2twXPp77ZcBRuqvmfI5gd/9vq6T
	 4cX7+QkU1m1eYrjoBE8CexZ4fwR2s/n/wwFnRSKIeUWQGo6L7QPbZ4Ufjs4OAWjpZV3il
	 PvxeWe2gFlo8GWJsLDbz995lqOAx9l3l86vzucO1R2GrSJaYXcYLmXNjrib5EUZfUYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793705715;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=ZlobiiRI2PMZXAFmH40YBBTEakyRU6tDnxg7jpDiYMA=;
	b=Ov7W4z1O4EFiYg+YdF+mdR56DNEbUBKChMahimbZQQTRKdZxW1AlhpTZ6KJx3O3tKj5n
	 BTkW6HMwmTr7PWEta39tsl+3+OK/LD1WvPsgO/gQyIz7Ac8ZOuZtH5Afk2/kd8CcJgMTL
	 +7CM4TznnNsPOMM1wpDw5fvc/E+geTC8dP0oSzFTJUt9eJ+NctJn4GQ4hjMOnXRprwgpa
	 +tPCtu1pci+mW2OupQHsXPueDpxTNC+V6vC37kgJeb9tJ7yeZmMq/BaQvVSINuXTXyF7g
	 5sAJtiuDMHuDJHv3LDryNHhPZC+MoFnFsft1CrmkahwCKAcZifk4XLrwcg0426CaRtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=UCXHQaB3;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDBF606A33A
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 11:35:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BDBF606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=UCXHQaB3
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261103113512epoutp027e200bd9d11ed5d1491080d72c9040a1~khdd3giF30925309253epoutp02Y
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 11:35:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261103113512epoutp027e200bd9d11ed5d1491080d72c9040a1~khdd3giF30925309253epoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793705712;
	bh=ZlobiiRI2PMZXAFmH40YBBTEakyRU6tDnxg7jpDiYMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCXHQaB3x2Ajc/x2//Ly3RA27s9UfeSDKoFnwmA7XCWScskJrAd0sPj+SVhsUmGoi
	 CpSyxiF0Wua/st/Jpp6qj6H3npqkhazXKd5BCSUz20UC+Vpj4lPA6Kia5QdytewENX
	 sXy3vQ+47a/MtqjEWPbmT92o8ZFEzCTq+4/h6uOo=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20261103113511epcas5p253253ce0294e741bfe727e2a8e586d01~khddKVchD2045420454epcas5p2K;
	Tue,  3 Nov 2026 11:35:11 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.94]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4jJmhZ49Bqz3hhT9; Tue,  3 Nov
	2026 11:35:10 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20261103111035epcas5p4443318f2a21dd58925eb89d275e7237e~khH__U0pd1738217382epcas5p4I;
	Tue,  3 Nov 2026 11:10:35 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261103111033epsmtip1884a2145771a5cdaf956f46df4e3864d~khH9RLGOH2961729617epsmtip1I;
	Tue,  3 Nov 2026 11:10:33 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v7 6/8] xfs: support write streams on realtime volumes
Date: Tue,  3 Nov 2026 16:36:38 +0530
Message-Id: <20261103110640.1000095-7-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261103110640.1000095-1-anuj20.g@samsung.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261103111035epcas5p4443318f2a21dd58925eb89d275e7237e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261103111035epcas5p4443318f2a21dd58925eb89d275e7237e
References: <20261103110640.1000095-1-anuj20.g@samsung.com>
	<CGME20261103111035epcas5p4443318f2a21dd58925eb89d275e7237e@epcas5p4.samsung.com>

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
index 636f039e8f71..a5cc6dfa17dd 100644
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
index 2490b6ec5f4e..fcbb088c33e3 100644
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
index a541e97b580f..0a0a08eb3eb1 100644
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

