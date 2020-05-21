Return-Path: <SRS0=XxdV=7D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12234C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 23:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7E03207F9
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 23:13:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S4BGhQHm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbgEUXNY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 19:13:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52246 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730626AbgEUXNY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 19:13:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LNCItb156997;
        Thu, 21 May 2020 23:13:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=pjQEy4tdYhPq0JjpXi5bFtReWr0gjuz1z9g5U2+cdq4=;
 b=S4BGhQHmII+kwyH2X3Ui3a/rBhNfRuG+Mi1cSr0M3n1nlmvvxlsWCnI5LHXPKAB/RfKo
 LVM1MijiX3H3y3Yn0GMKL5w22AVA/GdhN0NDZPQOEsUxgSbaQDO87QHv+dpvFcaGRM+n
 IiBvldVJuomf7qR5zuU5chShw7RD4FxXL6xOdfbN3DNBZtvgkyEAx4wcOf4cX+iREjH7
 ReZjVdEgO2zaqZBUckEtBSKBPq2x6b/wydovCB7qJYEOu/aQ7/I6Ib+TlJF830Uech0U
 paRx5VMR2eJ2Mzcc51ZB6dEkoKwPLYnBgJ+z+EGsQzVk1IDC2govoBe2Xhx8RXYxqbZ6 eQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31284mb4bh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 May 2020 23:13:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LNDFjj123872;
        Thu, 21 May 2020 23:13:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 312t3cmmrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 May 2020 23:13:17 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04LNDDjE011736;
        Thu, 21 May 2020 23:13:13 GMT
