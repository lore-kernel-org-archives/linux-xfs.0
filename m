Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0GGon5t104176 for <xfs@oss.sgi.com>; Mon, 16 Jan 2012 10:50:50 -0600
Message-ID: <4F145569.5020007@sgi.com>
Date: Mon, 16 Jan 2012 10:50:49 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/8] xfstests: use preallocation for ag-wiper
References: <1321875088-30801-1-git-send-email-david@fromorbit.com>
	<1321875088-30801-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1321875088-30801-5-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 01/-10/63 13:59, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> To enable sane testing of large scale filesystems, the --large-fs
> test option uses xfs_db magic to mark AGs full without doing any IO.
> This leaves only a small amount of free space left in the filesystem
> to stress the high AGs of the filesystem rather than the low AGs.
>
> This method requires us to have special filesystem check options to
> avoid free space checking in xfs_check, and we cannot current run
> xfs_repair on such a filesystem at all. As it is, free space
> checking on xfs_check does not scale, so we still need to avoid this
> checking regardless of how we fill the filesystem.
>
> We can acheive exactly the same fill behaviour by preallocating a
> single large file in the filesystem immediately after creating it.
> This is a filesystem independent manner of filling the filesystem,
> and allows us to do large filesystem testing on more than just XFS.
>
> Further, this preallocation method effectively adds a new "very
> large file" test. It also enables us to run an unmodified xfs_repair
> or filesystem specific fsck program to check the filesystem for
> sanity, so we can now do full sanity checking of such large
> filesystems.
>
...
> +_setup_large_xfs_fs()
> +{
> +	fs_size=$1
> +	local tmp_dir=/tmp/
> +
> +	[ "$LARGE_SCRATCH_DEV" != yes ]&&  return 0
> +	[ -z "$SCRATCH_DEV_EMPTY_SPACE" ]&&  SCRATCH_DEV_EMPTY_SPACE=0
> +	[ $SCRATCH_DEV_EMPTY_SPACE -ge $fs_size ]&&  return 0
> +
> +	# calculate the size of the file we need to allocate.
> +	# Default free space in the FS is 50GB, but you can specify more via
> +	# SCRATCH_DEV_EMPTY_SPACE
> +	file_size=$(($fs_size - 50*1024*1024*1024))
> +	file_size=$(($file_size - $SCRATCH_DEV_EMPTY_SPACE))

Should SCRATCH_DEV_EMPTY_SPACE variable be documented in the usage output?

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
