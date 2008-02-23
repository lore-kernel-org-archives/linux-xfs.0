Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Feb 2008 16:16:57 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1N0GpmX031532
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 16:16:53 -0800
Date: Fri, 22 Feb 2008 19:17:15 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch, debug, 2/2] Use power-of-2 size ktrace buffers
Message-ID: <20080223001715.GA22614@infradead.org>
References: <20080218230112.GU155407@sgi.com> <20080222040806.GB16993@infradead.org> <20080222043020.GN155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222043020.GN155407@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Feb 22, 2008 at 03:30:20PM +1100, David Chinner wrote:
> Ok, I'll cook up another patch for that and send it out.

Yeah, making that a separate patch is fine with me.  It's just a logical
next step.

> > a second step ktrace should be replaced with something based on the
> > various trace thingies floating around allowing to read out the trace
> > buffer from userspace instead of having to rely on kdb.
> 
> Yeah, that make sense for tracing from userspace. But most of the
> time I find a need for the tracing is when the machine has crashed
> or assert failed. Hence I don't see that we can really remove the
> kdb side of things. Perhaps two different tracing modules could
> be done.....

It should still be one tracing buffer, with both a userspace space
interface and one from the various kernel debuggers.  Adding the
trace buffers to core dumps in addition would be even better.
