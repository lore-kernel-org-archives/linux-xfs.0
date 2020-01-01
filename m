Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A73F7C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6627C206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:03:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BfREjZWQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbgAABDa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:03:30 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45518 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbgAABD3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:03:29 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0010x7X9085430
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:03:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=dcw7XtanPwfvMg34DwgngsKJNC6e4CXxvWlFoBDq2SE=;
 b=BfREjZWQCbAhZyfJIoXh/Wvuik8SoeYhJBHg3ino/HvamcytoV42u+3Jcc202TzgOQux
 bt37fQXRNn3tKH0cJ341CLJN6wZzoyRrOjBoqsSpqP6utw3ud9FmbhxeAwJsk9eYu8N/
 3YAo7889zo3+9NbqwANDe2Y2oAfX4jur50GcBwZKFWFPlSoKJou/mlVdjAICNsrTpn9G
 CSzzUSzdBt/gHeJ6G5bJ/CTnOCcin9ek7I6p5nPXzXpgaWgTbjz5QAKtaKlj0XSgK0KM
 1vrTujOz7Wcfei4uoo4d4Ms8BwtkOlWBx2g2p9c/URCekJC/8GsWGrrdCqU8qMRqi9T2 Kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2x5ypqjw68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:03:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0010ww7e190720
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:03:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2x8guedta2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:03:26 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00113PM5020850
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:03:25 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:03:24 -0800
Subject: [PATCH 1/4] xfs: repair inode records
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:03:22 -0800
Message-ID: <157784060272.1358827.1608101046094412818.stgit@magnolia>
In-Reply-To: <157784059646.1358827.16261069190736091900.stgit@magnolia>
References: <157784059646.1358827.16261069190736091900.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010007
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Try to reinitialize corrupt inodes, or clear the reflink flag
if it's not needed.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile             |    1 
 fs/xfs/libxfs/xfs_format.h  |    3 
 fs/xfs/scrub/inode_repair.c |  662 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h       |    2 
 fs/xfs/scrub/scrub.c        |    2 
 5 files changed, 668 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/inode_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 7506dc7092e2..a66b75625940 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -163,6 +163,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   array.o \
 				   bitmap.o \
 				   ialloc_repair.o \
