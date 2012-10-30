Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9ULGTsw073264 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 16:16:29 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	1QDlLHMyWS20lola for <xfs@oss.sgi.com>;
	Tue, 30 Oct 2012 14:18:17 -0700 (PDT)
Date: Wed, 31 Oct 2012 08:18:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] 289: Test that filesystem sends discard requests
	only on free sectors
Message-ID: <20121030211815.GZ29378@dastard>
References: <1350549946-17192-1-git-send-email-tracek@redhat.com>
	<1350549946-17192-3-git-send-email-tracek@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1350549946-17192-3-git-send-email-tracek@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Tomas Racek <tracek@redhat.com>
Cc: lczerner@redhat.com, xfs@oss.sgi.com

On Thu, Oct 18, 2012 at 10:45:46AM +0200, Tomas Racek wrote:
> This is done by comparing free sectors reported by some FS utility
> (dumpe2fs/xfs_db) and actual discard commands sent to device obtained
> via blk tracer in debugfs.
> 
> Currently supported FS are ext[34], xfs; device with discard support is
> not required, the test creates loop device for this purpose.
....
> +mkfs_loop()
> +{
> +	if [ $FSTYP = "xfs" ]; then
> +		MKFS_OPTIONS="-f $MKFS_OPTIONS"
> +	fi
> +
> +	$MKFS_PROG -t $FSTYP $MKFS_OPTIONS $loop_dev &> /dev/null

You don't need the "-t $FSTYP" here - the mkfs program is already
set to the specific filesytem type beign tested, anyway.

> +get_block_size()
> +{
> +	case $FSTYP in
> +	ext[34])
> +		bsize=$($DUMPE2FS_PROG $loop_dev 2>&1 | sed -n '/^Block size/ s/.*: *\(.*\)/\1/p')
> +	;;
> +	xfs)
> +		$UMOUNT_PROG $loop_mnt
> +		bsize=$($XFS_DB_PROG -c "sb" -c"p" $loop_dev | sed -n 's/^blocksize = \([0-9]\+\).*/\1/p')
> +		$MOUNT_PROG $loop_dev $loop_mnt

block size is returned by stat(1). No need for filesystem specific
methods to get this. e.g.:

$ stat -c %o foo
4096
$


> +get_free_sectors()
> +{
> +	case $FSTYP in
> +	ext[34])
> +		size=1
> +		clstsize=$($DUMPE2FS_PROG $loop_dev 2>/dev/null | sed '/Cluster size/!d; s/.*: *//')
> +		if [ -n "$clstsize" ]; then
> +			size=$((clstsize/bsize))
> +		fi
> +		$DUMPE2FS_PROG $loop_dev 2>/dev/null | sed '/  Free blocks/!d; s/.*: //; s/, /\n/g; /^$/d' | \
> +			$AWK_PROG -v spb=$spb -v size=$size 'BEGIN{FS="-"}; {printf "%d-%d\n", spb * $1, (spb * $2 == 0)? spb * ($1 + size) - 1 : spb * ($2 + size) - 1}' > $free_sectors

Lines are way too long, and this needs some comments to explain what
the line noise is calculatiing. And what is "$spb"?

> +	;;
> +	xfs)
> +		$UMOUNT_PROG $loop_mnt
> +		agblocks=$($XFS_DB_PROG -c"sb" -c "p" $loop_dev | sed -n 's/agblocks = \(.*\)$/\1/p')

xfs_info | mkfs_filter > /dev/null 2> $tmp.info
. $tmp.info

and the number of blocks in an AG is now in $agsize.

> +		$XFS_DB_PROG -c"freesp -d" $loop_dev
>
> | $AWK_PROG '{if($1 == "from") exit; else print}' | \
> +			$AWK_PROG -v agb=$agblocks -v spb=$spb '{print spb * ($1 * agb + $2) "-" spb * ($1 * agb + $2 + $3) - 1}' | sort -n > $free_sectors
> +		$MOUNT_PROG $loop_dev $loop_mnt

These need to be line wrapped to fit within roughly 80 columns.
Also, some comments about that all this line noise is calculating
would be handy for us to determine if it is correct and reliable...


> +	;;
>
>
> +	esac
> +}
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.config
> +
> +# real QA test starts here
> +
> +_supported_fs ext3 ext4 xfs
> +_supported_os Linux
> +_require_fstrim
> +_require_dumpe2fs

Not for XFS.

> +_require_fs_space $TEST_DIR 3145728

So requires 3GB of space? That will fail on all my test devices.
If you need this much space, then please use the scratch device.

> +
> +debugfs=$($MOUNT_PROG | grep debugfs | cut -d " " -f3)
> +[ -n $debugfs ] || _notrun "This test requires mounted debugfs"
> +
> +cat $debugfs/tracing/available_tracers | grep -q blk || _notrun "blk tracer is not available"

_require_tracer
_require_blk_tracer

> +free_sectors=$tmp/sectors
> +trace=$tmp/trace
> +
> +echo -n "Obtaining free sectors from FS..."
> +get_free_sectors
> +echo "done."
> +
> +echo -n "Running fstrim & trace..."
> +echo 1 > /sys/block/$loop_base/trace/enable
> +echo blk > $debugfs/tracing/current_tracer
> +echo > $debugfs/tracing/trace
> +echo 1 > $debugfs/tracing/tracing_on

This trace+trim operations set should be done in a function...

> +
> +$FSTRIM_PROG $loop_mnt > /dev/null
> +
> +cat $debugfs/tracing/trace | grep "\[fstrim\]"  | cut -d ":" -f2- |
> +$AWK_PROG '$3 == "D"' |  		   # Filter discard operation
> +$AWK_PROG '{print $4 "-" $4 + $6 - 1}' | # Transform (start, length) => (start, end)
> +sort -n > $trace

The moment the trace output format changes, this will break.  Also,
just cat-ing from $debugfs/tracing/trace is unreliable and can skip
events (because it is slow) and if the trace buffer overflows,
events will also be missed. Hence I don't think this is a reliable
way to capture where free space is supposed to be in the underlying
file.

Better, IMO, is to preallocate the image file, then run fiemap on it
after the fact to find all the holes that were punched by the
discard operations. That way you actually test the loop device
discard implementation, as well as confirming that fstrim only
discards free space.

With this, you don't even need to to dump free space from the
filesystem prior to issuing fstrim - all you need to do is confirm
that there is a hole in the file covering each free space extent.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
