Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 14:49:11 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1LMn60j003719
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 14:49:08 -0800
Date: Fri, 22 Feb 2008 09:49:28 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch] detect and correct bad features2 superblock field
Message-ID: <20080221224928.GE155407@sgi.com>
References: <20080220054041.GM155407@sgi.com> <20080220191328.GB24257@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220191328.GB24257@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Feb 20, 2008 at 02:13:28PM -0500, Christoph Hellwig wrote:
> On Wed, Feb 20, 2008 at 04:40:41PM +1100, David Chinner wrote:
> > There is a bug in mkfs.xfs that can result in writing the features2
> > field in the superblock to the wrong location. This only occurs
> > on some architectures, typically those with 32 bit userspace and
> > 64 bit kernels.
> 
> Well, we don't use different ABIs for kernel vs userspace so some
> kernels will get it wrong aswell, you just won't notice until moving
> to a different box because userspace is the same.

True.

> > +
> > +	/* must be padded to 64 bit alignment */
> >  } xfs_dsb_t;
> 
> I'm pretty sure there is some gcc __packed__ magic to enfore that,
> might it be worth to poke some gcc experts to add it?

Yes, it's probably the right thing to do. However, if we are going
to "pack" disk structures, I'd like to do that all in one series
of patches rather than mixed up in other fixes....

> But the actual patch looks fine, ACK from me.

Thanks.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
