Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34646 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750823AbeAPRbY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 12:31:24 -0500
Date: Tue, 16 Jan 2018 09:30:45 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: _xfs_buf_find: Block out of range, then umount hung
Message-ID: <20180116173045.GP5602@magnolia>
References: <20180113145228.GA16780@onthe.net.au>
 <20180115120258.GA44369@bfoster.bfoster>
 <20180116013536.GA10406@onthe.net.au>
 <20180116131255.GC52295@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180116131255.GC52295@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Chris Dunlop <chris@onthe.net.au>, linux-xfs@vger.kernel.org

On Tue, Jan 16, 2018 at 08:12:56AM -0500, Brian Foster wrote:
> On Tue, Jan 16, 2018 at 12:35:36PM +1100, Chris Dunlop wrote:
> > On Mon, Jan 15, 2018 at 07:02:58AM -0500, Brian Foster wrote:
> > > On Sun, Jan 14, 2018 at 01:52:28AM +1100, Chris Dunlop wrote:
> > > > Hi,
> > > > 
> > > > tl;dr: a filesystem corruption (cause unknown) has produced an unkillable
> > > > umount. Is the only recourse to reboot?
> > > 
> > > From this particular state, probably.
> > 
> > Yeah, I figured that and rebooted.
> > 
> > > So for one reason or another, you end up trying to remove a bogus block
> > > number from the AGFL (perhaps the old agfl size issue?).
> > 
> > This stuff?
> > 
> > https://www.spinics.net/lists/xfs/msg42213.html
> > 
> > FYI the filesystem was created on linux-3.18.25 and the error appeared
> > shortly after moving to linux-4.9.76.
> > 
> 
> Yeah, though I guess that was more of a v5 superblock thing which
> probably isn't relevant if the filesystem was from v3.18. Somebody else
> may be able to chime in on that.

For a v5 filesystem (crc=1, as told by xfs_info), 3.18 is very relevant
because the AGFL size fixes went in 4.5.

For a v4 filesystem it makes no difference since it is unaffected.

One thing I'm mising from this thread is whether or not this is a v5
fs?  Can you post xfs_info output?

> > > > Jan 13 19:57:31 b2 kernel: ================================================
> > > > Jan 13 19:57:31 b2 kernel: [ BUG: lock held when returning to user space! ]
> > > > Jan 13 19:57:31 b2 kernel: 4.9.76-otn-00021-g2af03421 #1 Tainted: G        W
> > > > Jan 13 19:57:31 b2 kernel: ------------------------------------------------
> > > > Jan 13 19:57:31 b2 kernel: tp_fstore_op/31412 is leaving the kernel with locks still held!
> > > > Jan 13 19:57:31 b2 kernel: 1 lock held by tp_fstore_op/31412:
> > > > Jan 13 19:57:31 b2 kernel:  #0:  (sb_internal){......}, at: [<ffffffffa07692a3>] xfs_trans_alloc+0xe3/0x130 [xfs]
> > > 
> > > Though it looks like we return to userspace in transaction context..?
> > > This is the same pid as above and the current code looks like the
> > > transaction should be cancelled in xfs_attr_set(). We're somewhere down
> > > in xfs_attr_leaf_addname(), however. From there, both calls to
> > > xfs_defer_finish() jump to out_defer_cancel on failure, which sets
> > > args->trans = NULL before we return. Hmm, that looks like a bug to me.
> > > 
> > > Are you able to reproduce this particular hung unmount behavior? If so,
> > > does anything change with something like the appended hunk? Note that
> > > you may have to backport that to v4.9-<whatever> since it appears that
> > > is before out_defer_cancel was created.
> > 
> > Sorry, wasn't able to reproduce: once it was up again mount didn't succeed:
> > 
> > # mount /dev/sdp1 /var/lib/ceph/osd/ceph-60
> > mount: mount /dev/sdp1 on /var/lib/ceph/osd/ceph-60 failed: Structure needs cleaning
> > # mount -f /dev/sdp1 /var/lib/ceph/osd/ceph-60
> > # umount /var/lib/ceph/osd/ceph-60
> > umount: /var/lib/ceph/osd/ceph-60: not mounted
> > 
> > I tried an 'xfs_repair -L' which found some stuff, but I don't know if the
> > "stuff" was due to the log being lost or part of the original problem:
> > 
> 
> xfs_repair output is usually noisy (and not very useful) when a dirty
> log is zapped. Did you retain a copy of the mount failure error from the
> log?
> 
> Anyways, I injected an error at one of the xfs_defer_finish() calls in
> xfs_attr_leaf_addname() and hit the unmount problem:
> 
> [  269.007928] ================================================
> [  269.008798] WARNING: lock held when returning to user space!
> [  269.009615] 4.15.0-rc7+ #94 Tainted: G           O    
> [  269.010327] ------------------------------------------------
> [  269.011525] setfattr/1213 is leaving the kernel with locks still held!
> [  269.012275] 1 lock held by setfattr/1213:
> [  269.012704]  #0:  (sb_internal#2){.+.+}, at: [<00000000f32b9a4b>] xfs_trans_alloc+0xe0/0x120 [xfs]
> 
> ... so we should be able to fix that, at least.
> 
> > # xfs_repair -L -vv /dev/sdp1
> > Phase 1 - find and verify superblock...
> >        - max_mem = 148590945, icount = 203072, imem = 793, dblock = 233112145, dmem = 113824
> >        - block cache size set to 18553288 entries
> > Phase 2 - using internal log
> >        - zero log...
> > zero_log: head block 554618 tail block 553989
> > ALERT: The filesystem has valuable metadata changes in a log which is being
> > destroyed because the -L option was used.
> >        - scan filesystem freespace and inode maps...
> > bad agbno 4294967295 in agfl, agno 2
> > freeblk count 8 != flcount 7 in ag 2
> > bad agbno 4294967295 in agfl, agno 1
> > freeblk count 7 != flcount 6 in ag 1
> > sb_ifree 42557, counted 42256
> > sb_fdblocks 82529171, counted 82532805
> > ...
> > 
> > The rest of the output didn't look particularly interesting to my untrained
> > eye, but the full output is available at: https://pastebin.com/KD7BKTLu
> > 
> > The mount succeeded after this.
> > 
> > In the end, as I wasn't sure of the status of the data and it was replicated
> > elsewhere anyway, I blew away the filesystem and started again.

Drat, I was about to say "send us a metadump and we can confirm/test
it"...

...he says, nearly ready to post his "fix all the v5 agfl problems once and
for all" series.

--D

> > 
> 
> Backups! :)
> 
> Brian
> 
> > Thanks for your time!
> > 
> > Chris
> > 
> > 
> > > 
> > > Brian
> > > 
> > > ---8<---
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > index a76914db72ef..e86c51d39e66 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > @@ -717,7 +717,6 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
> > > 	return error;
> > > out_defer_cancel:
> > > 	xfs_defer_cancel(args->dfops);
> > > -	args->trans = NULL;
> > > 	return error;
> > > }
> > > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
