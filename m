Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 21:25:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8G4PKJr031806
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 21:25:21 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C2EDC12757D5
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 21:26:52 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id XcCUsxaajPvbuSHq for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 21:26:52 -0700 (PDT)
Date: Tue, 16 Sep 2008 14:26:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/6] XFS: mark inodes for reclaim via a tag in the
	inode radix tree
Message-ID: <20080916042649.GQ5811@disturbed>
References: <1221315300-30336-1-git-send-email-david@fromorbit.com> <1221315300-30336-3-git-send-email-david@fromorbit.com> <20080915211425.GF29743@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080915211425.GF29743@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Sep 15, 2008 at 05:14:26PM -0400, Christoph Hellwig wrote:
> On Sun, Sep 14, 2008 at 12:14:56AM +1000, Dave Chinner wrote:
> > Prepare for removing the deleted inode list by marking inodes
> > for reclaim in the inode radix trees so that we can use the
> > radix trees to find reclaimable inodes.
> 
> Any reason this is split from patch 4 in the series?  Looks good
> otherwise.

Yeah - so I can test each change as I write it. Adding the tag
didn't cause any problems, changing to traverse based on the tag
didn't cause any problems, removing the old list didn't cause any
problems.  i.e. the patches are small, easily verifiable steps.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
