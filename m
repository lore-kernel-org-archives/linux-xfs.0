Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 03 Mar 2008 17:42:58 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m241gZex029390
	for <xfs@oss.sgi.com>; Mon, 3 Mar 2008 17:42:37 -0800
Received: from toro.qb3.berkeley.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A8C8A6480CE
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2008 17:43:04 -0800 (PST)
Received: from toro.qb3.berkeley.edu (toro.QB3.Berkeley.EDU [169.229.244.93]) by cuda.sgi.com with ESMTP id pQRikbRjjIINKlUT for <xfs@oss.sgi.com>; Mon, 03 Mar 2008 17:43:04 -0800 (PST)
Date: Mon, 3 Mar 2008 17:43:03 -0800 (PST)
From: slaton <slaton@berkeley.edu>
Subject: Re: Linux XFS filesystem corruption (XFS_WANT_CORRUPTED_GOTO)
In-Reply-To: <op.t7gxfvle3jf8g2@pc-bnaujok.melbourne.sgi.com>
Message-ID: <Pine.LNX.4.64.0803031739120.7542@toro.qb3.berkeley.edu>
References: <Pine.LNX.4.64.0802221718430.13471@toro.qb3.berkeley.edu>
 <47C343D1.30304@sandeen.net> <Pine.LNX.4.64.0802251447390.20825@toro.qb3.berkeley.edu>
 <Pine.LNX.4.64.0802271441390.19923@toro.qb3.berkeley.edu>
 <op.t67spv073jf8g2@pc-bnaujok.melbourne.sgi.com>
 <Pine.LNX.4.64.0803031710480.7542@toro.qb3.berkeley.edu>
 <op.t7gxfvle3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Unfortunately, mounting triggered another XFS_WANT_CORRUPTED_GOTO error:

XFS mounting filesystem sda1
Starting XFS recovery on filesystem: sda1 (logdev: internal)
XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1546 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffff882c3be6
Call Trace:
 [<ffffffff882c204b>] :xfs:xfs_free_ag_extent+0x18a/0x690
 [<ffffffff882c3be6>] :xfs:xfs_free_extent+0xa9/0xc9
 [<ffffffff882fabf5>] :xfs:xlog_recover_process_efi+0x117/0x149
 [<ffffffff882fac6d>] :xfs:xlog_recover_process_efis+0x46/0x6f
 [<ffffffff882fbb7e>] :xfs:xlog_recover_finish+0x16/0x98
 [<ffffffff882f4e68>] :xfs:xfs_log_mount_finish+0x19/0x1c
 [<ffffffff882fdb52>] :xfs:xfs_mountfs+0x892/0x99a
 [<ffffffff8830b663>] :xfs:kmem_alloc+0x67/0xcd
 [<ffffffff8830b6d2>] :xfs:kmem_zalloc+0x9/0x21
 [<ffffffff882fe7a0>] :xfs:xfs_mru_cache_create+0x127/0x188
 [<ffffffff8830376e>] :xfs:xfs_mount+0x333/0x3b4
 [<ffffffff88314452>] :xfs:xfs_fs_fill_super+0x0/0x1ab
 [<ffffffff883144d0>] :xfs:xfs_fs_fill_super+0x7e/0x1ab
 [<ffffffff80449fe3>] __down_write_nested+0x12/0x9a
 [<ffffffff802a131e>] get_filesystem+0x12/0x35
 [<ffffffff8028e8aa>] sget+0x379/0x38e
 [<ffffffff8028ef31>] set_bdev_super+0x0/0xf
 [<ffffffff8028f06a>] get_sb_bdev+0x11d/0x168
 [<ffffffff8028f296>] vfs_kern_mount+0x94/0x124
 [<ffffffff8028f363>] do_kern_mount+0x3d/0xee
 [<ffffffff802a35ff>] do_mount+0x6e5/0x738
 [<ffffffff80275743>] handle_mm_fault+0x385/0x789
 [<ffffffff8030dfe9>] __up_read+0x10/0x8a
 [<ffffffff8022341c>] do_page_fault+0x453/0x7a3
 [<ffffffff802757bd>] handle_mm_fault+0x3ff/0x789
 [<ffffffff80271188>] zone_statistics+0x41/0x63
 [<ffffffff8026aa1b>] __alloc_pages+0x6a/0x2d4
 [<ffffffff802a3903>] sys_mount+0x8b/0xce
 [<ffffffff8020bdde>] system_call+0x7e/0x83
Ending XFS recovery on filesystem: sda1 (logdev: internal)

Haven't tried to unmount or anything else, yet. How to proceed?

Just to reiterate, currently using kernel 2.6.23.16 and xfsprogs 2.9.4-1.

thanks
slaton

Slaton Lipscomb
Nogales Lab, Howard Hughes Medical Institute
http://cryoem.berkeley.edu

