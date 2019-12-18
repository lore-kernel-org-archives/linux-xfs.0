Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD11C2D0BF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 19:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 167C12082E
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 19:37:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bCaKsvFt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfLRTht (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 14:37:49 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44154 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbfLRTht (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 14:37:49 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIJYMvl123943;
        Wed, 18 Dec 2019 19:37:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=SJttFxX1Otmt9o2KmK2KG5QucN08c8k3CWDXkVXil+Y=;
 b=bCaKsvFt+hGiBvgu+WEB/49cG2ZQCn068kQ4JbxYX5janGLfGJhGdBus/Hf+SyFBK/z/
 lMP3p0CK0HCQv1zJb7O0lDjj/miMpXRV5FQ/bYyM27a8pKcq+1It8b4lPofh6hm8fW/S
 xiMFjcol33AlDsPck1CWssH+17wdb8KgnIcArsQqnLJauxWm5sK9O6zSfaxOJifuq0iD
 mYnBH4ujCWkOmOZqa8b4OQrC0D8ch67/TAv0jVkz8ZJ/w2T/d4X5DSUR/B8hJYu0GipL
 rq7n2EHP7GuGetME88V9+sRUwmH/Brb6bOulgAjgwAKQTyfJms3qW6NsC2VcFY7vT/JF BQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2wvqpqfrxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 19:37:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIJXPkd152428;
        Wed, 18 Dec 2019 19:37:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2wyp085qst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 19:37:45 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBIJbh0r021146;
        Wed, 18 Dec 2019 19:37:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Dec 2019 11:37:42 -0800
Subject: [PATCH 3/3] xfs: don't commit sunit/swidth updates to disk if that
 would cause repair failures
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com, david@fromorbit.com,
        alex@zadara.com
Date:   Wed, 18 Dec 2019 11:37:41 -0800
Message-ID: <157669786175.117895.11314956770127929017.stgit@magnolia>
In-Reply-To: <157669784202.117895.9984764081860081830.stgit@magnolia>
References: <157669784202.117895.9984764081860081830.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912180152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912180152
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Alex Lyakas reported[1] that mounting an xfs filesystem with new sunit
and swidth values could cause xfs_repair to fail loudly.  The problem
here is that repair calculates the where mkfs should have allocated the
root inode, based on the superblock geometry.  The allocation decisions
depend on sunit, which means that we really can't go updating sunit if
it would lead to a subsequent repair failure on an otherwise correct
filesystem.

Port from xfs_repair some code that computes the location of the root
inode and teach mount to skip the ondisk update if it would cause
problems for repair.  Along the way we'll update the documentation,
provide a function for computing the minimum AGFL size instead of
open-coding it, and cut down some indenting in the mount code.

Note that we allow the mount to proceed (and new allocations will
reflect this new geometry) because we've never screened this kind of
thing before.  We'll have to wait for a new future incompat feature to
enforce correct behavior, alas.

Note that the geometry reporting always uses the superblock values, not
the incore ones, so that is what xfs_info and xfs_growfs will report.

[1] https://lore.kernel.org/linux-xfs/20191125130744.GA44777@bfoster/T/#m00f9594b511e076e2fcdd489d78bc30216d72a7d

Reported-by: Alex Lyakas <alex@zadara.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ialloc.c |   70 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.h |    1 +
 fs/xfs/xfs_mount.c         |   45 ++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h         |   21 +++++++++++++
 4 files changed, 136 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 988cde7744e6..eeec7c8d93fd 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2909,3 +2909,73 @@ xfs_ialloc_setup_geometry(
 	else
 		igeo->ialloc_align = 0;
 }
+
+/*
+ * Compute the location of the root directory inode that is laid out by mkfs.
+ * The @sunit parameter will be copied from the superblock if it is negative.
+ */
+xfs_ino_t
+xfs_ialloc_calc_rootino(
+	struct xfs_mount	*mp,
+	int			sunit)
+{
+	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	xfs_agblock_t		first_bno;
+
+	if (sunit < 0)
+		sunit = mp->m_sb.sb_unit;
+
+	/*
+	 * Pre-calculate the geometry of AG 0.  We know what it looks like
+	 * because libxfs knows how to create allocation groups now.
+	 *
+	 * first_bno is the first block in which mkfs could possibly have
+	 * allocated the root directory inode, once we factor in the metadata
+	 * that mkfs formats before it.  Namely, the four AG headers...
+	 */
+	first_bno = howmany(4 * mp->m_sb.sb_sectsize, mp->m_sb.sb_blocksize);
+
+	/* ...the two free space btree roots... */
+	first_bno += 2;
+
+	/* ...the inode btree root... */
+	first_bno += 1;
+
+	/* ...the initial AGFL... */
+	first_bno += xfs_alloc_min_freelist(mp, NULL);
+
+	/* ...the free inode btree root... */
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		first_bno++;
+
+	/* ...the reverse mapping btree root... */
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		first_bno++;
+
+	/* ...the reference count btree... */
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		first_bno++;
+
+	/*
+	 * ...and the log, if it is allocated in the first allocation group.
+	 *
+	 * This can happen with filesystems that only have a single
+	 * allocation group, or very odd geometries created by old mkfs
+	 * versions on very small filesystems.
+	 */
+	if (mp->m_sb.sb_logstart &&
+	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == 0)
+		 first_bno += mp->m_sb.sb_logblocks;
+
+	/*
+	 * Now round first_bno up to whatever allocation alignment is given
+	 * by the filesystem or was passed in.
+	 */
+	if (xfs_sb_version_hasdalign(&mp->m_sb) && igeo->ialloc_align > 0)
+		first_bno = roundup(first_bno, sunit);
+	else if (xfs_sb_version_hasalign(&mp->m_sb) &&
+			mp->m_sb.sb_inoalignmt > 1)
+		first_bno = roundup(first_bno, mp->m_sb.sb_inoalignmt);
+
+	return XFS_AGINO_TO_INO(mp, 0, XFS_AGB_TO_AGINO(mp, first_bno));
+}
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 323592d563d5..72b3468b97b1 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -152,5 +152,6 @@ int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
 
 int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
 void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
+xfs_ino_t xfs_ialloc_calc_rootino(struct xfs_mount *mp, int sunit);
 
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 3750f0074c74..7f94c6b20920 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -31,7 +31,7 @@
 #include "xfs_reflink.h"
 #include "xfs_extent_busy.h"
 #include "xfs_health.h"
-
+#include "xfs_trace.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
 static int xfs_uuid_table_size;
@@ -359,6 +359,42 @@ xfs_readsb(
 	return error;
 }
 
+/*
+ * If the sunit/swidth change would move the precomputed root inode value, we
+ * must reject the ondisk change because repair will stumble over that.
+ * However, we allow the mount to proceed because we never rejected this
+ * combination before.  Returns true to update the sb, false otherwise.
+ */
+static inline int
+xfs_check_new_dalign(
+	struct xfs_mount	*mp,
+	int			new_dalign,
+	bool			*update_sb)
+{
+	struct xfs_sb		*sbp = &mp->m_sb;
+	xfs_ino_t		calc_ino;
+
+	calc_ino = xfs_ialloc_calc_rootino(mp, new_dalign);
+	trace_xfs_check_new_dalign(mp, new_dalign, calc_ino);
+
+	if (sbp->sb_rootino == calc_ino) {
+		*update_sb = true;
+		return 0;
+	}
+
+	xfs_warn(mp,
+"Cannot change stripe alignment; would require moving root inode.");
+
+	/*
+	 * XXX: Next time we add a new incompat feature, this should start
+	 * returning -EINVAL to fail the mount.  Until then, spit out a warning
+	 * that we're ignoring the administrator's instructions.
+	 */
+	xfs_warn(mp, "Skipping superblock stripe alignment update.");
+	*update_sb = false;
+	return 0;
+}
+
 /*
  * If we were provided with new sunit/swidth values as mount options, make sure
  * that they pass basic alignment and superblock feature checks, and convert
@@ -422,10 +458,17 @@ xfs_update_alignment(
 	struct xfs_sb		*sbp = &mp->m_sb;
 
 	if (mp->m_dalign) {
+		bool		update_sb;
+		int		error;
+
 		if (sbp->sb_unit == mp->m_dalign &&
 		    sbp->sb_width == mp->m_swidth)
 			return 0;
 
+		error = xfs_check_new_dalign(mp, mp->m_dalign, &update_sb);
+		if (error || !update_sb)
+			return error;
+
 		sbp->sb_unit = mp->m_dalign;
 		sbp->sb_width = mp->m_swidth;
 		mp->m_update_sb = true;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index c13bb3655e48..a86be7f807ee 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3573,6 +3573,27 @@ DEFINE_KMEM_EVENT(kmem_alloc_large);
 DEFINE_KMEM_EVENT(kmem_realloc);
 DEFINE_KMEM_EVENT(kmem_zone_alloc);
 
+TRACE_EVENT(xfs_check_new_dalign,
+	TP_PROTO(struct xfs_mount *mp, int new_dalign, xfs_ino_t calc_rootino),
+	TP_ARGS(mp, new_dalign, calc_rootino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(int, new_dalign)
+		__field(xfs_ino_t, sb_rootino)
+		__field(xfs_ino_t, calc_rootino)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->new_dalign = new_dalign;
+		__entry->sb_rootino = mp->m_sb.sb_rootino;
+		__entry->calc_rootino = calc_rootino;
+	),
+	TP_printk("dev %d:%d new_dalign %d sb_rootino %llu calc_rootino %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->new_dalign, __entry->sb_rootino,
+		  __entry->calc_rootino)
+)
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

