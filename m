Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 27 May 2008 16:20:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4RNKQ64026560
	for <xfs@oss.sgi.com>; Tue, 27 May 2008 16:20:28 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 95A401C00CD
	for <xfs@oss.sgi.com>; Tue, 27 May 2008 16:21:16 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id 47xYwaX2gE1Nd9vU for <xfs@oss.sgi.com>; Tue, 27 May 2008 16:21:16 -0700 (PDT)
Date: Wed, 28 May 2008 09:21:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_check
Message-ID: <20080527232111.GB3819@disturbed>
References: <20080527162605.GA30344@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080527162605.GA30344@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, May 27, 2008 at 06:26:05PM +0200, Christoph Hellwig wrote:
> In the past we had quite a few cases where we told people to run
> xfs_repair -n instead of xfs_check.  I think that makes a lot of sense
> because xfs_repair -n generally gives output at least as useful as
> xfs_check if not more so and also is a lot faster.  Is there any reason
> why we shouldn't simply kill xfs_check and replaced it with a wrapper
> around xfs_repair?

xfs_repair doesn't yet check free space btrees - it simply
blows them away and rebuilds htem from scratch. Hence errors
in those btrees will go unreported. xfs_check will tell you
about errors in those trees.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
