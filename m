Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7QEJtXh103484 for <xfs@oss.sgi.com>; Fri, 26 Aug 2011 09:19:56 -0500
Subject: Re: [PATCH 1/4] xfs: Don't allocate new buffers on every call to
	_xfs_buf_find
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110826081132.GA3551@infradead.org>
References: <1314341497-23910-1-git-send-email-david@fromorbit.com>
	<1314341497-23910-2-git-send-email-david@fromorbit.com>
	<20110826081132.GA3551@infradead.org>
Date: Fri, 26 Aug 2011 09:19:48 -0500
Message-ID: <1314368388.2821.6.camel@doink>
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

On Fri, 2011-08-26 at 04:11 -0400, Christoph Hellwig wrote:
. . .
> >  
> > +found:
> > +	ASSERT(bp->b_flags & XBF_MAPPED);
> 
> This doesn't look right to me.  Various buffers like inode or remoate attrs
> are unmapped, and I can't see any reason why we would assert not beeing
> allowed to find them here.
> 
> Thinking about it more I'm also not sure skipping the code to map
> buffers on a straight cache hit is a good idea - there's nothing
> inherent to requiring a given buffer to be mapped for all callers.

I actually tripped this assert last night the first time I
tried running it.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
