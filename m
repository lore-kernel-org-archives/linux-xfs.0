Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ABE0D7F4E
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 23:04:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9967F8F8039
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 21:03:58 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	qyaPEKoaldASaKxf for <xfs@oss.sgi.com>;
	Mon, 08 Sep 2014 21:03:56 -0700 (PDT)
Date: Tue, 9 Sep 2014 14:03:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfs: track collapse via file offset rather than
	extent index
Message-ID: <20140909040352.GC20518@dastard>
References: <1410092760-3451-1-git-send-email-bfoster@redhat.com>
	<1410092760-3451-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1410092760-3451-2-git-send-email-bfoster@redhat.com>
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
Cc: xfs@oss.sgi.com

On Sun, Sep 07, 2014 at 08:25:57AM -0400, Brian Foster wrote:
> The collapse range implementation uses a transaction per extent shift.
> The progress of the overall operation is tracked via the current extent
> index of the in-core extent list. This is racy because the ilock must be
> dropped and reacquired for each transaction according to locking and log
> reservation rules. Therefore, writeback to prior regions of the file is
> possible and can change the extent count. This changes the extent to
> which the current index refers and causes the collapse to fail mid
> operation. To avoid this problem, the entire file is currently written
> back before the collapse operation starts.
> 
> To eliminate the need to flush the entire file, use the file offset
> (fsb) to track the progress of the overall extent shift operation rather
> than the extent index. Modify xfs_bmap_shift_extents() to
> unconditionally convert the start_fsb parameter to an extent index and
> return the file offset of the extent where the shift left off, if
> further extents exist. The bulk of ths function can remain based on
> extent index as ilock is held by the caller. xfs_collapse_file_space()
> now uses the fsb output as the starting point for the subsequent shift.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good. There's a couple of small things I noticed, but
they aren't worth redoing the patches again to fix.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
