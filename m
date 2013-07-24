Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0B71C7CBF
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 18:58:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 97548304077
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 16:58:20 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	IHJqicgNDhI0SHW2 for <xfs@oss.sgi.com>;
	Wed, 24 Jul 2013 16:58:18 -0700 (PDT)
Date: Thu, 25 Jul 2013 09:57:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: 091, 240,
	268 fix for xfs on 4k sector hard drive
Message-ID: <20130724235739.GR19986@dastard>
References: <20130724143208.34b77534@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130724143208.34b77534@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 24, 2013 at 02:32:08PM -0400, Dwight Engen wrote:
> Tests 091,240, and 268 are failing on my 4k sector hard disk. The dio writes
> from fsx and aiodio_sparse2 are failing on xfs with EINVAL which is returned
> from the check at the top of xfs_file_dio_aio_write().
> 
> The fix is to use blockdev -getpbsz to get the physical sector size instead
> of the logical sector size. This makes 091 and 268 work. 240 will not run
> on a 4k drive since fs block size == device block size. Tested against
> xfs,ext4, and btrfs.

What's the logical sector size of the drive? If it's 4k, then
blockdev --getss should be returning 4k. If it's not, then either
the drive is reporting that it supports 512 bytes sectors when it
doesn't (i.e. the drive is broken) or blockdev is returning the
wrong information (i.e. blockdev is broken)....

What does mkfs.xfs output on that device?

>  rm -f $TEST_DIR/aiodio_sparse
>  
> -logical_block_size=`blockdev --getss $TEST_DEV`
> +logical_block_size=`blockdev --getpbsz $TEST_DEV`

FWIW, that doesn't make much sense - putting the physical block size
into a variable named "logical_block_size".....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
