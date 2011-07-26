Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6QMeJlH146235 for <xfs@oss.sgi.com>; Tue, 26 Jul 2011 17:40:20 -0500
Date: Tue, 26 Jul 2011 18:40:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfs: flag all buffers as metadata
Message-ID: <20110726224016.GA10394@infradead.org>
References: <20110726150633.GA17400@infradead.org>
	<20110726150644.GA18000@infradead.org>
	<1311719935.11557.12.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311719935.11557.12.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Jul 26, 2011 at 05:38:55PM -0500, Alex Elder wrote:
> On Tue, 2011-07-26 at 11:06 -0400, Christoph Hellwig wrote: 
> > Now that REQ_META bios aren't treated specially in the CFQ I/O schedule
> > anymore, we can tag all buffers as metadata to make blktrace traces more
> > meaningful.  Note that we use buffers also to zero out partial blocks
> > in the preallocation / hole punching code, and while they operate on
> > data blocks the zeros written certainly aren't data.  I think this case
> > is borderline metadata enough to not bother special casing it.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> This looks good.  I plan to re-base the xfs master branch
> after 3.1-rc1 is out, so I'll wait until after that to
> commit this (and the others in this series).

I'd prefer to get it out to Linus ASAP after some review.  Just
committing it to for-linus for now and later rebasing master on top
should do fine for that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
