Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 15:54:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NMseOa031668
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 15:54:41 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8C4131D31A
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 15:55:50 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id Z4HFm3zfNTLShY2U for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 15:55:50 -0700 (PDT)
Date: Thu, 24 Jul 2008 08:55:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] implement IHOLD/IRELE directly
Message-ID: <20080723225548.GO6761@disturbed>
References: <20080723194950.GF6188@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723194950.GF6188@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Jul 23, 2008 at 09:49:50PM +0200, Christoph Hellwig wrote:
> Now that all direct calls to VN_HOLD/VN_RELE are gone we can implement
> IHOLD/IRELE directly.
> 
> For the IHOLD case also replace igrab with a direct increment of i_count
> because we are guaranteed to already have a live and referenced inode
> by the VFS.  Also remove the vn_hold statistic because it's been rather
> meaningless for some time with most references done by other callers.

Seeing as you are changing from an igrab() to a straight
atomic_inc(), can you put an:

ASSERT(atomic_read(&VFS_I(ip)->i_count) > 0)

into the IHOLD macro so we catch screwups in reference counting as
quickly as possible?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
