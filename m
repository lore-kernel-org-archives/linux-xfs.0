Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D41EC432C0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 22:30:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54F682071B
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 22:30:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MaDq1+ae"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfKVWa5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 17:30:57 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36540 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfKVWa4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 17:30:56 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAMMT3rj099842;
        Fri, 22 Nov 2019 22:30:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=vjJTpVrwRi7efufXa/LO4zW/Xy5nRRdpwOlF1P4DTTM=;
 b=MaDq1+aeLHPB6JsdlzC+LWuTM5/8SQJSkUsloIcYNve/vQzgobqdBhybDXpYmH6FHynH
 ts5P8t4bgPQ8/PsFNP+XT2KWcpDwWj4M7mHd+s8vsKJnZSrwI1Bt6+xY3MZIGoRep2Rt
 X1011S1DSL/gJqteHdfYxtm7JSVu+8XIAbcI2tSUdDtQ3Cieo4wLWLjN0FQqZptx+Yf2
 R3dk0ATEAsni8f+9xqDjWUkVYXsnZeU1V8X2QFPUxw10Jjf1pUcVaMT8mkaPG3js7CeT
 9iAAH7PR9PSGMNwZ7K5y5MvM1zdu17Tu77UVptOd3Xh6lwyPj3M6gDtXvl1udCrHY0XY Fw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2wa9rr585u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 22:30:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAMMSMBV184416;
        Fri, 22 Nov 2019 22:30:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2we8ygjfd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 22:30:50 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAMMUoIb026174;
        Fri, 22 Nov 2019 22:30:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Nov 2019 14:30:49 -0800
Date:   Fri, 22 Nov 2019 14:30:48 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: Convert kmem_alloc() users
Message-ID: <20191122223048.GK6219@magnolia>
References: <20191120104425.407213-1-cmaiolino@redhat.com>
 <20191120104425.407213-6-cmaiolino@redhat.com>
 <20191122155756.GE6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122155756.GE6219@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9449 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911220178
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9449 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911220178
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 22, 2019 at 07:57:56AM -0800, Darrick J. Wong wrote:
> On Wed, Nov 20, 2019 at 11:44:25AM +0100, Carlos Maiolino wrote:
> > Use kmalloc() directly.

<snip all this>

> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 5423171e0b7d..7bb53fbf32f6 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -1962,7 +1962,7 @@ xlog_recover_buffer_pass1(
> >  		}
> >  	}
> >  
> > -	bcp = kmem_alloc(sizeof(struct xfs_buf_cancel), 0);
> > +	bcp = kmalloc(sizeof(struct xfs_buf_cancel), GFP_KERNEL | __GFP_NOFAIL);
> >  	bcp->bc_blkno = buf_f->blf_blkno;
> >  	bcp->bc_len = buf_f->blf_len;
> >  	bcp->bc_refcount = 1;
> > @@ -2932,7 +2932,8 @@ xlog_recover_inode_pass2(
> >  	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
> >  		in_f = item->ri_buf[0].i_addr;
> >  	} else {
> > -		in_f = kmem_alloc(sizeof(struct xfs_inode_log_format), 0);
> > +		in_f = kmalloc(sizeof(struct xfs_inode_log_format),
> > +			       GFP_KERNEL | __GFP_NOFAIL);
> >  		need_free = 1;
> >  		error = xfs_inode_item_format_convert(&item->ri_buf[0], in_f);
> >  		if (error)
> > @@ -4271,7 +4272,7 @@ xlog_recover_add_to_trans(
> >  		return 0;
> >  	}
> >  
> > -	ptr = kmem_alloc(len, 0);
> > +	ptr = kmalloc(len, GFP_KERNEL | __GFP_NOFAIL);
> >  	memcpy(ptr, dp, len);
> >  	in_f = (struct xfs_inode_log_format *)ptr;
> 
> I noticed that kmalloc is generating warnings with generic/049 when 16k
> directories (-n size=16k) are enabled.  I /think/ this is because it's
> quite possible to write out an xlog_op_header with a length of more than
> a single page; log recovery will then try to allocate a huge memory
> buffer to recover the transaction; and so we try to do a huge NOFAIL
> allocation, which makes the mm unhappy.
> 
> The one thing I've noticed with this conversion series is that the flags
> translation isn't 100% 1-to-1.  Before, kmem_flags_convert didn't
> explicitly set __GFP_NOFAIL anywhere; we simply took the default
> behavior.  IIRC that means that small allocations actually /are/
> guaranteed to succeed, but multipage allocations certainly aren't.
> This seems to be one place where we could have asked for a lot of
> memory, failed to get it, and crashed.
> 
> Now that we explicitly set NOFAIL in all the places where we don't also
> check for a null return, I think we're just uncovering latent bugs
> lurking in the code base.  The kernel does actually fulfill the
> allocation request, but it's clearly not happy.

FWIW I ran with various dirsizes and options and it looks like this is
the only place where we screw this up... patches soon.

--D

> --D
> 
> Relevant snippet of dmesg; everything else was normal:
> 
>  XFS (sdd): Mounting V5 Filesystem
>  XFS (sdd): Starting recovery (logdev: internal)
>  ------------[ cut here ]------------
>  WARNING: CPU: 1 PID: 459342 at mm/page_alloc.c:3275 get_page_from_freelist+0x434/0x1660
>  Modules linked in: dm_thin_pool dm_persistent_data dm_bio_prison dm_snapshot dm_bufio dm_flakey xfs libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 ip_set_hash_ip ip_set_hash_net xt_tcpudp xt_set ip_set_hash_mac bfq ip_set nfnetlink ip6table_filter ip6_tables iptable_filter sch_fq_codel ip_tables x_tables nfsv4 af_packet [last unloaded: scsi_debug]
>  CPU: 1 PID: 459342 Comm: mount Not tainted 5.4.0-rc3-djw #rc3
>  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
>  RIP: 0010:get_page_from_freelist+0x434/0x1660
>  Code: e6 00 00 00 00 48 89 84 24 a0 00 00 00 0f 84 08 fd ff ff f7 84 24 c0 00 00 00 00 80 00 00 74 0c 83 bc 24 84 00 00 00 01 76 02 <0f> 0b 49 8d 87 10 05 00 00 48 89 c7 48 89 84 24 88 00 00 00 e8 03
>  RSP: 0018:ffffc900035d3918 EFLAGS: 00010202
>  RAX: ffff88803fffb680 RBX: 0000000000002968 RCX: ffffea0000c8e108
>  RDX: ffff88803fffbba8 RSI: ffff88803fffb870 RDI: 0000000000000000
>  RBP: 0000000000000002 R08: 0000000000000201 R09: 000000000002ff81
>  R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
>  R13: 0000000000048cc0 R14: 0000000000000001 R15: ffff88803fffb680
>  FS:  00007fcfdf89a080(0000) GS:ffff88803ea00000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 000055b202ec48c8 CR3: 000000003bfdc005 CR4: 00000000001606a0
>  Call Trace:
>   ? kvm_clock_read+0x14/0x30
>   __alloc_pages_nodemask+0x172/0x3a0
>   kmalloc_order+0x18/0x80
>   kmalloc_order_trace+0x1d/0x130
>   xlog_recover_add_to_trans+0x4b/0x340 [xfs]
>   xlog_recovery_process_trans+0xe9/0xf0 [xfs]
>   xlog_recover_process_data+0x9e/0x1f0 [xfs]
>   xlog_do_recovery_pass+0x3a9/0x7c0 [xfs]
>   xlog_do_log_recovery+0x72/0x150 [xfs]
>   xlog_do_recover+0x43/0x2a0 [xfs]
>   xlog_recover+0xdf/0x170 [xfs]
>   xfs_log_mount+0x2e3/0x300 [xfs]
>   xfs_mountfs+0x4e7/0x9f0 [xfs]
>   xfs_fc_fill_super+0x2f8/0x520 [xfs]
>   ? xfs_fs_destroy_inode+0x4f0/0x4f0 [xfs]
>   get_tree_bdev+0x198/0x270
>   vfs_get_tree+0x23/0xb0
>   do_mount+0x87e/0xa20
>   ksys_mount+0xb6/0xd0
>   __x64_sys_mount+0x21/0x30
>   do_syscall_64+0x50/0x180
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>  RIP: 0033:0x7fcfdf15d3ca
>  Code: 48 8b 0d c1 8a 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8e 8a 2c 00 f7 d8 64 89 01 48
>  RSP: 002b:00007fff0af10a58 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
>  RAX: ffffffffffffffda RBX: 000055b202ec1970 RCX: 00007fcfdf15d3ca
>  RDX: 000055b202ec1be0 RSI: 000055b202ec1c20 RDI: 000055b202ec1c00
>  RBP: 0000000000000000 R08: 000055b202ec1b80 R09: 0000000000000000
>  R10: 00000000c0ed0000 R11: 0000000000000202 R12: 000055b202ec1c00
>  R13: 000055b202ec1be0 R14: 0000000000000000 R15: 00007fcfdf67e8a4
>  irq event stamp: 18398
>  hardirqs last  enabled at (18397): [<ffffffff8123738f>] __slab_alloc.isra.83+0x6f/0x80
>  hardirqs last disabled at (18398): [<ffffffff81001d8a>] trace_hardirqs_off_thunk+0x1a/0x20
>  softirqs last  enabled at (18158): [<ffffffff81a003af>] __do_softirq+0x3af/0x4a4
>  softirqs last disabled at (18149): [<ffffffff8106528c>] irq_exit+0xbc/0xe0
>  ---[ end trace 3669c914fa8ccac6 ]---
> 
> AFAICT this is because inode buffers are 32K on this system
> 
> >  
> > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > index a2664afa10c3..2993af4a9935 100644
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> > @@ -988,7 +988,8 @@ xfs_qm_reset_dqcounts_buf(
> >  	if (qip->i_d.di_nblocks == 0)
> >  		return 0;
> >  
> > -	map = kmem_alloc(XFS_DQITER_MAP_SIZE * sizeof(*map), 0);
> > +	map = kmalloc(XFS_DQITER_MAP_SIZE * sizeof(*map),
> > +		      GFP_KERNEL | __GFP_NOFAIL);
> >  
> >  	lblkno = 0;
> >  	maxlblkcnt = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
> > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > index 7f03b4ab3452..dfd419d402ea 100644
> > --- a/fs/xfs/xfs_rtalloc.c
> > +++ b/fs/xfs/xfs_rtalloc.c
> > @@ -962,7 +962,7 @@ xfs_growfs_rt(
> >  	/*
> >  	 * Allocate a new (fake) mount/sb.
> >  	 */
> > -	nmp = kmem_alloc(sizeof(*nmp), 0);
> > +	nmp = kmalloc(sizeof(*nmp), GFP_KERNEL | __GFP_NOFAIL);
> >  	/*
> >  	 * Loop over the bitmap blocks.
> >  	 * We will do everything one bitmap block at a time.
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index cc1933dc652f..eee831681e9c 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1739,7 +1739,7 @@ static int xfs_init_fs_context(
> >  {
> >  	struct xfs_mount	*mp;
> >  
> > -	mp = kmem_alloc(sizeof(struct xfs_mount), KM_ZERO);
> > +	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL | __GFP_NOFAIL);
> >  	if (!mp)
> >  		return -ENOMEM;
> >  
> > -- 
> > 2.23.0
> > 
