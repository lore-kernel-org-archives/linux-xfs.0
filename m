Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 16:24:35 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6ONOVq7016025
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 16:24:33 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6CB921924607
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 16:25:40 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id XUHyUC5pZ1Ia0biX for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 16:25:40 -0700 (PDT)
Date: Fri, 25 Jul 2008 09:25:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/15] split up xfs_btree_init_cursor
Message-ID: <20080724232537.GD15438@disturbed>
References: <20080723200835.GD7401@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723200835.GD7401@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Jul 23, 2008 at 10:08:35PM +0200, Christoph Hellwig wrote:
> xfs_btree_init_cursor contains close to little shared code for the different
> btrees and will get even more non-common code in the future.  Split it up
> into one routine per btree type.
> 
> Because xfs_btree_dup_cursor needs to call the init routine for a generic
> btree cursor add a new btree operation vector that contains a dup_cursor
> method that initializes a new cursor based on an existing one.
> 
> The btree operations vector is based on an idea and code from Dave Chinner
> and will be used for more operations later on.

Looks ok to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
