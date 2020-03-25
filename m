Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC1F3C1975A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 06:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 868AC206F8
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 06:06:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="naUh5m58"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgCYGGd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 02:06:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46034 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgCYGGc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 02:06:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P5xBx9069156;
        Wed, 25 Mar 2020 06:06:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=x6oBbHEs8ZDdj3KMZYW8ZUgVoKqghQ2fzqluR7qLV6s=;
 b=naUh5m58EEevwo3rfxQ2QdwjkVr/hUYtpqCnbspKknYiSWJtvC93GnmbcbWww+xkOVA4
 GVpd2/Pb+/WmG4EpymUzpnWopsdfEnys3OWAyNkQNUelkZ8F7hpv1VKv6v/Curh+LV2Q
 lvLw1j3cLjdHj93brK8ELnWV5Us3XmdKeUYdTCJIKNvEsypeMmZIa7K3WfNzkPdYHFOq
 DnJmmc3X6ISoi/Yc8zWsJAlrhxVDIMRVa90ml/eOOfxvgmRuHWbMYPZdsacf1JEuFHB8
 Gey2kXegzJpWb0RqzTQeeqdmsjOxVRd0W2eVC2tVS85lQHkCeUBmqNJYcLIrEK7F8bcW 9g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ywabr7y1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 06:06:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P5vn9e176338;
        Wed, 25 Mar 2020 06:06:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2yxw940u6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 06:06:29 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02P66SBt010867;
        Wed, 25 Mar 2020 06:06:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 23:06:27 -0700
Date:   Tue, 24 Mar 2020 23:06:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2 1/4] xfs: prohibit fs freezing when using empty
 transactions
Message-ID: <20200325060627.GW29339@magnolia>
References: <158510667039.922633.6138311243444001882.stgit@magnolia>
 <158510667670.922633.9371387481128286027.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158510667670.922633.9371387481128286027.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003250048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1
 lowpriorityscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250048
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

I noticed that fsfreeze can take a very long time to freeze an XFS if
there happens to be a GETFSMAP caller running in the background.  I also
happened to notice the following in dmesg:

------------[ cut here ]------------
WARNING: CPU: 2 PID: 43492 at fs/xfs/xfs_super.c:853 xfs_quiesce_attr+0x83/0x90 [xfs]
Modules linked in: xfs libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 ip_set_hash_ip ip_set_hash_net xt_tcpudp xt_set ip_set_hash_mac ip_set nfnetlink ip6table_filter ip6_tables bfq iptable_filter sch_fq_codel ip_tables x_tables nfsv4 af_packet [last unloaded: xfs]
CPU: 2 PID: 43492 Comm: xfs_io Not tainted 5.6.0-rc4-djw #rc4
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
RIP: 0010:xfs_quiesce_attr+0x83/0x90 [xfs]
Code: 7c 07 00 00 85 c0 75 22 48 89 df 5b e9 96 c1 00 00 48 c7 c6 b0 2d 38 a0 48 89 df e8 57 64 ff ff 8b 83 7c 07 00 00 85 c0 74 de <0f> 0b 48 89 df 5b e9 72 c1 00 00 66 90 0f 1f 44 00 00 41 55 41 54
RSP: 0018:ffffc900030f3e28 EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffff88802ac54000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff81e4a6f0 RDI: 00000000ffffffff
RBP: ffff88807859f070 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000010 R12: 0000000000000000
R13: ffff88807859f388 R14: ffff88807859f4b8 R15: ffff88807859f5e8
FS:  00007fad1c6c0fc0(0000) GS:ffff88807e000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0c7d237000 CR3: 0000000077f01003 CR4: 00000000001606a0
Call Trace:
 xfs_fs_freeze+0x25/0x40 [xfs]
 freeze_super+0xc8/0x180
 do_vfs_ioctl+0x70b/0x750
 ? __fget_files+0x135/0x210
 ksys_ioctl+0x3a/0xb0
 __x64_sys_ioctl+0x16/0x20
 do_syscall_64+0x50/0x1a0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

These two things appear to be related.  The assertion trips when another
thread initiates a fsmap request (which uses an empty transaction) after
the freezer waited for m_active_trans to hit zero but before the the
freezer executes the WARN_ON just prior to calling xfs_log_quiesce.

The lengthy delays in freezing happen because the freezer calls
xfs_wait_buftarg to clean out the buffer lru list.  Meanwhile, the
GETFSMAP caller is continuing to grab and release buffers, which means
that it can take a very long time for the buffer lru list to empty out.

We fix both of these races by calling sb_start_write to obtain freeze
protection while using empty transactions for GETFSMAP and for metadata
scrubbing.  The other two users occur during mount, during which time we
cannot fs freeze.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: improve comments
---
 fs/xfs/scrub/scrub.c |    9 +++++++++
 fs/xfs/xfs_fsmap.c   |    9 +++++++++
 fs/xfs/xfs_trans.c   |    5 +++++
 3 files changed, 23 insertions(+)

diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index f1775bb19313..8ebf35b115ce 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -168,6 +168,7 @@ xchk_teardown(
 			xfs_irele(sc->ip);
 		sc->ip = NULL;
 	}
+	sb_end_write(sc->mp->m_super);
 	if (sc->flags & XCHK_REAPING_DISABLED)
 		xchk_start_reaping(sc);
 	if (sc->flags & XCHK_HAS_QUOTAOFFLOCK) {
@@ -490,6 +491,14 @@ xfs_scrub_metadata(
 	sc.ops = &meta_scrub_ops[sm->sm_type];
 	sc.sick_mask = xchk_health_mask_for_scrub_type(sm->sm_type);
 retry_op:
+	/*
+	 * If freeze runs concurrently with a scrub, the freeze can be delayed
+	 * indefinitely as we walk the filesystem and iterate over metadata
+	 * buffers.  Freeze quiesces the log (which waits for the buffer LRU to
+	 * be emptied) and that won't happen while checking is running.
+	 */
+	sb_start_write(mp->m_super);
+
 	/* Set up for the operation. */
 	error = sc.ops->setup(&sc, ip);
 	if (error)
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 918456ca29e1..442fd4311f18 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -896,6 +896,14 @@ xfs_getfsmap(
 	info.format_arg = arg;
 	info.head = head;
 
+	/*
+	 * If fsmap runs concurrently with a scrub, the freeze can be delayed
+	 * indefinitely as we walk the rmapbt and iterate over metadata
+	 * buffers.  Freeze quiesces the log (which waits for the buffer LRU to
+	 * be emptied) and that won't happen while we're reading buffers.
+	 */
+	sb_start_write(mp->m_super);
+
 	/* For each device we support... */
 	for (i = 0; i < XFS_GETFSMAP_DEVS; i++) {
 		/* Is this device within the range the user asked for? */
@@ -935,6 +943,7 @@ xfs_getfsmap(
 
 	if (tp)
 		xfs_trans_cancel(tp);
+	sb_end_write(mp->m_super);
 	head->fmh_oflags = FMH_OF_DEV_T;
 	return error;
 }
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 3b208f9a865c..a65dc227e40d 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -306,6 +306,11 @@ xfs_trans_alloc(
  *
  * Note the zero-length reservation; this transaction MUST be cancelled
  * without any dirty data.
+ *
+ * Callers should obtain freeze protection to avoid two conflicts with fs
+ * freezing: (1) having active transactions trip the m_active_trans ASSERTs;
+ * and (2) grabbing buffers at the same time that freeze is trying to drain
+ * the buffer LRU list.
  */
 int
 xfs_trans_alloc_empty(
