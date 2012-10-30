Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UJ1pps066544 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 14:01:51 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	EKjxYDjQumiKt34l for <xfs@oss.sgi.com>;
	Tue, 30 Oct 2012 12:03:40 -0700 (PDT)
Date: Tue, 30 Oct 2012 11:45:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/25] xfs: make buffer read verication an IO completion
	function
Message-ID: <20121030004546.GW29378@dastard>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-4-git-send-email-david@fromorbit.com>
	<20121030002916.GE30227@caliban.engr.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121030002916.GE30227@caliban.engr.sgi.com>
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
To: Phil White <pwhite@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Oct 29, 2012 at 05:29:17PM -0700, Phil White wrote:
> On Thu, Oct 25, 2012 at 05:33:52PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Add a verifier function callback capability to the buffer read
> > interfaces.  This will be used by the callers to supply a function
> > that verifies the contents of the buffer when it is read from disk.
> > This patch does not provide callback functions, but simply modifies
> > the interfaces to allow them to be called.
> > 
> > The reason for adding this to the read interfaces is that it is very
> > difficult to tell fom the outside is a buffer was just read from
> > disk or whether we just pulled it out of cache. Supplying a callbck
> > allows the buffer cache to use it's internal knowledge of the buffer
> > to execute it only when the buffer is read from disk.
> > 
> > It is intended that the verifier functions will mark the buffer with
> > an EFSCORRUPTED error when verification fails. This allows the
> > reading context to distinguish a verification error from an IO
> > error, and potentially take further actions on the buffer (e.g.
> > attempt repair) based on the error reported.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
......
> This is OK with me so far, but I have comments on some of the callbacks.

/me looks around, doesn't find anything...

The comments must be elsewhere. ;)

BTW, Phil, can you trim away all the bits of the patch you aren't
commenting on? Having to scroll through hundreds of lines of quoted
email to find your replies is a little slow, and it's quite easy to
miss comments when they are widely spread apart. Most people just
quote the patch hunk they are making the comment about to avoid this
problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
