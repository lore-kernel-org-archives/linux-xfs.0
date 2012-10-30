Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UM78XF076398 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 17:07:09 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	nnsJ6pC2DrTEEq6n for <xfs@oss.sgi.com>;
	Tue, 30 Oct 2012 15:08:58 -0700 (PDT)
Date: Wed, 31 Oct 2012 09:08:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 25/25] xfs: add write verifiers to log recovery
Message-ID: <20121030220855.GA29378@dastard>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-26-git-send-email-david@fromorbit.com>
	<20121026085448.GD3035@infradead.org>
	<20121026203107.GJ29378@dastard>
	<20121030122331.GB30039@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121030122331.GB30039@infradead.org>
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

On Tue, Oct 30, 2012 at 08:23:31AM -0400, Christoph Hellwig wrote:
> > Remote attr buffers aren't logged - they are written sycnhronously
> > during the transaction - so won't get found by this.
> 
> Oh right.  Removing the synchronous writes for the remote attrs is
> someting we should tackled on day as well.
> 
> > As for remote
> > symlink buffers, yeah, that might be a problem. Ultimately, both of
> > these buffer types are going to grow headers for CRCs, so this
> > problem will go away. I'm not sure how to address this problem
> > in the mean time short of putting the buffer content type into all
> > the buf_log_format headers. Do you have any better ideas?
> 
> I can't think of a really good idea.  But introducing user exploitable
> issues in log recovery is something I'd avoid.  I also hate having to
> change the log format now if we're going to bump it soon again.  Let
> me look a bit more at the log recovery code if there's some way to
> interfer the buffer type.

I couldn't find any short of magic number matches. The ones that can
be inferred (inode and dquot buffers) are done that way, but for
everything else they are anonymous buffers being recovered. I might
just drop this patch for now, and only re-introduce it for CRC
enabled filesystems when that is added.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
