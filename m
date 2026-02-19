Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27772E541E;
	Thu, 19 Feb 2026 06:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771481168; cv=none; b=oTanlOvWnXL529fK+vgpS/OYQDBz7weDH6p6pY0ax3n/2Qqn+NOV+jMWCTJrlDdPTh9pYYj0wfvDfD+STs0xtswddnYh6vVVT+eTvXYQ9V8E378/EVTydRvBUFapuuAtLk0+zdwSrH+rKwCbViRDpK8wIF7uRC7t1xagwCAO6AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771481168; c=relaxed/simple;
	bh=pRGeVHysY0QB2mXkOiS3Tyaa0sR7jfquAReSu7uYbNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1z/ePnDnJ8xYcutWPzlS5TsX76O+0vZHREDBQCCxz26B+zcAPwWF510jlziz8rx8Td6mmVLPBV/VDCfzk9IOcIR2ppphnX0nkEykqh9mjdTzcWqQVdzi0My/dJwGeMXwHhom83D4E3Y+Uj/W0Jd19ivNYdM9/jbzLrNckhTSGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fPyI8wXb; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fPyI8wXb"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61IKu1KD2385573;
	Thu, 19 Feb 2026 06:05:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=z1F8NWcQQXiTmwcgK
	miB0yMcu944U6N6muNy7ADa868=; b=fPyI8wXbW1nUw682ai0+YS+5PtyMKlvIb
	53DiJADKht5oHC/mXaEeVgnnKg//MI6RXK0p6ahn9oxSU/QklEuV1396uvuEHxl8
	SsnKJ1e1yRWXa/CrKnsBxmQRhpE20hZT8abIGo/9Mkhg3eM1rCaowI1xQizBL/xz
	6SmB3sAZ+a3pqPF4bHIv0NAVsqdEf0RYCxIZQV8QC7uJWUFtWZI2lQj1p3gmzk8q
	+FpGQM06pjU5ieKYqvK6RGI6QqqPQrCJHkePsBf7dx5deYjvRKYxu6+7r4eYYr1X
	9QIdV1rqsDWBtn92yVwNsBe+2l+qAWVvIa0/uVI8jGcely5rkmZTA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj6s4p2j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:05:53 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61J45SFC017777;
	Thu, 19 Feb 2026 06:05:52 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb28k060-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:05:52 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61J65p3g23528150
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 06:05:51 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4944A58056;
	Thu, 19 Feb 2026 06:05:51 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B95BA58052;
	Thu, 19 Feb 2026 06:05:47 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.124.222.193])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 06:05:47 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org, david@fromorbit.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, nirjhar@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, hsiangkao@linux.alibaba.com
Subject: [RFC v1 4/4] xfs: Add support to shrink multiple empty realtime groups
Date: Thu, 19 Feb 2026 11:33:54 +0530
Message-ID: <1a3d14a03083b031ec831a3e748d9002fab23504.1771418537.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1771418537.git.nirjhar.roy.lists@gmail.com>
References: <cover.1771418537.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=dvvWylg4 c=1 sm=1 tr=0 ts=6996a842 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8
 a=SRrdq9N9AAAA:8 a=7-415B0cAAAA:8 a=AcoWIN0dc7QibKHddDgA:9
 a=biEYGPWJfzWAr4FL6Ov7:22
X-Proofpoint-GUID: KGpcM-wFv6HO03E4VcCxwp4Z8OrJ-1wU
X-Proofpoint-ORIG-GUID: 2GrbDeJzxUxV__zlQ5nJ1qerMOxMkk_Q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA0OSBTYWx0ZWRfXz2IZ+pIU1DTD
 S1S/hqpT5f0a3lfnpNNhPqdDXPcmDhfHnpJRnfSPcHMKzQjLYPLXpiKeUbGSmqggfa8XuJPW45v
 1n84QXySdlubuRiKw9ne4a3DtlT6455GPlsjKTatpADZDt1Tqh/8CAAcavfGqiBD6RA0HLi9a61
 pSi5sW0OlKdSsSBB5NRCOWbq5qhMnYzLAdWWfr0cbpZv9fYxOQgB8yR+OzJwDzhZ/koLYZ6ABOC
 pU2Z87eZPDm9K6Wz6tawnii/05/Twp7pnECN2DMx+2zCW0cPW1osom/rnifPub494e4VbedwZ5+
 sxlAQuMqtzxpyjDGzlk6HjKDiE9H/5xLDY5xRORPGQJib5mSvA5pjnlrvl/dDhpQ0cD5nzMI4Fb
 P9wXkFCtu0TsGxoQEEWw4H5oTIz8rfXfnSUqTRkjVsPo5sfiaJb6sDqRKjC7ysxFGTCkFebVjVb
 XkAHurFDCMlUisaszCQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_01,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 phishscore=0 suspectscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602190049

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

This patch is based on a previous RFC[1] by Gao Xiang and various
ideas proposed by Dave Chinner in the RFC[1].

This patch adds the functionality to shrink the filesystem beyond
1 rtgroup. We can remove only empty rtgroups in order to prevent loss
of data. Before I summarize the overall steps of the shrink
process, I would like to introduce some of the terminologies:

1. Empty rtgroup - An rtgroup with no allocated space. Removal of this
   rtgroup will not result in any data loss.

2. Active/Online rtgroup - Online rtgroup and active rtgroup will be used
   interchangebly. An rtgroup is active or online when all the regular
   operations can be done on it. When we mount a filesystem, all
   the rtgroups are by default online/active. In terms of implementation,
   an online rtgroup will have number of active references greater than 0
   (the default value is 1 i.e, an rtgroup by default is online/active).

3. rtgroup offlining/deactivation - rtgroup offlining and rtgroup
   deactivation will be used interchangebly. An rtgroup is said to be
   offlined/deactivated when no new high level operation can be started
   on the rtgroup. This is implemented with the help of active
   references. When the active reference count of an rtgroup is 0, the
   rtgroup is said to be deactivated.
   No new active reference can be taken if the present active reference
   count is 0. This way a barrier is formed from preventing new high
   level operations to get started on an already offlined rtgroup.

4. Reactivating an rtgroup - If we try to remove an offlined rtgroup but
   for some reason, we can't, then we reactivate the rtgroup i.e, the
   rtgroup will once more be in an usable state i.e, the active reference
   count will be set to 1. All the high level operations can now be
   performed on this rtgroup. In terms of implementation, in order to
   activate an rtgroup, we atomically set the active reference count to 1.

5. rtgroup removal - This means that an rtgroup no longer exists in the
   filesystem.

6. New tail rtgroup - This refers to the last rtgroup that will be formed
   after the removal of 1 or more rtgroups. For example, if there are 4
   rtgroups, each with 32 rtextents, then there are total of 4 * 32 = 128
   rtextents. Now, if we remove 40 rtextents, rtgroup 3(indexed at 0)
   will be completely removed (32 rtextents) and from AG 2, we will
   remove 8 rtextents. So rtgroup 2 will be the new tail rtgroup with 24
   rtextents.

7. Old tail rtgroup - This is the last rtgroup before the start of
   the shrink process. If the number of rtextents removed is less than
   the last rtgroup's size, then the old tail rtgroup will be the same as
   the new tail rtgroup.

8. rtgroup stabilization - This simply means that the in-memory contents
   are synched to the disk.

