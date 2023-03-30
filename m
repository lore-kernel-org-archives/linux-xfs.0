Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC508C6FD1D
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Mar 2023 20:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjC3UqQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Mar 2023 16:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjC3UqP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Mar 2023 16:46:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89CD12D
        for <linux-xfs@vger.kernel.org>; Thu, 30 Mar 2023 13:46:12 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32UHNwc1002926
        for <linux-xfs@vger.kernel.org>; Thu, 30 Mar 2023 20:46:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=VKiKkthnuIwV/7SPbzmQByQOkwvIODPmvndljFXhQTI=;
 b=F4ONJZKskKYb4FbqUcgg8KCjUk6wrsRYt8A9BcxNeKxrXP9V+RFG/LOHLYEOifJ2nIir
 PL0PmnfY61+1F7Lro5oPyrjKTOg9idf31yo/LPVsoYFkzADzHAsD25zmdy04ZPmfkQDV
 v+52Zjx+NyxiKq+CLOcwqXQeYHUFbGZh9B8PoUYWsh/ovKSBiEA+Y2kakwnRhGkTZAZT
 EgXCg9v1jZqji/4LjeMqYC5RuQwfBe7jSwLSzSAp9tYgTO+NRjwQaFk8+HA+IEjqqENZ
 AIr1Mr6k43uvs+Hz6CenEX3O2aFYxpp5AfV/5dIg4B7xhBB3HfFJ4GC6ZVbKyDGQAXvD sA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pmq56uw5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Mar 2023 20:46:12 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32UJ9xxG010730
        for <linux-xfs@vger.kernel.org>; Thu, 30 Mar 2023 20:46:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3phqda8jwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Mar 2023 20:46:11 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32UKkBKP034541
        for <linux-xfs@vger.kernel.org>; Thu, 30 Mar 2023 20:46:11 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-159-130-152.vpn.oracle.com [10.159.130.152])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3phqda8jw5-1;
        Thu, 30 Mar 2023 20:46:11 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     wen.gang.wang@oracle.com
Subject: [PATCH] xfs: fix AGFL allocation dead lock
Date:   Thu, 30 Mar 2023 13:46:10 -0700
Message-Id: <20230330204610.23546-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_13,2023-03-30_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303300163
X-Proofpoint-GUID: E7XDDx5q5fDSjHnqO628vo2vLC2VR6Nq
X-Proofpoint-ORIG-GUID: E7XDDx5q5fDSjHnqO628vo2vLC2VR6Nq
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There is deadlock with calltrace on process 10133:

PID 10133 not sceduled for 4403385ms (was on CPU[10])
	#0	context_switch() kernel/sched/core.c:3881
	#1	__schedule() kernel/sched/core.c:5111
	#2	schedule() kernel/sched/core.c:5186
	#3	xfs_extent_busy_flush() fs/xfs/xfs_extent_busy.c:598
	#4	xfs_alloc_ag_vextent_size() fs/xfs/libxfs/xfs_alloc.c:1641
	#5	xfs_alloc_ag_vextent() fs/xfs/libxfs/xfs_alloc.c:828
	#6	xfs_alloc_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:2362
	#7	xfs_free_extent_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:3029
	#8	__xfs_free_extent() fs/xfs/libxfs/xfs_alloc.c:3067
	#9	xfs_trans_free_extent() fs/xfs/xfs_extfree_item.c:370
	#10	xfs_efi_recover() fs/xfs/xfs_extfree_item.c:626
	#11	xlog_recover_process_efi() fs/xfs/xfs_log_recover.c:4605
	#12	xlog_recover_process_intents() fs/xfs/xfs_log_recover.c:4893
	#13	xlog_recover_finish() fs/xfs/xfs_log_recover.c:5824
	#14	xfs_log_mount_finish() fs/xfs/xfs_log.c:764
	#15	xfs_mountfs() fs/xfs/xfs_mount.c:978
	#16	xfs_fs_fill_super() fs/xfs/xfs_super.c:1908
	#17	mount_bdev() fs/super.c:1417
	#18	xfs_fs_mount() fs/xfs/xfs_super.c:1985
	#19	legacy_get_tree() fs/fs_context.c:647
	#20	vfs_get_tree() fs/super.c:1547
	#21	do_new_mount() fs/namespace.c:2843
	#22	do_mount() fs/namespace.c:3163
	#23	ksys_mount() fs/namespace.c:3372
	#24	__do_sys_mount() fs/namespace.c:3386
	#25	__se_sys_mount() fs/namespace.c:3383
	#26	__x64_sys_mount() fs/namespace.c:3383
	#27	do_syscall_64() arch/x86/entry/common.c:296
	#28	entry_SYSCALL_64() arch/x86/entry/entry_64.S:180

It's waiting xfs_perag.pagb_gen to increase (busy extent clearing happen).
From the vmcore, it's waiting on AG 1. And the ONLY busy extent for AG 1 is
with the transaction (in xfs_trans.t_busy) for process 10133. That busy extent
is created in a previous EFI with the same transaction. Process 10133 is
waiting, it has no change to commit that that transaction. So busy extent
clearing can't happen and pagb_gen remain unchanged. So dead lock formed.

commit 06058bc40534530e617e5623775c53bb24f032cb disallowed using busy extents
for any path that calls xfs_extent_busy_trim(). That looks over-killing.
For AGFL block allocation, it just use the first extent that satisfies, it won't
try another extent for choose a "better" one. So it's safe to reuse busy extent
for AGFL.

To fix above dead lock, this patch allows reusing busy extent for AGFL.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/xfs/xfs_extent_busy.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index ef17c1f6db32..f857a5759506 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -344,6 +344,7 @@ xfs_extent_busy_trim(
 	ASSERT(*len > 0);
 
 	spin_lock(&args->pag->pagb_lock);
+restart:
 	fbno = *bno;
 	flen = *len;
 	rbp = args->pag->pagb_tree.rb_node;
@@ -362,6 +363,20 @@ xfs_extent_busy_trim(
 			continue;
 		}
 
+		/*
+		 * AGFL reserving (metadata) is just using the first-
+		 * fit extent, there is no optimization that tries further
+		 * extents. So it's safe to reuse the busy extent and safe
+		 * to update the busy extent.
+		 * Reuse for AGFL even busy extent being discarded.
+		 */
+		if (args->resv == XFS_AG_RESV_AGFL) {
+			if (!xfs_extent_busy_update_extent(args->mp, args->pag,
+				busyp, fbno, flen, false))
+				goto restart;
+			continue;
+		}
+
 		if (bbno <= fbno) {
 			/* start overlap */
 
-- 
2.21.0 (Apple Git-122.2)

