Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Dec 2006 13:57:51 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kB4LvdaG014737
	for <xfs@oss.sgi.com>; Mon, 4 Dec 2006 13:57:42 -0800
Date: Tue, 5 Dec 2006 08:56:36 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] remove v_number
Message-ID: <20061204215636.GM33919298@melbourne.sgi.com>
References: <20061129154729.GC6400@lst.de> <20061130003050.GG33919298@melbourne.sgi.com> <20061204113406.GC11074@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061204113406.GC11074@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Mon, Dec 04, 2006 at 12:34:06PM +0100, Christoph Hellwig wrote:
> On Thu, Nov 30, 2006 at 11:30:50AM +1100, David Chinner wrote:
> > On Wed, Nov 29, 2006 at 04:47:29PM +0100, Christoph Hellwig wrote:
> > > v_number is unused except for the naming some locks (which is a
> > > functionality totally unused by Linux), so remove it and assorted
> > > crap.  Besides saving two words in struct vnode this also gets rid
> > > of a spinlock per inode allocation.
> > 
> > Hmm - given that I've just used the v_number in post-mortem analysis
> > of a nasty bug to correlate the sequence of events during a series
> > of mkdir operations (i.e. transactions in the incore log buffers,
> > the resulting xfs_inodes and some screwed up dentries) that lead to
> > a BUG_ON being tripped in d_instantiate.
> > 
> > So, while it appears to be unused, it is _very_ useful for
> > determining the SOE that has occurred in certain types of problems.
> > 
> > FWIW, while analysing this crash dump a couple of days ago I was
> > wishing that dentries had an equivalent sequence number because
> > there is no way to tell what dentry was supposed to be related to
> > what inode after it got screwed up...
> 
> Putting in sequence counting is trivial using kprobes.

Never used kprobes - I'll take your word that it's easy....

> Will you put
> in this patch after I write you a kprobes modules to do the sequence
> numbering?

I wasn't NACKing your patch - I was making the point that this
apparently unused code does have some useful, non-obvious, redeeming
features.

Pardon my lack of kprobes knowledge, but what is the point of
removing this code if we have to then go and add kprobes
instrumentation to every XFS installation we support to provide the
same information? Where does the kprobes data get kept? In
the kernel, or partially in kernel and in userspace? How
would you correlate the sequence number and the vnode from the
crash dump? How much extra runtime memory does it use?

I'm not saying no, Christoph - I'm just trying to understand
the implications of what you are suggesting....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