The overall steps for the removal of rtgroup(s) are as follows:
PHASE 1: Preparing the rtgroups for removal
1. Deactivate the rtgroups to be removed completely - This is done
   by the function xfs_shrinkfs_rt_deactivate_rtgroups(). The steps to
   deactivate an rtgrpoup are as follows(function is
   xfs_rtgroup_deactivate()):
     1.a Manually reserve/reduce from the global rtextent free counters
         1 rtgroup worth of rtextents. This is done in order
         to prevent a race where, some rtgroups have been offlined but
         the delayed  allocator has already promised some bytes
         and the real rtextent allocation is failing due to the
         rtgroup(s) being offline.
         So shrink operation reserves to the shrink transaction the
         space to be removed from the incore rtextents and either
         commits that change to the ondisk rtextents
         (shrink succeeds) or gives it back (shrink fails).
     1.b Wait for the active reference to come to 0.
         This is done so that no other entity is racing while the removal
         is in progress i.e, no new high level operation can start on
         that rtgroup while we are trying to remove the rtgroup.
         rtgroup deactivation will fail if the rtgroup is non-empty at
	 the time of deactivation.
2. Once we have waited for the active references to come down to 0,
   we make sure that all the pending operations on that rtgroup are
   completed and the in-core and on-disk structures are in synch i.e,
   the rtgroup is stabilized on to the disk.
   The steps to stablize the rtgroup onto the disk are as follows:
   2.a We need to flush and empty the logs and wait for all the pending
       I/Os to complete - for this, perform a log force+ail push by
       calling xfs_ail_push_all_sync(). This also ensures that
       none of the future logged transactions will refer to these
       rtgroups during log recovery in case if sudden shutdown/crash
       happens while we are trying to remove these rtgroups. We also sync
       the superblock with the disk.
   2.b Wait for all the busy extents for the target rtgroups to be
       resolved (done by the function xfs_extent_busy_wait_rtgroups())
   2.c Flush the xfs_discard_wq workqueue
3. Once the rtgroup is deactivated and stabilized on to the disk, we
   check if all the target rtgroups are empty, and if not, we fail the
   shrink process.

PHASE 2: Shrink new tail rtgroup, punch out totally empty rtgroups
4. Once the preparation phase is over, we start the actual removal
   process. This is done in the function
   xfs_shrinkfs_rt_remove_rtgroups().
   Here, we first remove the rtgroups completely and then update the
   metadata of the new tail rtgroup. The (new) tail rtgroup metadata is
   shrunk in the function xfs_shrinkfs_rt_shrink_new_tail_rtgroup().
5. In the end we log the changes and commit the transaction.

Removal of each incore rtgroup structure is done by the function
xfs_shrinkfs_rt_remove_rtgroup().
The steps can be outlined as follows:
1. Call xfs_rtginodes_ensure_all() to load all the metadata inodes for
   the target rtgroup.
2. Truncate the data blocks for all the metadata files for that rtgroup -
   done by the function xfs_rt_metainodes_truncate().
3. Remove the metadata inodes for the rtgroup - done by the function
   xfs_rt_metainodes_remove().
4. Erase the group from the xarray.
5. Freeing the intents drain queue - done by the function
   xfs_defer_drain_free().
6. Freeing busy extents list.
7. Freeing the struct xfs_rtgroup pointer - We assert that all the active
   and passive references are down to 0.

[1] https://lore.kernel.org/all/20210414195240.1802221-1-hsiangkao@redhat.com/

Inspired-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/libxfs/xfs_group.c     |  14 +
 fs/xfs/libxfs/xfs_group.h     |   2 +
 fs/xfs/libxfs/xfs_rtgroup.c   | 105 ++++-
 fs/xfs/libxfs/xfs_rtgroup.h   |  29 ++
 fs/xfs/xfs_buf_item_recover.c |  25 +-
 fs/xfs/xfs_extent_busy.c      |  30 ++
 fs/xfs/xfs_extent_busy.h      |   2 +
 fs/xfs/xfs_inode.c            |   8 +-
 fs/xfs/xfs_rtalloc.c          | 799 +++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trans.c            |   1 -
 10 files changed, 994 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
