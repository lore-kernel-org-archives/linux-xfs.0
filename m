Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Jun 2007 08:10:41 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l54FAZWt031602
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 08:10:36 -0700
Date: Mon, 4 Jun 2007 16:10:34 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Review: factor extracting extent size hints from the inode
Message-ID: <20070604151034.GC28425@infradead.org>
References: <20070604052333.GR85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604052333.GR85884050@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Jun 04, 2007 at 03:23:33PM +1000, David Chinner wrote:
> Replace frequently repeated, open coded extraction of the
> extent size hint from the xfs_inode with a single helper
> function.

Looks good, but I'd suggest not putting in the unlikelys.  Realtime
or alignment are perfectly normal codepaths and hardcoding them to
be predicted not taken sounds like a bad idea.  unlilely should be
limited to exception error handling code.
