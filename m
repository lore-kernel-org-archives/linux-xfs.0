Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qANLPwxM119344 for <xfs@oss.sgi.com>; Fri, 23 Nov 2012 15:25:58 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	6jZotcFEscrQsQdg for <xfs@oss.sgi.com>;
	Fri, 23 Nov 2012 13:28:08 -0800 (PST)
Date: Sat, 24 Nov 2012 08:27:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/32] xfs: make growfs initialise the AGFL header
Message-ID: <20121123212750.GK32450@dastard>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-9-git-send-email-david@fromorbit.com>
	<20121123124119.GC12150@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121123124119.GC12150@infradead.org>
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

On Fri, Nov 23, 2012 at 07:41:19AM -0500, Christoph Hellwig wrote:
> On Mon, Nov 12, 2012 at 10:54:00PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > For verification purposes, AGFLs need to be initialised to a known
> > set of values. For upcoming CRC changes, they are also headers that
> > need to be initialised. Currently, growfs does neither for the AGFLs
> > - it ignores them completely. Add initialisation of the AGFL to be
> > full of invalid block numbers (NULLAGBLOCK) to put the
> > infrastructure in place needed for CRC support.
> > 
> > Includes a comment clarification from Jeff Liu.
> 
> Looks good.
> 
> If you plan to touch this code even more I'd suggst splitting out a
> helper for each kinda of block / header that is initialized from
> xfs_growfs_data_private.

I thought about doing that, but in the end I wanted to avoid
structural changes as much as possible. As it is, I do need to touch
bits of it for the CRC code - refactoring it will involve rebasing
several patches though... :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
