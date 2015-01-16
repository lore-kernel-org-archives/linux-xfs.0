Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 85C097F4E
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2015 01:30:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5440B304032
	for <xfs@oss.sgi.com>; Thu, 15 Jan 2015 23:30:29 -0800 (PST)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34]) by
	cuda.sgi.com with ESMTP id RnCSEZENEmorsufm (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Jan 2015 23:30:26 -0800 (PST)
Received: from epcpsbgr5.samsung.com
	(u145.gpu120.samsung.co.kr [203.254.230.145])
	by mailout4.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0NI900JOSE6PNH40@mailout4.samsung.com> for
	xfs@oss.sgi.com; Fri, 16 Jan 2015 16:30:25 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
References: <1421165126-3585-1-git-send-email-linkinjeon@gmail.com>
	<1421165126-3585-10-git-send-email-linkinjeon@gmail.com>
	<20150114201710.GB49511@bfoster.bfoster>
	<004301d030ac$0ad62960$20827c20$@samsung.com>
	<20150115122831.GA18876@bfoster.bfoster>
In-reply-to: <20150115122831.GA18876@bfoster.bfoster>
Subject: RE: [PATCH v8 9/11] xfstests: generic/043: Test multiple fallocate
	insert/collapse range calls
Date: Fri, 16 Jan 2015 16:30:24 +0900
Message-id: <005301d0315e$4af0db50$e0d291f0$@samsung.com>
MIME-version: 1.0
Content-language: ko
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
To: 'Brian Foster' <bfoster@redhat.com>
Cc: 'Namjae Jeon' <linkinjeon@gmail.com>, tytso@mit.edu, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

> On Thu, Jan 15, 2015 at 07:14:26PM +0900, Namjae Jeon wrote:
> >
> > > > +_require_scratch
> > > > +_require_xfs_io_command "fiemap"
> > > > +_require_xfs_io_command "finsert"
> > > > +_require_xfs_io_command "fcollapse"
> > > > +_do_die_on_error=y
> > >
> > > What is _do_die_on_error for? Seems like that's only relevant for using
> > > _do()?
> > >
> > > > +src=$SCRATCH_MNT/testfile
> > > > +dest=$SCRATCH_MNT/testfile.dest
> > > > +BLOCKS=100
> > > > +BSIZE=`get_block_size $SCRATCH_MNT`
> > > > +
> > >
> > > rm -f $seqres.full
> > >
> > > ... to clear out the old .full file.
> > >
> > > > +_scratch_mkfs MKFS_OPTIONS >> $seqres.full 2>&1
> > >
> > > You don't need MKFS_OPTIONS here. In fact, this currently causes a mkfs
> > > failure (missing $) that we don't detect because we aren't checking that
> > > the mkfs actually succeeds. All we need to do here is:
> > >
> > > _scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
> > >
> > > If you dig down into _scratch_mkfs(), you'll see that it already
> > > includes $MKFS_OPTIONS and thus formats the fs as specified by the test
> > > config.
> > >
> > > It might also be a good idea to check that the _scratch_mount below
> > > succeeds as well...
> > >
> > > > +_scratch_mount >> $seqres.full 2>&1
> > > > +length=$(($BLOCKS * $BSIZE))
> > > > +
> > > > +# Write file
> > > > +$XFS_IO_PROG -f -c "pwrite 0 $length" -c fsync $src > /dev/null
> > > > +cp $src $dest
> > > > +
> > >
> > > It seems quite unlikely for this to not create a single extent given the
> > > smallish file size and freshly created fs, but who knows with various fs
> > > types, test configurations, test device sizes, etc. Another option could
> > > be to check the starting extent count and verify the ending extent count
> > > matches, rather than assume hardcoded values of 1.
> > >
> > > To be honest, even just including the starting extent count in the
> > > golden output (e.g., add an fiemap command here as well) might be good
> > > enough to distinguish that failure path from something going wrong in
> > > the collapse path, should it ever occur.
> > >
> > > > +# Insert alternate blocks
> > > > +for (( j=0; j < $(($BLOCKS/2)); j++ )); do
> > > > +	offset=$((($j*$BSIZE)*2))
> > > > +	$XFS_IO_PROG -c "finsert $offset $BSIZE" $dest > /dev/null
> > > > +done
> > > > +
> > > > +# Check if 100 extents are present
> > > > +$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l
> > > > +
> > > > +_check_scratch_fs
> > > > +if [ $? -ne 0 ]; then
> > > > +	status=1
> > > > +	exit
> > > > +fi
> > > > +
> > > > +# Collapse alternate blocks
> > > > +for (( j=0; j < $(($BLOCKS/2)); j++ )); do
> > > > +	offset=$((($j*$BSIZE)))
> > > > +	$XFS_IO_PROG -c "fcollapse $offset $BSIZE" $dest > /dev/null
> > > > +done
> > > > +
> > > > +# Check if 1 extents are present
> > > > +$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l
> > > > +
> > > > +# compare original file and test file.
> > > > +cmp $src $dest || _fail "file bytes check failed"
> > > > +
> > > > +_check_scratch_fs
> > > > +if [ $? -ne 0 ]; then
> > > > +	status=1
> > > > +	exit
> > > > +fi
> > > > +
> > > > +umount $SCRATCH_MNT
> > > > +
> > >
> > > The scratch device is unmounted and checked after each test that uses it
> > > so the above is unnecessary.
> > I checked your each review points. and updated patch.
> >
> > Could you please review below patch ?
> > Thanks a lot!
> >
> > ------------------------------------------------------------------------------
> > Subject: [PATCH v9 9/11] xfstests: generic/043: Test multiple fallocate
> >  insert/collapse range calls
> >
> > This testcase(043) tries to test finsert range a single alternate block
> > mulitiple times and test merge code of collase range.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > ---
> >  tests/generic/043     |   96 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/043.out |    2 +
> >  tests/generic/group   |    1 +
> >  3 files changed, 99 insertions(+), 0 deletions(-)
> >  create mode 100644 tests/generic/043
> >  create mode 100644 tests/generic/043.out
> >
> > diff --git a/tests/generic/043 b/tests/generic/043
> > new file mode 100644
> > index 0000000..a6f91ce
> > --- /dev/null
> > +++ b/tests/generic/043
> > @@ -0,0 +1,96 @@
> > +#! /bin/bash
> > +# FS QA Test No. generic/043
> > +#
> > +# Test multiple fallocate insert/collapse range calls on same file.
> > +# Call insert range a single alternate block multiple times until the file
> > +# is left with 100 extents and as much number of extents. And Call collapse
> > +# range about the previously inserted ranges to test merge code of collapse
> > +# range. Also check for data integrity and file system consistency.
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2014 Samsung Electronics.  All Rights Reserved.
> > +#
> > +# This program is free software; you can redistribute it and/or
> > +# modify it under the terms of the GNU General Public License as
> > +# published by the Free Software Foundation.
> > +#
> > +# This program is distributed in the hope that it would be useful,
> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +# GNU General Public License for more details.
> > +#
> > +# You should have received a copy of the GNU General Public License
> > +# along with this program; if not, write the Free Software Foundation,
> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > +#
> > +#-----------------------------------------------------------------------
> > +#
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_fs generic
> > +_supported_os Linux
> > +
> > +_require_scratch
> > +_require_xfs_io_command "fiemap"
> > +_require_xfs_io_command "finsert"
> > +_require_xfs_io_command "fcollapse"
> > +_do_die_on_error=always
> 
> Still not sure what the above is for, but otherwise this one looks fine
> to me:
Yes, It is not needed. I will remove it when I resend total patct-set.
Thanks!
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > +src=$SCRATCH_MNT/testfile
> > +dest=$SCRATCH_MNT/testfile.dest
> > +BLOCKS=100
> > +BSIZE=`get_block_size $SCRATCH_MNT`
> > +rm -f $seqres.full
> > +
> > +_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
> > +_scratch_mount || _fail "mount failed"
> > +length=$(($BLOCKS * $BSIZE))
> > +
> > +# Write file
> > +_do "$XFS_IO_PROG -f -c \"pwrite 0 $length\" -c fsync $src"
> > +cp $src $dest
> > +extent_before=`$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l`
> > +
> > +# Insert alternate blocks
> > +for (( j=0; j < $(($BLOCKS/2)); j++ )); do
> > +	offset=$((($j*$BSIZE)*2))
> > +	_do "$XFS_IO_PROG -c \"finsert $offset $BSIZE\" $dest"
> > +done
> > +
> > +# Check if 100 extents are present
> > +$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l
> > +
> > +_check_scratch_fs
> > +if [ $? -ne 0 ]; then
> > +	status=1
> > +	exit
> > +fi
> > +
> > +# Collapse alternate blocks
> > +for (( j=0; j < $(($BLOCKS/2)); j++ )); do
> > +	offset=$((($j*$BSIZE)))
> > +	_do "$XFS_IO_PROG -c \"fcollapse $offset $BSIZE\" $dest"
> > +done
> > +
> > +extent_after=`$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l`
> > +if [ $extent_before -ne $extent_after ]; then
> > +	echo "extents mismatched before = $extent_before after = $extent_after"
> > +fi
> > +
> > +# compare original file and test file.
> > +cmp $src $dest || _fail "file bytes check failed"
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/043.out b/tests/generic/043.out
> > new file mode 100644
> > index 0000000..28427c5
> > --- /dev/null
> > +++ b/tests/generic/043.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 043
> > +100
> > diff --git a/tests/generic/group b/tests/generic/group
> > index c0944b3..0a10bdd 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -45,6 +45,7 @@
> >  040 auto quick prealloc
> >  041 auto quick prealloc
> >  042 auto quick prealloc
> > +043 auto quick prealloc
> >  053 acl repair auto quick
> >  062 attr udf auto quick
> >  068 other auto freeze dangerous stress
> > --
> > 1.7.7
> >
> >

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
