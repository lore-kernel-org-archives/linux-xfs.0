Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p03AlH4k075582 for <xfs@oss.sgi.com>; Mon, 3 Jan 2011 04:47:17 -0600
Date: Mon, 3 Jan 2011 11:49:13 +0100 (CET)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: xfs: add FITRIM support
In-Reply-To: <20101228160940.GA28295@infradead.org>
Message-ID: <alpine.LFD.2.00.1101031100100.2815@dhcp-lab-213.englab.brq.redhat.com>
References: <20101125112304.GA4195@infradead.org>
	<1293054073.2408.374.camel@doink>
	<20101228160940.GA28295@infradead.org>
MIME-Version: 1.0
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
Cc: lczerner@redhat.com, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

On Tue, 28 Dec 2010, Christoph Hellwig wrote:

> On Wed, Dec 22, 2010 at 03:41:13PM -0600, Alex Elder wrote:
> > > +	error = xfs_alloc_read_agf(mp, NULL, agno,
> > > +				   XFS_ALLOC_FLAG_TRYLOCK, &agbp);
> > > +	if (error || !agbp) {
> > > +		if (error == EAGAIN)
> > > +			error = 0;
> > 
> > EAGAIN is ignored because it's an advisory interface, right?
> > How hard are we expected to try?  What I really mean is,
> > is the benefit of FITRIM enough that we should try again
> > later when we can get a buffer or lock on it?
> 
> That was the idea when I wrote this code.  But back then we called it
> regularly from a kernel thread.  For FITRIM it makes more sense to just
> remove the trylock.
> 
> > I don't know where (or if) FITRIM is precisely documented.
> > But I question whether truncating down the start offset is
> > the correct thing to do.  If the starting byte offset given
> > were not block-aligned, it seems like you should not assume
> > that the caller wanted the bytes below unmapped.  (This is
> > a broader question, not related directly to your change.)
> > 
> > Similarly, on the length it is probably best to truncate
> > it, because it avoids any bytes beyond the specified range
> > getting unmapped.  (I.e., in my mind what you did is the
> > right way to do it.)  But these interpretations are
> > dependent on the specific interpretation of FITRIM...
> 
> Good question.  Adding Lukas to the Cc.  I tried to talk him into
> writing a manpage to document the interface better, but that's only
> been a few days before the holidays.  This is something we should
> documented.  I don't quite understand the need for the range interface
> anyway.

First of all, sorry for not having proper documentation just yet, I'll
try to work something out.

Regarding truncation of starting offset and length (also minlen) the
proper way is to truncate everything down to align with block size. For
example this is the way I am doing it in ext4:

	start = range->start >> sb->s_blocksize_bits;

It is not really a big deal to trim something that was not originally
intended to, not mentioning that there probably was not any intention at
all when it is not aligned to block size. We just trim slightly more, or
slightly less and it does not affect filesystem nor user of the
filesystem, since it trims just not used space.

But what we want to do (and what I missed in ext4) is to align start+len
not just len alone, because we might miss some blocks, when the FITRIM is
invoked in sequential manner. Then, truncating start down and truncation
start+len down is the right thing to do.

Regarding the need to have range interface I had two reasons to do this
as it is, but only one is really worth it. Since we want to run FITRIM
from the userspace on the background, we want to disturb other IO as
little as possible and whole filesystem trim can take minutes on some
devices (not talking about LUNs which is even more painful). So you'll
probably agree that we do not want to have possibly minute long stalls
when doing FITRIM.

But it is optional, so if you have fast device with small, not very
fragmented filesystem you can end up doing FITRIM on the whole filesystem
at once and it will be the right thing to do. Also, some might want to have
nice-n-shiny progress bars:).

Thanks!
-Lukas

> 
> > You don't update range anywhere, so the copyout below
> > is not really doing anything useful.  However I think
> > it should stay, and the number of bytes actually
> > trimmed should be updated and returned to the user.
> > That seems to be what ext4 does (the only reference
> > I found at the moment for what FITRIM is supposed
> > to return).
> 
> Yes, I guess I should update the range.
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
