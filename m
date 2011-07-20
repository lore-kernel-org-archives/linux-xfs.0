Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6KFG3rc235272 for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 10:16:03 -0500
Subject: Re: [PATCH 1/4] xfs: use a cursor for bulk AIL insertion
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110719233644.GB9359@dastard>
References: <1310960419-9875-1-git-send-email-david@fromorbit.com>
	<1310960419-9875-2-git-send-email-david@fromorbit.com>
	<1311116624.1964.38.camel@doink>  <20110719233644.GB9359@dastard>
Date: Wed, 20 Jul 2011 10:16:01 -0500
Message-ID: <1311174961.2906.6.camel@doink>
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

On Wed, 2011-07-20 at 09:36 +1000, Dave Chinner wrote:
> On Tue, Jul 19, 2011 at 06:03:44PM -0500, Alex Elder wrote:
> > On Mon, 2011-07-18 at 13:40 +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Delayed logging can insert tens of thousands of log items into the
> > > AIL at the same LSN. When the committing of log commit records
> > > occur, we can get insertions occurring at a
. . .
> _after_ which the new
> >          * items should go.  If lip is null the AIL was empty, so
> >          * the new items go at the head of the AIL.
> >          */
> >         if (lip)
> >                 list_splice(list, &lip->li_ail);
> >         else
> >                 list_splice(list, &ailp->xa_ail);
> > }
> 
> 
> Looks cleaner, but I'll need to test it. Right now all my test
> resources are busy with non-mainline stuff, so it's going to be next
> week sometime before I can do this.

I'll actually try to test this today.	-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
