Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Jul 2008 00:25:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6U7PXkS021993
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2008 00:25:33 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C5D7ED4EFC
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2008 00:26:45 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id W9VgJu1PFTNTxHTa for <xfs@oss.sgi.com>; Wed, 30 Jul 2008 00:26:45 -0700 (PDT)
Date: Wed, 30 Jul 2008 17:26:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 20/21] implement generic xfs_btree_delete/delrec
Message-ID: <20080730072626.GU13395@disturbed>
References: <20080729193153.GU19104@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729193153.GU19104@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Jul 29, 2008 at 09:31:53PM +0200, Christoph Hellwig wrote:
> Make the btree delete code generic.  Based on a patch from David Chinner
> with lots of changes to follow the original btree implementations more
> closely.  While this loses some of the generic helper routines for
> inserting/moving/removing records it also solves some of the one off
> bugs in the original code and makes it easier to verify.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
