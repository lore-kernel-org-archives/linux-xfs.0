Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Jun 2007 08:08:31 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l54F8SWt030604
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 08:08:29 -0700
Date: Mon, 4 Jun 2007 16:08:28 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Review: remount read-only path is as broken as freezing was....
Message-ID: <20070604150828.GB28425@infradead.org>
References: <20070604051433.GP85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604051433.GP85884050@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Jun 04, 2007 at 03:14:33PM +1000, David Chinner wrote:
> 
> I recently had a remount,ro test fail in a way I had previously
> only seen freezing fail. That is, it failed because we still
> had active transactions after calling xfs_quiesce_fs(). Further
> investigation shows that this path is broken in the same ways
> that the xfs freeze path was broken (and recently fixed).

Actually it became more broken due to the fix changing things
a little.

In general a mount -o ro should be similar to a quience in
most ways, so the closer we can get them the better.  The patch
looks good to me.  One thing is that SYNC_INODE_QUIESCE should
probably get a more descriptive name and a comment explaining
why it's needed for quience (we want inodes updated not only in
the log) and why not for remount r/o (because no one cares for that
in this case)
