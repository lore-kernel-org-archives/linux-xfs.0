Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9BLoUdD244944 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 16:50:30 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	BeYZejYxi3Fgnn1p for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 14:52:01 -0700 (PDT)
Date: Fri, 12 Oct 2012 08:52:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/19] xfs: verify AGFL blocks as they are read from disk
Message-ID: <20121011215200.GG2739@dastard>
References: <1349754670-32009-1-git-send-email-david@fromorbit.com>
	<1349754670-32009-8-git-send-email-david@fromorbit.com>
	<20121011214421.GG6346@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121011214421.GG6346@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Oct 11, 2012 at 05:44:21PM -0400, Christoph Hellwig wrote:
> On Tue, Oct 09, 2012 at 02:50:58PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Add an AGFL block verify callback function and pass it into the
> > buffer read functions. Add a debug only check for valid block
> > numbers in the AGFL.
> 
> The check isn't executed only for debug builds, but rather all
> the time.  I'm not sure that this actually is a good idea.

RIght, I need to update the commit message to indicate that the
debug only checks are being made unconditional. That is, we're going
to detect the AGFL being invalid on production systems now.

Realistically, I'd much prefer that we have more robust verification
of on-disk structures when we pull them into memory regardless of
CRC functionality. We don't verify the AGFL at all, and given that
it generally stays resident in memory, a small amount of iextra
overhead when they are read isn't going to be noticable.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