On Tue, 4 Mar 2008, Barry Naujok wrote:

> On Tue, 04 Mar 2008 12:29:27 +1100, slaton <slaton@berkeley.edu> wrote:
> 
> > Barry,
> > 
> > I ran xfs_metadump (with -g -o -w options) on the partition and in
> > addition to the file output this was written to stder:
> > 
> > xfs_metadump: suspicious count 22 in bmap extent 9 in dir2 ino 940064492
> > xfs_metadump: suspicious count 21 in bmap extent 8 in dir2 ino 1348807890
> > xfs_metadump: suspicious count 29 in bmap extent 9 in dir2 ino 2826081099
> > xfs_metadump: suspicious count 23 in bmap extent 54 in dir2 ino 3093231364
> > xfs_metadump: suspicious count 106 in bmap extent 4 in dir2 ino 3505884782
> > 
> > Should i go ahead and do a mount/umount (to replay log) and then
> > xfs_repair, or would another course of action be recommended, given these
> > potential problem inodes?
> 
> Depending on the size of the directories, these numbers are probably fine.
> I believe a mount/unmount/repair is the best course of action from here.
> 
> So be extra safe, run another metadump after mount/unmount before running
> repair.
> 
> Barry.
> 
> > thanks
> > slaton
> > 
> > Slaton Lipscomb
> > Nogales Lab, Howard Hughes Medical Institute
> > http://cryoem.berkeley.edu
> > 
> > On Thu, 28 Feb 2008, Barry Naujok wrote:
> > 
> > > On Thu, 28 Feb 2008 09:44:04 +1100, slaton <slaton@berkeley.edu> wrote:
> > > 
> > > > Hi,
> > > > 
> > > > I'm still hoping for some help with this. Is any more information needed
> > > > in addition to the ksymoops output previously posted?
> > > > 
> > > > In particular i'd like to know if just remounting the filesystem (to
> > > > replay the journal), then unmounting and running xfs_repair is the best
> > > > course of action. In addition, i'd like to know what recommended
> > > > kernel/xfsprogs versions to use for best results.
> > > 
> > > I would get xfsprogs 2.9.4 (2.9.6 is not a good version with your kernel),
> > > ftp://oss.sgi.com/projects/xfs/previous/cmd_tars/xfsprogs_2.9.4-1.tar.gz
> > > 
> > > To be on the safe side, either make an entire copy of your drive to
> > > another device, or run "xfs_metadump -o /dev/sda1" to capture
> > > a metadata (no file data) of your filesystem.
> > > 
> > > Then run xfs_repair (mount/unmount maybe required if the log is dirty).
> > > 
> > > If the filesystem is in a bad state after the repair (eg. everything in
> > > lost+found), email the xfs_repair log and request further advise.
> > > 
> > > Regards,
> > > Barry.
> > > 
> > > 
> > > > thanks
> > > > slaton
> > > > 
> > > > Slaton Lipscomb
> > > > Nogales Lab, Howard Hughes Medical Institute
> > > > http://cryoem.berkeley.edu
> > > > 
> > > > On Mon, 25 Feb 2008, slaton wrote:
> > > > 
> > > > > Thanks for the reply.
> > > > >
> > > > > > Are you hitting http://oss.sgi.com/projects/xfs/faq.html#dir2 ?
> > > > >
> > > > > Presumably not - i'm using 2.6.17.11, and that information indicates
> > > > the
> > > > > bug was fixed in 2.6.17.7.
> > > > >
> > > > > I've attached the output from running ksymoops on messages.1. First
> > > > > crash/trace (Feb 21 19:xx) corresponds to the original XFS event; the
> > > > > second (Feb 22 15:xx) is the system going down when i tried to unmount
> > > > the
> > > > > volume.
> > > > >
> > > > > Here are the additional syslog msgs corresponding to the Feb 22 15:xx
> > > > > crash.
> > > > >
> > > > > Feb 22 15:47:13 qln01 kernel: grsec: From 10.0.2.93: unmount of
> > > > /dev/sda1
> > > > > by /bin/umount[umount:18604] uid/euid:0/0 gid/egid:0/0, parent
> > > > > /bin/bash[bash:31972] uid/euid:0/0 gid/egid:0/0
> > > > > Feb 22 15:47:14 qln01 kernel: xfs_force_shutdown(sda1,0x1) called from
> > > > > line 338 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff88173ce4
> > > > > Feb 22 15:47:14 qln01 kernel: xfs_force_shutdown(sda1,0x1) called from
> > > > > line 338 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff88173ce4
> > > > > Feb 22 15:47:28 qln01 kernel: BUG: soft lockup detected on CPU#0!
> > > > >
> > > > > thanks
> > > > > slaton
> > > > 
> > > > 
> > > 
> 
