Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 23:44:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8G6hxVh009683
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 23:43:59 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 86EB9445E5F
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 23:45:30 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id C4rD2XJfZoLQbSoV for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 23:45:30 -0700 (PDT)
Date: Tue, 16 Sep 2008 16:31:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] move XFS_BMAP_SANITY_CHECK out of line
Message-ID: <20080916063146.GZ5811@disturbed>
References: <20080915004703.GG12213@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080915004703.GG12213@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Sep 15, 2008 at 02:47:03AM +0200, Christoph Hellwig wrote:
> Move the XFS_BMAP_SANITY_CHECK macro out of line and make it a properly typed
> function.  Also pass the xfs_buf for the btree block instead of just the btree
> block header, as we will need some additional information for it to implement
> CRC checking of btree blocks.

Looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
