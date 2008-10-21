Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Oct 2008 13:34:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9LKYWxZ012039
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 13:34:33 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D81225292C3
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 13:36:16 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 5yPDJOP0ZC9siog0 for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 13:36:16 -0700 (PDT)
Date: Wed, 22 Oct 2008 07:36:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] stop using xfs_itobp in xfs_bulkstat
Message-ID: <20081021203612.GL25906@disturbed>
References: <20081020222036.GA23662@lst.de> <20081021024455.GB18495@disturbed> <20081021081329.GA23344@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021081329.GA23344@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Oct 21, 2008 at 04:13:29AM -0400, Christoph Hellwig wrote:
> On Tue, Oct 21, 2008 at 01:44:55PM +1100, Dave Chinner wrote:
> > On Tue, Oct 21, 2008 at 12:20:36AM +0200, Christoph Hellwig wrote:
> > > xfs_bulkstat only wants the dinode, offset and buffer from a given
> > > inode number.  Instead of using xfs_itobp on a fake inode that is much
> > > easier done with xfs_inotobp, which just needs an imap_flag paramter to
> > > pass down the XFS_IMAP_BULKSTAT flag.
> > 
> > Nice - that removes the only external user of xfs_inode_alloc() very
> > cleanly. Looks ok to me.
> 
> Which means we should mark it static now.  Updated patch below:

Looks good.

BTW, the original patch series has run through xfsqa on my setup
overnight without any problems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
