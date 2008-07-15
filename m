Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jul 2008 20:37:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6F3bLhg018589
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 20:37:23 -0700
Message-ID: <487C1BAF.2030404@sgi.com>
Date: Tue, 15 Jul 2008 13:38:23 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Is it possible the check an frozen XFS filesytem to avoid downtime
References: <200807141542.51613.ms@teamix.de>
In-Reply-To: <200807141542.51613.ms@teamix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <ms@teamix.de>
Cc: xfs@oss.sgi.com

Hi Martin,

Martin Steigerwald wrote:
> Hi!
> 
> We seen in-memory corruption on two XFS filesystem on a server heartbeat 
> cluster of one of our customers:
> 
> 
> XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1563 of file 
> fs/xfs/xfs_alloc.c.  Caller 0xffffffff8824eb5d
> 
> Call Trace:
>  [<ffffffff8824cff3>] :xfs:xfs_free_ag_extent+0x1a6/0x6b5
>  [<ffffffff8824eb5d>] :xfs:xfs_free_extent+0xa9/0xc9
>  [<ffffffff88258636>] :xfs:xfs_bmap_finish+0xf0/0x169
>  [<ffffffff88278b4c>] :xfs:xfs_itruncate_finish+0x180/0x2c1
>  [<ffffffff8829071a>] :xfs:xfs_setattr+0x841/0xe59
>  [<ffffffff8022e868>] sock_common_recvmsg+0x30/0x45
>  [<ffffffff8829adc8>] :xfs:xfs_vn_setattr+0x121/0x144
>  [<ffffffff8022a06d>] notify_change+0x156/0x2ef
>  [<ffffffff883bf9c6>] :nfsd:nfsd_setattr+0x334/0x4b1
>  [<ffffffff883c61d6>] :nfsd:nfsd3_proc_setattr+0xa2/0xae
>  [<ffffffff883bb24d>] :nfsd:nfsd_dispatch+0xdd/0x19e
>  [<ffffffff8833a10e>] :sunrpc:svc_process+0x3cb/0x6d9
>  [<ffffffff8025b20b>] __down_read+0x12/0x9a
>  [<ffffffff883bb816>] :nfsd:nfsd+0x192/0x2b0
>  [<ffffffff80255f38>] child_rip+0xa/0x12
>  [<ffffffff883bb684>] :nfsd:nfsd+0x0/0x2b0
>  [<ffffffff80255f2e>] child_rip+0x0/0x12
> 
> xfs_force_shutdown(dm-1,0x8) called from line 4261 of file fs/xfs/xfs_bmap.c.  
> Return address = 0xffffffff88258673
> Filesystem "dm-1": Corruption of in-memory data detected.  Shutting down 
> filesystem: dm-1
> Please umount the filesystem, and rectify the problem(s)
> 
> on
> 
> Linux version 2.6.21-1-amd64 (Debian 2.6.21-4~bpo.1) (nobse@backports.org) 
> (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Tue Jun 5 
> 07:43:32 UTC 2007
> 
> 
> We plan to do a takeover so that the server which appears to have memory 
> errors can be memtested. 
> 
> After the takeover we would like to make sure that the XFS filesystems are 
> intact. Is it possible to do so without taking the filesystem completely 
> offline?
> 
> I thought about mounting read only and it might be the best choice available, 
> but then it will *fail* write accesses. I would prefer if these are just 
> stalled.
> 
> I tried xfs_freeze -f on my laptop home directory, but then did not machine to 
> get it check via xfs_check or xfs_repair -nd... is it possible at all?
> 
> Ciao,


When I last tried (and I don't think Barry has done anything to it to change
things) it wouldn't work.
However, I think it could/should be changed to make it work.

My notes from the SGI bug:

958642: running xfs_check and "xfs_repair -n" on a frozen xfs filesystem
> We've been asked a few times about the possibility of running xfs_check
> or xfs_repair -n on a frozen filesystem.
> And a while back I looked into what some of the hinderances were.
> And now I've forgotten ;-))
> 
> I think there are hinderances for libxfs_init (check_open()) and
> for having a dirty log.
> 
> For libxfs_init, I found that I couldn't run the tools without error'ing out.
> I think I found out that I needed the INACTIVE flag,
> without READONLY/DANGEROUSLY, like xfs_logprint does.
> 
> ----------------------------------------
> Date: Thu, 19 Oct 2006 11:24:06 +1000
> From: Timothy Shimmin <tes@sgi.com>
> To: lachlan@sgi.com
> cc: xfs-dev@sgi.com
> Subject: Re: init.c patch
> ------------------------------------------------------
>   Ok, my understanding of the READONLY/DANGEROUSLY flags were wrong.
>   I thought they were just overriding flags when you were guaranteeing you were only reading
>   and it would be more permissive,
>   but they are for doing stuff on readonly (ro) mounts.
>   They are rather confusing to me. When you go with defaults for repair and db then
>   it doesn't set the INACTIVE flag.
>   It means if I do _not_ want to be fatal then I need to set INACTIVE but not set READONLY or
>   DANGEROUSLY - which is what logprint does.
> 
>   I would have thought they'd be an option which for commands which don't modify anything,
>   that they can read from a non-ro mounted filesystem (at the users risk) -
>   which is what logprint does. i.e an option which just sets INACTIVE and only
>   produces a warning.
> 
>   The other alternative is to be able to test for a frozen fs as you suggested.
> ----------------------------------------------------------
> 
> Lachlan suggested using a check_isfrozen() routine instead of overriding
> check_isactive().
> 
> 
> And as far as the dirty log is concerned...
> It will be dirty when it is frozen, but in a special way.
> It will have an unmount record followed by a dummy record -
> solely used so that when mounted again it can do
> the unlinked list processing.
> So we could add code to test if the log just had an unmount record
> followed by a dummy record and continue anyway knowing that
> the metadata was consistent.
> e.g. in xfs_repair/phase2.c:zero_log() it calls xlog_find_tail()
> and tests if (head_blk != tail_blk) to know if the log is dirty.
> I think libxfs should provide a routine: libxfs_dirty_log
> or in the libxlog code with a suitable name,
> which could say how dirty the log is ;-)
> Is it dirty such that we have real transactions to replay or
> does it just have to do the unlinked processing as in the case of
> a frozen filesystem.
> It would be nice anyway to have an abstraction here because
> it is finding out the head and tail blocks solely for this purpose
> and doesn't really care what they are.
> 
> --Tim


--Tim
