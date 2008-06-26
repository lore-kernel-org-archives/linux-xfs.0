Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 06:17:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5QDHXtI025872
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 06:17:33 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 36BC611D6622
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 06:18:33 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id voRNgeicES5cvQnK for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 06:18:33 -0700 (PDT)
Date: Thu, 26 Jun 2008 23:18:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush
	requirements
Message-ID: <20080626131829.GT29319@disturbed>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-2-git-send-email-david@fromorbit.com> <20080626074636.GB7064@infradead.org> <20080626112133.GJ11558@disturbed> <20080626130700.GA24325@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626130700.GA24325@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, matthew@wil.cx, linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 09:07:00AM -0400, Christoph Hellwig wrote:
> On Thu, Jun 26, 2008 at 09:21:33PM +1000, Dave Chinner wrote:
> > Ok, so that involves exactly what? A new header file, a new API name
> > (ideas anyone?) and kerneldoc comments?
> 
> Yes, probably just a new header with properly documented functions.
> Thew two non-trivial ones you added should probably not be inlines,
> btw.

Yeah, they grew a little bigger than expected...

> flush_lock_init/flush_lock/flush_trylock/flush_done/flush_is_locked?

Ok, I was thinking along those lines. I'll redo the patch series
using that interface tomorrow.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
