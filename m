Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43560 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728539AbfFEPPS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Jun 2019 11:15:18 -0400
Date: Wed, 5 Jun 2019 17:14:51 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/20] xfs: don't use REQ_PREFLUSH for split log writes
Message-ID: <20190605151451.GC14846@lst.de>
References: <20190603172945.13819-1-hch@lst.de> <20190603172945.13819-7-hch@lst.de> <20190604161240.GA44563@bfoster> <20190604224544.GB29573@dread.disaster.area> <20190605105112.GA49049@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605105112.GA49049@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Wed, Jun 05, 2019 at 06:51:12AM -0400, Brian Foster wrote:
> Yep. Another thing that briefly crossed my mind is whether we could in
> theory optimize flushes out if the tail hasn't moved since the last
> flush. We'd still have to FUA the log records, but we haven't introduced
> any such integrity/ordering requirements if the tail hasn't changed,
> right?
> 
> It's debatable whether that would provide any value, but it might at
> least apply to certain scenarios like if the tail happens to be pinned
> by a single object across several iclog writes, or if fsyncs or some
> other pattern result in smaller/frequent checkpoints relative to
> metadata writeback, etc.

Well, for the fsync we require the data device to be flushed for
the fsync semantics anyway.  So we'd now need to treat that special,
simiar to that old log_flushed return parameter hack.
