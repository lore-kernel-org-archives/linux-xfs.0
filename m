Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4S1G22w181864 for <xfs@oss.sgi.com>; Thu, 27 May 2010 20:16:03 -0500
Received: from hrndva-omtalb.mail.rr.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9C91157D2BC
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 18:20:19 -0700 (PDT)
Received: from hrndva-omtalb.mail.rr.com (hrndva-omtalb.mail.rr.com
	[71.74.56.124]) by cuda.sgi.com with ESMTP id MD89LjlviA0mMSP3
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 18:20:19 -0700 (PDT)
Subject: Re: [PATCH 1/6] writeback: initial tracing support
From: Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20100527143233.836b2c47.akpm@linux-foundation.org>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
	<1274784852-30502-2-git-send-email-david@fromorbit.com>
	<20100527143233.836b2c47.akpm@linux-foundation.org>
Date: Thu, 27 May 2010 21:18:21 -0400
Message-ID: <1275009502.22648.582.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Reply-To: rostedt@goodmis.org
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu, 2010-05-27 at 14:32 -0700, Andrew Morton wrote:

> > --- /dev/null
> > +++ b/include/trace/events/writeback.h
> > @@ -0,0 +1,171 @@
> > +#undef TRACE_SYSTEM
> > +#define TRACE_SYSTEM writeback
> > +
> > +#if !defined(_TRACE_WRITEBACK_H) || defined(TRACE_HEADER_MULTI_READ)
> 
> Seems wrong.  If you define TRACE_HEADER_MULTI_READ then include this
> header twice, things explode.  Which negates the purpose of
> _TRACE_WRITEBACK_H.

That's intended. It is documented in
samples/trace_events/trace-events-samples.h

The purpose of the TRACE_HEADER_MULTI_READ is to read the trace header
multi times. ;-)


You can also read about it here:

 http://lwn.net/Articles/379903/

here:

  http://lwn.net/Articles/381064/

and here:

   http://lwn.net/Articles/383362/

-- Steve

> 
> > +#define _TRACE_WRITEBACK_H
> > +
> > +#include <linux/backing-dev.h>
> > +#include <linux/writeback.h>
> > +

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
