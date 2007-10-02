Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Oct 2007 16:41:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l92NffT6001821
	for <xfs@oss.sgi.com>; Tue, 2 Oct 2007 16:41:45 -0700
Date: Wed, 3 Oct 2007 09:41:27 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: REVIEW: xfs_reno
Message-ID: <20071002234126.GH23367404@sgi.com>
References: <op.tzj549h63jf8g2@pc-bnaujok.melbourne.sgi.com> <20071002090216.GA22721@infradead.org> <20071002091951.GE995458@sgi.com> <470274BF.7070702@thebarn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470274BF.7070702@thebarn.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: David Chinner <dgc@sgi.com>, Christoph Hellwig <hch@infradead.org>, Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Tue, Oct 02, 2007 at 11:41:35AM -0500, Russell Cattelan wrote:
> >At that point, we'll got a "working" shrink that will allow
> >shrinking to only 50% of the original size because the log will
> >get in the way. To fix that, we'll need to implement transactions
> >to move the log...
>
> If we do that could be move to an inode based log?

What do we gain from doing that? (I'm a bit slow today)

> Keep it contagious so recovery won't have to parse
> up the file system to find the log.

I'm worried by those contagious logs. What do you catch from them? :)

> The normal running case should be easier to deal with if
> the log was just a file?

I don't see how it changes anything - we address the log directly
by block number and device...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