index 51ef9dd9d1ed..8210895d069a 100644
--- a/fs/xfs/libxfs/xfs_group.c
+++ b/fs/xfs/libxfs/xfs_group.c
@@ -230,3 +230,17 @@ xfs_group_get_by_fsb(
 {
 	return xfs_group_get(mp, xfs_fsb_to_gno(mp, fsbno, type), type);
 }
+
+int
+xfs_group_get_active_refcount(struct xfs_group *xg)
+{
+	ASSERT(xg);
+	return atomic_read(&xg->xg_active_ref);
+}
+
+int
+xfs_group_get_passive_refcount(struct xfs_group *xg)
+{
+	ASSERT(xg);
+	return atomic_read(&xg->xg_ref);
+}
diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
index 692cb9266457..d21cb610fd57 100644
--- a/fs/xfs/libxfs/xfs_group.h
+++ b/fs/xfs/libxfs/xfs_group.h
@@ -83,6 +83,8 @@ void xfs_group_free(struct xfs_mount *mp, uint32_t index,
 		enum xfs_group_type type, void (*uninit)(struct xfs_group *xg));
 int xfs_group_insert(struct xfs_mount *mp, struct xfs_group *xg,
 		uint32_t index, enum xfs_group_type);
+int xfs_group_get_active_refcount(struct xfs_group *xg);
+int xfs_group_get_passive_refcount(struct xfs_group *xg);
 
 #define xfs_group_set_mark(_xg, _mark) \
 	xa_set_mark(&(_xg)->xg_mount->m_groups[(_xg)->xg_type].xa, \
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index be16efaa6925..dd5f51129a37 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -163,8 +163,13 @@ xfs_initialize_rtgroups(
 }
 
 /*
- * Update the rt extent count of the previous tail rtgroup if it changed during
- * recovery (i.e. recovery of a growfs).
+ * This function does the following:
+ * - Updates the previous rtgroup tail if prev_rgcount < current rgcount i.e,
+ *   the filesystem has grown OR
+ * - Updates the current tail rtgroup when prev_agcount > current agcount i.e,
+ *   the filesystem has shrunk beyond 1 rtgroup OR
+ * - Updates the current tail rtgroup when only the last rtgroup was shrunk or
+ *   grown i.e, prev_agcount == mp->m_sb.sb_rgcount.
  */
 int
 xfs_update_last_rtgroup_size(
@@ -172,13 +177,18 @@ xfs_update_last_rtgroup_size(
 	xfs_rgnumber_t		prev_rgcount)
 {
 	struct xfs_rtgroup	*rtg;
+	xfs_rgnumber_t		rgno;
 
 	ASSERT(prev_rgcount > 0);
 
-	rtg = xfs_rtgroup_grab(mp, prev_rgcount - 1);
+	if (prev_rgcount >= mp->m_sb.sb_rgcount)
+		rgno = mp->m_sb.sb_rgcount - 1;
+	else
+		rgno = prev_rgcount - 1;
+	rtg = xfs_rtgroup_grab(mp, rgno);
 	if (!rtg)
 		return -EFSCORRUPTED;
-	rtg->rtg_extents = __xfs_rtgroup_extents(mp, prev_rgcount - 1,
+	rtg->rtg_extents = __xfs_rtgroup_extents(mp, rgno,
 			mp->m_sb.sb_rgcount, mp->m_sb.sb_rextents);
 	rtg_group(rtg)->xg_block_count = rtg->rtg_extents * mp->m_sb.sb_rextsize;
 	xfs_rtgroup_rele(rtg);
@@ -749,3 +759,90 @@ xfs_log_rtsb(
 	xfs_trans_ordered_buf(tp, rtsb_bp);
 	return rtsb_bp;
 }
+
+void
+xfs_rtgroup_activate(struct xfs_rtgroup	*rtg)
+{
+	ASSERT(!xfs_rtgroup_is_active(rtg));
+	init_waitqueue_head(&rtg_group(rtg)->xg_active_wq);
+	atomic_set(&rtg_group(rtg)->xg_active_ref, 1);
+	xfs_add_frextents(rtg_mount(rtg),
+			xfs_rtgroup_extents(rtg_mount(rtg), rtg_rgno(rtg)));
+}
+
+int
+xfs_rtgroup_deactivate(struct xfs_rtgroup	*rtg)
+{
+	ASSERT(rtg);
+
+	int			error = 0;
+	xfs_rgnumber_t		rgno = rtg_rgno(rtg);
+	struct	xfs_mount	*mp = rtg_mount(rtg);
+	xfs_rtxnum_t		rtextents =
+			xfs_rtgroup_extents(mp, rgno);
+
+	ASSERT(xfs_rtgroup_is_active(rtg));
+	ASSERT(rtg_rgno(rtg) < mp->m_sb.sb_rgcount);
+
+	if (!xfs_rtgroup_is_empty(rtg))
+		return -ENOTEMPTY;
+	/*
+	 * Manually reduce/reserve 1 realtime group worth of
+	 * free realtime extents from the global counters. This is necessary
+	 * in order to prevent a race where, some rtgs have been temporarily
+	 * offlined but the delayed allocator has already promised some bytes
+	 * and later the real extent/block allocation is failing due to
+	 * the rtgs(s) being offline.
+	 * If the overall shrink fails, we will restore the values.
+	 */
+
+	error = xfs_dec_frextents(mp, rtextents);
+	if (error)
+		return -ENOTEMPTY;
+	xfs_rtgroup_rele(rtg);
+	do {
+		error = wait_event_killable(rtg_group(rtg)->xg_active_wq,
+				!xfs_rtgroup_is_active(rtg));
+		if (error == -ERESTARTSYS) {
+			/* Restore the reserved free rtextents */
+			xfs_add_frextents(mp, rtextents);
+			return error;
+		}
+	} while (xfs_rtgroup_is_active(rtg));
+
+	return 0;
+}
+
+/*
+ * This function checks whether an rtgroup is empty. An rtg is eligible to be
+ * removed if it is empty.
+ */
+bool
+xfs_rtgroup_is_empty(
+	struct xfs_rtgroup *rtg)
+{
+	ASSERT(rtg);
+
+	struct xfs_mount        *mp = rtg_mount(rtg);
+	int                     error = 0;
+	xfs_rtxnum_t            new;
+	xfs_rtxnum_t            start = 0;
+	xfs_rtxnum_t            len;
+	int                     stat;
+	xfs_rgnumber_t          rgno = rtg_rgno(rtg);
+
+	struct xfs_rtalloc_args args = {
+		.mp  = mp,
+		.rtg = rtg,
+	};
+
+	args.tp = xfs_trans_alloc_empty(mp);
+	if (!args.tp)
+		return false;
+	len = xfs_rtgroup_extents(mp, rgno);
+	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_BITMAP);
+	error = xfs_rtcheck_range(&args, start, len, 1, &new, &stat);
+	xfs_trans_cancel(args.tp);
+	xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_BITMAP);
+	return !error && stat;
+}
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 6cab338007a2..a0a86578033d 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -120,6 +120,20 @@ xfs_rtgroup_get(
 	return to_rtg(xfs_group_get(mp, rgno, XG_TYPE_RTG));
 }
 
+static inline int
+xfs_rtgroup_get_passive_refcount(struct xfs_rtgroup *rtg)
+{
+	ASSERT(rtg);
+	return xfs_group_get_passive_refcount(rtg_group(rtg));
+}
+
+static inline int
+xfs_rtgroup_get_active_refcount(struct xfs_rtgroup *rtg)
+{
+	ASSERT(rtg);
+	return xfs_group_get_active_refcount(rtg_group(rtg));
+}
+
 static inline struct xfs_rtgroup *
 xfs_rtgroup_hold(
 	struct xfs_rtgroup	*rtg)
@@ -277,6 +291,21 @@ xfs_daddr_to_rtb(
 	return bno;
 }
 
+static inline bool
+xfs_rtgroup_is_active(struct xfs_rtgroup	*rtg)
+{
+	ASSERT(rtg);
+	return xfs_rtgroup_get_active_refcount(rtg) > 0;
+}
+
+void xfs_rtgroup_activate(struct xfs_rtgroup	*rtg);
+int xfs_rtgroup_deactivate(struct xfs_rtgroup	*rtg);
+bool xfs_rtgroup_is_empty(struct xfs_rtgroup *rtg);
+
+#define for_each_rgno_range_reverse(agno, old_rgcount, new_rgcount) \
+	for ((agno) = ((old_rgcount) - 1); (typeof(old_rgcount))(agno) >= \
+		((typeof(old_rgcount))(new_rgcount) - 1); (agno)--)
+
 #ifdef CONFIG_XFS_RT
 int xfs_rtgroup_alloc(struct xfs_mount *mp, xfs_rgnumber_t rgno,
 		xfs_rgnumber_t rgcount, xfs_rtbxlen_t rextents);
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index e4c8af873632..856ff686f0f0 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -750,11 +750,8 @@ xlog_recover_do_primary_sb_buffer(
 		xfs_alert(mp, "Shrinking AG count in log recovery not supported");
 		return -EFSCORRUPTED;
 	}
-	if (mp->m_sb.sb_rgcount < orig_rgcount) {
-		xfs_warn(mp,
- "Shrinking rtgroup count in log recovery not supported");
-		return -EFSCORRUPTED;
-	}
+	if (mp->m_sb.sb_rgcount < orig_rgcount)
+		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_SHRINK);
 
 	/*
 	 * If the last AG was grown or shrunk, we also need to update the
@@ -789,11 +786,19 @@ xlog_recover_do_primary_sb_buffer(
 	}
 	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
 
-	error = xfs_initialize_rtgroups(mp, orig_rgcount, mp->m_sb.sb_rgcount,
-			mp->m_sb.sb_rextents);
-	if (error) {
-		xfs_warn(mp, "Failed recovery rtgroup init: %d", error);
-		return error;
+	if (orig_rgcount > mp->m_sb.sb_rgcount) {
+		/*
+		 * Remove the old rtgroups that were removed previously by a
+		 * growfs.
+		 */
+		xfs_free_rtgroups(mp, mp->m_sb.sb_rgcount, orig_rgcount);
+	} else {
+		error = xfs_initialize_rtgroups(mp, orig_rgcount,
+				mp->m_sb.sb_rgcount, mp->m_sb.sb_rextents);
+		if (error) {
+			xfs_warn(mp, "Failed recovery rtgroup init: %d", error);
+			return error;
+		}
 	}
 	return 0;
 }
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index da3161572735..60337a8295ed 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -676,6 +676,36 @@ xfs_extent_busy_wait_all(
 			xfs_extent_busy_wait_group(rtg_group(rtg));
 }
 
