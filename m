Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 00:45:40 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5Q7jbgv003159
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 00:45:37 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7ECCB2832D3
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 00:46:38 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id EZOzfq18SKzROMMH for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 00:46:38 -0700 (PDT)
Date: Thu, 26 Jun 2008 03:46:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush
	requirements
Message-ID: <20080626074636.GB7064@infradead.org>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214455277-6387-2-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, matthew@wil.cx, linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 02:41:12PM +1000, Dave Chinner wrote:
> XFS object flushing doesn't quite match existing completion semantics.  It
> mixed exclusive access with completion. That is, we need to mark an object as
> being flushed before flushing it to disk, and then block any other attempt to
> flush it until the completion occurs.
> 
> To do this we introduce:
> 
> void init_completion_flush(struct completion *x)
> 	which initialises x->done = 1
> 
> void completion_flush_start(struct completion *x)
> 	which blocks if done == 0, otherwise decrements done to zero and
> 	allows the caller to continue.
> 
> bool completion_flush_start_nowait(struct completion *x)
> 	returns a failure status if done == 0, otherwise decrements done
> 	to zero and returns a "flush started" status. This is provided
> 	to allow flushing to begin safely while holding object locks in
> 	inverted order.
> 
> This replaces the use of semaphores for providing this exclusion
> and completion mechanism.

Given that the only API call shared with normal completions is
complete() I'd rather make this a primitive of it's own, even if
internally implemented as completions.

Also please add kerneldoc comments for all new APIs eported to modules.
