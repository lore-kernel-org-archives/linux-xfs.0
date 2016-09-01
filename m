Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 26ACF7CA2
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 16:34:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 890F0AC001
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 14:34:10 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	l2Ak94q1tBVfQ39f for <xfs@oss.sgi.com>;
	Thu, 01 Sep 2016 14:34:04 -0700 (PDT)
Date: Fri, 2 Sep 2016 07:34:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/13] xfs: fix $XFS_DB_PROG usage
Message-ID: <20160901213400.GW22388@dastard>
References: <147216769914.32641.55434969009554013.stgit@birch.djwong.org>
	<147216773738.32641.691363173215857168.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147216773738.32641.691363173215857168.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, eguan@redhat.com, fstests@vger.kernel.org, xfs@oss.sgi.com

On Thu, Aug 25, 2016 at 04:28:57PM -0700, Darrick J. Wong wrote:
> xfs_db requires us to pass in the log device, if any; this can be
> accomplished via _scratch_xfs_db_options (if we're operating on the
> scratch device, anyway).  However, many of the tests/xfs/ scripts
> pass only $SCRATCH_DEV directly, so they'll fail if we test with an
> external log.  So, fix that.

I hadn't looked at this until now, but....

> diff --git a/tests/xfs/001 b/tests/xfs/001
> index c33adae..e1e1411 100755
> --- a/tests/xfs/001
> +++ b/tests/xfs/001
> @@ -44,11 +44,11 @@ _do_bit_test()
>  	bits="$2"
>  
>  	echo "testing $field with $bits bits"
> -	$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write $field 0" $SCRATCH_DEV
> +	$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write $field 0" `_scratch_xfs_db_options`

*yuck*

We are going to be getting that wrong -all the time-.

I'd suggest changing these to

	_scratch_xfs_db <command string>

and

_scratch_xfs_db()
{
	$XFS_DB_PROG $* `_scratch_xfs_db_options`
}

And hiding everything to do with devices completely i a much cleaner
and more maintainable solution to the problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
