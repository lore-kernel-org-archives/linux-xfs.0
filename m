Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 22:33:51 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6U5Xnj1002002
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 22:33:50 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0957C19531BC
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 22:35:01 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id i6LbPVNRQmjVx0UG for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 22:35:01 -0700 (PDT)
Date: Wed, 30 Jul 2008 15:34:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/21] add get_maxrecs btree operation
Message-ID: <20080730053455.GO13395@disturbed>
References: <20080729193121.GO19104@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729193121.GO19104@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Jul 29, 2008 at 09:31:21PM +0200, Christoph Hellwig wrote:
> Factor xfs_btree_maxrecs into a per-btree operation.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

->get_maxrecs was extracted out of my original patchset, right?

I didn't apply it to removing xfs_btree_maxrecs(), though. Good
idea. Looks fine to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
