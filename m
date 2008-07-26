Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Jul 2008 02:11:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6Q9BLif019995
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:11:21 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3F4AAEA58FE
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:12:32 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id J1y9H0ggDGvpOWa8 for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:12:32 -0700 (PDT)
Date: Sat, 26 Jul 2008 19:12:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] optimize xfs_ichgtime
Message-ID: <20080726091230.GS5947@disturbed>
References: <20080726063335.GB22603@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080726063335.GB22603@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sat, Jul 26, 2008 at 08:33:35AM +0200, Christoph Hellwig wrote:
> Port a little optmization from file_update_time to xfs_ichgtime, and
> only update the timestamp and mark the inode dirty if the timestamp
> actually changes in the timer tick resultion supported by the running
> kernel.

Looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
