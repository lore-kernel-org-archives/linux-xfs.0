Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 71A9E7F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 13:54:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ED08EAC003
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 11:54:25 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Xe9euBoDyMRBLeHz for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 11:54:23 -0800 (PST)
Date: Wed, 26 Feb 2014 06:54:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests: add test for btrfs-progs restore feature
Message-ID: <20140225195420.GX13647@dastard>
References: <1393352816-26065-1-git-send-email-fdmanana@gmail.com>
	<1393353848-26790-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393353848-26790-1-git-send-email-fdmanana@gmail.com>
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
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Feb 25, 2014 at 06:44:08PM +0000, Filipe David Borba Manana wrote:
> This is a regression test to verify that the restore feature of btrfs-progs
> is able to correctly recover files that have compressed extents, specially when
> the respective file extent items have a non-zero data offset field.
> 
> This issue is fixed by the following btrfs-progs patch:
> 
>     Btrfs-progs: fix restore of files with compressed extents
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
....
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15

here=`pwd`

> +
> +_cleanup()
> +{
> +    rm -fr $tmp
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +_need_to_be_root
> +
> +rm -f $seqres.full
> +
> +test_btrfs_restore()
> +{
> +	if [ -z $1 ]
> +	then
> +		OPTIONS=""
> +	else
> +		OPTIONS="-o compress-force=$1"
> +	fi
> +	_scratch_mkfs >/dev/null 2>&1
> +	_scratch_mount $OPTIONS
> +
> +	$XFS_IO_PROG -f -c "pwrite -S 0xff -b 100000 0 100000" \
> +		$SCRATCH_MNT/foo | _filter_xfs_io
> +
> +	# Ensure a single file extent item is persisted.
> +	_run_btrfs_util_prog filesystem sync $SCRATCH_MNT

What's the difference here between "sync" and the command run above?
Unless there's some specific reason for using the above command (and
that needs to be commented), I think that sync(1) should be used
instead in all tests.

Indeed, why a separate command - just adding a "-c fsync" to the
xfs_io command, or even -s to make it open the file O_SYNC should do
what you need without needing a specific sync command....


> +
> +	$XFS_IO_PROG -c "pwrite -S 0xaa -b 100000 100000 100000" \
> +		$SCRATCH_MNT/foo | _filter_xfs_io
> +
> +	# Now ensure a second one is created (and not merged with previous one).
> +	_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
> +
> +	# Make the extent item be split into several ones, each with a data
> +	# offset field != 0
> +	$XFS_IO_PROG -c "pwrite -S 0x1e -b 2 10000 2" $SCRATCH_MNT/foo \
> +		| _filter_xfs_io
> +	$XFS_IO_PROG -c "pwrite -S 0xd0 -b 11 33000 11" $SCRATCH_MNT/foo \
> +		| _filter_xfs_io
> +	$XFS_IO_PROG -c "pwrite -S 0xbc -b 100 99000 100" $SCRATCH_MNT/foo \
> +		| _filter_xfs_io
> +
> +	md5sum $SCRATCH_MNT/foo | _filter_scratch

So you are doing this with first having "persisted" the new extents.
Seems kind of strange that you need to persist some and not
others...

> +	_scratch_unmount
> +	_check_scratch_fs

_check_scratch_fs should be unmounting the SCRATCH_DEV itself
internally. If it's not doing that for btrfs, then the btrfs check
code needs fixing. ;)

> +
> +	_run_btrfs_util_prog restore $SCRATCH_DEV $tmp
> +	md5sum $tmp/foo | cut -d ' ' -f 1

What, exactly, are you restoring to /tmp/$$? Does this assume that
/tmp is a btrfs filesystem? If so, that is an invalid assumption -
/tmp can be any type of filesystem at all.

It's also wrong to use $tmp like this....

> +}
> +
> +mkdir $tmp
> +echo "Testing restore of file compressed with lzo"
> +test_btrfs_restore "lzo"
> +echo "Testing restore of file compressed with zlib"
> +test_btrfs_restore "zlib"
> +echo "Testing restore of file without any compression"
> +test_btrfs_restore

Yup, using $tmp like this is definitely wrong. $tmp is really for test
harness files and test logs, not for *test data*. TEST_DIR is what you
should be using here, not $tmp.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
