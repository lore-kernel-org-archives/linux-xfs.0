Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2RKmGbj168284 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 15:48:17 -0500
Date: Tue, 27 Mar 2012 15:48:25 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 7/8] xfs: fix fstrim offset calculations
Message-ID: <20120327204825.GB7762@sgi.com>
References: <1332393313-1955-1-git-send-email-david@fromorbit.com>
	<1332393313-1955-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1332393313-1955-8-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 22, 2012 at 04:15:12PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_ioc_fstrim() doesn't treat the incoming offset and length
> correctly. It treats them as a filesystem block address, rather than
> a disk address. This is wrong because the range passed in is a
> linear representation , while the filesystem block address notiation
> is a sparse representation. Hence we cannot convert the range direct
> to filesystem block units and then use that for calculating the
> range to trim.
> 
> While this sounds dangerous, the problem is limited to calculting
> what AGs need to be trimmed. The code that calcuates the actual
> ranges to trim gets the right result (i.e. only ever discards free
> space), even though it uses the wrong ranges to limit what is
> trimmed. Hence this is not a bug that endangers user data.

Yep, I can see that the calculation of what we pass to blkdev_issue_discard()
is correct and always a free extent.  I am having a hard time seeing the
problem related to calculating which AGs to trim.  Can you give an example?

> Fix this by treating the range as a disk address range and use the
> appropriate functions to convert the range into the desired formats
> for calculations.
> 
> Further, fix the first free extent lookup (the longest) to actually
> find the largest free extent. Currently this lookup uses a <=
> lookup, which results in finding the extent to the left of the
> largest because we can never get an exact match on the largest
> extent. This is due to the fact that while we know it's size, we
> don't know it's location and so the exact match fails and we move
> one record to the left to get the next largest extent. Instead, use
> a >= search so that the lookup returns the largest extent regardless
> of the fact we don't get an exact match on it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
