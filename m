Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p68L7hJD006408 for <xfs@oss.sgi.com>; Fri, 8 Jul 2011 16:07:43 -0500
Subject: Re: [RFC] remove filestreams support?
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110705110127.GA27102@infradead.org>
References: <20110704153443.GA21501@infradead.org>
	<20110705015458.GZ561@dastard> <20110705110127.GA27102@infradead.org>
Date: Fri, 8 Jul 2011 16:07:39 -0500
Message-ID: <1310159259.3024.63.camel@doink>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, 2011-07-05 at 07:01 -0400, Christoph Hellwig wrote:
> On Tue, Jul 05, 2011 at 11:54:58AM +1000, Dave Chinner wrote:
> > So rather than deprecating the functionality, perhaps we should look
> > at implementing it through a simpler, more generic, better
> > integrated interface? That will increase the usefulness of the
> > functionality for a much wider audience than it has now, and also
> > provide the virt/blk throttling folk with exactly the "don't cross
> > the streams" functionality they suggest filesystems are unable to
> > support easily.....
> 
> That does indeed sound simpler, and also more useful.  Do the users
> who have chimed in here (and off list) think such a scheme would be
> useful for them?

We have customers that make good use of filestreams.
I don't think it matters whether they use CXFS or XFS,
it's a very useful allocation strategy, and an important
feature for certain applications.  I like the idea of
generalizing it and/or improving its interface though.

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
