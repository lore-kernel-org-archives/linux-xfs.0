Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41194 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753916AbdC1Dlk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Mar 2017 23:41:40 -0400
Date: Tue, 28 Mar 2017 11:41:30 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfsdump: fix race condition between lseek() and
 read()/write()
Message-ID: <20170328034130.GT14226@eguan.usersys.redhat.com>
References: <1461244016-7373-1-git-send-email-eguan@redhat.com>
 <20170327202030.GK5722@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170327202030.GK5722@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Mon, Mar 27, 2017 at 01:20:30PM -0700, Darrick J. Wong wrote:
> [move to new list]
> 
> On Thu, Apr 21, 2016 at 09:06:56PM +0800, Eryu Guan wrote:
> > There's a race condition in the [get|put]_invtrecord() routines, because
> > a lseek() followed by a read()/write() is not atmoic, the file offset
> > might be changed before read()/write().
> > 
> > xfs/302 catches this failure as:
> > xfsdump: drive 1: INV : Unknown version 0 - Expected version 1
> > xfsdump: inv_core.c:66: get_counters: Assertion `((invt_counter_t *)(*cntpp))->ic_vernum == (inv_version_t) 1' failed.
> > 
> > And it can be reproduced by running multi-stream dump in a tight loop
> >   mount /dev/<dev> /mnt/xfs
> >   mkdir /mnt/xfs/dumpdir
> >   # populate dumpdir here
> >   while xfsdump -M l1 -M l2 -f d1 -f d2 -L ses /mnt/xfs -s dumpdir; do
> >   	:
> >   done
> > 
> > Fix it by replacing the "lseek(); read()/write()" sequence by
> > pread()/pwrite(), which make the seek and I/O an atomic operation.
> > 
> > Also convert and remove all *_SEEKCUR routines to "SEEK_SET" variants,
> > because they depend on the maintenance of current file offset, but
> > pread()/pwrite() don't change file offset.
> > 
> > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > ---
> > 
> > Tested via the reproducer and xfstests "-g dump" run, with both v4 and v5 XFS.
> > 
> > I'm not sure if this is the right fix, perhaps what should be fixed is the
> > "INVLOCK()", which is now implemented by flock(2), and doesn't work in
> > multi-thread env, if what it's meant to protect is concurrent accesses from
> > different threads, not processes.
> > 
> > If so, it seems to me that making INVLOCK() a pthread rw lock could fix the
> > race condition as well. But the INVLOCK calls are almost everywhere, I didn't
> > find a simple way to try it.
> 
> I wonder, did this ever make any progress?  Offhand it looks ok, but then
> I'm no xfsdump expert.

No, you're the first one to comment on this patch :)

> 
> (Yes, our QA is bugging me about xfs/302 failures too...)

JFYI, xfs/059 and xfs/301 also fail due to this bug, just that xfs/059
failure rarely happens.

Thanks,
Eryu