Received: from localhost (/10.159.131.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 16:13:13 -0700
Date:   Thu, 21 May 2020 16:13:12 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Airlie <airlied@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: lockdep trace with xfs + mm in it from 5.7.0-rc5
Message-ID: <20200521231312.GJ17635@magnolia>
References: <CAPM=9tyy5vubggbcj32bGpA_h6yDaBNM3QeJPySTzci-etfBZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9tyy5vubggbcj32bGpA_h6yDaBNM3QeJPySTzci-etfBZw@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005210174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005210174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[cc linux-xfs]

On Fri, May 22, 2020 at 08:21:50AM +1000, Dave Airlie wrote:
> Hi,
> 
> Just updated a rawhide VM to the Fedora 5.7.0-rc5 kernel, did some
> package building,
> 
> got the below trace, not sure if it's known and fixed or unknown.

It's a known false-positive.  An inode can't simultaneously be getting
reclaimed due to zero refcount /and/ be the target of a getxattr call.
Unfortunately, lockdep can't tell the difference, and it seems a little
strange to set NOFS on the allocation (which increases the chances of a
runtime error) just to quiet that down.

--D

> Dave.
> 
>   725.862536] ======================================================
> [  725.862564] WARNING: possible circular locking dependency detected
> [  725.862591] 5.7.0-0.rc5.20200515git1ae7efb38854.1.fc33.x86_64 #1 Not tainted
> [  725.862612] ------------------------------------------------------
> [  725.862630] kswapd0/159 is trying to acquire lock:
> [  725.862645] ffff9b38d01a4470 (&xfs_nondir_ilock_class){++++}-{3:3},
> at: xfs_ilock+0xde/0x2c0 [xfs]
> [  725.862718]
>                but task is already holding lock:
> [  725.862735] ffffffffbbb8bd00 (fs_reclaim){+.+.}-{0:0}, at:
> __fs_reclaim_acquire+0x5/0x30
> [  725.862762]
>                which lock already depends on the new lock.
> 
> [  725.862785]
>                the existing dependency chain (in reverse order) is:
> [  725.862806]
>                -> #1 (fs_reclaim){+.+.}-{0:0}:
> [  725.862824]        fs_reclaim_acquire+0x34/0x40
> [  725.862839]        __kmalloc+0x4f/0x270
> [  725.862878]        kmem_alloc+0x93/0x1d0 [xfs]
> [  725.862914]        kmem_alloc_large+0x4c/0x130 [xfs]
> [  725.862945]        xfs_attr_copy_value+0x74/0xa0 [xfs]
> [  725.862984]        xfs_attr_get+0x9d/0xc0 [xfs]
> [  725.863021]        xfs_get_acl+0xb6/0x200 [xfs]
> [  725.863036]        get_acl+0x81/0x160
> [  725.863052]        posix_acl_xattr_get+0x3f/0xd0
> [  725.863067]        vfs_getxattr+0x148/0x170
> [  725.863081]        getxattr+0xa7/0x240
> [  725.863093]        path_getxattr+0x52/0x80
> [  725.863111]        do_syscall_64+0x5c/0xa0
> [  725.863133]        entry_SYSCALL_64_after_hwframe+0x49/0xb3
> [  725.863149]
>                -> #0 (&xfs_nondir_ilock_class){++++}-{3:3}:
> [  725.863177]        __lock_acquire+0x1257/0x20d0
> [  725.863193]        lock_acquire+0xb0/0x310
> [  725.863207]        down_write_nested+0x49/0x120
> [  725.863242]        xfs_ilock+0xde/0x2c0 [xfs]
> [  725.863277]        xfs_reclaim_inode+0x3f/0x400 [xfs]
> [  725.863312]        xfs_reclaim_inodes_ag+0x20b/0x410 [xfs]
> [  725.863351]        xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
> [  725.863368]        super_cache_scan+0x190/0x1e0
> [  725.863383]        do_shrink_slab+0x184/0x420
> [  725.863397]        shrink_slab+0x182/0x290
> [  725.863409]        shrink_node+0x174/0x680
> [  725.863927]        balance_pgdat+0x2d0/0x5f0
> [  725.864389]        kswapd+0x21f/0x510
> [  725.864836]        kthread+0x131/0x150
> [  725.865277]        ret_from_fork+0x3a/0x50
> [  725.865707]
>                other info that might help us debug this:
> 
> [  725.866953]  Possible unsafe locking scenario:
> 
> [  725.867764]        CPU0                    CPU1
> [  725.868161]        ----                    ----
> [  725.868531]   lock(fs_reclaim);
> [  725.868896]                                lock(&xfs_nondir_ilock_class);
> [  725.869276]                                lock(fs_reclaim);
> [  725.869633]   lock(&xfs_nondir_ilock_class);
> [  725.869996]
>                 *** DEADLOCK ***
> 
> [  725.871061] 4 locks held by kswapd0/159:
> [  725.871406]  #0: ffffffffbbb8bd00 (fs_reclaim){+.+.}-{0:0}, at:
> __fs_reclaim_acquire+0x5/0x30
> [  725.871779]  #1: ffffffffbbb7cef8 (shrinker_rwsem){++++}-{3:3}, at:
> shrink_slab+0x115/0x290
> [  725.872167]  #2: ffff9b39f07a50e8
> (&type->s_umount_key#56){++++}-{3:3}, at: super_cache_scan+0x38/0x1e0
> [  725.872560]  #3: ffff9b39f077f258
> (&pag->pag_ici_reclaim_lock){+.+.}-{3:3}, at:
> xfs_reclaim_inodes_ag+0x82/0x410 [xfs]
> [  725.873013]
>                stack backtrace:
> [  725.873811] CPU: 3 PID: 159 Comm: kswapd0 Not tainted
> 5.7.0-0.rc5.20200515git1ae7efb38854.1.fc33.x86_64 #1
> [  725.874249] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS ?-20180724_192412-buildhw-07.phx2.fedoraproject.org-1.fc29
> 04/01/2014
> [  725.875158] Call Trace:
> [  725.875625]  dump_stack+0x8b/0xc8
> [  725.876090]  check_noncircular+0x134/0x150
> [  725.876547]  __lock_acquire+0x1257/0x20d0
> [  725.877019]  lock_acquire+0xb0/0x310
> [  725.877517]  ? xfs_ilock+0xde/0x2c0 [xfs]
> [  725.877988]  down_write_nested+0x49/0x120
> [  725.878473]  ? xfs_ilock+0xde/0x2c0 [xfs]
> [  725.878955]  ? xfs_reclaim_inode+0x3f/0x400 [xfs]
> [  725.879448]  xfs_ilock+0xde/0x2c0 [xfs]
> [  725.879925]  xfs_reclaim_inode+0x3f/0x400 [xfs]
> [  725.880414]  xfs_reclaim_inodes_ag+0x20b/0x410 [xfs]
> [  725.880876]  ? sched_clock_cpu+0xc/0xb0
> [  725.881343]  ? mark_held_locks+0x2d/0x80
> [  725.881798]  ? _raw_spin_unlock_irqrestore+0x46/0x60
> [  725.882268]  ? lockdep_hardirqs_on+0x11e/0x1b0
> [  725.882734]  ? try_to_wake_up+0x249/0x820
> [  725.883234]  xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
> [  725.883700]  super_cache_scan+0x190/0x1e0
> [  725.884180]  do_shrink_slab+0x184/0x420
> [  725.884653]  shrink_slab+0x182/0x290
> [  725.885129]  shrink_node+0x174/0x680
> [  725.885596]  balance_pgdat+0x2d0/0x5f0
> [  725.886074]  kswapd+0x21f/0x510
> [  725.886540]  ? finish_wait+0x90/0x90
> [  725.887013]  ? balance_pgdat+0x5f0/0x5f0
> [  725.887477]  kthread+0x131/0x150
> [  725.887937]  ? __kthread_bind_mask+0x60/0x60
> [  725.888410]  ret_from_fork+0x3a/0x50
