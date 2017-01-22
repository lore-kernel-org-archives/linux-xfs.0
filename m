Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46977 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750770AbdAVFB0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Jan 2017 00:01:26 -0500
Date: Sat, 21 Jan 2017 21:01:18 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v5 0/9] xfstests: online scrub/repair support
Message-ID: <20170122050118.GL12985@birch.djwong.org>
References: <148498621936.17109.4249711513404036449.stgit@birch.djwong.org>
 <CAOQ4uxgDPEQiC72-o7yt0P6o2xdVTb6kQNxoePOzYWRbCCXxKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgDPEQiC72-o7yt0P6o2xdVTb6kQNxoePOzYWRbCCXxKw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Sat, Jan 21, 2017 at 09:38:23PM +0200, Amir Goldstein wrote:
> On Sat, Jan 21, 2017 at 10:10 AM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> > Hi all,
> >
> > This is the fifth revision of a patchset that adds to XFS userland tools
> > support for online metadata scrubbing and repair.
> >
> > The new patches in this series do three things: first, they expand the
> > filesystem populate commands inside xfstests to be able to create all
> > types of XFS metadata.  Second, they create a bunch of xfs_db wrapper
> > functions to iterate all fields present in a given metadata object and
> > fuzz them in various ways.  Finally, for each metadata object type there
> > is a separate test that iteratively fuzzes all fields of that object and
> > runs it through the mount/scrub/repair loop to see what happens.
> >
> > If you're going to start using this mess, you probably ought to just
> > pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
> > The kernel patches in the git trees should apply to 4.10-rc4; xfsprogs
> > patches to for-next; and xfstest to master.
> >
> > The patches have survived all auto group xfstests both with scrub-only
> > mode and also a special debugging mode to xfs_scrub that forces it to
> > rebuild the metadata structures even if they're not damaged.
> >
> 
> Darrick,
> 
> xfs/1301 hogs every time at the same point in the test
> after Fuzz dirblklog = middlebit, those are the last words in dmesg:
> Log size 12800 blocks too small, minimum size is 23646 blocks
> XFS (dm-2): AAIEEE! Log failed size checks. Abort!
> XFS (dm-2): log mount failed

Yeah.... there's some oddball problems in xfs_repair where directory
related corruption causes it to misread directory free space so when it
goes to add "unlinked" inodes to lost+found the process goes totally
nuts and/or deadlocks on buffers.  I haven't had a chance to figure out
what's causing /this/ particular problem, though..... :(

--D

> 
> Then xfs_repair stays at 100% (waited >10 min).
> This is the backtrace from xfs_repair:
> 
> libxfs_trans_log_buf (tp=<optimized out>, bp=bp@entry=0x9d7200,
> first=first@entry=65272, last=last@entry=65275) at trans.c:385
> 385             xfs_buf_item_log(bip, first, last);
> (gdb) bt
> #0  libxfs_trans_log_buf (tp=<optimized out>, bp=bp@entry=0x9d7200,
> first=first@entry=65272, last=last@entry=65275) at trans.c:385
> #1  0x000000000045c28d in xfs_dir2_data_log_unused
> (args=args@entry=0xa1fe00, bp=0x9d7200, dup=dup@entry=0xadacf8) at
> xfs_dir2_data.c:712
> #2  0x000000000045b3d2 in xfs_dir2_sf_to_block
> (args=args@entry=0xa1fe00) at xfs_dir2_block.c:1209
> #3  0x0000000000462b84 in xfs_dir2_sf_addname
> (args=args@entry=0xa1fe00) at xfs_dir2_sf.c:339
> #4  0x00000000004594e8 in libxfs_dir_createname (tp=0x9e31b0,
> dp=0x9d6e60, name=name@entry=0x7ffe5fff3690, inum=inum@entry=161,
> first=first@entry=0x7ffe5fff3688, dfops=dfops@entry=0x7ffe5fff36a0,
>     total=1848) at xfs_dir2.c:297
> #5  0x000000000042259e in mv_orphanage (mp=mp@entry=0x7ffe5fff4b30,
> ino=ino@entry=161, isa_dir=0) at phase6.c:1205
> #6  0x0000000000423ed4 in check_for_orphaned_inodes (irec=<optimized
> out>, agno=<optimized out>, mp=<optimized out>) at phase6.c:3105
> #7  phase6 (mp=mp@entry=0x7ffe5fff4b30) at phase6.c:3284
> #8  0x0000000000403b5d in main (argc=<optimized out>, argv=<optimized
> out>) at xfs_repair.c:947
> 
> 
> Attached 1301.full and dmesg from 2 runs.
> 
> Using to following branch tips:
> 
> xfstests:
> 949963c xfs: actually record per-field fuzzing online repair output
> xfsprogs:
> 3dd963c xfs_scrub: create a script to scrub all xfs filesystems
> kernel:
> fbcd13f xfs: avoid mount-time deadlock in CoW extent recovery
> 
> Will let it run through the night see what happens...
> 
> Amir.



