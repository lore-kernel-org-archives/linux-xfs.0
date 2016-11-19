Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60538 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752282AbcKSAmW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Nov 2016 19:42:22 -0500
Date: Fri, 18 Nov 2016 19:42:17 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] generic/391: check inode metadata on f{data}sync
 after power-cut
Message-ID: <20161119004217.GA3051@laptop.bfoster>
References: <20161117032753.69315-1-jaegeuk@kernel.org>
 <20161117192051.GE74211@jaegeuk>
 <20161118063943.GF27776@eguan.usersys.redhat.com>
 <20161118194442.GD31226@jaegeuk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161118194442.GD31226@jaegeuk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org

On Fri, Nov 18, 2016 at 11:44:42AM -0800, Jaegeuk Kim wrote:
> On Fri, Nov 18, 2016 at 02:39:43PM +0800, Eryu Guan wrote:
> > On Thu, Nov 17, 2016 at 11:20:51AM -0800, Jaegeuk Kim wrote:
> > > This patch adds tests/generic/391 to test fsync and fdatasync with power-cuts.
> > > 
> > > The rule to check is:
> > > 1) fsync should guarantee all the inode metadata after power-cut,
> > > 2) fdatasync should guarantee i_size and i_blocks at least after power-cut.
> > > 
> > > Suggested-by: Chao Yu <yuchao0@huawei.com>
> > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > > ---
> > >  tests/generic/391     | 136 ++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/391.out |  11 ++++
> > >  tests/generic/group   |   1 +
> > >  3 files changed, 148 insertions(+)
> > >  create mode 100644 tests/generic/391
> > >  create mode 100644 tests/generic/391.out
> > > 
> > > diff --git a/tests/generic/391 b/tests/generic/391
> > > new file mode 100644
> > > index 0000000..2b95151
> > > --- /dev/null
> > > +++ b/tests/generic/391
> > > @@ -0,0 +1,136 @@
> > > +#! /bin/bash
> > > +# FS QA Test 391
> > > +#
> > > +# Test inode's metadata after fsync or fdatasync calls.
> > > +# In the case of fsync, filesystem should recover all the inode metadata, while
> > > +# recovering i_blocks and i_size at least for fdatasync.
> > > +#
> > > +#-----------------------------------------------------------------------
> > > +# Copyright (c) 2016 Jaegeuk Kim.  All Rights Reserved.
> > > +#
> > > +# This program is free software; you can redistribute it and/or
> > > +# modify it under the terms of the GNU General Public License as
> > > +# published by the Free Software Foundation.
> > > +#
> > > +# This program is distributed in the hope that it would be useful,
> > > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > +# GNU General Public License for more details.
> > > +#
> > > +# You should have received a copy of the GNU General Public License
> > > +# along with this program; if not, write the Free Software Foundation,
> > > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > > +#-----------------------------------------------------------------------
> > > +#
> > > +
> > > +seq=`basename $0`
> > > +seqres=$RESULT_DIR/$seq
> > > +echo "QA output created by $seq"
> > > +
> > > +here=`pwd`
> > > +tmp=/tmp/$$
> > > +status=1	# failure is the default!
> > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > +
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	rm -f $tmp.*
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/filter
> > > +. ./common/punch
> > > +
> > > +# real QA test starts here
> > > +_supported_fs generic
> > > +_supported_os Linux
> > > +
> > > +rm -f $seqres.full
> > > +_require_scratch
> > > +_require_scratch_shutdown
> > > +_require_xfs_io_command "fpunch"
> > > +
> > > +_scratch_mkfs >/dev/null 2>&1
> > > +_scratch_mount
> > > +
> > > +testfile=$SCRATCH_MNT/testfile
> > > +
> > > +# check inode metadata after shutdown
> > > +check_inode_metadata()
> > > +{
> > > +	$XFS_IO_PROG -r -c "stat -v" $1 >$tmp.before
> > > +	src/godown $SCRATCH_MNT >> $seqres.full
> > > +	_scratch_cycle_mount
> > > +	$XFS_IO_PROG -r -c "stat -v" $1 >$tmp.after
> > > +
> > > +	if [ $FSTYP = xfs ]; then
> > > +		sed -i '/stat.blocks/d' $tmp.before
> > > +		sed -i '/stat.blocks/d' $tmp.after
> > > +	fi
> > 
> > Blacklist some fs "randomly" seems not easy to maintain, at least we
> > need some comments to explain why we do this.
> > 
> > I prefer the other way Brian suggested, i.e. truncate the file to
> > correct size before the real fsync/fdatasync to remove any preallocated
> > blocks past eof. I made the following update and test passed on XFS
> > without problems, what do you think?
> 
> I don't think that is a right way, since it breaks the existing IO behavior.
> I tested a little bit, and it seems the key is to call fclose to truncate
> out-of-eof blocks. Indeed, I could get the expected i_blocks by adding open and
> close after shutdown->remount; please check v3.
> 

I'm not sure what you mean by truncate breaking existing behavior. FWIW,
you can probably get similar behavior by issuing the fsync in a
subsequent xfs_io call rather than adding the '-c fsync' to the same
xfs_io call that issues the write. This is because in most cases XFS
cleans up such preallocation on file close. Do note however that if a
file is repeatedly open-write-closed, the preallocation can stick around
longer.

> BTW, does it make sense user needs to do fclose after power-cut to reclaim such
> the preallocated blocks? I feel that XFS must reclaim them during recovery on
> mount.
> 

I'm not sure there's much we can do about this, particularly since XFS
uses physical style logging and thus it's not straightforward to tell
when log recovery is extending the bmap of a file beyond i_size. Even
then, there are cases where we can't free post-eof blocks even if we
know they exist, such as when an inode has explicit (fallocate)
preallocation.

Brian

> Thanks,
> 
> > 
> > --- a/tests/generic/391
> > +++ b/tests/generic/391
> > @@ -65,10 +65,6 @@ check_inode_metadata()
> >         _scratch_cycle_mount
> >         $XFS_IO_PROG -r -c "stat -v" $1 >$tmp.after
> >  
> > -       if [ $FSTYP = xfs ]; then
> > -               sed -i '/stat.blocks/d' $tmp.before
> > -               sed -i '/stat.blocks/d' $tmp.after
> > -       fi
> >         diff $tmp.before $tmp.after >$tmp.diff
> >  
> >         if [ "$2" = "fdatasync" ]; then
> > @@ -82,13 +78,19 @@ check_inode_metadata()
> >  }
> >  
> >  # append XX KB with f{data}sync, followed by power-cut
> > +# truncate file to the current size to avoid post-eof preallocated
> > +# blocks on XFS
> >  test_i_size()
> >  {
> > +       local len=$2
> > +       local base_len=$((4 * 1024 * 1024))
> > +       local new_len=$((base_len + len))
> >         echo "==== i_size $2 test with $1 ====" | tee -a $seqres.full
> > -       $XFS_IO_PROG -f -c "pwrite 0 4M"        \
> > -                       -c "fsync"              \
> > -                       -c "pwrite 4M $2"       \
> > -                       -c "$1"                 \
> > +       $XFS_IO_PROG -f -c "pwrite 0 $base_len"         \
> > +                       -c "fsync"                      \
> > +                       -c "pwrite $base_len $len"      \
> > +                       -c "truncate $new_len"          \
> > +                       -c "$1"                         \
> >                         $testfile >/dev/null
> >         check_inode_metadata $testfile $1
> >  }
> > @@ -108,12 +110,15 @@ test_i_time()
> >  }
> >  
> >  # punch XX KB with f{data}sync, followed by power-cut
> > +# truncate file to the current size to avoid post-eof preallocated
> > +# blocks on XFS
> >  test_punch()
> >  {
> >         echo "==== fpunch $2 test with $1 ====" | tee -a $seqres.full
> >         $XFS_IO_PROG -f -c "pwrite 0 4202496"   \
> >                         -c "fsync"              \
> > -                       -c "fpunch 4194304 $2"\
> > +                       -c "fpunch 4194304 $2"  \
> > +                       -c "truncate 4202496"   \
> >                         -c "$1"                 \
> >                         $testfile >/dev/null
> >  
> > Thanks,
> > Eryu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
