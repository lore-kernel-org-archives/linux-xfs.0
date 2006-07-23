Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Jul 2006 13:06:33 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6NK68DW030214
	for <xfs@oss.sgi.com>; Sun, 23 Jul 2006 13:06:08 -0700
Date: Sun, 23 Jul 2006 20:06:50 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: review: fix remount vs barrier options
Message-ID: <20060723190650.GA22180@infradead.org>
References: <20060721152807.D1998769@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060721152807.D1998769@wobbly.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: xfs@oss.sgi.com, jeremy@sgi.com

> It finally clicked that we are not clearing the buffer flag
> from a previously written log buffer, even though we'll no
> longer set a new flag into a buffer (due to the mount flag
> being cleared), so we _can_ still issue barrier writes when
> remounted without barriers.

That's true.  Ooops.

> This was made more complicated by the way a freshly mounted
> filesystem with 8 log buffers wouldn't show up the problem,
> since we have to slowly cycle through the "clear" log buffers
> before we see the bug.  This seems like the simplest fix...
> 
> (Hmmm, actually, I wonder if this will also resolve the quota
> log I/O problem that was reported the other day too).

Shouldn't we make sure we clear all flags when reusing a log buffer?
Relying on clearing individual flags seems rather fragile to me.
