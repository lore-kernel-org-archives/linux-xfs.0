Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3B9267CB6
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 09:31:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 944FAAC005
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 07:31:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FC6iOMKXSfh3U1Ta (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Apr 2016 07:31:37 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 0D5A5BB17
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 14:31:36 +0000 (UTC)
Received: from redhat.com (unused [10.10.50.39] (may be forged))
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u38EVVjF013297
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Fri, 8 Apr 2016 10:31:34 -0400
Date: Fri, 8 Apr 2016 16:31:31 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: XFS hung task in xfs_ail_push_all_sync() when unmounting FS
	after disk failure/recovery
Message-ID: <20160408143131.GA24175@redhat.com>
References: <f049419a2ab10f8e3c4fef0e4f4ca1ba@mail.gmail.com>
	<20160322121922.GA53693@bfoster.bfoster>
	<232dd85fde11d4ef1625f070eabfd167@mail.gmail.com>
	<20160408131658.GB30614@bfoster.bfoster>
	<98e40e83fabf331b114fd6f41084d282@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <98e40e83fabf331b114fd6f41084d282@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi Shyam,

do you mind to share your systemtap script with us?

I'd like to take a look on it, and probably Brian will be interested to.


On Fri, Apr 08, 2016 at 07:05:24PM +0530, Shyam Kaushik wrote:
> Hi Brian,
> 
> Yes the below report is a bit different than the original report. I wanted
> to confirm if the new patches from Dave will see these odd
> crashes/hung-task.
> 
> I applied Dave's patch & managed to recreate the original issue. With
> systemtap I do see that FS has been marked for shutdown (xfs_aildpush() -
> mp:0xffff880062d09800 m_flags:4325656), but still the infinite tries keep
> happening with xfsaild_push() seeing XFS_IFLOCK on the inode. Pls note
> that this issue happens only when I see
> 
> XFS (dm-10): Detected failing async write on buffer block 0x368d76a0.
> Retrying async write.
> 
> in the logs. In all other cases, this problem doesn't happen. So there is
> something with this async-write retries that is leaving the state of the
> inode with IFLOCK that rest of aildpush is not able to handle.
> 
> --Shyam
> 
> -----Original Message-----
> From: Brian Foster [mailto:bfoster@redhat.com]
> Sent: 08 April 2016 18:47
> To: Shyam Kaushik
> Cc: david@fromorbit.com; xfs@oss.sgi.com; Alex Lyakas
> Subject: Re: XFS hung task in xfs_ail_push_all_sync() when unmounting FS
> after disk failure/recovery
> 
> On Fri, Apr 08, 2016 at 04:21:02PM +0530, Shyam Kaushik wrote:
> > Hi Dave, Brian, Carlos,
> >
> > While trying to reproduce this issue I have been running into different
> > issues that are similar. Underlying issue remains the same when backend
> to
> > XFS is failed & we unmount XFS, we run into hung-task timeout (180-secs)
> > with stack like
> >
> > kernel: [14952.671131]  [<ffffffffc06a5f59>]
> > xfs_ail_push_all_sync+0xa9/0xe0 [xfs]
> > kernel: [14952.671139]  [<ffffffff810b26b0>] ?
> > prepare_to_wait_event+0x110/0x110
> > kernel: [14952.671181]  [<ffffffffc0690111>] xfs_unmountfs+0x61/0x1a0
> > [xfs]
> >
> > while running trace-events, XFS ail push keeps looping around
> >
> >    xfsaild/dm-10-21143 [001] ...2 17878.555133: xfs_ilock_nowait: dev
> > 253:10 ino 0x0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-21143 [001] ...2 17878.555138: xfs_iunlock: dev 253:10
> > ino 0x0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-21143 [001] ...2 17878.555138: xfs_ail_push: dev 253:10
> > lip 0xffff880031f6ae40 lsn 1/73448 type XFS_LI_INODE flags IN_AIL
> >    xfsaild/dm-10-21143 [001] ...2 17878.605136: xfs_ilock_nowait: dev
> > 253:10 ino 0x0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-21143 [001] ...2 17878.605141: xfs_iunlock: dev 253:10
> > ino 0x0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-21143 [001] ...2 17878.605142: xfs_ail_push: dev 253:10
> > lip 0xffff880031f6ae40 lsn 1/73448 type XFS_LI_INODE flags IN_AIL
> >
> > observe ino==0x0 (its a freed inode) but the corresponding lip stays
> with
> > xfsaild push. I had run a systemtap when this problem happened & the
> > following keeps repeating.
> >
> 
> That's interesting, and looks different from the original report in
> terms of the inode number being cleared. The original report looks like
> it has a valid inode and there's some problematic sequence where it's
> not being removed from the AIL in the event of errors.
> 
> I think at this point we know that XFS attempts to retry these I/Os
> indefinitely. Dave has outstanding patches to deal with this issue. The
> question Dave raised above was whether the filesystem shut down, and if
> not, why (as a failed log I/O should cause a shutdown)? Carlos was
> looking into this it appears...
> 
> > xfs_inode_item_push() - inode:0xffff88003d8ca000 m_flags:0x420118
> > flags:0x1
> > xfs_iflush() - inode:ffff88003d8ca000 aborting for forced shutdown
> > xfs_iflush_abort() - iip:0x0
> >
> > xfs_inode_item_push() is doing xfs_iflush() but it sees FS_SHUTDOWN flag
> > marked & does an xfs_iflush_abort().xfs_iflush_abort() sees
> i_itemp==NULL
> > on the lip & doesn't do anything. So we have this stale lip that is not
> > associated to inode anymore that keeps xfs_ail_push_all_sync() busy.
> >
> > On few other occurrences, i have had NULL pointer/dereference or other
> > sorts of crashes at this line
> >
> > 	xfsaild_push()
> > 		lock_result = lip->li_ops->iop_push(lip,
> > &ailp->xa_buf_list);
> >
> > with debug prints, in one of the occurrence lip->li_ops was NULL & in
> > another lip->li_ops was pointing to a bad pointer that subsequent
> > dereference crashed it. This also indicates that a bad/freed lip was
> > inserted that xfsaild_push() is working.
> >
> > I hit upon Dave's patch "xfs: xfs_inode_free() isn't RCU safe" &
> realized
> > that this could explain the above issue where a lip that has been freed
> is
> > wrongly referenced & later we could even have the inode disconnected.
> What
> > do you think?
> >
> > In any case I uploaded the full xfs trace events before this issue
> started
> > & till the end. It is at
> > https://www.dropbox.com/s/21qstz4ld1gn8yi/xfs_trace_pipe.gz?dl=0
> >
> 
> It seems like it could be related. I didn't catch anything obvious from
> the trace, but there's a lot of data there. The RCU-unsafe issue was
> difficult to track down without instrumentation.. I'm not sure that will
> be evident from the trace. The best thing to do wrt to that might be to
> try with Dave's patches, as that so far appears to address the problem.
> (In fact, it might be worth it to try Dave's shutdown on umount patch
> he referred to up-thread to address the original problem as well).
> 
> Brian
> 
> > Pls let me know. Thanks.
> >
> > --Shyam
> >
> > -----Original Message-----
> > From: Shyam Kaushik [mailto:shyam@zadarastorage.com]
> > Sent: 23 March 2016 15:23
> > To: 'Brian Foster'
> > Cc: 'xfs@oss.sgi.com'; Alex Lyakas
> > Subject: RE: XFS hung task in xfs_ail_push_all_sync() when unmounting FS
> > after disk failure/recovery
> >
> > Hi Carlos,
> >
> > w.r.t. your question below
> >
> > >>> Shyam, after you reconnected the disks, the messages about failed
> > async metadata
> > >>> writes stops to be logged?
> >
> > After I reconnect the disks, messages about failed async metadata writes
> > stops to be logged. But the key thing is messages like
> >
> > XFS (dm-29): xfs_log_force: error -5 returned
> >
> > Keeps repeating every 30-secs which indicates that there is some buf/io
> > error status that is being carried forward.
> >
> > >>> Any chance you can reliably reproduce it?
> >
> > Yes I have a way to reproduce it, but its not reliable. What I do is
> setup
> > a dm-linear over a disk. Create XFS, mount & trigger few copy threads to
> > copy varying sized files into the FS. At this point pull out the drive
> > (with scsi-remove-single-device in /proc/scsi/scsi) & in a short-while
> > convert the dm-linear to dm-ioerror. Then I bring back the underlying
> > drive, convert back dm-ioerror to dm-linear & try to unmount XFS.
> >
> > This problem somehow happens on a newly created XFS. If I copy several
> > files into XFS/delete them & then copy them again, repeat the drive
> > failure/recovery experiment it doesn't reproduce.
> >
> > Thanks.
> >
> > --Shyam
> >
> > Subject: Re: XFS hung task in xfs_ail_push_all_sync() when unmounting FS
> > after disk failure/recovery
> > From: Carlos Maiolino <cmaiolino@xxxxxxxxxx>
> > Date: Tue, 22 Mar 2016 16:38:25 +0100
> > In-reply-to: <20160322140345.GA54245@bfoster.bfoster>
> > Mail-followup-to: xfs@xxxxxxxxxxx
> > User-agent: Mutt/1.5.24 (2015-08-30)
> >
> > Hi Brian,
> >
> > These traces, and the stack trace presented, looks quite similar with
> the
> > one we were discussing a few days ago, using a dm-thin snapshot.
> >
> > Looks like with the same bug I've been hunting and Shyam confirmed my
> > hypothesis
> > of this bug be able to be reproduced with a regular device.
> >
> > If it's the same bug, yes, I reproduced it using upstream kernel.
> >
> > The difference between both (this bug and the one I've been working on)
> is
> > how
> > xfs actually behaves when async metadata writes fail. Other than that,
> it
> > pretty
> > much looks the same.
> >
> > Trying to unmount the filesystem hungs in xfs_log_force(), well,
> basically
> > the
> > reason I submitted the patch to include the caller into xfs_log_force
> > trace. I'd
> > like to see ftrace traces from this system with that patch if possible.
> >
> > I didn't have time to keep working on this for the past few days, but
> > looks like
> > it's time to come back to it.
> >
> > Shyam, after you reconnected the disks, the messages about failed async
> > metadata
> > writes stops to be logged?
> >
> > Any chance you can reliably reproduce it?
> >
> > I'm not a xfs journal expert, but it looks like the writeback of items
> in
> > AIL
> > got stuck due the IO errors, and were never completed, but I don't know
> > what I
> > should expect after the disk is reconnected.
> >
> > In my case though, with upstream kernel, I didn't get a XFS_SHUTDOWN
> until
> > I
> > tried to unmount the filesystem, which differs from this case, where xfs
> > looks
> > to have shutdown the filesystem after a few tries to writeback the
> > metadata.
> >
> > Anyway, I can dig more into it this week, if nobody knows what is going
> on
> > before I do it :)
> >
> > -----Original Message-----
> > From: Shyam Kaushik [mailto:shyam@zadarastorage.com]
> > Sent: 22 March 2016 18:32
> > To: 'Brian Foster'
> > Cc: 'xfs@oss.sgi.com'; Alex Lyakas
> > Subject: RE: XFS hung task in xfs_ail_push_all_sync() when unmounting FS
> > after disk failure/recovery
> >
> > Hi Brian,
> >
> > Thanks for your quick reply. I repeated the test & trace-pipe is
> > constantly filled with this:
> >
> >    xfsaild/dm-10-3335  [003] ...2 24890.546491: xfs_ilock_nowait: dev
> > 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.546492: xfs_iunlock: dev 253:10
> > ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.546493: xfs_ail_flushing: dev
> > 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
> >    xfsaild/dm-10-3335  [003] ...2 24890.596491: xfs_ilock_nowait: dev
> > 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.596492: xfs_iunlock: dev 253:10
> > ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.596494: xfs_ail_flushing: dev
> > 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
> >    xfsaild/dm-10-3335  [003] ...2 24890.646497: xfs_ilock_nowait: dev
> > 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.646498: xfs_iunlock: dev 253:10
> > ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.646500: xfs_ail_flushing: dev
> > 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
> >    xfsaild/dm-10-3335  [003] ...2 24890.696467: xfs_ilock_nowait: dev
> > 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.696468: xfs_iunlock: dev 253:10
> > ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.696468: xfs_ail_flushing: dev
> > 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
> >    xfsaild/dm-10-3335  [003] ...2 24890.746548: xfs_ilock_nowait: dev
> > 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.746550: xfs_iunlock: dev 253:10
> > ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.746550: xfs_ail_flushing: dev
> > 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
> >    xfsaild/dm-10-3335  [003] ...2 24890.796479: xfs_ilock_nowait: dev
> > 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.796480: xfs_iunlock: dev 253:10
> > ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.796480: xfs_ail_flushing: dev
> > 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
> >    xfsaild/dm-10-3335  [003] ...2 24890.846467: xfs_ilock_nowait: dev
> > 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 24890.846468: xfs_iunlock: dev 253:10
> > ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >
> >
> > while regular activity seems to happen on other inodes/kworker threads
> >
> >     kworker/u8:4-27691 [001] ...1 24895.811474: xfs_writepage: dev
> 253:10
> > ino 0x1801061 pgoff 0x29000 size 0x1aebbc offset 0 length 0 delalloc 1
> > unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.811477: xfs_invalidatepage: dev
> > 253:10 ino 0x1801061 pgoff 0x29000 size 0x1aebbc offset 0 length 1000
> > delalloc 1 unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.811478: xfs_releasepage: dev
> > 253:10 ino 0x1801061 pgoff 0x29000 size 0x1aebbc offset 0 length 0
> > delalloc 0 unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.811482: xfs_writepage: dev
> 253:10
> > ino 0x4017bdf pgoff 0x29000 size 0x1aebbc offset 0 length 0 delalloc 1
> > unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.811482: xfs_invalidatepage: dev
> > 253:10 ino 0x4017bdf pgoff 0x29000 size 0x1aebbc offset 0 length 1000
> > delalloc 1 unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.811483: xfs_releasepage: dev
> > 253:10 ino 0x4017bdf pgoff 0x29000 size 0x1aebbc offset 0 length 0
> > delalloc 0 unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.811485: xfs_writepage: dev
> 253:10
> > ino 0x68048c3 pgoff 0x29000 size 0x1aebbc offset 0 length 0 delalloc 1
> > unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.811486: xfs_invalidatepage: dev
> > 253:10 ino 0x68048c3 pgoff 0x29000 size 0x1aebbc offset 0 length 1000
> > delalloc 1 unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.811486: xfs_releasepage: dev
> > 253:10 ino 0x68048c3 pgoff 0x29000 size 0x1aebbc offset 0 length 0
> > delalloc 0 unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.812381: xfs_writepage: dev
> 253:10
> > ino 0x1805e37 pgoff 0x29000 size 0x68470 offset 0 length 0 delalloc 1
> > unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.812382: xfs_invalidatepage: dev
> > 253:10 ino 0x1805e37 pgoff 0x29000 size 0x68470 offset 0 length 1000
> > delalloc 1 unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.812382: xfs_releasepage: dev
> > 253:10 ino 0x1805e37 pgoff 0x29000 size 0x68470 offset 0 length 0
> delalloc
> > 0 unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.812385: xfs_writepage: dev
> 253:10
> > ino 0x4019c95 pgoff 0x29000 size 0x68470 offset 0 length 0 delalloc 1
> > unwritten 0
> >     kworker/u8:4-27691 [001] ...1 24895.812385: xfs_invalidatepage: dev
> > 253:10 ino 0x4019c95 pgoff 0x29000 size 0x68470 offset 0 length 1000
> > delalloc 1 unwritten 0
> >
> >
> > looks like xfsaild is not able to take lock until hung-task timeout
> kicks
> > in
> >
> >    xfsaild/dm-10-3335  [003] ...2 25247.649468: xfs_ilock_nowait: dev
> > 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 25247.649469: xfs_iunlock: dev 253:10
> > ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 25247.649469: xfs_ail_flushing: dev
> > 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
> >    xfsaild/dm-10-3335  [003] ...2 25247.699478: xfs_ilock_nowait: dev
> > 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 25247.699516: xfs_iunlock: dev 253:10
> > ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 25247.699517: xfs_ail_flushing: dev
> > 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
> >    xfsaild/dm-10-3335  [003] ...2 25247.749471: xfs_ilock_nowait: dev
> > 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 25247.749478: xfs_iunlock: dev 253:10
> > ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
> >    xfsaild/dm-10-3335  [003] ...2 25247.749479: xfs_ail_flushing: dev
> > 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
> >
> > Please let me know how to debug this further. Thanks.
> >
> > --Shyam
> > -----Original Message-----
> > From: Brian Foster [mailto:bfoster@redhat.com]
> > Sent: 22 March 2016 17:49
> > To: Shyam Kaushik
> > Cc: xfs@oss.sgi.com; Alex Lyakas
> > Subject: Re: XFS hung task in xfs_ail_push_all_sync() when unmounting FS
> > after disk failure/recovery
> >
> > On Tue, Mar 22, 2016 at 04:51:39PM +0530, Shyam Kaushik wrote:
> > > Hi XFS developers,
> > >
> > > We are seeing the following issue with XFS on kernel 3.18.19.
> > >
> > > We have XFS mounted over a raw disk. Disk was pulled out manually.
> There
> > > were async writes on files that were errored like this
> > >
> > ...
> > >
> > > And XFS hit metadata & Log IO errors that it decides to shutdown:
> > >
> > > Mar 16 16:03:22 host0 kernel: [ 4637.351841] XFS (dm-29): metadata I/O
> > > error: block 0x3a27fbd0 ("xlog_iodone") error 5 numblks 64
> > > Mar 16 16:03:22 host0 kernel: [ 4637.352820] XFS(dm-29): SHUTDOWN!!!
> > > old_flags=0x0 new_flags=0x2
> > > Mar 16 16:03:22 host0 kernel: [ 4637.353187] XFS (dm-29): Log I/O
> Error
> > > Detected.  Shutting down filesystem
> > ...
> > > Later the drive was re-inserted back. After the drive was re-inserted,
> > XFS
> > > was attempted to be unmounted
> > >
> > > Mar 16 16:16:53 host0 controld: [2557] [     ] umount[202]
> > > : umount(/sdisk/vol5b0, xfs)
> > >
> > > But nothing happens except for the 30-secs xfs_log_force errors that
> > keeps
> > > repeating
> > >
> > ...
> > >
> > > This problem doesn't happen consistently, but happens periodically
> with
> > a
> > > drive failure/recovery followed by XFS unmount. I couldn't find this
> > issue
> > > fixed in later kernels. Can you please suggest how I can debug this
> > issue
> > > further?
> > >
> >
> > Similar problems have been reproduced due to racy/incorrect EFI/EFD
> > object tracking, which are internal data structures associated with
> > freeing extents.
> >
> > What happens if you enable tracepoints while the fs is in this hung
> > unmount state?
> >
> > # trace-cmd start -e "xfs:*"
> > # cat /sys/kernel/debug/tracing/trace_pipe
> >
> > Brian
> >
> > > Thanks!
> > >
> > > --Shyam
> > >
> > > _______________________________________________
> > > xfs mailing list
> > > xfs@oss.sgi.com
> > > http://oss.sgi.com/mailman/listinfo/xfs
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
