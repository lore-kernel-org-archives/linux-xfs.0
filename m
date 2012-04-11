Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3BMpde7123752 for <xfs@oss.sgi.com>; Wed, 11 Apr 2012 17:51:40 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	3Ps5DlscB8HLuBdi for <xfs@oss.sgi.com>;
	Wed, 11 Apr 2012 15:51:37 -0700 (PDT)
Date: Thu, 12 Apr 2012 08:51:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: kill XBF_LOCK
Message-ID: <20120411225132.GV18323@dastard>
References: <1334052213-26870-1-git-send-email-david@fromorbit.com>
	<1334052213-26870-2-git-send-email-david@fromorbit.com>
	<4F844B02.2030301@sgi.com> <20120410222027.GR18323@dastard>
	<20120411200729.GJ28816@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120411200729.GJ28816@infradead.org>
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
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Wed, Apr 11, 2012 at 04:07:29PM -0400, Christoph Hellwig wrote:
> On Wed, Apr 11, 2012 at 08:20:27AM +1000, Dave Chinner wrote:
> > > The reason I ask, the sources that I have for xfs_buf_get() seems to
> > > still have a "goto no_buffer" for the failed
> > > xfs_buf_allocate_memory() call and this patch removes that call. I
> > > did not find anything in the 8 buf clean-up series that would alter
> > > this area.
> > 
> > I'm sure I posted it previously. Let me update all the reviewed-by
> > tags and I'll resend the entire series....
> 
> I think Mark meant the patch to fix the error handling for failed
> allocation, which needs to be redone to only insert the buffer into the
> rbtree once it's fully set up.

Right. What I meant was that I need to resend the entire 12-13
buffer cache patches I have in my queue right now so that they
should all apply easily...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
