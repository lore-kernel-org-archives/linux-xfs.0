Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 23:56:40 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S6uXMw025133
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 23:56:34 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 06E145506FF
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 23:56:32 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id G0Gq3oDWxa06dCet for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 23:56:32 -0700 (PDT)
Date: Tue, 28 Oct 2008 17:56:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/7] kill xfs_dinode_core_t
Message-ID: <20081028065629.GT4985@disturbed>
References: <20081027133912.GF1109@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027133912.GF1109@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 27, 2008 at 09:39:12AM -0400, Christoph Hellwig wrote:
> Now that we have a separate xfs_icdinode_t for the in-core inode which
> gets logged there is no need anymore for the xfs_dinode vs xfs_dinode_core
> split - the fact that part of the structure gets logged through the inode
> log item and a small part not can better be described in a comment.
> 
> All sizeof operations on the dinode_core either really wanted the
> icdinode and are switched to that one, or had already added the size
> of the agi unlinked list pointer.  Later both will be replaced with
> helpers once we get the larger CRC-enabled dinode.
> 
> Removing the data and attribute fork unions also has the advantage that
> xfs_dinode.h doesn't need to pull in every header under the sun.
> 
> While we're at it also add some more comments describing the dinode
> structure.
> 
> (First sent on October 7th)
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com
