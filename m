Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 16:27:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6ONRIAB016835
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 16:27:18 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3B1FE9D7C9
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 16:28:29 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id BnGfIU7lERkQsGLU for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 16:28:29 -0700 (PDT)
Date: Fri, 25 Jul 2008 09:28:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/15] make btree root in inode support generic
Message-ID: <20080724232827.GF15438@disturbed>
References: <20080723200848.GF7401@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723200848.GF7401@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Jul 23, 2008 at 10:08:48PM +0200, Christoph Hellwig wrote:
> The bmap btree is rooted in the inode and not in a single disk block.  Make
> the support for this feature more generic by:
> 
>  (a) adding a btree flag to check for instead of the XFS_BTNUM_BMAP type
>  (b) add a get_root_from_inode btree operation to get a btree block from
>      the inode, with the implementation details left to the individual btree.
> 
> Also clean up xfs_btree_get_block, which is the place these two features
> are used.
> 
> The XFS_BTREE_ROOT_IN_INODE is based upon a patch from Dave Chinner.

Looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
