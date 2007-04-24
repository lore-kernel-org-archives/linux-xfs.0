Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Apr 2007 02:04:33 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3O94TfB004786
	for <xfs@oss.sgi.com>; Tue, 24 Apr 2007 02:04:30 -0700
Date: Tue, 24 Apr 2007 09:51:47 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: review [1 of 3]: lazy superblock counters - core kernel
Message-ID: <20070424085147.GA28820@infradead.org>
References: <20070419231459.GX48531920@melbourne.sgi.com> <20070423220010.GA18325@infradead.org> <20070424012808.GD48531920@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070424012808.GD48531920@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Apr 24, 2007 at 11:28:08AM +1000, David Chinner wrote:
> > This is really quite nasty.  Should we at least force a cache flush here?
> 
> Ok, so the patch I sent out was an older version that had a very similar
> name to the current patch in my series (xfs-lazy-sb vs xfs_lazy_sb).
> This code doesn't exist in the version I should have sent out.
> 
> The latest version, plus the changes suggested here and with the
> second patch folded back into it is attached.

Looks like in the new code we simply ignore log reservation
failures in xfs_log_sbcount?

Otherwise this looks good to me.

converting all sb feature checks to use the inlines would be
a nice cleanup opportunity for someone bored :)
