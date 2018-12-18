Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:41972 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726305AbeLREgb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Dec 2018 23:36:31 -0500
Date: Tue, 18 Dec 2018 15:36:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: 3-way deadlock with xfs_dquot, xfs_buf and xfs_inode
Message-ID: <20181218043626.GA31274@dastard>
References: <CAJDdQW1bUSZ+3p-4XMbtzU0y5SifQnnwmStKGhb5dkozCaExoA@mail.gmail.com>
 <20181217233343.GE10644@dastard>
 <CAJDdQW2U5hE2W245iodcOF408DV8W1D1-MSRtSMvY8=TT9rnCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJDdQW2U5hE2W245iodcOF408DV8W1D1-MSRtSMvY8=TT9rnCg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?utf-8?B?5byg5pys6b6Z?= <zbl.lkml@gmail.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Tue, Dec 18, 2018 at 10:41:48AM +0800, 张本龙 wrote:
> Dave Chinner <david@fromorbit.com> 于2018年12月18日周二 上午7:33写道：
> >
> > On Sat, Dec 15, 2018 at 01:34:33PM +0800, 张本龙 wrote:
> > > Hi Developpers and XFS,
> > >
> > > There seems to be a deadlock involving 3 threads: 1) the fsync thread
> > > has acquired the project quota lock, and is trying to get the xfs_buf
> > > (it's a an agf); 2) the xfs_buf is attached to a transaction, and
> > > xfs_end_io is trying to get the xfs_inode ilock; 3) the write thread
> > > has acquired the xfs_inode ilock, and tries to get the xfs_dquot.
> > > Below are the traces.
> >
> > I don't see a deadlock here. What's holding the AGF lock and
> > preventing progress from being made?
> >
> 
> Oh, I was thinking the AGF is attached to a transaction.

it may be, but it has to be locked to be joined to a transaction.

> So between
> xfs_trans_bjoin() and xfs_trans_commit(), a buf cannot be used by
> others right? Then it should be released by xfs_end_io() in
> xfs_trans_commit(),

No, because that transaction doesn't hold the AGF.

> and the deadlock is like:
> 
> Thread          1                  2
>          3
>                    fsync()
>                    dqlock P
>                    agf lock
>                    <blocks>
>                                   xfs_end_io
>                                   (agf locked by transaction)
>                                   ilock A
>                                   <blocks>
>                                   unlock agf in trans commit
				^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				This is wrong.

There is no AGF held in the ioend transaction in progress.
xfs_setfilesize() only needs to lock the inode as that is all it
modifies. It's also compeltely independent of the transaction being
run in the fsync context unless they have ot modify the same
metadata (which they don't).

Use 'echo w > /proc/sysrq-trigger' to list all the blocked
processes. Maybe one of them is holding the AGF locked and is
waiting on something else...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
