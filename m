Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBSG7e9g174465 for <xfs@oss.sgi.com>; Tue, 28 Dec 2010 10:07:42 -0600
Date: Tue, 28 Dec 2010 11:09:40 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs: add FITRIM support
Message-ID: <20101228160940.GA28295@infradead.org>
References: <20101125112304.GA4195@infradead.org>
	<1293054073.2408.374.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1293054073.2408.374.camel@doink>
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
Cc: lczerner@redhat.com, xfs@oss.sgi.com

On Wed, Dec 22, 2010 at 03:41:13PM -0600, Alex Elder wrote:
> > +	error = xfs_alloc_read_agf(mp, NULL, agno,
> > +				   XFS_ALLOC_FLAG_TRYLOCK, &agbp);
> > +	if (error || !agbp) {
> > +		if (error == EAGAIN)
> > +			error = 0;
> 
> EAGAIN is ignored because it's an advisory interface, right?
> How hard are we expected to try?  What I really mean is,
> is the benefit of FITRIM enough that we should try again
> later when we can get a buffer or lock on it?

That was the idea when I wrote this code.  But back then we called it
regularly from a kernel thread.  For FITRIM it makes more sense to just
remove the trylock.

> I don't know where (or if) FITRIM is precisely documented.
> But I question whether truncating down the start offset is
> the correct thing to do.  If the starting byte offset given
> were not block-aligned, it seems like you should not assume
> that the caller wanted the bytes below unmapped.  (This is
> a broader question, not related directly to your change.)
> 
> Similarly, on the length it is probably best to truncate
> it, because it avoids any bytes beyond the specified range
> getting unmapped.  (I.e., in my mind what you did is the
> right way to do it.)  But these interpretations are
> dependent on the specific interpretation of FITRIM...

Good question.  Adding Lukas to the Cc.  I tried to talk him into
writing a manpage to document the interface better, but that's only
been a few days before the holidays.  This is something we should
documented.  I don't quite understand the need for the range interface
anyway.

> You don't update range anywhere, so the copyout below
> is not really doing anything useful.  However I think
> it should stay, and the number of bytes actually
> trimmed should be updated and returned to the user.
> That seems to be what ext4 does (the only reference
> I found at the moment for what FITRIM is supposed
> to return).

Yes, I guess I should update the range.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
