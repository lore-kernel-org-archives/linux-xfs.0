Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55462 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932341AbcKQQ6m (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Nov 2016 11:58:42 -0500
Date: Fri, 18 Nov 2016 00:51:32 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] generic/391: check inode metadata on f{data}sync after
 power-cut
Message-ID: <20161117165132.GC27776@eguan.usersys.redhat.com>
References: <20161117032753.69315-1-jaegeuk@kernel.org>
 <20161117083527.GY27776@eguan.usersys.redhat.com>
 <20161117125658.GA49658@bfoster.bfoster>
 <20161117140019.GA27776@eguan.usersys.redhat.com>
 <20161117163203.GB49658@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161117163203.GB49658@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, fstests@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org

On Thu, Nov 17, 2016 at 11:32:03AM -0500, Brian Foster wrote:
[snip some unrelated context]
> > > > > +{
> > > > > +	src/godown $SCRATCH_MNT >> $seqres.full
> > > > > +	$XFS_IO_PROG -r -c "stat -v" $1 >$tmp.before
> > > > 
> > > > Shouldn't we call godown *after* xfs_io -c stat? I saw EIO on this
> > > > xfs_io command and all sub-tests reported stat diff.
> > > > 
> > > 
> > > Yeah.. I haven't run the test, but I would expect pretty much anything
> > > to return an error after an fs shutdown.
> > > 
> > > > And perhaps we need to flush the log on godown for XFS? i.e.
> > > > 
> > > > src/godown -f $SCRATCH_MNT >> $seqres.full
> > > > 
> > > 
> > > I don't think this is necessary. The semantics of fsync() dictate that
> > > the fs do what is necessary to make the file persistent on disk. This
> > > means it is the fs responsibility to ensure the changes are logged on
> > > disk. Indeed, xfs_file_fsync() calls _xfs_log_force_lsn() to flush the
> > > log up to the most recent LSN that covered the inode in question.
> > > 
> > > > Otherwise XFS fails all the "1024" & fsync tests (after I fixed the
> > > > godown & xfs_io order locally), fdatasync tests are fine.
> > > > 
> > > > @@ -1,8 +1,16 @@
> > > >  QA output created by 391
> > > >  ==== i_size 1024 test with fsync ====
> > > > +6c6
> > > > +< stat.blocks = 8200
> > > > +---
> > > > +> stat.blocks = 16256
> > > >  ==== i_size 4096 test with fsync ====
> > > >  ==== i_time test with fsync ====
> > > >  ==== fpunch 1024 test with fsync ====
> > > > +6c6
> > > > +< stat.blocks = 8208
> > > > +---
> > > > +> stat.blocks = 24576
> > > >  ==== fpunch 4096 test with fsync ====
> > > > 
> > > > Not sure if this is the expected behavior on XFS. cc'ed xfs list for
> > > > some inputs.
> > > > 
> > > 
> > > Am I reading this correctly that you're seeing more blocks than
> > > expected? If so, preallocation perhaps?
> > 
> > Yes, you're correct, I see more blocks after godown than before godown.
> > 
> > I tried adding "-o allocsize=4k" to MOUNT_OPTIONS, it works but not
> > always. e.g. on a host with sunit/swidth reported from underlying block
> > device, test still fails.
> > 
> 
> I'm not quite sure where the preallocation is coming from in that case.
> It looks like it should honor allocsize, so that might be worth looking
> into.
> 
> > # xfs_info /mnt/xfs
> > meta-data=/dev/mapper/systemvg-testlv2 isize=512    agcount=16, agsize=245696 blks
> >          =                       sectsz=512   attr=2, projid32bit=1
> >          =                       crc=1        finobt=1 spinodes=0 rmapbt=0
> >          =                       reflink=0
> > data     =                       bsize=4096   blocks=3931136, imaxpct=25
> >          =                       sunit=64     swidth=192 blks
> > naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> > log      =internal               bsize=4096   blocks=2560, version=2
> >          =                       sectsz=512   sunit=64 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > 
> > Part of the test diff:
> >  ==== i_size 1024 test with fsync ====
> > +6c6
> > +< stat.blocks = 8200
> > +---
> > +> stat.blocks = 8704
> > 
> > On the other hand, adding "-f" to godown always works for me.
> >
> 
> I'm guessing the difference here is that fsync flushes the inode with
> preallocation, but preallocation is typically cleaned up on file close
> (when xfs_io exits). So a subsequent log flush at shutdown may flush
> the transaction that clears out post-eof blocks. Note that it may also
> hit the disk without the log forcing shutdown, it's just not guaranteed
> in that case.
> 
> The right thing to do is probably deal with preallocation explicitly in
> the test. E.g., a truncate of the file to the current size after a
> potentially preallocated write, but before the fsync, should always
> result in an equivalent blocks count post-recovery.

You're right, I added truncate operation to isize test and punch test,
and this case passed without problem on XFS. Thanks!

Eryu
