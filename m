Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 662477F4E
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 20:27:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5210330404E
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 18:27:05 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ZpBOvdCh0WOORy22 for <xfs@oss.sgi.com>;
	Mon, 22 Sep 2014 18:27:00 -0700 (PDT)
Date: Tue, 23 Sep 2014 11:26:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] generic/032: add xfs unwritten extent data corruption
	reproducer
Message-ID: <20140923012656.GP4267@dastard>
References: <1411414836-64598-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1411414836-64598-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Mon, Sep 22, 2014 at 03:40:36PM -0400, Brian Foster wrote:
> XFS had a data corruption problem where writeback of pages to unwritten
> extents would fail to run unwritten extent conversion at I/O completion.
> This causes subsequent reads of written, but unconverted regions to
> return zeroes. This occurs on sub-page block size filesystems when
> writeback contends for the inode lock (e.g., with a file writer).
> 
> Add a test that creates the conditions to reproduce the data corruption
> and detect it by looking for unwritten extents after all said extents
> have been overwritten.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

I still think the error handling for the unwritten extent case is
wrong. Failure debug is exactly what $seqres.full is for, so that's
where failure information should go. If we detect a failure case
and have to abort immediately, then _fail() should be used. And
_fail() leaves a message to look at $seqres.full for details.

So:

> +	# Check for unwritten extents. We should have none since we wrote over
> +	# the entire preallocated region and ran fsync.
> +	$XFS_IO_PROG \
> +		-c "fiemap -v" \
> +		$SCRATCH_MNT/file | _filter_fiemap | \
> +		grep unwritten >> $seqres.full 2>&1
> +	if [ $? == 0 ]; then
> +		# data corruption! dump the extent list and break out to dump
> +		# the file content
> +		$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/file
> +		break
> +	fi

Can simply be:

	$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/file | \
		tee -a $seqres.full | \
		filter_fiemap | grep unwritten
	[ $? == 0 ] && _fail "Unwritten extents found!"

and will result in the output:

generic/032  0s.... [failed, exit status 1] - output mismatch (see ....results/generic/032.bad)

And results/generic/032.bad will contain:

....
Unwritten extents found!
(see ..../results/generic/032.full for details)

And the complete fiemap output will be in results/generic/032.full.

> +done
> +
> +echo $iters iterations
> +
> +kill $syncpid
> +wait
> +
> +# clear page cache and dump the file
> +_scratch_remount
> +hexdump $SCRATCH_MNT/file
> +
> +_scratch_unmount

No need to unmount. check does that when checking the filesystem,
and if not the next _require_scratch call will do it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
