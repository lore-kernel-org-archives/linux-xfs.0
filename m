Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 238C0C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 15:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6A8F22400
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 15:51:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tSXAOXQc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1773461AbgJZPvs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 11:51:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54710 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1771082AbgJZPvs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 11:51:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QFeSSD095169
        for <linux-xfs@vger.kernel.org>; Mon, 26 Oct 2020 15:51:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=2xnfFWfncg8e1XLYrY7MXRZ1P4kXXcJlRFiAor4iQ/c=;
 b=tSXAOXQcvPnO8E3M98AJwBykaACQdjWxfzkXwYKI1JhX+DSrAvwzKSJG/PPWdXbVdyqO
 20kA/fplVLoic9YPScs1z00ZpNoIm6jXbhHUMSnzJ+FVSOtMGJWUwbyB7IQ6KuxKETAR
 ERP3abVhqHUgYhDnG53rcUEQbf+Pqw2z4SIsXiSWgoqWh9Cohzf3zrAOq2s9xR+gHv+7
 +PEvW6obhKUhDOFgFYKPEHNCYC3DjIyJnkscwM5utydrQUWoQqN0feZFT0GWyR3y/Cok
 Y/pnOOM/UuWKDU6MYsBg6mtOmh4rxf+3x4hkwhUbJY70UaKVG7zgQCla9WjfU5tSMRj0 eA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34dgm3tyqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Oct 2020 15:51:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QFdvY3191659
        for <linux-xfs@vger.kernel.org>; Mon, 26 Oct 2020 15:51:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34cx5w3j76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Oct 2020 15:51:45 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QFpiBK015505
        for <linux-xfs@vger.kernel.org>; Mon, 26 Oct 2020 15:51:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 08:51:44 -0700
Date:   Mon, 26 Oct 2020 08:51:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix invalid pointer dereference in
 xfs_attr3_node_inactive