+/*
+ * Similar to xfs_extent_busy_wait_all() - It waits for all the busy extents to
+ * get resolved for the range of rtgroups provided. For now, this function is
+ * introduced to be used in online shrink process. Unlike
+ * xfs_extent_busy_wait_all(), this takes a passive reference, because this
+ * function is expected to be called for the rtgroups whose active reference has
+ * been reduced to 0 i.e, offline rtgroups.
+ *
+ * @mp - The xfs mount point
+ * @first_agno - The 0 based AG index of the range of rtgroups from which we
+ *     will start.
+ * @end_agno - The 0 based AG index of the range of rtgroups from till which we
+ *     will traverse.
+ */
+void
+xfs_extent_busy_wait_rtgroups(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		first_rgno,
+	xfs_rgnumber_t		end_rgno)
+{
+	xfs_agnumber_t		rgno;
+	struct xfs_rtgroup	*rtg = NULL;
+
+	for_each_rgno_range_reverse(rgno, end_rgno + 1, first_rgno + 1) {
+		rtg = xfs_rtgroup_get(mp, rgno);
+		xfs_extent_busy_wait_group(rtg_group(rtg));
+		xfs_rtgroup_put(rtg);
+	}
+}
+
 /*
  * Callback for list_sort to sort busy extents by the group they reside in.
  */
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index 3e6e019b6146..5e09099dcd67 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -57,6 +57,8 @@ bool xfs_extent_busy_trim(struct xfs_group *xg, xfs_extlen_t minlen,
 		unsigned *busy_gen);
 int xfs_extent_busy_flush(struct xfs_trans *tp, struct xfs_group *xg,
 		unsigned busy_gen, uint32_t alloc_flags);
