Return-Path: <SRS0=y7rh=X4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E62C10F14
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 01:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1277D222C0
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 01:52:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qiJMLyJ9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfJCBwv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Oct 2019 21:52:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46334 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbfJCBwv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Oct 2019 21:52:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x931mrQY064436
        for <linux-xfs@vger.kernel.org>; Thu, 3 Oct 2019 01:52:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=Kl1zT61Iv6WdwtmEgqPmhUsDfiPrEYRyhF6897QMD9w=;
 b=qiJMLyJ9FTYh+7O3ZXF21JGUQWFU1DgWzouoMGpUv/cInfsBFVShY+dPOwLQeADzsvHc
 +6Bf3RY0eVrK0RKWo3G6chljKsDy7N9thsjLep27wAGQ5YaCCGICmLWV17E6yT2UkOPc
 PE7gOUKHtLS5FFilvI9uJvTx1gLi1cQL5Ah1E3t/Gfthm8dAaOuGQxouhIWUjToTebqI
 7+OpRAAlX/Ed6c62pn6/0rH29C7jADqhKsw6j2j8e1okRsARFcaAvD90+0q5Vdh1FkY/
 20yEv0lP/R6WC7yhQJ8XneLUyKMndmxl7VLIW2vVgW80EY/LvsGyJkH0qkZcExrR3ajS AQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2v9xxv0n2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 03 Oct 2019 01:52:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x931nMmF147109
        for <linux-xfs@vger.kernel.org>; Thu, 3 Oct 2019 01:52:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2vc9dmqykf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 03 Oct 2019 01:52:49 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x931qmWu003246
        for <linux-xfs@vger.kernel.org>; Thu, 3 Oct 2019 01:52:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Oct 2019 18:52:48 -0700
Date:   Wed, 2 Oct 2019 18:52:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: frequent 5.4-rc1 crash?
Message-ID: <20191003015247.GI13108@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9398 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=939
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910030015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9398 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910030015
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi everyone,

Does anyone /else/ see this crash in generic/299 on a V4 filesystem (tho
afaict V5 configs crash too) and a 5.4-rc1 kernel?  It seems to pop up
on generic/299 though only 80% of the time.

--D

[ 1806.186197] run fstests generic/299 at 2019-10-02 18:15:30
[ 1808.279874] XFS (sdb): Mounting V4 Filesystem
[ 1808.283519] XFS (sdb): Ending clean mount
[ 1808.284530] XFS (sdb): Quotacheck needed: Please wait.
[ 1808.317062] XFS (sdb): Quotacheck: Done.
[ 1808.319821] Mounted xfs file system at /opt supports timestamps until 2038 (0x7fffffff)
[ 1886.218794] BUG: kernel NULL pointer dereference, address: 0000000000000018
[ 1886.219787] #PF: supervisor read access in kernel mode
[ 1886.220638] #PF: error_code(0x0000) - not-present page
[ 1886.221496] PGD 0 P4D 0 
[ 1886.221970] Oops: 0000 [#1] PREEMPT SMP
[ 1886.222596] CPU: 2 PID: 227320 Comm: kworker/u10:2 Tainted: G        W         5.4.0-rc1-djw #rc1
[ 1886.224016] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
[ 1886.225261] Workqueue: writeback wb_workfn (flush-8:16)
[ 1886.225926] RIP: 0010:__lock_acquire+0x4c3/0x1490
[ 1886.226595] Code: 00 00 00 48 8b 74 24 48 65 48 33 34 25 28 00 00 00 8b 44 24 04 0f 85 a1 0f 00 00 48 83 c4 50 5b 5d 41 5c 41 5d 41 5e 41 5f c3 <48> 81 3f 20 66 6d 82 41 ba 00 00 00 00 45 0f 45 d0 83 fe 01 0f 87
[ 1886.229146] RSP: 0000:ffffc900052c3bc0 EFLAGS: 00010002
[ 1886.230008] RAX: 0000000000000000 RBX: 0000000000000018 RCX: 0000000000000000
[ 1886.231238] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000018
[ 1886.236382] RBP: ffff888077f80000 R08: 0000000000000001 R09: 0000000000000001
[ 1886.241630] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[ 1886.243530] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000018
[ 1886.244669] FS:  0000000000000000(0000) GS:ffff88807e000000(0000) knlGS:0000000000000000
[ 1886.245941] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1886.246913] CR2: 0000000000000018 CR3: 0000000072f7b003 CR4: 00000000001606a0
[ 1886.247834] Call Trace:
[ 1886.248217]  ? mark_held_locks+0x47/0x70
[ 1886.248810]  ? trace_hardirqs_on_thunk+0x1a/0x20
[ 1886.249445]  lock_acquire+0x90/0x180
[ 1886.249876]  ? __wake_up_common_lock+0x62/0xc0
[ 1886.250577]  _raw_spin_lock_irqsave+0x3e/0x80
[ 1886.251327]  ? __wake_up_common_lock+0x62/0xc0
[ 1886.252538]  __wake_up_common_lock+0x62/0xc0
[ 1886.257318]  wb_workfn+0x10e/0x610
[ 1886.260171]  ? __lock_acquire+0x268/0x1490
[ 1886.266124]  ? process_one_work+0x1da/0x5d0
[ 1886.266941]  process_one_work+0x25b/0x5d0
[ 1886.267759]  worker_thread+0x3d/0x3a0
[ 1886.268497]  ? process_one_work+0x5d0/0x5d0
[ 1886.269285]  kthread+0x121/0x140
[ 1886.269808]  ? kthread_park+0x80/0x80
[ 1886.270317]  ret_from_fork+0x3a/0x50
[ 1886.270811] Modules linked in: xfs libcrc32c dm_flakey ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 ip_set_hash_ip ip_set_hash_net xt_tcpudp bfq xt_set ip_set_hash_mac ip_set nfnetlink ip6table_filter ip6_tables iptable_filter sch_fq_codel ip_tables x_tables nfsv4 af_packet [last unloaded: scsi_debug]
[ 1886.274144] Dumping ftrace buffer:
[ 1886.274637]    (ftrace buffer empty)
[ 1886.275129] CR2: 0000000000000018
[ 1886.275567] ---[ end trace 20db199015efe614 ]---
[ 1886.278601] RIP: 0010:__lock_acquire+0x4c3/0x1490
[ 1886.283408] Code: 00 00 00 48 8b 74 24 48 65 48 33 34 25 28 00 00 00 8b 44 24 04 0f 85 a1 0f 00 00 48 83 c4 50 5b 5d 41 5c 41 5d 41 5e 41 5f c3 <48> 81 3f 20 66 6d 82 41 ba 00 00 00 00 45 0f 45 d0 83 fe 01 0f 87

