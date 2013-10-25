Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 67E5F7F3F
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 06:29:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 411D030407E
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 04:29:36 -0700 (PDT)
Date: Fri, 25 Oct 2013 04:29:34 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: prevent stack overflows from page cache allocation
Message-ID: <20131025112934.GA1585@infradead.org>
References: <1382585110-1796-1-git-send-email-david@fromorbit.com>
	<20131024084803.GA28144@infradead.org>
	<20131024103751.GS2797@dastard>
	<20131024154220.GA19055@infradead.org>
	<20131024164115.GU1935@sgi.com> <20131024212448.GW2797@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131024212448.GW2797@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Fri, Oct 25, 2013 at 08:24:48AM +1100, Dave Chinner wrote:
> > > I'd much prefer aiming for the proper fix first.  If for some reason we
> > > can't get it done in time the workaround can be applied.
> > 
> > Dave probably has a customer waiting on this.
> 
> Obviously. And being a kernel where we have a fixed ABI, we can't
> backport any fix that changes core code.

No one is trying to tell you what to ship to your customers.  That
doesn't mean we should aim for the right fix upstream.

I don't really mind pushing patches like yours as a last resort when
dealing with unrepsonsive or disagreeing maintainers like we had to do
in the past, but trying to push the workaround without even attemping
the proper fix is a bit sad.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
