Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Oct 2008 19:43:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9L2hHAU012653
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 19:43:17 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7DC411449A7A
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 19:45:01 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id tUFOUO5m3DEcl2Qk for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 19:45:01 -0700 (PDT)
Date: Tue, 21 Oct 2008 13:44:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] stop using xfs_itobp in xfs_bulkstat
Message-ID: <20081021024455.GB18495@disturbed>
References: <20081020222036.GA23662@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020222036.GA23662@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Oct 21, 2008 at 12:20:36AM +0200, Christoph Hellwig wrote:
> xfs_bulkstat only wants the dinode, offset and buffer from a given
> inode number.  Instead of using xfs_itobp on a fake inode that is much
> easier done with xfs_inotobp, which just needs an imap_flag paramter to
> pass down the XFS_IMAP_BULKSTAT flag.

Nice - that removes the only external user of xfs_inode_alloc() very
cleanly. Looks ok to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
