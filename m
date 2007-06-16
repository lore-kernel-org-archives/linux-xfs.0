Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 16 Jun 2007 13:38:55 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5GKcoWt023305
	for <xfs@oss.sgi.com>; Sat, 16 Jun 2007 13:38:52 -0700
Date: Sat, 16 Jun 2007 21:38:51 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Review: Multi-File Data Streams V2
Message-ID: <20070616203851.GA7817@infradead.org>
References: <20070613041629.GI86004887@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070613041629.GI86004887@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Thanks, this version looks a lot better now.

The pip checks in xfs_inode.c are still in, but I'm pretty sure they're
not nessecary, and even if they were nessecary they'd need a good comment
explaining why.

The patch still hooks into xfs_close despite your comment that you
updated it for the removal of it.

I still strongly believe the mru cache should not be inside xfs.  It's
a completely generic library function and should go into lib/ so it's
available to all of the kernel.  That means it'll need some codingstyle
updates and proper kerneldoc comments, though.
