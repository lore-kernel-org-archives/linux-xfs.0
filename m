Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D61C5DF62
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 04:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 367CF2075C
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 04:44:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hqXeteqn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730944AbfKFEoa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Nov 2019 23:44:30 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55982 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729303AbfKFEo3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Nov 2019 23:44:29 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA64i6ru078411;
        Wed, 6 Nov 2019 04:44:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=snGtq/nWttwN90OKhn98bwpRunQm/1+ub5EJOLJ66LQ=;
 b=hqXeteqnWSzzx2R3CiT5bBOY6U57ZWALBVVpNJ10HvXy+7WJ6ZbhwTFGjmdbg/V6JS6l
 f+bOXimsPd2HmqqQPVWJaMhFhidi0jzLrOOH/2ko4u7taEmxAnFya3STGgv1yYahY0sM
 UviyToWBhCNQ6pdHI48n8du/dJJjaP2zXkkTAhHphfG81nFQaYmFFN+N+PJJRUIP2/MW
 JrBxdSDCXY3cpoM1RQSaDrl7fayCFqsAiz6mZMGq0EZB8JGq/C5ATMB7KGiXqNb1TWzm
 Njs0YyNNAvJ81F8sf369K8c/qldTTWG/n9VoGKh99rT401lmTdcKPMyoZlpDImdCrjQB Sw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w12eraxt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 04:44:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA64i2Er175785;
        Wed, 6 Nov 2019 04:44:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2w3162ns6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 04:44:06 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA64h6Em031459;
        Wed, 6 Nov 2019 04:43:06 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Nov 2019 20:43:06 -0800
Subject: [PATCH 2/2] xfs: periodically yield scrub threads to the scheduler
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        hch@lst.de
Date:   Tue, 05 Nov 2019 20:43:06 -0800
Message-ID: <157301538629.678524.5328247190031479757.stgit@magnolia>
In-Reply-To: <157301537390.678524.16085197974806955970.stgit@magnolia>
References: <157301537390.678524.16085197974806955970.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060049
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060049
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Christoph Hellwig complained about the following soft lockup warning
when running scrub after generic/175 when preemption is disabled and
slub debugging is enabled:

watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [xfs_scrub:161]
Modules linked in:
irq event stamp: 41692326
hardirqs last  enabled at (41692325): [<ffffffff8232c3b7>] _raw_0
hardirqs last disabled at (41692326): [<ffffffff81001c5a>] trace0
softirqs last  enabled at (41684994): [<ffffffff8260031f>] __do_e
softirqs last disabled at (41684987): [<ffffffff81127d8c>] irq_e0
CPU: 3 PID: 16189 Comm: xfs_scrub Not tainted 5.4.0-rc3+ #30
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.124
RIP: 0010:_raw_spin_unlock_irqrestore+0x39/0x40
Code: 89 f3 be 01 00 00 00 e8 d5 3a e5 fe 48 89 ef e8 ed 87 e5 f2
RSP: 0018:ffffc9000233f970 EFLAGS: 00000286 ORIG_RAX: ffffffffff3
RAX: ffff88813b398040 RBX: 0000000000000286 RCX: 0000000000000006
RDX: 0000000000000006 RSI: ffff88813b3988c0 RDI: ffff88813b398040
RBP: ffff888137958640 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffea00042b0c00
R13: 0000000000000001 R14: ffff88810ac32308 R15: ffff8881376fc040
FS:  00007f6113dea700(0000) GS:ffff88813bb80000(0000) knlGS:00000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6113de8ff8 CR3: 000000012f290000 CR4: 00000000000006e0
Call Trace:
 free_debug_processing+0x1dd/0x240
 __slab_free+0x231/0x410
 kmem_cache_free+0x30e/0x360
 xchk_ag_btcur_free+0x76/0xb0
 xchk_ag_free+0x10/0x80
 xchk_bmap_iextent_xref.isra.14+0xd9/0x120
 xchk_bmap_iextent+0x187/0x210
 xchk_bmap+0x2e0/0x3b0
 xfs_scrub_metadata+0x2e7/0x500
 xfs_ioc_scrub_metadata+0x4a/0xa0
 xfs_file_ioctl+0x58a/0xcd0
 do_vfs_ioctl+0xa0/0x6f0
 ksys_ioctl+0x5b/0x90
 __x64_sys_ioctl+0x11/0x20
 do_syscall_64+0x4b/0x1a0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

If preemption is disabled, all metadata buffers needed to perform the
scrub are already in memory, and there are a lot of records to check,
it's possible that the scrub thread will run for an extended period of
time without sleeping for IO or any other reason.  Then the watchdog
timer or the RCU stall timeout can trigger, producing the backtrace
above.

To fix this problem, we detect when preemption is disabled and
explicitly schedule() the scrub thread every few seconds.

Reported-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/common.h |   14 +++++++++++++-
 fs/xfs/scrub/scrub.h  |    9 +++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 003a772cd26c..597b4d45e990 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -14,8 +14,20 @@
 static inline bool
 xchk_should_terminate(
 	struct xfs_scrub	*sc,
-	int				*error)
+	int			*error)
 {
+#if !IS_ENABLED(CONFIG_PREEMPT)
+	/*
+	 * If preemption is disabled, we need to yield to the scheduler every
+	 * few seconds so that we don't run afoul of the soft lockup watchdog
+	 * or RCU stall detector.
+	 */
+	if (sc->next_yield != 0 && time_after(jiffies, sc->next_yield))
+		return false;
+	schedule();
+	sc->next_yield = jiffies + msecs_to_jiffies(5000);
+#endif
+
 	if (fatal_signal_pending(current)) {
 		if (*error == 0)
 			*error = -EAGAIN;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index ad1ceb44a628..ada8e4976024 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -75,6 +75,15 @@ struct xfs_scrub {
 
 	/* State tracking for single-AG operations. */
 	struct xchk_ag			sa;
+
+#if !IS_ENABLED(CONFIG_PREEMPT)
+	/*
+	 * This is the time (in jiffies) when this scrub thread needs to
+	 * yield the processor back to the scheduler so that we don't run
+	 * afoul of either the soft lockup watchdog or RCU stall detector.
+	 */
+	unsigned long			next_yield;
+#endif
 };
 
 /* XCHK state flags grow up from zero, XREP state flags grown down from 2^31 */

