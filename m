Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D44D7F47
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 17:26:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 16F06AC008
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 15:26:30 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	xJLKGrjRvsrJnKSo for <xfs@oss.sgi.com>;
	Tue, 10 Nov 2015 15:26:28 -0800 (PST)
Date: Wed, 11 Nov 2015 10:25:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: Introduce writeback context for writepages
Message-ID: <20151110232543.GH14311@dastard>
References: <1440479153-1584-1-git-send-email-david@fromorbit.com>
	<1440479153-1584-3-git-send-email-david@fromorbit.com>
	<20150831180221.GA16371@bfoster.bfoster>
	<20150831185612.GB349@infradead.org>
	<20150831221743.GI26895@dastard>
	<20150901074103.GA27231@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150901074103.GA27231@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

[ finally getting back to this :/ ]

On Tue, Sep 01, 2015 at 12:41:03AM -0700, Christoph Hellwig wrote:
> On Tue, Sep 01, 2015 at 08:17:43AM +1000, Dave Chinner wrote:
> > The patch changes the bio allocation patterns - it allocates them on
> > the fly and holds them, so we could potentially exhaust the bio
> > mempool with this submission technique.
> 
> I've spend time to look over the patch again, and still don't see
> a change. 

Ah, it's in the next patch that I haven't posted that "goes straight
to bios". Ignore it for now...

> > The ioend allocation pattern
> > is different, too, because we only used to have 1 per buffer on a
> > writepage call and the last one was used for the write clustering.
> 
> .. that we now build up way bigger ioend chains.
> 
> So back to Brians concern:  we can now have fairly large piles of
> ioends built up while potentially getting scheduled out, and this
> does look like a potential real issue to me.  I wonder if we should
> (ab-)use the blk_plug_cb infrastructure so that we can flush the
> pending ioends out on a context switch?

Possibly, but I'm thinking that we should just end up building bios
directly and submitting them once they are reach size limits of
boundaries rather than building ioend chains for later submission.

Did the work for arbitrarily sized bios ever get merged? I can't
find any evidence that it did....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
