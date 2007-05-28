Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 May 2007 18:50:28 -0700 (PDT)
Received: from dh.localdomain (inn.nightwish.hu [217.20.130.190])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4S1oNWt007902
	for <xfs@oss.sgi.com>; Sun, 27 May 2007 18:50:25 -0700
From: Pallai Roland <dap@mail.index.hu>
Subject: Re: raid5: I lost a XFS file system due to a minor IDE cable problem
Date: Mon, 28 May 2007 03:50:17 +0200
References: <200705241318.30711.dap@mail.index.hu> <200705251635.36533.dap@mail.index.hu> <20070528003010.GS85884050@sgi.com>
In-Reply-To: <20070528003010.GS85884050@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705280350.18384.dap@mail.index.hu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Linux-Raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com


On Monday 28 May 2007 02:30:11 David Chinner wrote:
> On Fri, May 25, 2007 at 04:35:36PM +0200, Pallai Roland wrote:
> > On Friday 25 May 2007 06:55:00 David Chinner wrote:
> > > Oh, did you look at your logs and find that XFS had spammed them
> > > about writes that were failing?
> >
> > The first message after the incident:
> >
> > May 24 01:53:50 hq kernel: Filesystem "loop1": XFS internal error
> > xfs_btree_check_sblock at line 336 of file fs/xfs/xfs_btree.c.  Caller
> > 0xf8ac14f8 May 24 01:53:50 hq kernel: <f8adae69>
> > xfs_btree_check_sblock+0x4f/0xc2 [xfs]  <f8ac14f8>
> > xfs_alloc_lookup+0x34e/0x47b [xfs] May 24 01:53:50 HF kernel: <f8ac14f8>
> > xfs_alloc_lookup+0x34e/0x47b [xfs]  <f8b1a9c7> kmem_zone_zalloc+0x1b/0x43
> > [xfs] May 24 01:53:50 hq kernel: <f8abe645>
> > xfs_alloc_ag_vextent+0x24d/0x1110 [xfs]  <f8ac0647>
> > xfs_alloc_vextent+0x3bd/0x53b [xfs] May 24 01:53:50 hq kernel: <f8ad2f7e>
> > xfs_bmapi+0x1ac4/0x23cd [xfs]  <f8acab97>
> > xfs_bmap_search_multi_extents+0x8e/0xd8 [xfs] May 24 01:53:50 hq kernel:
> > <f8b00001> xlog_dealloc_log+0x49/0xea [xfs]  <f8afdaee>
> > xfs_iomap_write_allocate+0x2d9/0x58b [xfs] May 24 01:53:50 hq kernel:
> > <f8afc3ae> xfs_iomap+0x60e/0x82d [xfs]  <c0113bc8>
> > __wake_up_common+0x39/0x59 May 24 01:53:50 hq kernel: <f8b1ae11>
> > xfs_map_blocks+0x39/0x6c [xfs]  <f8b1bd7b>
> > xfs_page_state_convert+0x644/0xf9c [xfs] May 24 01:53:50 hq kernel:
> > <c036f384> schedule+0x5d1/0xf4d  <f8b1c780> xfs_vm_writepage+0x0/0xe0
> > [xfs] May 24 01:53:50 hq kernel: <f8b1c7d7> xfs_vm_writepage+0x57/0xe0
> > [xfs]  <c01830e8> mpage_writepages+0x1fb/0x3bb May 24 01:53:50 hq kernel:
> > <c0183020> mpage_writepages+0x133/0x3bb  <f8b1c780>
> > xfs_vm_writepage+0x0/0xe0 [xfs] May 24 01:53:50 hq kernel: <c0147bb3>
> > do_writepages+0x35/0x3b  <c018135c> __writeback_single_inode+0x88/0x387
> > May 24 01:53:50 hq kernel: <c01819b7> sync_sb_inodes+0x1b4/0x2a8 
> > <c0181c63> writeback_inodes+0x63/0xdc May 24 01:53:50 hq kernel:
> > <c0147943> background_writeout+0x66/0x9f  <c01482b3> pdflush+0x0/0x1ad
> > May 24 01:53:50 hq kernel: <c01483a2> pdflush+0xef/0x1ad  <c01478dd>
> > background_writeout+0x0/0x9f May 24 01:53:50 hq kernel: <c012d10b>
> > kthread+0xc2/0xc6  <c012d049> kthread+0x0/0xc6 May 24 01:53:50 hq kernel:
> > <c0100dd5> kernel_thread_helper+0x5/0xb
> >
> > .and I've spammed such messages. This "internal error" isn't a good
> > reason to shut down the file system?
>
> Actaully, that error does shut the filesystem down in most cases. When you
> see that output, the function is returning -EFSCORRUPTED. You've got a
> corrupted freespace btree.
>
> The reason why you get spammed is that this is happening during background
> writeback, and there is no one to return the -EFSCORRUPTED error to. The
> background writeback path doesn't specifically detect shut down filesystems
> or trigger shutdowns on errors because that happens in different layers so
> you just end up with failed data writes. These errors will occur on the
> next foreground data or metadata allocation and that will shut the
> filesystem down at that point.
>
> I'm not sure that we should be ignoring EFSCORRUPTED errors here; maybe in
> this case we should be shutting down the filesystem.  That would certainly
> cut down on the spamming and would not appear to change anything other
> behaviour....
 If I remember correctly, my file system wasn't shutted down at all, it 
was "writeable" for whole night, the yafc slowly "written" files to it. Maybe 
all write operations had failed, but yafc doesn't warn.

 Spamming is just annoying when we need to find out what went wrong (My 
kernel.log is 300Mb), but for data security it's important to react to 
EFSCORRUPTED error in any case, I think so. Please consider this.

> > I think if there's a sign of corrupted file system, the first thing we
> > should do is to stop writes (or the entire FS) and let the admin to
> > examine the situation.
>
> Yes, that's *exactly* what a shutdown does. In this case, your writes are
> being stopped - hence the error messages - but the filesystem has not yet
> been shutdown.....
 All writes being stopped that were involved in the freespace btree, but a few 
operations were executed (on the corrupted FS), right? Ignoring of 
EFSCORRUPTED isn't a good idea in this case.


--
 d
