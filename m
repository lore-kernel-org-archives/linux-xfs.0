Return-Path: <SRS0=BKGZ=5R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4379C2D0F1
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 11:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 751F820776
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 11:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732026AbgDALTQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Apr 2020 07:19:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36708 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732146AbgDALTP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Apr 2020 07:19:15 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 031B3V3f010740
        for <linux-xfs@vger.kernel.org>; Wed, 1 Apr 2020 07:19:14 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 304r4ykfp8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Apr 2020 07:19:14 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Wed, 1 Apr 2020 12:19:01 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 1 Apr 2020 12:19:00 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 031BJAPK58064966
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Apr 2020 11:19:10 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 709E74204B;
        Wed,  1 Apr 2020 11:19:10 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 895E142045;
        Wed,  1 Apr 2020 11:19:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.52.194])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  1 Apr 2020 11:19:09 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: prohibit fs freezing when using empty transactions
Date:   Wed, 01 Apr 2020 16:52:11 +0530
Organization: IBM
In-Reply-To: <158510667670.922633.9371387481128286027.stgit@magnolia>
References: <158510667039.922633.6138311243444001882.stgit@magnolia> <158510667670.922633.9371387481128286027.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20040111-0008-0000-0000-000003686D65
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040111-0009-0000-0000-00004A89F57A
Message-Id: <2023753.tQ6Ys18cog@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-01_01:2020-03-31,2020-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501
 spamscore=0 suspectscore=1 mlxscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004010097
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, March 25, 2020 8:54 AM Darrick J. Wong wrote: 
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> I noticed that fsfreeze can take a very long time to freeze an XFS if
> there happens to be a GETFSMAP caller running in the background.  I also
> happened to notice the following in dmesg:
> 
> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 43492 at fs/xfs/xfs_super.c:853 xfs_quiesce_attr+0x83/0x90 [xfs]
> Modules linked in: xfs libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 ip_set_hash_ip ip_set_hash_net xt_tcpudp xt_set ip_set_hash_mac ip_set nfnetlink ip6table_filter ip6_tables bfq iptable_filter sch_fq_codel ip_tables x_tables nfsv4 af_packet [last unloaded: xfs]
> CPU: 2 PID: 43492 Comm: xfs_io Not tainted 5.6.0-rc4-djw #rc4
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
> RIP: 0010:xfs_quiesce_attr+0x83/0x90 [xfs]
> Code: 7c 07 00 00 85 c0 75 22 48 89 df 5b e9 96 c1 00 00 48 c7 c6 b0 2d 38 a0 48 89 df e8 57 64 ff ff 8b 83 7c 07 00 00 85 c0 74 de <0f> 0b 48 89 df 5b e9 72 c1 00 00 66 90 0f 1f 44 00 00 41 55 41 54
> RSP: 0018:ffffc900030f3e28 EFLAGS: 00010202
> RAX: 0000000000000001 RBX: ffff88802ac54000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff81e4a6f0 RDI: 00000000ffffffff
> RBP: ffff88807859f070 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000010 R12: 0000000000000000
> R13: ffff88807859f388 R14: ffff88807859f4b8 R15: ffff88807859f5e8
> FS:  00007fad1c6c0fc0(0000) GS:ffff88807e000000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f0c7d237000 CR3: 0000000077f01003 CR4: 00000000001606a0
> Call Trace:
>  xfs_fs_freeze+0x25/0x40 [xfs]
>  freeze_super+0xc8/0x180
>  do_vfs_ioctl+0x70b/0x750
>  ? __fget_files+0x135/0x210
>  ksys_ioctl+0x3a/0xb0
>  __x64_sys_ioctl+0x16/0x20
>  do_syscall_64+0x50/0x1a0
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> These two things appear to be related.  The assertion trips when another
> thread initiates a fsmap request (which uses an empty transaction) after
> the freezer waited for m_active_trans to hit zero but before the the
> freezer executes the WARN_ON just prior to calling xfs_log_quiesce.
> 
> The lengthy delays in freezing happen because the freezer calls
> xfs_wait_buftarg to clean out the buffer lru list.  Meanwhile, the
> GETFSMAP caller is continuing to grab and release buffers, which means
> that it can take a very long time for the buffer lru list to empty out.
> 
> We fix both of these races by calling sb_start_write to obtain freeze
> protection while using empty transactions for GETFSMAP and for metadata
> scrubbing.  The other two users occur during mount, during which time we
> cannot fs freeze.
>

sb_[start|end]_write() calls do indeed exclude the fsfreezer task from
executing when fsmap ioctl call is being serviced.  I do not understand the
code associated with xfs scrub. Apart from that, the changes look good to me.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/scrub.c |    4 ++++
>  fs/xfs/xfs_fsmap.c   |    4 ++++
>  fs/xfs/xfs_trans.c   |    5 +++++
>  3 files changed, 13 insertions(+)
> 
> 
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index f1775bb19313..a42bb66b335d 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -168,6 +168,7 @@ xchk_teardown(
>  			xfs_irele(sc->ip);
>  		sc->ip = NULL;
>  	}
> +	sb_end_write(sc->mp->m_super);
>  	if (sc->flags & XCHK_REAPING_DISABLED)
>  		xchk_start_reaping(sc);
>  	if (sc->flags & XCHK_HAS_QUOTAOFFLOCK) {
> @@ -490,6 +491,9 @@ xfs_scrub_metadata(
>  	sc.ops = &meta_scrub_ops[sm->sm_type];
>  	sc.sick_mask = xchk_health_mask_for_scrub_type(sm->sm_type);
>  retry_op:
> +	/* Avoid conflicts with fs freeze. */
> +	sb_start_write(mp->m_super);
> +
>  	/* Set up for the operation. */
>  	error = sc.ops->setup(&sc, ip);
>  	if (error)
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 918456ca29e1..2bb2cd1e63cf 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -896,6 +896,9 @@ xfs_getfsmap(
>  	info.format_arg = arg;
>  	info.head = head;
>  
> +	/* Avoid conflicts with fs freeze. */
> +	sb_start_write(mp->m_super);
> +
>  	/* For each device we support... */
>  	for (i = 0; i < XFS_GETFSMAP_DEVS; i++) {
>  		/* Is this device within the range the user asked for? */
> @@ -935,6 +938,7 @@ xfs_getfsmap(
>  
>  	if (tp)
>  		xfs_trans_cancel(tp);
> +	sb_end_write(mp->m_super);
>  	head->fmh_oflags = FMH_OF_DEV_T;
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 3b208f9a865c..a65dc227e40d 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -306,6 +306,11 @@ xfs_trans_alloc(
>   *
>   * Note the zero-length reservation; this transaction MUST be cancelled
>   * without any dirty data.
> + *
> + * Callers should obtain freeze protection to avoid two conflicts with fs
> + * freezing: (1) having active transactions trip the m_active_trans ASSERTs;
> + * and (2) grabbing buffers at the same time that freeze is trying to drain
> + * the buffer LRU list.
>   */
>  int
>  xfs_trans_alloc_empty(
> 
> 


-- 
chandan



