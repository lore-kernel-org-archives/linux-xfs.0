Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 23 Nov 2007 09:37:24 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lANHbFjv029158
	for <xfs@oss.sgi.com>; Fri, 23 Nov 2007 09:37:19 -0800
Date: Fri, 23 Nov 2007 17:37:23 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/9] Use _META bio I/O types for metadata I/O
Message-ID: <20071123173723.GA12227@infradead.org>
References: <20071122003512.GI114266761@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122003512.GI114266761@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>

On Thu, Nov 22, 2007 at 11:35:12AM +1100, David Chinner wrote:
> Improve metadata I/O merging in the elevator
> 
> Change all async metadata buffers to use [READ|WRITE]_META I/O types
> so that the I/O doesn't get issued immediately. This allows merging
> of adjacent metadata requests but still prioritises them over bulk
> data. This shows a 10-15% improvement in sequential create speed of
> small files.
> 
> Don't include the log buffers in this classification - leave them
> as sync types so they are issued immediately.

Looks good, and just including the trivial fs.h addition here might be
okay aswell.
