Return-Path: <SRS0=nIBV=A7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75536C433E5
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jul 2020 16:46:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49A93206E9
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jul 2020 16:46:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vKD+R2Kh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729801AbgGTPk6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 11:40:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43954 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729792AbgGTPkw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jul 2020 11:40:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06KFYQS5100382;
        Mon, 20 Jul 2020 15:40:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=9AOYkY5vBY5rwY8KcpNfZyRPuwyIKO/Xf9p6BfszgcA=;
 b=vKD+R2Khsr7sBNaxysSfYFsSaT5VAwVC+h5n7qA4ib9Ej2ui/+05dGiA6w5619dEw61W
 a5aqb5ze/61F2AMrgPQnwT7YEFVxR3Ia6twTg9H+NleVW3zEVxQY23T98B9gG+HvwtP8
 WI9wGGgwiiON3GsY0jn66q/IdGjDQ0jph5doZgy30wvkR2GQAkjBWfywHzfU+hGnbYoT
 0jYXYOLICZGpRuhFO34/920RzsONJVMkSjB1HAYxrYz8V4Dl6PqmdYh/qnGJ8aIBoCgY
 nnByUkVs6oPHq3Im2JPNPpcqKa/Yq8zQjHBATpbeENcTGFqe+66LCl1DHZj+iKg7Uu7H sQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32bs1m7qgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 Jul 2020 15:40:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06KFYCPA171328;
        Mon, 20 Jul 2020 15:40:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32d8m09f9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jul 2020 15:40:47 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06KFej9n013486;
        Mon, 20 Jul 2020 15:40:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jul 2020 15:40:45 +0000
Date:   Mon, 20 Jul 2020 08:40:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Waiman Long <longman@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, Qian Cai <cai@lca.pw>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v6] xfs: Fix false positive lockdep warning with
 sb_internal & fs_reclaim
Message-ID: <20200720154043.GV7625@magnolia>
References: <20200707191629.13911-1-longman@redhat.com>
 <20200713164112.GZ7606@magnolia>
 <104087053.24407245.1595259123778.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <104087053.24407245.1595259123778.JavaMail.zimbra@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=56 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007200106
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=56 bulkscore=0
 adultscore=0 lowpriorityscore=0 mlxlogscore=999 malwarescore=0
 clxscore=1015 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007200106
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 20, 2020 at 11:32:03AM -0400, Waiman Long wrote:
> 
> 
> ----- Original Message -----
> From: "Darrick J. Wong" <darrick.wong@oracle.com>
> To: "Waiman Long" <longman@redhat.com>
> Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Dave Chinner" <david@fromorbit.com>, "Qian Cai" <cai@lca.pw>, "Eric Sandeen" <sandeen@redhat.com>
> Sent: Monday, July 13, 2020 12:41:12 PM
> Subject: Re: [PATCH v6] xfs: Fix false positive lockdep warning with sb_internal & fs_reclaim
> 
> On Tue, Jul 07, 2020 at 03:16:29PM -0400, Waiman Long wrote:
> > Depending on the workloads, the following circular locking dependency
> > warning between sb_internal (a percpu rwsem) and fs_reclaim (a pseudo
> > lock) may show up:
> > 
> > ======================================================
> > WARNING: possible circular locking dependency detected
> > 5.0.0-rc1+ #60 Tainted: G        W
> > ------------------------------------------------------
> > fsfreeze/4346 is trying to acquire lock:
> > 0000000026f1d784 (fs_reclaim){+.+.}, at:
> > fs_reclaim_acquire.part.19+0x5/0x30
> > 
> > but task is already holding lock:
> > 0000000072bfc54b (sb_internal){++++}, at: percpu_down_write+0xb4/0x650
> > 
> > which lock already depends on the new lock.
> >   :
> >  Possible unsafe locking scenario:
> > 
> >        CPU0                    CPU1
> >        ----                    ----
> >   lock(sb_internal);
> >                                lock(fs_reclaim);
> >                                lock(sb_internal);
> >   lock(fs_reclaim);
> > 
> >  *** DEADLOCK ***
> > 
> > 4 locks held by fsfreeze/4346:
> >  #0: 00000000b478ef56 (sb_writers#8){++++}, at: percpu_down_write+0xb4/0x650
> >  #1: 000000001ec487a9 (&type->s_umount_key#28){++++}, at: freeze_super+0xda/0x290
> >  #2: 000000003edbd5a0 (sb_pagefaults){++++}, at: percpu_down_write+0xb4/0x650
> >  #3: 0000000072bfc54b (sb_internal){++++}, at: percpu_down_write+0xb4/0x650
> > 
> > stack backtrace:
> > Call Trace:
> >  dump_stack+0xe0/0x19a
> >  print_circular_bug.isra.10.cold.34+0x2f4/0x435
> >  check_prev_add.constprop.19+0xca1/0x15f0
> >  validate_chain.isra.14+0x11af/0x3b50
> >  __lock_acquire+0x728/0x1200
> >  lock_acquire+0x269/0x5a0
> >  fs_reclaim_acquire.part.19+0x29/0x30
> >  fs_reclaim_acquire+0x19/0x20
> >  kmem_cache_alloc+0x3e/0x3f0
> >  kmem_zone_alloc+0x79/0x150
> >  xfs_trans_alloc+0xfa/0x9d0
> >  xfs_sync_sb+0x86/0x170
> >  xfs_log_sbcount+0x10f/0x140
> >  xfs_quiesce_attr+0x134/0x270
> >  xfs_fs_freeze+0x4a/0x70
> >  freeze_super+0x1af/0x290
> >  do_vfs_ioctl+0xedc/0x16c0
> >  ksys_ioctl+0x41/0x80
> >  __x64_sys_ioctl+0x73/0xa9
> >  do_syscall_64+0x18f/0xd23
> >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > 
> > This is a false positive as all the dirty pages are flushed out before
> > the filesystem can be frozen.
> > 
> > One way to avoid this splat is to add GFP_NOFS to the affected allocation
> > calls by using the memalloc_nofs_save()/memalloc_nofs_restore() pair.
> > This shouldn't matter unless the system is really running out of memory.
> > In that particular case, the filesystem freeze operation may fail while
> > it was succeeding previously.
> > 
> > Without this patch, the command sequence below will show that the lock
> > dependency chain sb_internal -> fs_reclaim exists.
> > 
> >  # fsfreeze -f /home
> >  # fsfreeze --unfreeze /home
> >  # grep -i fs_reclaim -C 3 /proc/lockdep_chains | grep -C 5 sb_internal
> > 
> > After applying the patch, such sb_internal -> fs_reclaim lock dependency
> > chain can no longer be found. Because of that, the locking dependency
> > warning will not be shown.
> > 
> > Suggested-by: Dave Chinner <david@fromorbit.com>
> > Signed-off-by: Waiman Long <longman@redhat.com>
> 
> Looks good to me,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Will this patch be merged into the xfs tree soon?

It should appear in for-next in the next day or so.  I am trying to push
there only every other couple of weeks to reduce the amount of developer
tree rebasing that has to go on when people are trying to land a complex
series.

--D

> Thanks,
> Longman
> 
