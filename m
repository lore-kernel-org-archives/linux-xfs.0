Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 21:26:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8G4QNBF031986
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 21:26:23 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A827E12757DE
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 21:27:55 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id TXJ2WMktm4zYTliL for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 21:27:55 -0700 (PDT)
Date: Tue, 16 Sep 2008 14:27:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] XFS: rename inode reclaim functions
Message-ID: <20080916042753.GR5811@disturbed>
References: <1221315300-30336-1-git-send-email-david@fromorbit.com> <1221315300-30336-4-git-send-email-david@fromorbit.com> <20080915211400.GE29743@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080915211400.GE29743@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Sep 15, 2008 at 05:14:00PM -0400, Christoph Hellwig wrote:
> On Sun, Sep 14, 2008 at 12:14:57AM +1000, Dave Chinner wrote:
> > The function names xfs_finish_reclaim and xfs_finish_reclaim_all
> > are not very descriptive of what they are reclaiming. Rename to
> > xfs_reclaim_inode[s] to match the xfs_sync_inodes() function.
> 
> Looks good, but in case you respin the series I'd move to this to
> number two in the series.

I can do that, though I'm getting pretty sick of this whole patch
set by now....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