Message-ID: <20201026155142.GB347246@magnolia>
References: <20200204070636.25572-1-zlang@redhat.com>
 <20200204213932.GM20628@dread.disaster.area>
 <20200205000910.GB6870@magnolia>
 <20200205040211.GO14282@dhcp-12-102.nay.redhat.com>
 <20201026051947.GE17190@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026051947.GE17190@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9785 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=10 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260109
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9785 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=10 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260109
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 26, 2020 at 01:19:48PM +0800, Zorro Lang wrote:
> On Wed, Feb 05, 2020 at 12:02:11PM +0800, Zorro Lang wrote:
> > On Tue, Feb 04, 2020 at 04:09:10PM -0800, Darrick J. Wong wrote:
> > > On Wed, Feb 05, 2020 at 08:39:32AM +1100, Dave Chinner wrote:
> > > > On Tue, Feb 04, 2020 at 03:06:36PM +0800, Zorro Lang wrote:
> > > > > This patch fixes below KASAN report. The xfs_attr3_node_inactive()
> > > > > gets 'child_bp' at there:
> > > > >   error = xfs_trans_get_buf(*trans, mp->m_ddev_targp,
> > > > >                             child_blkno,
> > > > >                             XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0,
> > > > >                             &child_bp);
> > > > >   if (error)
> > > > >           return error;
> > > > >   error = bp->b_error;
> > > > > 
> > > > > But it turns to use 'bp', not 'child_bp'. And the 'bp' has been freed by:
> > > > >   xfs_trans_brelse(*trans, bp);
> > > > 
> > > > ....
> > > > > ---
> > > > >  fs/xfs/xfs_attr_inactive.c | 2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> > > > > index bbfa6ba84dcd..26230d150bf2 100644
> > > > > --- a/fs/xfs/xfs_attr_inactive.c
> > > > > +++ b/fs/xfs/xfs_attr_inactive.c
> > > > > @@ -211,7 +211,7 @@ xfs_attr3_node_inactive(
> > > > >  				&child_bp);
> > > > >  		if (error)
> > > > >  			return error;
> > > > > -		error = bp->b_error;
> > > > > +		error = child_bp->b_error;
> > > > >  		if (error) {
> > > > >  			xfs_trans_brelse(*trans, child_bp);
> > > > >  			return error;
> > > > 
> > > > Isn't this dead code now? i.e. any error that occurs on the buffer
> > > > during a xfs_trans_get_buf() call is returned directly and so it's
> > > > caught by the "if (error)" check. Hence this whole child_bp->b_error
> > > > check can be removed, right?
> > > 
> > > It will be after I send in the second half of the 5.6 merge window.  I
> > > decided to hang onto the buffer error code rework until all of the
> > > kernel fuzz tests finished running and I was satisfied with my own
> > > userspace port of the same series.
> > > 
> > > (All that is now done, so I'll send that to linus tomorrow.)
> 
> Hi,
> 
> Has this issue been fixed? Due to I still hit xfs/433 fail on latest xfs-linux:

Clearly it hasn't.  Taking a second look at this, I think the _get_buf
call could return 0, having set *child_bp to a buffer that previously
encountered an IO error.  If that was the case, we just brelse the
buffer and bail out.  If there wasn't a previous error, we invalidate
the buffer and keep going.

IOWs, I think this patch is correct.  Could you rebase this to 5.10-rc1
and resend it, please?

--D

> [53972.827180] run fstests xfs/433 at 2020-10-24 23:11:10
> [53975.984049] XFS (vda3): Mounting V5 Filesystem
> [53976.134116] XFS (vda3): Ending clean mount
> [53976.210045] xfs filesystem being mounted at /mnt/xfstests/scratch supports timestamps until 2038 (0x7fffffff)
> [53982.471101] XFS (vda3): Unmounting Filesystem
> [53982.823725] XFS (vda3): Mounting V5 Filesystem
> [53982.876916] XFS (vda3): Ending clean mount
> [53982.898987] xfs filesystem being mounted at /mnt/xfstests/scratch supports timestamps until 2038 (0x7fffffff)
> [53982.949671] XFS (vda3): Injecting error (false) at file fs/xfs/xfs_buf.c, line 2345, on filesystem "vda3"
> [53982.952998] XFS (vda3): Injecting error (false) at file fs/xfs/xfs_buf.c, line 2345, on filesystem "vda3"
> [53982.957436] XFS (vda3): Injecting error (false) at file fs/xfs/xfs_buf.c, line 2345, on filesystem "vda3"
> [53982.960791] XFS (vda3): Injecting error (false) at file fs/xfs/xfs_buf.c, line 2345, on filesystem "vda3"
> [53982.963502] ==================================================================
> [53982.966070] BUG: KASAN: use-after-free in xfs_attr3_node_inactive+0x684/0x7c0 [xfs]
> [53982.968000] Read of size 4 at addr fffffc0106509854 by task rm/2847654
> 
> [53982.970018] CPU: 0 PID: 2847654 Comm: rm Tainted: G        W         5.9.0-rc4 #1
> [53982.971872] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
> [53982.973583] Call trace:
> [53982.974323]  dump_backtrace+0x0/0x3d0
> [53982.975267]  show_stack+0x1c/0x28
> [53982.976159]  dump_stack+0x13c/0x1b8
> [53982.977092]  print_address_description.constprop.12+0x68/0x4e0
> [53982.978575]  kasan_report+0x134/0x1b8
> [53982.979521]  __asan_report_load4_noabort+0x2c/0x50
> [53982.980876]  xfs_attr3_node_inactive+0x684/0x7c0 [xfs]
> [53982.982320]  xfs_attr_inactive+0x414/0x7e8 [xfs]
> [53982.983633]  xfs_inactive+0x398/0x4e8 [xfs]
> [53982.984835]  xfs_fs_destroy_inode+0x440/0xf48 [xfs]
> [53982.986080]  destroy_inode+0xa8/0x178
> [53982.987024]  evict+0x2bc/0x4a8
> [53982.987804]  iput+0x504/0x8f8
> [53982.988561]  do_unlinkat+0x36c/0x480
> [53982.989482]  __arm64_sys_unlinkat+0x94/0xf0
> [53982.990558]  do_el0_svc+0x1c4/0x3c0
> [53982.991442]  el0_sync_handler+0xf8/0x124
> [53982.992437]  el0_sync+0x140/0x180
> 
> [53982.993669] Allocated by task 2847654:
> [53982.994663]  kasan_save_stack+0x24/0x50
> [53982.995682]  __kasan_kmalloc.isra.6+0xc4/0xe0
> [53982.996798]  kasan_slab_alloc+0x14/0x20
> [53982.997768]  slab_post_alloc_hook+0x5c/0x548
> [53982.998846]  kmem_cache_alloc+0x170/0x400
> [53983.000016]  _xfs_buf_alloc+0x68/0x1318 [xfs]
> [53983.001249]  xfs_buf_get_map+0x13c/0xcb8 [xfs]
> [53983.002504]  xfs_buf_read_map+0xbc/0xdc0 [xfs]
> [53983.003765]  xfs_trans_read_buf_map+0x534/0x1ff0 [xfs]
> [53983.005209]  xfs_da_read_buf+0x1ac/0x258 [xfs]
> [53983.006487]  xfs_da3_node_read+0x3c/0x98 [xfs]
> [53983.007735]  xfs_attr_inactive+0x5b8/0x7e8 [xfs]
> [53983.009034]  xfs_inactive+0x398/0x4e8 [xfs]
> [53983.010240]  xfs_fs_destroy_inode+0x440/0xf48 [xfs]
> [53983.011507]  destroy_inode+0xa8/0x178
> [53983.012442]  evict+0x2bc/0x4a8
> [53983.013228]  iput+0x504/0x8f8
> [53983.013972]  do_unlinkat+0x36c/0x480
> [53983.014884]  __arm64_sys_unlinkat+0x94/0xf0
> [53983.015964]  do_el0_svc+0x1c4/0x3c0
> [53983.016864]  el0_sync_handler+0xf8/0x124
> [53983.017858]  el0_sync+0x140/0x180
> 
> [53983.019086] Freed by task 2847654:
> [53983.019946]  kasan_save_stack+0x24/0x50
> [53983.020953]  kasan_set_track+0x24/0x38
> [53983.021908]  kasan_set_free_info+0x20/0x40
> [53983.022940]  __kasan_slab_free+0x100/0x170
> [53983.023973]  kasan_slab_free+0x10/0x18
> [53983.024924]  slab_free_freelist_hook+0xf8/0x260
> [53983.026093]  kmem_cache_free+0xd0/0x4b0
> [53983.027205]  xfs_buf_free+0x354/0x958 [xfs]
> [53983.028399]  xfs_buf_rele+0x1040/0x1a90 [xfs]
> [53983.029643]  xfs_trans_brelse+0x294/0x858 [xfs]
> [53983.030941]  xfs_attr3_node_inactive+0x1a4/0x7c0 [xfs]
> [53983.032396]  xfs_attr_inactive+0x414/0x7e8 [xfs]
> [53983.033693]  xfs_inactive+0x398/0x4e8 [xfs]
> [53983.034889]  xfs_fs_destroy_inode+0x440/0xf48 [xfs]
> [53983.036143]  destroy_inode+0xa8/0x178
> [53983.037083]  evict+0x2bc/0x4a8
> [53983.037868]  iput+0x504/0x8f8
> [53983.038636]  do_unlinkat+0x36c/0x480
> [53983.039553]  __arm64_sys_unlinkat+0x94/0xf0
> [53983.040622]  do_el0_svc+0x1c4/0x3c0
> [53983.041515]  el0_sync_handler+0xf8/0x124
> [53983.042523]  el0_sync+0x140/0x180
> 
> [53983.043750] The buggy address belongs to the object at fffffc0106509600
>                 which belongs to the cache xfs_buf of size 632
> [53983.046824] The buggy address is located 596 bytes inside of
>                 632-byte region [fffffc0106509600, fffffc0106509878)
> [53983.049772] The buggy address belongs to the page:
> [53983.050993] page:00000000e91654da refcount:1 mapcount:0 mapping:0000000000000000 index:0xfffffc0106500000 pfn:0x14650
> [53983.053681] flags: 0x17ffff8000000200(slab)
> [53983.054748] raw: 17ffff8000000200 ffffffff7ffaaa80 0000000600000006 fffffc012154a380
> [53983.056713] raw: fffffc0106500000 000000008055004a 00000001ffffffff 0000000000000000
> [53983.058688] page dumped because: kasan: bad access detected
> 
> [53983.060494] Memory state around the buggy address:
> [53983.061719]  fffffc0106509700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [53983.063569]  fffffc0106509780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [53983.065350] >fffffc0106509800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc
> [53983.067180]                                                  ^
> [53983.068670]  fffffc0106509880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [53983.070474]  fffffc0106509900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [53983.072340] ==================================================================
> 
> > 
> > Oh, that's great! Please ignore this noise(/patch) :)
> > 
> > Thanks,
> > Zorro
> > 
> > > 
> > > --D
> > > 
> > > > Cheers,
> > > > 
> > > > Dave.
> > > > -- 
> > > > Dave Chinner
> > > > david@fromorbit.com
> > > 
> > 
> 
