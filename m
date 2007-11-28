Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 28 Nov 2007 01:48:10 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAS9lxoP029449
	for <xfs@oss.sgi.com>; Wed, 28 Nov 2007 01:48:01 -0800
Date: Wed, 28 Nov 2007 10:48:02 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] kill superflous buffer locking
Message-ID: <20071128094802.GB7760@lst.de>
References: <20070924184926.GA20661@lst.de> <4716DD79.6040309@sgi.com> <474CD2BA.8070204@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474CD2BA.8070204@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com, xfs-dev <xfs-dev@sgi.com>

On Wed, Nov 28, 2007 at 01:30:18PM +1100, Lachlan McIlroy wrote:
> Christoph,
> 
> We've fixed the source of the assertion (that was the bugs in
> xfs_buf_associate_memory()) so I'm pushing your buffer lock
> removal patch back in again.
> 
> While looking through it I found a couple of issues:
> 
> - It called unlock_page() before calls to PagePrivate() and
>   PageUptodate().  I think the page needs to be locked during
>   these calls so I moved the unlock_page() further down.

This doesn't really matter at all.  XFS is the only user of the
address_space the pages reside in and we never have overlapping
buffers.  That's the reason why we can remove the buffer locking.
Now if there was a variant of find_or_create_page that didn't set
pages locked at all we could happily use it and get rid of the last
place we deal with locked pages.

> - Unlocking the pages as we go can cause a double unlock in the
>   error handling for a NULL page in the XBF_READ_AHEAD case so I
>   removed the unlocking code for that case.

Indeed.  Thanks for spotting this.
