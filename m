Return-Path: <SRS0=76Wm=2X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7221C2D0C2
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jan 2020 18:24:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4F802072C
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jan 2020 18:24:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WzQx+WzX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgABSYo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jan 2020 13:24:44 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58868 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727942AbgABSYo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jan 2020 13:24:44 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 002IE6iC111189;
        Thu, 2 Jan 2020 18:24:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=aSzW+yBh6hx4kcvli6wHD4xu/pdAwED9MU3I0fOIhRs=;
 b=WzQx+WzXPrviD27u++Is9TV1BWdFzy8JNwDbii535sKgsW5jpUylOT4goiQICR6B9Y+D
 GnDV3JwYwpMAfaKKKWo3I4SRUZSfD0KLTumjuXyKFQnDxoMb/lteDN6G25gcuf3T4l5/
 bKq4cGleXBfiPhFeBLDDXHlvve9qkSmn8+uJGyQ9WjwOi6STZQAOIS9QNTXs9yG+JxRD
 gYIqrH1GEOgoDWvjDuj4yTrtj6p0F4EJZ/F6XRl33Klscn7sv6F3XxmqvBEDOcHqtWPa
 erNSfpOqI+tE8FMxrVq/HLCYgyqi8RxsXs6NZtK61O9I7mnklE0WrcYsA1SElnH/Sm70 cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2x5y0prr97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jan 2020 18:24:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 002IDxDj005829;
        Thu, 2 Jan 2020 18:24:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2x8guscq6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jan 2020 18:24:37 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 002IOaON027028;
        Thu, 2 Jan 2020 18:24:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jan 2020 10:24:36 -0800
Date:   Thu, 2 Jan 2020 10:24:35 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Qian Cai <cai@lca.pw>
Cc:     Waiman Long <longman@redhat.com>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfs: Fix false positive lockdep warning with sb_internal
 & fs_reclaim
Message-ID: <20200102182435.GB1508633@magnolia>
References: <20200102155208.8977-1-longman@redhat.com>
 <24F33D67-E975-48E1-A285-0D0129CC3033@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24F33D67-E975-48E1-A285-0D0129CC3033@lca.pw>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=27 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001020152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=27 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001020152
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 02, 2020 at 11:19:51AM -0500, Qian Cai wrote:
> 
> 
> > On Jan 2, 2020, at 10:52 AM, Waiman Long <longman@redhat.com> wrote:
> > 
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
> >  :
> > Possible unsafe locking scenario:
> > 
> >       CPU0                    CPU1
> >       ----                    ----
> >  lock(sb_internal);
> >                               lock(fs_reclaim);
> >                               lock(sb_internal);
> >  lock(fs_reclaim);
> > 
> > *** DEADLOCK ***
> > 
> > 4 locks held by fsfreeze/4346:
> > #0: 00000000b478ef56 (sb_writers#8){++++}, at: percpu_down_write+0xb4/0x650
> > #1: 000000001ec487a9 (&type->s_umount_key#28){++++}, at: freeze_super+0xda/0x290
> > #2: 000000003edbd5a0 (sb_pagefaults){++++}, at: percpu_down_write+0xb4/0x650
> > #3: 0000000072bfc54b (sb_internal){++++}, at: percpu_down_write+0xb4/0x650
> > 
> > stack backtrace:
> > Call Trace:
> > dump_stack+0xe0/0x19a
> > print_circular_bug.isra.10.cold.34+0x2f4/0x435
> > check_prev_add.constprop.19+0xca1/0x15f0
> > validate_chain.isra.14+0x11af/0x3b50
> > __lock_acquire+0x728/0x1200
> > lock_acquire+0x269/0x5a0
> > fs_reclaim_acquire.part.19+0x29/0x30
> > fs_reclaim_acquire+0x19/0x20
> > kmem_cache_alloc+0x3e/0x3f0
> > kmem_zone_alloc+0x79/0x150
> > xfs_trans_alloc+0xfa/0x9d0
> > xfs_sync_sb+0x86/0x170
> > xfs_log_sbcount+0x10f/0x140
> > xfs_quiesce_attr+0x134/0x270
> > xfs_fs_freeze+0x4a/0x70
> > freeze_super+0x1af/0x290
> > do_vfs_ioctl+0xedc/0x16c0
> > ksys_ioctl+0x41/0x80
> > __x64_sys_ioctl+0x73/0xa9
> > do_syscall_64+0x18f/0xd23
> > entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > 
> > According to Dave Chinner:
> > 
> >  Freezing the filesystem, after all the data has been cleaned. IOWs
> >  memory reclaim will never run the above writeback path when
> >  the freeze process is trying to allocate a transaction here because
> >  there are no dirty data pages in the filesystem at this point.
> > 
> >  Indeed, this xfs_sync_sb() path sets XFS_TRANS_NO_WRITECOUNT so that
> >  it /doesn't deadlock/ by taking freeze references for the
> >  transaction. We've just drained all the transactions
> >  in progress and written back all the dirty metadata, too, and so the
> >  filesystem is completely clean and only needs the superblock to be
> >  updated to complete the freeze process. And to do that, it does not
> >  take a freeze reference because calling sb_start_intwrite() here
> >  would deadlock.
> > 
> >  IOWs, this is a false positive, caused by the fact that
> >  xfs_trans_alloc() is called from both above and below memory reclaim
> >  as well as within /every level/ of freeze processing. Lockdep is
> >  unable to describe the staged flush logic in the freeze process that
> >  prevents deadlocks from occurring, and hence we will pretty much
> >  always see false positives in the freeze path....
> > 
> > Perhaps breaking the fs_reclaim pseudo lock into a per filesystem lock
> > may fix the issue. However, that will greatly complicate the logic and
> > may not be worth it.
> > 
> > Another way to fix it is to disable the taking of the fs_reclaim
> > pseudo lock when in the freezing code path as a reclaim on the freezed
> > filesystem is not possible as stated above. This patch takes this
> > approach by setting the __GFP_NOLOCKDEP flag in the slab memory
> > allocation calls when the filesystem has been freezed.
> > 
> > Without this patch, the command sequence below will show that the lock
> > dependency chain sb_internal -> fs_reclaim exists.
> > 
> > # fsfreeze -f /home
> > # fsfreeze --unfreeze /home
> > # grep -i fs_reclaim -C 3 /proc/lockdep_chains | grep -C 5 sb_internal
> > 
> > After applying the patch, such sb_internal -> fs_reclaim lock dependency
> > chain can no longer be found. Because of that, the locking dependency
> > warning will not be shown.
> 
> There was an attempt to fix this in the past, but Dave rejected right
> away for any workaround in xfs and insisted to make lockdep smarter
> instead. No sure your approach will make any difference this time.
> Good luck.

/me wonders if you can fix this by having the freeze path call
memalloc_nofs_save() since we probably don't want to be recursing into
the fs for reclaim while freezing it?  Probably not, because that's a
bigger hammer than we really need here.  We can certainly steal memory
from other filesystems that aren't frozen.

It doesn't solve the key issue that lockdep isn't smart enough to know
that we can't recurse into the fs that's being frozen and therefore
there's no chance of deadlock.

--D
