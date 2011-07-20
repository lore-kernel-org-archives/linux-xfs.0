Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6KFJaEJ235488 for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 10:19:36 -0500
Subject: Re: [PATCH 3/4] xfs: convert AIL cursors to use struct list_head
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110719234324.GC9359@dastard>
References: <1310960419-9875-1-git-send-email-david@fromorbit.com>
	<1310960419-9875-4-git-send-email-david@fromorbit.com>
	<1311116636.1964.40.camel@doink>  <20110719234324.GC9359@dastard>
Date: Wed, 20 Jul 2011 10:19:35 -0500
Message-ID: <1311175175.2906.8.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2011-07-20 at 09:43 +1000, Dave Chinner wrote:
> On Tue, Jul 19, 2011 at 06:03:56PM -0500, Alex Elder wrote:
> > On Mon, 2011-07-18 at 13:40 +1000, Dave Chinne
. . .
> > > + * Get the next item in the traversal and advance the cursor.  If the cursor
> > > + * was invalidated (indicated by a lip of 1), restart the traversal.
> >  * was invalidated (indicated by its item pointer's low bit being set),
> >  * restart the traversal.
> 
> I thought I fixed that. Hmmmm, I did fix a comment that said the
> same thing - just it wasn't the one you noticed. :/ I'll fix it up
> when I redo the splice code again.

Don't worry about it.  I'll change it (as I did here)
in my own copy and will use that (unless you give me
something newer before I'm ready to publish it).

You are welcome to update it later, of course.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
