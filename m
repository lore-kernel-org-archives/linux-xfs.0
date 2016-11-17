Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751161AbcKQTRK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Nov 2016 14:17:10 -0500
Date: Thu, 17 Nov 2016 11:17:05 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH] generic/391: check inode metadata on f{data}sync after
 power-cut
Message-ID: <20161117191705.GD74211@jaegeuk>
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
Cc: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org

Hello,

On Thu, Nov 17, 2016 at 11:32:03AM -0500, Brian Foster wrote:
> On Thu, Nov 17, 2016 at 10:00:19PM +0800, Eryu Guan wrote:
> > On Thu, Nov 17, 2016 at 07:56:58AM -0500, Brian Foster wrote:
> > > On Thu, Nov 17, 2016 at 04:35:27PM +0800, Eryu Guan wrote:
> > > > [cc'ed linux-xfs for inputs on a flush log issue]
> > > > 
> > > > On Wed, Nov 16, 2016 at 07:27:53PM -0800, Jaegeuk Kim wrote:
> > > > > This patch adds tests/generic/391 to test fsync and fdatasync with power-cuts.
> > > > > 
> > > > > The rule to check is:
> > > > > 1) fsync should guarantee all the inode metadata after power-cut,
> > > > > 2) fdatasync should guarantee i_size and i_blocks at least after power-cut.
> > > > > 
> > > > > Suggested-by: Chao Yu <yuchao0@huawei.com>
> > > > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > > > > ---
> > > > >  tests/generic/391     | 125 ++++++++++++++++++++++++++++++++++++++++++++++++++
> > > > >  tests/generic/391.out |  11 +++++
> > > > >  tests/generic/group   |   1 +
> > > > >  3 files changed, 137 insertions(+)
> > > > >  create mode 100644 tests/generic/391
> > > > >  create mode 100644 tests/generic/391.out
> > > > > 
...
> > > > > +
> > > > > +seq=`basename $0`
> > > > > +seqres=$RESULT_DIR/$seq
> > > > > +echo "QA output created by $seq"
> > > > > +
> > > > > +here=`pwd`
> > > > > +tmp=/tmp/$$
> > > > > +status=1	# failure is the default!
> > > > > +trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> > > > 
> > > > Better to follow the template and other tests on how to do cleanup, i.e.
> > > > trap _cleanup on exit and do real cleanups in it. e.g.
> > > > 
> > > > trap "_cleanup; exit \$status" 0 1 2 3 15
> > > > 
> > > > _cleanup()
> > > > {
> > > > 	cd /
> > > > 	rm -f $tmp.*
> > > > }
> > > > 
> > > > Not a big deal, but it's better to maintain consistency :)
> > > > 
> > > > > +
> > > > > +# get standard environment, filters and checks
> > > > > +. ./common/rc
> > > > > +. ./common/filter
> > > > > +. ./common/punch
> > > > > +
> > > > > +# real QA test starts here
> > > > > +_supported_fs generic
> > > > > +_supported_os Linux
> > > > > +
> > > > > +rm -f $seqres.full
> > > > > +_require_scratch
> > > > > +_require_scratch_shutdown
> > > > > +_require_xfs_io_command "fpunch"
> > > > > +
> > > > > +_scratch_mkfs >/dev/null 2>&1
> > > > > +_scratch_mount
> > > > > +
> > > > > +testfile=$SCRATCH_MNT/testfile
> > > > > +
> > > > > +# check inode metadata after shutdown
> > > > > +_check_inode_metadata()
> > > > 
> > > > No need to name local functions with the leading "_", that's for global
> > > > helper functions.
> > > > 
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
> 
> (Another angle here might be to consider whether the block count is the
> right metric for this test, as opposed to a hexdump that validates the
> written data actually made it to disk.).

So, it seems it'd be better to avoid checking i_blocks of XFS because of such
the preallocation, but for F2FS, I'd prefer to check i_blocks mismatch to detect
any regression.

Let me submit v2.

Thanks,