+				   inode_repair.o \
 				   refcount_repair.o \
 				   repair.o \
 				   xfile.o \
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 1b7dcbae051c..7f1616199d79 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -979,7 +979,8 @@ enum xfs_dinode_fmt {
 #define XFS_DFORK_APTR(dip)	\
 	(XFS_DFORK_DPTR(dip) + XFS_DFORK_BOFF(dip))
 #define XFS_DFORK_PTR(dip,w)	\
-	((w) == XFS_DATA_FORK ? XFS_DFORK_DPTR(dip) : XFS_DFORK_APTR(dip))
+	((void *)((w) == XFS_DATA_FORK ? XFS_DFORK_DPTR(dip) : \
+					 XFS_DFORK_APTR(dip)))
 
 #define XFS_DFORK_FORMAT(dip,w) \
 	((w) == XFS_DATA_FORK ? \
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
new file mode 100644
index 000000000000..268803d23177
--- /dev/null
+++ b/fs/xfs/scrub/inode_repair.c
@@ -0,0 +1,662 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
+#include "xfs_inode_buf.h"
+#include "xfs_inode_fork.h"
+#include "xfs_ialloc.h"
+#include "xfs_da_format.h"
+#include "xfs_reflink.h"
+#include "xfs_rmap.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_quota_defs.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+
+/*
+ * Inode Repair
+ *
+ * Roughly speaking, inode problems can be classified based on whether or not
+ * they trip the dinode verifiers.  If those trip, then we won't be able to
+ * _iget ourselves the inode.
+ *
+ * Therefore, the xrep_dinode_* functions fix anything that will cause the
+ * inode buffer verifier or the dinode verifier.  The xrep_inode_* functions
+ * fix things on live incore inodes.
+ */
+
+/* Make sure this buffer can pass the inode buffer verifier. */
+STATIC void
+xrep_dinode_buf(
+	struct xfs_scrub	*sc,
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_trans	*tp = sc->tp;
+	struct xfs_dinode	*dip;
+	xfs_agnumber_t		agno;
+	xfs_agino_t		agino;
+	int			ioff;
+	int			i;
+	int			ni;
+	bool			crc_ok;
+	bool			magic_ok;
+	bool			unlinked_ok;
+
+	ni = XFS_BB_TO_FSB(mp, bp->b_length) * mp->m_sb.sb_inopblock;
+	agno = xfs_daddr_to_agno(mp, XFS_BUF_ADDR(bp));
+	for (i = 0; i < ni; i++) {
+		ioff = i << mp->m_sb.sb_inodelog;
+		dip = xfs_buf_offset(bp, ioff);
+		agino = be32_to_cpu(dip->di_next_unlinked);
+
+		unlinked_ok = magic_ok = crc_ok = false;
+
+		if (xfs_verify_agino_or_null(sc->mp, agno, agino))
+			unlinked_ok = true;
+
+		if (dip->di_magic == cpu_to_be16(XFS_DINODE_MAGIC) &&
+		    xfs_dinode_good_version(mp, dip->di_version))
+			magic_ok = true;
+
+		if (xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
+				XFS_DINODE_CRC_OFF))
+			crc_ok = true;
+
+		if (magic_ok && unlinked_ok && crc_ok)
+			continue;
+
+		if (!magic_ok) {
+			dip->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
+			dip->di_version = 3;
+		}
+		if (!unlinked_ok)
+			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
+		xfs_dinode_calc_crc(mp, dip);
+		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
+		xfs_trans_log_buf(tp, bp, ioff, ioff + sizeof(*dip) - 1);
+	}
+}
+
+/* Reinitialize things that never change in an inode. */
+STATIC void
+xrep_dinode_header(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip)
+{
+	dip->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
+	if (!xfs_dinode_good_version(sc->mp, dip->di_version))
+		dip->di_version = 3;
+	dip->di_ino = cpu_to_be64(sc->sm->sm_ino);
+	uuid_copy(&dip->di_uuid, &sc->mp->m_sb.sb_meta_uuid);
+	dip->di_gen = cpu_to_be32(sc->sm->sm_gen);
+}
+
+/*
+ * Turn di_mode into /something/ recognizable.
+ *
+ * XXX: Ideally we'd try to read data block 0 to see if it's a directory.
+ */
+STATIC void
+xrep_dinode_mode(
+	struct xfs_dinode	*dip)
+{
+	uint16_t		mode;
+
+	mode = be16_to_cpu(dip->di_mode);
+	if (mode == 0 || xfs_mode_to_ftype(mode) != XFS_DIR3_FT_UNKNOWN)
+		return;
+
+	/* bad mode, so we set it to a file that only root can read */
+	mode = S_IFREG;
+	dip->di_mode = cpu_to_be16(mode);
+	dip->di_uid = 0;
+	dip->di_gid = 0;
+}
+
+/* Fix any conflicting flags that the verifiers complain about. */
+STATIC void
+xrep_dinode_flags(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip)
+{
+	struct xfs_mount	*mp = sc->mp;
+	uint64_t		flags2;
+	uint16_t		mode;
+	uint16_t		flags;
+
+	mode = be16_to_cpu(dip->di_mode);
+	flags = be16_to_cpu(dip->di_flags);
+	flags2 = be64_to_cpu(dip->di_flags2);
+
+	if (xfs_sb_version_hasreflink(&mp->m_sb) && S_ISREG(mode))
+		flags2 |= XFS_DIFLAG2_REFLINK;
+	else
+		flags2 &= ~(XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE);
+	if (flags & XFS_DIFLAG_REALTIME)
+		flags2 &= ~XFS_DIFLAG2_REFLINK;
+	if (flags2 & XFS_DIFLAG2_REFLINK)
+		flags2 &= ~XFS_DIFLAG2_DAX;
+	dip->di_flags = cpu_to_be16(flags);
+	dip->di_flags2 = cpu_to_be64(flags2);
+}
+
+/*
+ * Blow out symlink; now it points to the current dir.  We don't have to worry
+ * about incore state because this inode is failing the verifiers.
+ */
+STATIC void
+xrep_dinode_zap_symlink(
+	struct xfs_dinode	*dip)
+{
+	char			*p;
+
+	dip->di_format = XFS_DINODE_FMT_LOCAL;
+	dip->di_size = cpu_to_be64(1);
+	p = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+	*p = '.';
+}
+
+/*
+ * Blow out dir, make it point to the root.  In the future repair will
+ * reconstruct this directory for us.  Note that there's no in-core directory
+ * inode because the sf verifier tripped, so we don't have to worry about the
+ * dentry cache.
+ */
+STATIC void
+xrep_dinode_zap_dir(
+	struct xfs_mount		*mp,
+	struct xfs_dinode		*dip)
+{
+	struct xfs_dir2_sf_hdr		*sfp;
+	int				i8count;
+
+	dip->di_format = XFS_DINODE_FMT_LOCAL;
+	i8count = mp->m_sb.sb_rootino > XFS_DIR2_MAX_SHORT_INUM;
+	sfp = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+	sfp->count = 0;
+	sfp->i8count = i8count;
+	xfs_dir2_sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
+	dip->di_size = cpu_to_be64(xfs_dir2_sf_hdr_size(i8count));
+}
+
+/* Make sure we don't have a garbage file size. */
+STATIC void
+xrep_dinode_size(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dip)
+{
+	uint64_t		size;
+	uint16_t		mode;
+
+	mode = be16_to_cpu(dip->di_mode);
+	size = be64_to_cpu(dip->di_size);
+	switch (mode & S_IFMT) {
+	case S_IFIFO:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFSOCK:
+		/* di_size can't be nonzero for special files */
+		dip->di_size = 0;
+		break;
+	case S_IFREG:
+		/* Regular files can't be larger than 2^63-1 bytes. */
+		dip->di_size = cpu_to_be64(size & ~(1ULL << 63));
+		break;
+	case S_IFLNK:
+		/*
+		 * Truncate ridiculously oversized symlinks.  If the size is
+		 * zero, reset it to point to the current directory.  Both of
+		 * these conditions trigger dinode verifier errors, so there
+		 * is no in-core state to reset.
+		 */
+		if (size > XFS_SYMLINK_MAXLEN)
+			dip->di_size = cpu_to_be64(XFS_SYMLINK_MAXLEN);
+		else if (size == 0)
+			xrep_dinode_zap_symlink(dip);
+		break;
+	case S_IFDIR:
+		/*
+		 * Directories can't have a size larger than 32G.  If the size
+		 * is zero, reset it to an empty directory.  Both of these
+		 * conditions trigger dinode verifier errors, so there is no
+		 * in-core state to reset.
+		 */
+		if (size > XFS_DIR2_SPACE_SIZE)
+			dip->di_size = cpu_to_be64(XFS_DIR2_SPACE_SIZE);
+		else if (size == 0)
+			xrep_dinode_zap_dir(mp, dip);
+		break;
+	}
+}
+
+/* Fix extent size hints. */
+STATIC void
+xrep_dinode_extsize_hints(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip)
+{
+	struct xfs_mount	*mp = sc->mp;
+	uint64_t		flags2;
+	uint16_t		flags;
+	uint16_t		mode;
+	xfs_failaddr_t		fa;
+
+	mode = be16_to_cpu(dip->di_mode);
+	flags = be16_to_cpu(dip->di_flags);
+	flags2 = be64_to_cpu(dip->di_flags2);
+
+	fa = xfs_inode_validate_extsize(mp, be32_to_cpu(dip->di_extsize),
+			mode, flags);
+	if (fa) {
+		dip->di_extsize = 0;
+		dip->di_flags &= ~cpu_to_be16(XFS_DIFLAG_EXTSIZE |
+					      XFS_DIFLAG_EXTSZINHERIT);
+	}
+
+	if (dip->di_version < 3)
+		return;
+
+	fa = xfs_inode_validate_cowextsize(mp, be32_to_cpu(dip->di_cowextsize),
+			mode, flags, flags2);
+	if (fa) {
+		dip->di_cowextsize = 0;
+		dip->di_flags2 &= ~cpu_to_be64(XFS_DIFLAG2_COWEXTSIZE);
+	}
+}
+
+/* Inode didn't pass verifiers, so fix the raw buffer and retry iget. */
+STATIC int
+xrep_dinode_core(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_imap		imap;
+	struct xfs_buf		*bp;
+	struct xfs_dinode	*dip;
+	xfs_ino_t		ino;
+	bool			inuse;
+	int			error;
+
+	/* Map & read inode. */
+	ino = sc->sm->sm_ino;
+	error = xfs_imap(sc->mp, sc->tp, ino, &imap, XFS_IGET_UNTRUSTED);
+	if (error)
+		return error;
+
+	error = xfs_trans_read_buf(sc->mp, sc->tp, sc->mp->m_ddev_targp,
+			imap.im_blkno, imap.im_len, XBF_UNMAPPED, &bp, NULL);
+	if (error)
+		return error;
+
+	/* Make absolutely sure this inode isn't in core. */
+	error = xfs_icache_inode_is_allocated(sc->mp, sc->tp, ino, &inuse);
+	if (error == 0) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	/* Make sure we can pass the inode buffer verifier. */
+	xrep_dinode_buf(sc, bp);
+	bp->b_ops = &xfs_inode_buf_ops;
+
+	/* Fix everything the verifier will complain about. */
+	dip = xfs_buf_offset(bp, imap.im_boffset);
+	xrep_dinode_header(sc, dip);
+	xrep_dinode_mode(dip);
+	xrep_dinode_flags(sc, dip);
+	xrep_dinode_size(sc->mp, dip);
+	xrep_dinode_extsize_hints(sc, dip);
+
+	/* Write out the inode... */
+	xfs_dinode_calc_crc(sc->mp, dip);
+	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_DINO_BUF);
+	xfs_trans_log_buf(sc->tp, bp, imap.im_boffset,
+			imap.im_boffset + sc->mp->m_sb.sb_inodesize - 1);
+	error = xfs_trans_commit(sc->tp);
+	if (error)
+		return error;
+	sc->tp = NULL;
+
+	/* ...and reload it? */
+	error = xfs_iget(sc->mp, sc->tp, ino,
+			XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE, 0, &sc->ip);
+	if (error)
+		return error;
+	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
+	xfs_ilock(sc->ip, sc->ilock_flags);
+	error = xchk_trans_alloc(sc, 0);
+	if (error)
+		return error;
+	sc->ilock_flags |= XFS_ILOCK_EXCL;
+	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
+
+	return 0;
+}
+
+/* Fix everything xfs_dinode_verify cares about. */
+STATIC int
+xrep_dinode_problems(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	error = xrep_dinode_core(sc);
+	if (error)
+		return error;
+
+	/* We had to fix a totally busted inode, schedule quotacheck. */
+	if (XFS_IS_UQUOTA_ON(sc->mp))
+		xrep_force_quotacheck(sc, XFS_DQ_USER);
+	if (XFS_IS_GQUOTA_ON(sc->mp))
+		xrep_force_quotacheck(sc, XFS_DQ_GROUP);
+	if (XFS_IS_PQUOTA_ON(sc->mp))
+		xrep_force_quotacheck(sc, XFS_DQ_PROJ);
+
+	return 0;
+}
+
+/*
+ * Fix problems that the verifiers don't care about.  In general these are
+ * errors that don't cause problems elsewhere in the kernel that we can easily
+ * detect, so we don't check them all that rigorously.
+ */
+
+/* Make sure block and extent counts are ok. */
+STATIC int
+xrep_inode_blockcounts(
+	struct xfs_scrub	*sc)
+{
+	xfs_filblks_t		count;
+	xfs_filblks_t		acount;
+	xfs_extnum_t		nextents;
+	int			error;
+
+	/* Set data fork counters from the data fork mappings. */
+	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_DATA_FORK,
+			&nextents, &count);
+	if (error)
+		return error;
+	if (XFS_IS_REALTIME_INODE(sc->ip)) {
+		if (count >= sc->mp->m_sb.sb_rblocks)
+			return -EFSCORRUPTED;
+	} else if (!xfs_sb_version_hasreflink(&sc->mp->m_sb)) {
+		if (count >= sc->mp->m_sb.sb_dblocks)
+			return -EFSCORRUPTED;
+	}
+	sc->ip->i_d.di_nextents = nextents;
+
+	/* Set attr fork counters from the attr fork mappings. */
+	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
+			&nextents, &acount);
+	if (error)
+		return error;
+	if (count >= sc->mp->m_sb.sb_dblocks)
+		return -EFSCORRUPTED;
+	if (nextents >= (uint16_t)-1U)
+		return -EFSCORRUPTED;
+	sc->ip->i_d.di_anextents = nextents;
+
+	sc->ip->i_d.di_nblocks = count + acount;
+
+	/*
+	 * If we found attr fork extents but no attr fork root, zero the
+	 * attr fork extent count so that the attr fork repair will run.
+	 */
+	if (sc->ip->i_d.di_anextents != 0 && sc->ip->i_d.di_forkoff == 0)
+		sc->ip->i_d.di_anextents = 0;
+
+	return 0;
+}
+
+/* Check for invalid uid/gid.  Note that a -1U projid is allowed. */
+STATIC void
+xrep_inode_ids(
+	struct xfs_scrub	*sc)
+{
+	if (sc->ip->i_d.di_uid == -1U) {
+		sc->ip->i_d.di_uid = 0;
+		VFS_I(sc->ip)->i_mode &= ~(S_ISUID | S_ISGID);
+		if (XFS_IS_UQUOTA_ON(sc->mp))
+			xrep_force_quotacheck(sc, XFS_DQ_USER);
+	}
+
+	if (sc->ip->i_d.di_gid == -1U) {
+		sc->ip->i_d.di_gid = 0;
+		VFS_I(sc->ip)->i_mode &= ~(S_ISUID | S_ISGID);
+		if (XFS_IS_GQUOTA_ON(sc->mp))
+			xrep_force_quotacheck(sc, XFS_DQ_GROUP);
+	}
+}
+
+static inline void
+xrep_clamp_nsec(
+	struct timespec64	*ts)
+{
+	ts->tv_nsec = clamp_t(long, ts->tv_nsec, 0, NSEC_PER_SEC);
+}
+
+/* Nanosecond counters can't have more than 1 billion. */
+STATIC void
+xrep_inode_timestamps(
+	struct xfs_inode	*ip)
+{
+	xrep_clamp_nsec(&VFS_I(ip)->i_atime);
+	xrep_clamp_nsec(&VFS_I(ip)->i_mtime);
+	xrep_clamp_nsec(&VFS_I(ip)->i_ctime);
+
+	if (ip->i_d.di_version > 2)
+		xrep_clamp_nsec(&ip->i_d.di_crtime);
+}
+
+/* Fix inode flags that don't make sense together. */
+STATIC void
+xrep_inode_flags(
+	struct xfs_scrub	*sc)
+{
+	uint16_t		mode;
+
+	mode = VFS_I(sc->ip)->i_mode;
+
+	/* Clear junk flags */
+	if (sc->ip->i_d.di_flags & ~XFS_DIFLAG_ANY)
+		sc->ip->i_d.di_flags &= ~XFS_DIFLAG_ANY;
+
+	/* NEWRTBM only applies to realtime bitmaps */
+	if (sc->ip->i_ino == sc->mp->m_sb.sb_rbmino)
+		sc->ip->i_d.di_flags |= XFS_DIFLAG_NEWRTBM;
+	else
+		sc->ip->i_d.di_flags &= ~XFS_DIFLAG_NEWRTBM;
+
+	/* These only make sense for directories. */
+	if (!S_ISDIR(mode))
+		sc->ip->i_d.di_flags &= ~(XFS_DIFLAG_RTINHERIT |
+					  XFS_DIFLAG_EXTSZINHERIT |
+					  XFS_DIFLAG_PROJINHERIT |
+					  XFS_DIFLAG_NOSYMLINKS);
+
+	/* These only make sense for files. */
+	if (!S_ISREG(mode))
+		sc->ip->i_d.di_flags &= ~(XFS_DIFLAG_REALTIME |
+					  XFS_DIFLAG_EXTSIZE);
+
+	/* These only make sense for non-rt files. */
+	if (sc->ip->i_d.di_flags & XFS_DIFLAG_REALTIME)
+		sc->ip->i_d.di_flags &= ~XFS_DIFLAG_FILESTREAM;
+
+	/* Immutable and append only?  Drop the append. */
+	if ((sc->ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE) &&
+	    (sc->ip->i_d.di_flags & XFS_DIFLAG_APPEND))
+		sc->ip->i_d.di_flags &= ~XFS_DIFLAG_APPEND;
+
+	if (sc->ip->i_d.di_version < 3)
+		return;
+
+	/* Clear junk flags. */
+	if (sc->ip->i_d.di_flags2 & ~XFS_DIFLAG2_ANY)
+		sc->ip->i_d.di_flags2 &= ~XFS_DIFLAG2_ANY;
+
+	/* No reflink flag unless we support it and it's a file. */
+	if (!xfs_sb_version_hasreflink(&sc->mp->m_sb) ||
+	    !S_ISREG(mode))
+		sc->ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+
+	/* DAX only applies to files and dirs. */
+	if (!(S_ISREG(mode) || S_ISDIR(mode)))
+		sc->ip->i_d.di_flags2 &= ~XFS_DIFLAG2_DAX;
+
+	/* No reflink files on the realtime device. */
+	if (sc->ip->i_d.di_flags & XFS_DIFLAG_REALTIME)
+		sc->ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+
+	/* No mixing reflink and DAX yet. */
+	if (sc->ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK)
+		sc->ip->i_d.di_flags2 &= ~XFS_DIFLAG2_DAX;
+}
+
+/*
+ * Fix size problems with block/node format directories.  If we fail to find
+ * the extent list, just bail out and let the bmapbtd repair functions clean
+ * up that mess.
+ */
+STATIC void
+xrep_inode_blockdir_size(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	got;
+	struct xfs_ifork	*ifp;
+	xfs_fileoff_t		off;
+	int			error;
+
+	/* Find the last block before 32G; this is the dir size. */
+	ifp = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
+	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
+		error = xfs_iread_extents(sc->tp, sc->ip, XFS_DATA_FORK);
+		if (error)
+			return;
+	}
+
+	off = XFS_B_TO_FSB(sc->mp, XFS_DIR2_SPACE_SIZE);
+	if (!xfs_iext_lookup_extent_before(sc->ip, ifp, &off, &icur, &got)) {
+		/* zero-extents directory? */
+		return;
+	}
+
+	off = got.br_startoff + got.br_blockcount;
+	sc->ip->i_d.di_size = min_t(loff_t, XFS_DIR2_SPACE_SIZE,
+			XFS_FSB_TO_B(sc->mp, off));
+}
+
+/* Fix size problems with short format directories. */
+STATIC void
+xrep_inode_sfdir_size(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_ifork	*ifp;
+
+	ifp = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
+	sc->ip->i_d.di_size = ifp->if_bytes;
+}
+
+/*
+ * Fix any irregularities in an inode's size now that we can iterate extent
+ * maps and access other regular inode data.
+ */
+STATIC void
+xrep_inode_size(
+	struct xfs_scrub	*sc)
+{
+	/*
+	 * Currently we only support fixing size on extents or btree format
+	 * directories.  Files can be any size and sizes for the other inode
+	 * special types are fixed by xrep_dinode_size.
+	 */
+	if (!S_ISDIR(VFS_I(sc->ip)->i_mode))
+		return;
+	switch (XFS_IFORK_FORMAT(sc->ip, XFS_DATA_FORK)) {
+	case XFS_DINODE_FMT_EXTENTS:
+	case XFS_DINODE_FMT_BTREE:
+		xrep_inode_blockdir_size(sc);
+		break;
+	case XFS_DINODE_FMT_LOCAL:
+		xrep_inode_sfdir_size(sc);
+		break;
+	}
+}
+
+/* Fix any irregularities in an inode that the verifiers don't catch. */
+STATIC int
+xrep_inode_problems(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	error = xrep_inode_blockcounts(sc);
+	if (error)
+		return error;
+	xrep_inode_timestamps(sc->ip);
+	xrep_inode_flags(sc);
+	xrep_inode_ids(sc);
+	xrep_inode_size(sc);
+	xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+	return xfs_trans_roll_inode(&sc->tp, sc->ip);
+}
+
+/* Repair an inode's fields. */
+int
+xrep_inode(
+	struct xfs_scrub	*sc)
+{
+	int			error = 0;
+
+	/*
+	 * No inode?  That means we failed the _iget verifiers.  Repair all
+	 * the things that the inode verifiers care about, then retry _iget.
+	 */
+	if (!sc->ip) {
+		error = xrep_dinode_problems(sc);
+		if (error)
+			goto out;
+	}
+
+	/* By this point we had better have a working incore inode. */
+	ASSERT(sc->ip);
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+
+	/* If we found corruption of any kind, try to fix it. */
+	if ((sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT) ||
+	    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_XCORRUPT)) {
+		error = xrep_inode_problems(sc);
+		if (error)
+			goto out;
+	}
+
+	/* See if we can clear the reflink flag. */
+	if (xfs_is_reflink_inode(sc->ip))
+		return xfs_reflink_clear_inode_flag(sc->ip, &sc->tp);
+
+out:
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index c0769aaae9a4..dfb4fe77fae8 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -71,6 +71,7 @@ int xrep_agi(struct xfs_scrub *sc);
 int xrep_allocbt(struct xfs_scrub *sc);
 int xrep_iallocbt(struct xfs_scrub *sc);
 int xrep_refcountbt(struct xfs_scrub *sc);
+int xrep_inode(struct xfs_scrub *sc);
 
 struct xrep_newbt_resv {
 	/* Link to list of extents that we've reserved. */
@@ -169,6 +170,7 @@ xrep_reset_perag_resv(
 #define xrep_allocbt			xrep_notsupported
 #define xrep_iallocbt			xrep_notsupported
 #define xrep_refcountbt			xrep_notsupported
+#define xrep_inode			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 7a036a8e4189..ee2b77b4350b 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -261,7 +261,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xchk_setup_inode,
 		.scrub	= xchk_inode,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_inode,
 	},
 	[XFS_SCRUB_TYPE_BMBTD] = {	/* inode data fork */
 		.type	= ST_INODE,

