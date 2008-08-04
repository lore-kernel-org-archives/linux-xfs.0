Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Aug 2008 18:45:03 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m741j0ii004526
	for <xfs@oss.sgi.com>; Sun, 3 Aug 2008 18:45:01 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B925C197648C
	for <xfs@oss.sgi.com>; Sun,  3 Aug 2008 18:46:13 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 0G9RyZxwt2Hedihn for <xfs@oss.sgi.com>; Sun, 03 Aug 2008 18:46:13 -0700 (PDT)
Date: Mon, 4 Aug 2008 11:46:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/26] kill struct xfs_btree_hdr
Message-ID: <20080804014610.GD6119@disturbed>
References: <20080804013211.GB8819@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804013211.GB8819@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Aug 04, 2008 at 03:32:11AM +0200, Christoph Hellwig wrote:
> This type is only embedded in struct xfs_btree_block and never used
> directly.  By moving the fields directly into struct xfs_btree_block
> a lot of the macros for struct xfs_btree_sblock and struct xfs_btree_lblock
> can be used for struct xfs_btree_block too now which helps greatly
> with some of the migrations during implementing the generic btree code.

Looks fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
