Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3AMKW6t238247 for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 17:20:32 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	OnfSLsbNAt0HDCfw for <xfs@oss.sgi.com>;
	Tue, 10 Apr 2012 15:20:30 -0700 (PDT)
Date: Wed, 11 Apr 2012 08:20:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: kill XBF_LOCK
Message-ID: <20120410222027.GR18323@dastard>
References: <1334052213-26870-1-git-send-email-david@fromorbit.com>
	<1334052213-26870-2-git-send-email-david@fromorbit.com>
	<4F844B02.2030301@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F844B02.2030301@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 10, 2012 at 10:00:18AM -0500, Mark Tinguely wrote:
> On 04/10/12 05:03, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >Buffers are always returned locked from the lookup routines. Hence
> >we don't need to tell the lookup routines to return locked buffers,
> >on to try and lock them. Remove XBF_LOCK from all the callers and
> >from internal buffer cache usage.
.....
> >-no_buffer:
> >-	if (flags&  (XBF_LOCK | XBF_TRYLOCK))
> >-		xfs_buf_unlock(bp);
> >-	xfs_buf_rele(bp);
> >-	return NULL;
> >  }
> 
> 
> Do you have a new copy of the "xfs: fix buffer lookup race on
> allocation failure" patch. It would go about here in the sources.
> 
> The reason I ask, the sources that I have for xfs_buf_get() seems to
> still have a "goto no_buffer" for the failed
> xfs_buf_allocate_memory() call and this patch removes that call. I
> did not find anything in the 8 buf clean-up series that would alter
> this area.

I'm sure I posted it previously. Let me update all the reviewed-by
tags and I'll resend the entire series....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
