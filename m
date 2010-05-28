Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4S1IaqB181993 for <xfs@oss.sgi.com>; Thu, 27 May 2010 20:18:37 -0500
Received: from hrndva-omtalb.mail.rr.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0CECC157D2E3
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 18:22:53 -0700 (PDT)
Received: from hrndva-omtalb.mail.rr.com (hrndva-omtalb.mail.rr.com
	[71.74.56.125]) by cuda.sgi.com with ESMTP id xBT9FnwTvakHyjwG
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 18:22:53 -0700 (PDT)
Subject: Re: [PATCH 1/6] writeback: initial tracing support
From: Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20100528004416.GV12087@dastard>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
	<1274784852-30502-2-git-send-email-david@fromorbit.com>
	<20100527143233.836b2c47.akpm@linux-foundation.org>
	<20100528004416.GV12087@dastard>
Date: Thu, 27 May 2010 21:20:57 -0400
Message-ID: <1275009657.22648.584.camel@gandalf.stny.rr.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org

On Fri, 2010-05-28 at 10:44 +1000, Dave Chinner wrote:
> On Thu, May 27, 2010 at 02:32:33PM -0700, Andrew Morton wrote:
> >
> > > --- /dev/null
> > > +++ b/include/trace/events/writeback.h
> > > @@ -0,0 +1,171 @@
> > > +#undef TRACE_SYSTEM
> > > +#define TRACE_SYSTEM writeback
> > > +
> > > +#if !defined(_TRACE_WRITEBACK_H) || defined(TRACE_HEADER_MULTI_READ)
> > 
> > Seems wrong.  If you define TRACE_HEADER_MULTI_READ then include this
> > header twice, things explode.  Which negates the purpose of
> > _TRACE_WRITEBACK_H.
> 
> Every other trace event header does this, so if it's wrong then the
> same mistake is in at least 30 files now. I don't know enough about
> the tracing code to know why this is done, and I'm not keen to
> address such a mistake here...

It's all part of the CPP voodoo ritual. You don't want to know why, just
do it, otherwise you may find dancing CPP skulls running around your
bathtub.

If you want to be a CPP Voodoo Witch doctor too, read up on LWN, I
describe some of the magic there.

-- Steve


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
