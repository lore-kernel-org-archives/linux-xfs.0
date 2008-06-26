Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 04:31:19 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5QBVDFq008202
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 04:31:13 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56AB9182B66E
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 04:32:13 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id CqiDS4AFf4nvRUsW for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 04:32:13 -0700 (PDT)
Date: Thu, 26 Jun 2008 21:32:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush
	requirements
Message-ID: <20080626113209.GK11558@disturbed>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-2-git-send-email-david@fromorbit.com> <20080626112612.GW4392@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626112612.GW4392@parisc-linux.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matthew Wilcox <matthew@wil.cx>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 05:26:12AM -0600, Matthew Wilcox wrote:
> On Thu, Jun 26, 2008 at 02:41:12PM +1000, Dave Chinner wrote:
> > XFS object flushing doesn't quite match existing completion semantics.  It
> > mixed exclusive access with completion. That is, we need to mark an object as
> > being flushed before flushing it to disk, and then block any other attempt to
> > flush it until the completion occurs.
> 
> This sounds like mutex semantics.  Why are the existing mutexes not
> appropriate for your needs?

Different threads doing wait and complete.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
