Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Dec 2006 03:35:06 -0800 (PST)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB4BYvaG002796
	for <xfs@oss.sgi.com>; Mon, 4 Dec 2006 03:34:59 -0800
Date: Mon, 4 Dec 2006 12:34:06 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] remove v_number
Message-ID: <20061204113406.GC11074@lst.de>
References: <20061129154729.GC6400@lst.de> <20061130003050.GG33919298@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061130003050.GG33919298@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Nov 30, 2006 at 11:30:50AM +1100, David Chinner wrote:
> On Wed, Nov 29, 2006 at 04:47:29PM +0100, Christoph Hellwig wrote:
> > v_number is unused except for the naming some locks (which is a
> > functionality totally unused by Linux), so remove it and assorted
> > crap.  Besides saving two words in struct vnode this also gets rid
> > of a spinlock per inode allocation.
> 
> Hmm - given that I've just used the v_number in post-mortem analysis
> of a nasty bug to correlate the sequence of events during a series
> of mkdir operations (i.e. transactions in the incore log buffers,
> the resulting xfs_inodes and some screwed up dentries) that lead to
> a BUG_ON being tripped in d_instantiate.
> 
> So, while it appears to be unused, it is _very_ useful for
> determining the SOE that has occurred in certain types of problems.
> 
> FWIW, while analysing this crash dump a couple of days ago I was
> wishing that dentries had an equivalent sequence number because
> there is no way to tell what dentry was supposed to be related to
> what inode after it got screwed up...

Putting in sequence counting is trivial using kprobes.  Will you put
in this patch after I write you a kprobes modules to do the sequence
numbering?
