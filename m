Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4AEhVox070702 for <xfs@oss.sgi.com>; Tue, 10 May 2011 09:43:31 -0500
Subject: Re: [PATCH] xfs: fix duplicate workqueue initialisation
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110510053319.GA3047@infradead.org>
References: <1304993150-15327-1-git-send-email-david@fromorbit.com>
	<20110510053319.GA3047@infradead.org>
Date: Tue, 10 May 2011 09:43:27 -0500
Message-ID: <1305038607.2962.10.camel@doink>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, 2011-05-10 at 01:33 -0400, Christoph Hellwig wrote:
> On Tue, May 10, 2011 at 12:05:50PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The workqueue initialisation function is called twice when
> > initialising the XFS subsystem. Remove the second initialisation
> > call.
> 
> Not sure how we got there, but it looks indeed buggy.  I'm kinda
> surprised the workqueue code didn't blow up with the duplicate names.

Maybe duplicated by a merge along the way?

The second set of workqueues prevails, leaving the originals
unused and leaked.  In fact, an xfs module can probably even
unload cleanly because it doesn't really "own" the workqueue,
which by itself is an interesting artifact.

This is clearly a bug but I don't think it is truly harmful,
so I am not going to send it to Linus for 2.6.39.  If you
disagree, let me know and I'll send it separately.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
