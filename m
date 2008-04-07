Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 15:17:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m37MGuOC006849
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 15:16:59 -0700
Date: Tue, 8 Apr 2008 08:17:28 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [Patch] Per iclog callback chain lock
Message-ID: <20080407221728.GH108924158@sgi.com>
References: <20080401231348.GT103491721@sgi.com> <20080407125111.GB27350@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080407125111.GB27350@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Apr 07, 2008 at 08:51:11AM -0400, Christoph Hellwig wrote:
> Looks good.  You might want to kill ic_callback_tail while you're at it
> as it's a write-only struct member.

No, it's not a write-only member. xlog_notify() queues to the tail
by doing:

    410                 cb->cb_next = NULL;
    411                 *(iclog->ic_callback_tail) = cb;
    412                 iclog->ic_callback_tail = &(cb->cb_next);

So we can't remove it. Changing the callback chain to use a
struct list_head makes more sense, but that's a separate patch....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
