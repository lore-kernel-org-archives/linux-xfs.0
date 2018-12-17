Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:12710 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726255AbeLQXdq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Dec 2018 18:33:46 -0500
Date: Tue, 18 Dec 2018 10:33:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: 3-way deadlock with xfs_dquot, xfs_buf and xfs_inode
Message-ID: <20181217233343.GE10644@dastard>
References: <CAJDdQW1bUSZ+3p-4XMbtzU0y5SifQnnwmStKGhb5dkozCaExoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJDdQW1bUSZ+3p-4XMbtzU0y5SifQnnwmStKGhb5dkozCaExoA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?utf-8?B?5byg5pys6b6Z?= <zbl.lkml@gmail.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Sat, Dec 15, 2018 at 01:34:33PM +0800, 张本龙 wrote:
> Hi Developpers and XFS,
> 
> There seems to be a deadlock involving 3 threads: 1) the fsync thread
> has acquired the project quota lock, and is trying to get the xfs_buf
> (it's a an agf); 2) the xfs_buf is attached to a transaction, and
> xfs_end_io is trying to get the xfs_inode ilock; 3) the write thread
> has acquired the xfs_inode ilock, and tries to get the xfs_dquot.
> Below are the traces.

I don't see a deadlock here. What's holding the AGF lock and
preventing progress from being made?

i.e. we have:

process 	1		2		3
	fsync()
	  ilock A
	  dqlock P
	    agf lock
	    <blocks>
				xfs_end_io
				  ilock A
				  <blocks>
						write()
						  ilock B
						  dqlock P
						  <blocks>

So, basically, everyhting is waiting for the AGF lock, which
is held by something other than these three threads. When the AGF
lock is relesaed, the fsync() will make progress, then release
both dqlock P and ilock A and the other two threads will make
progress again.

> It's 3.10.0-514.16.1.el7.x86_64 kernel, met about 10-20 times a week
> on several hundred of servers.

That's not a mainline kernel and so we can't really help diagnose
this much further. You should really report it to your distro
support channels so they can help you with further diagnosis and
fixes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