+void xfs_extent_busy_wait_rtgroups(struct xfs_mount *mp,
+		xfs_rgnumber_t first_rgno, xfs_rgnumber_t end_rgno);
 void xfs_extent_busy_wait_all(struct xfs_mount *mp);
 bool xfs_extent_busy_list_empty(struct xfs_group *xg, unsigned int *busy_gen);
 struct xfs_extent_busy_tree *xfs_extent_busy_alloc(void);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f1f88e48fe22..b92e2d4f99b9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1410,8 +1410,12 @@ xfs_inactive(
 	if (xfs_is_readonly(mp) && !xlog_recovery_needed(mp->m_log))
 		goto out;
 
-	/* Metadata inodes require explicit resource cleanup. */
-	if (xfs_is_internal_inode(ip))
+	/*
+	 * Metadata inodes require explicit resource cleanup. During shrink we
+	 * are using this function to remove the already truncated metadata
+	 * inodes for the bitmap file, summary file.
+	 */
+	if (xfs_is_internal_inode(ip) && !xfs_is_shrinking(mp))
 		goto out;
 
 	/* Try to clean out the cow blocks if there are any. */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 83bebddb9ea8..75604e65da32 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -5,6 +5,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_fsops.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
@@ -34,6 +35,8 @@
 #include "xfs_rtrefcount_btree.h"
 #include "xfs_reflink.h"
 #include "xfs_zone_alloc.h"
+#include "xfs_log.h"
+#include "xfs_trans_priv.h"
 
 /*
  * Return whether there are any free extents in the size range given
@@ -91,6 +94,40 @@ xfs_rtany_summary(
 	return 0;
 }
 
+/* Resets the summary file to 0 */
+static int
+xfs_rt_reset_summary(
+	struct xfs_rtalloc_args	*args)
+{
+	xfs_fileoff_t		bbno;	/* bitmap block number */
+	int			error;
+	int			log;	/* summary level number (log length) */
+	xfs_suminfo_t		sum;	/* summary data */
+
+	for (log = args->mp->m_rsumlevels - 1; log >= 0; log--) {
+		for (bbno = args->mp->m_sb.sb_rbmblocks  - 1;
+		     (xfs_srtblock_t)bbno >= 0;
+		     bbno--) {
+			error = xfs_rtget_summary(args, log, bbno, &sum);
+			if (error)
+				goto out;
+			if (XFS_IS_CORRUPT(args->mp, sum < 0)) {
+				error = -EFSCORRUPTED;
+				goto out;
+			}
+			if (sum == 0)
+				continue;
+			error = xfs_rtmodify_summary(args, log, bbno, -sum);
+			if (error)
+				goto out;
+		}
+	}
+	error = 0;
+out:
+	xfs_rtbuf_cache_relse(args);
+	return error;
+}
+
 /*
  * Copy and transform the summary file, given the old and new
  * parameters in the mount structures.
@@ -935,6 +972,29 @@ xfs_growfs_rt_zoned(
 	kfree(nmp);
 	return error;
 }
+static int
+xfs_rt_recreate_summary(
+	struct xfs_rtgroup		*rtg,
+	struct xfs_trans		*tp,
+	const struct xfs_rtalloc_rec	*rec,
+	void				*priv)
+{
+	struct xfs_mount	*mp = (struct xfs_mount *)(priv);
+	struct xfs_rtalloc_args	nargs = {
+		.rtg		= rtg,
+		.tp		= tp,
+		.mp		= mp
+	};
+	xfs_fileoff_t		rbmoff;
+	unsigned int		lenlog;
+	int			error;
+
+	/* Compute the relevant location in the rtsum file. */
+	rbmoff = xfs_rtx_to_rbmblock(mp, rec->ar_startext);
+	lenlog = xfs_highbit64(rec->ar_extcount);
+	error = xfs_rtmodify_summary(&nargs, lenlog, rbmoff, 1);
+	return error;
+}
 
 static int
 xfs_growfs_rt_bmblock(
@@ -1390,6 +1450,713 @@ xfs_rt_check_size(
 	return error;
 }
 
+/*
+ * Get new active references for all the rtgroups. This might be called when
+ * shrinkage process encounters a failure at an intermediate stage after the
+ * active references of all/some of the target rtgroups have become 0.
+ */
+static void
+xfs_shrinkfs_rt_reactivate_rtgroups(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t	old_rgcount,
+	xfs_rgnumber_t	new_rgcount)
+{
+	struct xfs_rtgroup	*rtg = NULL;
+	xfs_rgnumber_t		rgno;
+
+	ASSERT(new_rgcount < old_rgcount);
+	for_each_rgno_range_reverse(rgno, old_rgcount, new_rgcount + 1) {
+		rtg = xfs_rtgroup_get(mp, rgno);
+		xfs_rtgroup_activate(rtg);
+		xfs_rtgroup_put(rtg);
+	}
+	xfs_sync_sb_buf(mp, true);
+}
+
+static int
+xfs_shrinkfs_rt_quiesce_rtgroups(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t	old_rgcount,
+	xfs_rgnumber_t	new_rgcount)
+{
+	int	error = 0;
+	int	count = 0;
+
+	/*
+	 * We should wait for the log to be empty and all the pending I/Os to
+	 * be completed so that the rtgroups are completely stabilized before we
+	 * start tearing them down. Flushing the AIL and synching the superblock
+	 * here ensures that none of the future logged transactions will refer
+	 * to these rtgroups during log recovery in case if sudden
+	 * shutdown/crash happens while we are trying to remove these rtgroups.
+	 * The following code is similar to xfs_log_quiesce() and xfs_log_cover.
+	 *
+	 * We are doing a xfs_sync_sb_buf + AIL flush twice. The first
+	 * xfs_sync_sb_buf writes a checkpoint, then the first AIL flush makes
+	 * the first checkpoint stable. The second set of xfs_sync_sb_buf + AIL
+	 * flush synchs the on-disk LSN with the in-core LSN.
+	 * Unlike xfs_log_cover(), we don't necessarily want the background
+	 * filesytem activity/log activity to stop (like in case of unmount
+	 * or freeze).
+	 */
+	cancel_delayed_work_sync(&mp->m_log->l_work);
+	error = xfs_log_force(mp, XFS_LOG_SYNC);
+	if (error)
+		goto out;
+
+	error = xfs_sync_sb_buf(mp, true);
+	if (error)
+		goto out;
+
+	xfs_ail_push_all_sync(mp->m_ail);
+	xfs_buftarg_wait(mp->m_ddev_targp);
+	xfs_buf_lock(mp->m_sb_bp);
+	xfs_buf_unlock(mp->m_sb_bp);
+
+	/*
+	 * The first xfs_sync_sb serves as a reference for the in-core tail
+	 * pointer and the second one updates the on-disk tail with the in-core
+	 * lsn. This is similar to what is being done in xfs_log_cover, however
+	 * here we are explicitly doing this twice in order to ensure forward
+	 * progress as, during shrink the filesystem is active.
+	 */
+	for (count = 0; count < 2; count++) {
+		error = xfs_sync_sb(mp, true);
+		if (error)
+			goto out;
+		xfs_ail_push_all_sync(mp->m_ail);
+	}
+
+	/*
+	 * Wait for all the busy extents to get resolved along with pending trim
+	 * ops for all the offlined rtgroups.
+	 */
+	xfs_extent_busy_wait_rtgroups(mp, new_rgcount, old_rgcount - 1);
+	flush_workqueue(xfs_discard_wq);
+out:
+	xfs_log_work_queue(mp);
+	return error;
+}
+
+/*
+ * The function deactivates or puts the rtgroups to an offline mode. rtgroup
+ * deactivation or rtgroup offlining means that no new operation can be started
+ * on that rtgroup. The rtgroup still exists, however no new high level
+ * operation (like rtextent allocation) can be started. In terms of
+ * implementation, an rtgroup is taken offline or is deactivated when
+ * xg_active_ref of the struct xfs_rtgroup is 0 i.e, the number
+ * of active references becomes 0.
+ * Since active references act as a form of barrier, so once the active
+ * reference of an rtgroup is 0, no new entity can get an active reference and
+ * in this way we ensure that once an rtgroup is offline (i.e, active reference
+ * count is 0), no one will be able to start a new operation in it unless the
+ * active reference count is explicitly set to 1 i.e, the rtgroup is made
+ * online/activated.
+ */
+static int
+xfs_shrinkfs_rt_deactivate_rtgroups(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t	old_rgcount,
+	xfs_rgnumber_t	new_rgcount)
+{
+	int			error = 0;
+	struct xfs_rtgroup	*rtg = NULL;
+	xfs_rgnumber_t		rgno;
+
+	ASSERT(new_rgcount < old_rgcount);
+	/*
+	 * If we are removing 1 or more rtgroups, we only need to take those
+	 * rtgroups offline which we are planning to remove completely. The new
+	 * tail rtgroup which will be partially shrunk, should not be taken
+	 * offline - since we will be doing an online operation on them, just
+	 * like any other high level operation. For complete rtgroup removal,
+	 * we need to take them offline since we cannot start any new operation
+	 * on them as they will be removed eventually.
+	 *
+	 * However, if the number of blocks that we are trying to remove is
+	 * an exact multiple of the rtgroup size (in rtextents), then the new
+	 * tail rtgroup will not be shrunk at all.
+	 */
+	for_each_rgno_range_reverse(rgno, old_rgcount, new_rgcount + 1) {
+		rtg = xfs_rtgroup_get(mp, rgno);
+		error = xfs_rtgroup_deactivate(rtg);
+		if (error) {
+			xfs_rtgroup_put(rtg);
+			if (rgno < old_rgcount - 1)
+				xfs_shrinkfs_rt_reactivate_rtgroups(mp,
+						old_rgcount, rgno + 1);
+			error = error == -ERESTARTSYS ? -ERESTARTSYS :
+				-ENOTEMPTY;
+			return error;
+		}
+		xfs_rtgroup_put(rtg);
+	}
+	/*
+	 * Now that we have deactivated/offlined the rtgroups, we need to make
+	 * sure that all the pending operations are completed and the in-core
+	 * and the on disk contents are completely in synch i.e, rtgroups are
+	 * stablized on to the disk.
+	 */
+
+	error = xfs_shrinkfs_rt_quiesce_rtgroups(mp, old_rgcount, new_rgcount);
+	if (error)
+		xfs_shrinkfs_rt_reactivate_rtgroups(mp, old_rgcount,
+				new_rgcount);
+	return error;
+}
+
+/*
+ * This function does 2 things:
+ * 1. Deactivate the rtgroups i.e, wait for all the active references to come to
+ *    0.
+ * 2. Checks whether all the rtgroups that the shrink process needs to remove
+ *    are empty.
+ *    If at least one of the target rtgroups is non-empty, shrink fails and
+ *    xfs_shrinkfs_rt_reactivate_rtgroups() is called.
+ * Please look into the individual functions for more details and the definition
+ * of the terminologies.
+ */
+static int
+xfs_shrinkfs_rt_prepare_rtgroups(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t	old_rgcount,
+	xfs_rgnumber_t	new_rgcount)
+{
+	struct xfs_rtgroup	*rtg = NULL;
+	xfs_rgnumber_t		rgno;
+	int			error = 0;
+
+	ASSERT(new_rgcount < old_rgcount);
+	/*
+	 * Deactivating/offlining the AGs i.e waiting for the active references
+	 * to come down to 0.
+	 */
+	error = xfs_shrinkfs_rt_deactivate_rtgroups(mp, old_rgcount,
+			new_rgcount);
+	if (error)
+		return error;
+	/*
+	 * At this point the rtgroups have been deactivated/offlined and the
+	 * in-core and the on-disk are synch. So now we need to check whether
+	 * all the rtgroups that we are trying to remove are empty.We will bail
+	 * out with a failure code even if 1 rtgroup is non-empty.
+	 */
+	for_each_rgno_range_reverse(rgno, old_rgcount, new_rgcount + 1) {
+		rtg = xfs_rtgroup_get(mp, rgno);
+		if (!xfs_rtgroup_is_empty(rtg)) {
+			xfs_rtgroup_put(rtg);
+			xfs_shrinkfs_rt_reactivate_rtgroups(mp, old_rgcount,
+				new_rgcount);
+			return -ENOTEMPTY;
+		}
+		xfs_rtgroup_put(rtg);
+	}
+	return 0;
+}
+
+static int
+xfs_shrinkfs_mark_meta_bufs_stale(
+	struct xfs_mount	*mp,
+	struct xfs_rtgroup	*rtg,
+	struct xfs_trans	*tp,
+	enum xfs_rtg_inodes	type,
+	xfs_fileoff_t		start_fsb,
+	xfs_fileoff_t		end_fsb)
+{
+	struct xfs_rtalloc_args	args = {
+		.mp		= mp,
+		.rtg		= rtg,
+		.tp		= tp
+	};
+	int			error = 0;
+
+	ASSERT(start_fsb <= end_fsb);
+
+	for (xfs_fileoff_t fsb = start_fsb; fsb <= end_fsb; fsb++) {
+		if (type == XFS_RTGI_BITMAP) {
+			error = xfs_rtbitmap_read_buf(&args, fsb);
+			if (error)
+				break;
+			ASSERT(args.rbmoff == fsb);
+			xfs_buf_stale(args.rbmbp);
+		} else if (type == XFS_RTGI_SUMMARY) {
+			error = xfs_rtsummary_read_buf(&args, fsb);
+			if (error)
+				break;
+			ASSERT(args.sumoff == fsb);
+			xfs_buf_stale(args.sumbp);
+		}
+	}
+	return error;
+}
+
+/*
+ * This function removes/unmaps the data blocks of the metadata inode(ip) and
+ * also updates the size of the metadata inode.
+ */
+static int
+xfs_rt_metafile_remove_blocks(
+	struct xfs_rtgroup	*rtg,
+	enum xfs_rtg_inodes	type,
+	struct xfs_trans	**tpp,
+	xfs_fileoff_t		offset_fsb)
+{
+	struct xfs_inode	*ip = rtg->rtg_inodes[type];
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error = 0;
+	uint64_t		new_sz;
+
+	ASSERT(ip);
+	ASSERT(xfs_is_internal_inode(ip));
+	ASSERT(tpp);
+	ASSERT(*tpp);
+
+	new_sz = (offset_fsb + 1) << mp->m_sb.sb_blocklog;
+	ASSERT(new_sz <= ip->i_disk_size);
+	if (new_sz == ip->i_disk_size)
+		return 0;
+	/*
+	 * Pass the start bitmap fsblock and the end bitmap fsblock which we
+	 * want to free (both inclusive).
+	 */
+	error = xfs_shrinkfs_mark_meta_bufs_stale(mp, rtg, *tpp, type,
+			offset_fsb + 1, XFS_B_TO_FSBT(mp, ip->i_disk_size - 1));
+	if (error)
+		return error;
+
+	ip->i_disk_size = new_sz;
+	i_size_write(VFS_I(ip), ip->i_disk_size);
+	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
+	error = xfs_itruncate_extents(tpp, ip, XFS_DATA_FORK, new_sz);
+	if (error)
+		return error;
+	xfs_iflags_set(ip, XFS_ITRUNCATED);
+	xfs_inode_clear_eofblocks_tag(ip);
+	return error;
+}
+
+/*
+ * This function will remove all the metadata inodes belonging the
+ * rtgroup.
+ * All the metadata inodes removed here should _not_ be locked
+ * exclusively.
+ */
+static int
+xfs_rt_metainodes_remove(struct xfs_rtgroup *rtg)
+{
+	ASSERT(rtg);
+
+	int			i = 0;
+	int			error = 0;
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_name		xfs_name;
+
+	/* bitmap and summary file have to be present */
+	ASSERT(rtg->rtg_inodes[XFS_RTGI_BITMAP]);
+	ASSERT(rtg->rtg_inodes[XFS_RTGI_SUMMARY]);
+
+	for (i = 0; i < XFS_RTGI_MAX; i++) {
+		struct xfs_inode *ip = rtg->rtg_inodes[i];
+		if (ip) {
+			xfs_name.name = xfs_rtginode_path(rtg_rgno(rtg), i);
+			xfs_name.len = strlen(xfs_name.name);
+			ASSERT(xfs_name.len >= 6);
+			error = xfs_remove(mp->m_rtdirip, &xfs_name, ip);
+			if (error)
+				break;
+			error = xfs_inactive(ip);
+			if (error)
+				break;
+			xfs_irele(ip);
+		}
+	}
+	return error;
+}
+
+/*
+ * This function will truncate all the metadata inodes belonging the rtgroup.
+ */
+static int
+xfs_rt_metainodes_truncate(
+		struct xfs_mount *mp,
+		struct xfs_trans **tpp,
+		struct xfs_rtgroup *rtg)
+{
+	ASSERT(mp);
+	ASSERT(rtg);
+	ASSERT(tpp);
+	ASSERT(*tpp);
+	ASSERT(!xfs_rtgroup_is_active(rtg));
+
+	int			i = 0;
+	int			error = 0;
+
+	/* bitmap and summary file has to be present */
+	ASSERT(rtg->rtg_inodes[XFS_RTGI_BITMAP]);
+	ASSERT(rtg->rtg_inodes[XFS_RTGI_SUMMARY]);
+
+	for (i = 0; i < XFS_RTGI_MAX; i++) {
+		struct xfs_inode *ip = rtg->rtg_inodes[i];
+		if (ip) {
+			xfs_ilock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+			xfs_trans_ijoin(*tpp, ip, 0);
+		}
+	}
+
+	for (i = 0; i < XFS_RTGI_MAX; i++) {
+		struct xfs_inode *ip = rtg->rtg_inodes[i];
+		if (ip) {
+			error = xfs_rt_metafile_remove_blocks(rtg, i, tpp, -1);
+			if (error)
+				break;
+			xfs_broot_realloc(&ip->i_df, 0);
+		}
+	}
+	if (error)
+		goto out;
+
+	xfs_growfs_rt_sb_fields(*tpp, mp);
+	error = xfs_trans_commit(*tpp);
+out:
+	for (i = 0; i < XFS_RTGI_MAX; i++) {
+		struct xfs_inode *ip = rtg->rtg_inodes[i];
+		if (ip)
+			xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	}
+	return error;
+}
+
+/*
+ * This function removes an entire empty rtgroup. Before removing the struct
+ * xfs_rtgroup reference, it removes the associated data structures. Before
+ * removing an rtgroup, the caller must ensure that the rtgroup has been
+ * deactivated with no active references and it has been fully stabilized on
+ * the disk.
+ * The steps are as follows:
+ *  1) Get a fake mount with reduced number of rtextents
+ *  2) load/initiallize all the metadata inodes for the rtgroup
+ *  3) Start a transaction
+ *  4) Remove the mapped data blocks for metadata inodes.
+ *  5) Then remove the metadata inodes.
+ *  6) Remove the group from xarray.
+ *  7) Then free the intents drain list, busy extent list and the group instance
+ */
+static int
+xfs_shrinkfs_rt_remove_rtgroup(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno)
+{
+	struct xfs_rtgroup	*cur_rtg = NULL;
+	struct xfs_group	*xg = NULL;
+	struct xfs_mount	*nmp = NULL;
+	int			error = 0;
+	struct xfs_trans	*tp = NULL;
+	int64_t			rtx;
+	int64_t			rtb;
+
+	ASSERT(mp);
+
+	cur_rtg = xfs_rtgroup_get(mp, rgno);
+	if (!cur_rtg)
+		return -EINVAL;
+	ASSERT(!xfs_rtgroup_is_active(cur_rtg));
+	rtx = xfs_rtgroup_extents(mp, rgno);
+	rtb = rtx * mp->m_sb.sb_rextsize;
+
+	nmp = xfs_growfs_rt_alloc_fake_mount(mp, mp->m_sb.sb_rblocks - rtb,
+		mp->m_sb.sb_rextsize);
+	if (!nmp) {
+		error = -ENOMEM;
+		goto out_free;
+	}
+
+	error = xfs_rtginodes_ensure_all(cur_rtg);
+	if (error)
+		goto out_free;
+
+	xfs_trans_resv_calc(nmp, &nmp->m_resv);
+	error = xfs_trans_alloc(mp, &M_RES(nmp)->tr_itruncate, 0, 0, 0, &tp);
+	if (error)
+		goto out_free;
+
+	/* Unmap all the blocks of all the metadata inodes */
+	error = xfs_rt_metainodes_truncate(nmp, &tp, cur_rtg);
+	if (error)
+		goto out_cancel;
+	/*
+	 * Now that we have truncated all the metadata inodes, remove and
+	 * free them.
+	 */
+	error = xfs_rt_metainodes_remove(cur_rtg);
+	ASSERT(!error);
+
+	xg = xa_erase(&mp->m_groups[XG_TYPE_RTG].xa, rgno);
+	/*
+	 * We have already ensured in the rtgroup preparation phase that all
+	 * intents for the offlined rtgroups have been resolved. So it safe to
+	 * free it here.
+	 */
+	xfs_defer_drain_free(&xg->xg_intents_drain);
+	/*
+	 * We have already ensured in the rtgroup preparation phase that all the
+	 * busy extents for the offlined rtgroups have been resolved. So it is
+	 * safe to free it here.
+	 */
+	kfree(xg->xg_busy_extents);
+	/*
+	 * Finally free the struct xfs_group of the rtgroup.
+	 */
+	kfree_rcu_mightsleep(xg);
+	error = 0;
+	goto out_free;
+
+out_cancel:
+	xfs_trans_cancel(tp);
+out_free:
+	kfree(nmp);
+	if (cur_rtg) {
+		xfs_rtgroup_put(cur_rtg);
+		XFS_IS_CORRUPT(mp, xfs_rtgroup_get_passive_refcount(
+				cur_rtg) != 0);
+	}
+	return error;
+}
+
+/*
+ * This function resets the contents of the summary file to 0 and re-populates
+ * it based on the new arguments.
+ */
+static int
+xfs_rt_reset_and_recreate_summary(
+	struct xfs_rtalloc_args	*oargs,
+	struct xfs_rtalloc_args	*nargs)
+{
+	int	error = 0;
+
+	error = xfs_rt_reset_summary(oargs);
+	if (error)
+		return error;
+	ASSERT(oargs->rtg);
+	ASSERT(nargs->tp);
+	ASSERT(nargs->mp);
+	error = xfs_rtalloc_query_all(oargs->rtg, nargs->tp, xfs_rt_recreate_summary,
+		nargs->mp);
+	return error;
+}
+
+/*
+ * This function shrinks the tail rtgroup partially.
+ */
+static int
+xfs_shrinkfs_rt_shrink_new_tail_rtgroup(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno,
+	int64_t			delta_rtx_rem)
+{
+	struct xfs_rtgroup	*rtg = xfs_rtgroup_get(mp, rgno);
+	struct xfs_inode	*rbmip = rtg_bitmap(rtg);
+	struct xfs_inode	*rsumip = rtg_summary(rtg);
+	int64_t			delta_rtb_rem = delta_rtx_rem *
+			mp->m_sb.sb_rextsize;
+	struct xfs_rtalloc_args	args = {
+		.mp		= mp,
+		.rtg		= rtg,
+	};
+	struct xfs_rtalloc_args	nargs = {
+		.rtg		= rtg,
+	};
+	struct xfs_mount	*nmp = NULL;
+	int			error = 0;
+	int64_t			rtgsize = xfs_rtgroup_extents(mp, rgno);
+
+	/*
+	 * Calculate new sb and mount fields for this round.  Also ensure the
+	 * rtg_extents value is uptodate as the rtbitmap code relies on it.
+	 */
+	nmp = nargs.mp = xfs_growfs_rt_alloc_fake_mount(mp,
+			mp->m_sb.sb_rblocks - delta_rtb_rem,
+			mp->m_sb.sb_rextsize);
+	if (!nmp) {
+		error = -ENOMEM;
+		goto out_free;
+	}
+	xfs_rtgroup_calc_geometry(nmp, rtg, rtg_rgno(rtg),
+			nmp->m_sb.sb_rgcount, nmp->m_sb.sb_rextents);
+
+	error = xfs_rtginodes_ensure_all(rtg);
+	if (error)
+		goto out_free;
+
+	/*
+	 * Recompute the growfsrt reservation from the new rsumsize, so that the
+	 * transaction below use the new, potentially larger value.
+	 */
+	xfs_trans_resv_calc(nmp, &nmp->m_resv);
+	error = xfs_trans_alloc(mp, &M_RES(nmp)->tr_itruncate, 0,
+			delta_rtb_rem, 0, &args.tp);
+	if (error)
+		goto out_free;
+	nargs.tp = args.tp;
+
+	xfs_ilock(rbmip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_ilock(rsumip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_trans_ijoin(args.tp, rbmip, 0);
+	xfs_trans_ijoin(args.tp, rsumip, 0);
+
+	/*
+	 * Update the rtbitmap file  with the new free rtextents count
+	 */
+	error = xfs_rtmodify_range(&args, rtgsize - delta_rtx_rem,
+			delta_rtx_rem, 0);
+	if (error)
+		goto out_cancel;
+	/*
+	 * For shrink, zero out the summary file and re-populate the
+	 * entries.
+	 */
+	error = xfs_rt_reset_and_recreate_summary(&args, &nargs);
+	if (error)
+		goto out_cancel;
+
+	/*
+	 * If the size of the metadata files have changed, update the inode
+	 * and unmap the metadata file data blocks accordingly. But before that,
+	 * mark the in-core buffers (for the blocks we want to unmap) stale.
+	 */
+	if (nmp->m_sb.sb_rbmblocks < mp->m_sb.sb_rbmblocks) {
+		error = xfs_rt_metafile_remove_blocks(rtg, XFS_RTGI_BITMAP,
+				&args.tp, nmp->m_sb.sb_rbmblocks - 1);
+		if (error)
+			goto out_cancel;
+	}
+
+	if (nmp->m_rsumblocks < mp->m_rsumblocks) {
+		error = xfs_rt_metafile_remove_blocks(rtg, XFS_RTGI_BITMAP,
+				&args.tp, nmp->m_rsumblocks - 1);
+		if (error)
+			goto out_cancel;
+	}
+
+	/*
+	 * Update superblock fields.
+	 */
+	xfs_growfs_rt_sb_fields(args.tp, nmp);
+	xfs_rtbuf_cache_relse(&nargs);
+	/*
+	 * Update # of free rtextents in the superblock.
+	 */
+	xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_FREXTENTS,
+			(int64_t)(-delta_rtx_rem));
+	/*
+	 * Update the calculated values in the real mount structure.
+	 */
+	mp->m_rsumlevels = nmp->m_rsumlevels;
+	mp->m_rsumblocks = nmp->m_rsumblocks;
+	/*
+	 * Recompute the growfsrt reservation from the new rsumsize.
+	 */
+	xfs_trans_resv_calc(mp, &mp->m_resv);
+	xfs_trans_set_sync(args.tp);
+	error = xfs_trans_commit(args.tp);
+	if (error)
+		goto out_cancel;
+	/*
+	 * Ensure the mount RT feature flag is now set, and compute new
+	 * maxlevels for rt btrees.
+	 */
+	mp->m_features |= XFS_FEAT_REALTIME;
+	xfs_rtrmapbt_compute_maxlevels(mp);
+	xfs_rtrefcountbt_compute_maxlevels(mp);
+	goto out;
+
+out_cancel:
+	xfs_trans_cancel(args.tp);
+out:
+	xfs_iunlock(rbmip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_iunlock(rsumip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+out_free:
+	kfree(nmp);
+	if (rtg)
+		xfs_rtgroup_put(rtg);
+	return error;
+}
+
+/*
+ * This function does the job of fully removing the extents and empty rtgroups (
+ * depending of the values of old_rgcount and new_rgcount). By removal it means,
+ * removal of all the rtgroup data structures, other data structures associated
+ * with it. Once this function succeeds, the rtgroups(and their extents) will no
+ * longer exist.
+ * The overall steps are as follows (details are in the function):
+ * - calculate the number of rtextents that will be removed from the new tail
+ *   rtgroup i.e, the rtgroup that will be shrunk partially.
+ * - call xfs_shrinkfs_rt_remove_rtgroup() that removes the rest of the
+ *   associated datastructures with the corresponding struct xfs_rtgroup.
+ * - call xfs_shrinkfs_rt_shrink_new_tail_rtgroup() if a partial shrink of the
+ *   new last rtgroup needs to be done.
+ */
+static int
+xfs_shrinkfs_rt_remove_rtgroups(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		old_rgcount,
+	xfs_rgnumber_t		new_rgcount,
+	int64_t			delta_rtb)
+{
+	xfs_rgnumber_t		rgno;
+	int			error = 0;
+	struct xfs_rtgroup	*cur_rtg = NULL;
+	int64_t			delta_rtx_rem;
+	bool is_del		= false;
+
+	delta_rtx_rem = div_u64(-delta_rtb, mp->m_sb.sb_rextsize);
+
+	ASSERT(new_rgcount <= old_rgcount);
+	ASSERT(delta_rtb < 0);
+
+	/*
+	 * This loop is calculating the number of realtime extents that needs to
+	 * be removed from the new tail rtgroup. If delta_rtx_rem is 0 after the
+	 * loop exits, then it means that the number of realtime extents we want
+	 * to remove is a multiple of rtgroup size (in realtime extents).
+	 */
+	for_each_rgno_range_reverse(rgno, old_rgcount, new_rgcount + 1) {
+		cur_rtg = xfs_rtgroup_get(mp, rgno);
+		delta_rtx_rem -= xfs_rtgroup_extents(mp, rgno);
+		xfs_rtgroup_put(cur_rtg);
+	}
+
+	/* We start deleting rtgroups from the end */
+	for_each_rgno_range_reverse(rgno, old_rgcount, new_rgcount + 1) {
+		error = xfs_shrinkfs_rt_remove_rtgroup(mp, rgno);
+		if (error && is_del) {
+			/*
+			 * We are supporting partial shrink success. So we
+			 * return from here with success code and reactivate
+			 * the rtgs which we deactivated earlier and but could
+			 * not remove.
+			 */
+			xfs_shrinkfs_rt_reactivate_rtgroups(mp, rgno + 1,
+				new_rgcount);
+			error = 0;
+		}
+		is_del = true; /* At least 1 rtgroup is removed */
+	}
+
+	if (delta_rtx_rem) {
+		/*
+		 * Remove delta_rtx_rem blocks from the rtgroup that will form
+		 * the new tail rtgroup after the rtgroups are removed. If the
+		 * number of realtime extents to be removed is a multiple of
+		 * realtime group size, then nothing is done here.
+		 */
+		error = xfs_shrinkfs_rt_shrink_new_tail_rtgroup(mp,
+				new_rgcount - 1, delta_rtx_rem);
+		if (error && is_del)
+			error = 0;
+	}
+
+	return error;
+}
 /*
  * Grow the realtime area of the filesystem.
  */
@@ -1403,6 +2170,10 @@ xfs_growfs_rt(
 	xfs_rgnumber_t		rgno;
 	xfs_agblock_t		old_rextsize = mp->m_sb.sb_rextsize;
 	int			error;
+	int64_t			delta_rtb = in->newblocks - mp->m_sb.sb_rblocks;
+	xfs_rtxnum_t		delta_rtx = div_u64(
+			delta_rtb > 0 ? delta_rtb : -delta_rtb,
+			mp->m_sb.sb_rextsize);
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -1414,10 +2185,15 @@ xfs_growfs_rt(
 	if (!mutex_trylock(&mp->m_growlock))
 		return -EWOULDBLOCK;
 
-	/* Shrink not supported. */
 	error = -EINVAL;
-	if (in->newblocks <= mp->m_sb.sb_rblocks)
-		goto out_unlock;
+
+	if (delta_rtb < 0) {
+		/* Can only shrink at the granularity of an rt extent */
+		if (delta_rtx == 0)
+			goto out_unlock;
+		xfs_set_shrinking(mp);
+	}
+
 	/* Can only change rt extent size when adding rt volume. */
 	if (mp->m_sb.sb_rblocks > 0 && in->extsize != mp->m_sb.sb_rextsize)
 		goto out_unlock;
@@ -1467,8 +2243,21 @@ xfs_growfs_rt(
 		if (error)
 			goto out_unlock;
 	}
+	if (new_rgcount < old_rgcount) {
+		ASSERT(xfs_has_rtgroups(mp));
+		error = xfs_shrinkfs_rt_prepare_rtgroups(mp, old_rgcount,
+				new_rgcount);
+		if (error)
+			goto out_unlock;
+	}
 
-	if (xfs_grow_last_rtg(mp)) {
+	if (xfs_is_shrinking(mp)) {
+		error = xfs_shrinkfs_rt_remove_rtgroups(mp, old_rgcount,
+				new_rgcount, delta_rtb);
+		if (error)
+			goto out_unlock;
+	}
+	if (xfs_grow_last_rtg(mp) && (delta_rtb > 0)) {
 		error = xfs_growfs_rtg(mp, old_rgcount - 1, in->newblocks,
 				in->extsize);
 		if (error)
@@ -1518,6 +2307,8 @@ xfs_growfs_rt(
 	}
 
 out_unlock:
+	if (xfs_is_shrinking(mp))
+		xfs_clear_shrinking(mp);
 	mutex_unlock(&mp->m_growlock);
 	return error;
 }
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 474f5a04ec63..c43755986b9d 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -431,7 +431,6 @@ xfs_trans_mod_sb(
 		tp->t_rextslog_delta += delta;
 		break;
 	case XFS_TRANS_SB_RGCOUNT:
-		ASSERT(delta > 0);
 		tp->t_rgcount_delta += delta;
 		break;
 	default:
-- 
2.43.5

