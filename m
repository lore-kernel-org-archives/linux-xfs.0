Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TM78tZ199521 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 17:07:08 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	9RbZtHNgQfyREqep for <xfs@oss.sgi.com>;
	Thu, 29 Mar 2012 15:07:07 -0700 (PDT)
Date: Fri, 30 Mar 2012 09:07:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/8] xfs: check for buffer errors before waiting
Message-ID: <20120329220704.GB18323@dastard>
References: <1333023835-12856-1-git-send-email-david@fromorbit.com>
	<1333023835-12856-2-git-send-email-david@fromorbit.com>
	<4F74B229.6030707@sgi.com> <20120329211025.GD692@dastard>
	<4F74D89B.1060008@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F74D89B.1060008@sgi.com>
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

On Thu, Mar 29, 2012 at 04:48:11PM -0500, Mark Tinguely wrote:
> On 03/29/12 16:10, Dave Chinner wrote:
> >On Thu, Mar 29, 2012 at 02:04:09PM -0500, Mark Tinguely wrote:
> >If the previous user of the buffer got an error, it is not
> >guaranteed to be cleared because the buffer is not re-initialised.
> >i.e. it's an uncached buffer that we control completely and reuse
> >from IO to IO with just a reset of the bno and length. If b_error is
> >non zero here, then the IO can fail because nothing else clears the
> >error in the dispatch path....
> 
> Thank-you for the explanation.
> 
> FYI: I am having problems with the patches applying. This patch
> complained at hunk at offset 623. Maybe I am using too new of kernel
> source.

That's because they are based on top of a current TOT mainline and
Christoph's dio ilock and xfsbufd removal changes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
