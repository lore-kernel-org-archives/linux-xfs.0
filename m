Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 16 Jun 2007 13:19:51 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5GKJlWt019741
	for <xfs@oss.sgi.com>; Sat, 16 Jun 2007 13:19:48 -0700
Date: Sat, 16 Jun 2007 20:55:08 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Review: fix test 004 to account for reserved space
Message-ID: <20070616195508.GB6929@infradead.org>
References: <20070604063328.GT85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604063328.GT85884050@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>, asg-qa <asg-qa@melbourne.sgi.com>

On Mon, Jun 04, 2007 at 04:33:28PM +1000, David Chinner wrote:
> With the changes to use some space by default in only in memory
> as a reserved pool, df and statfs will now output a fre block
> count that is slightly different to  what is held in the superblock.
> 
> Update the qa test to account for this change.

I think we should rather subtract the amount of internally reserved blocks
from the return value in xfs_statvfs.
