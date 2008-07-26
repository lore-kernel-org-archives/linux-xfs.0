Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Jul 2008 02:06:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6Q96Ibw019389
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:06:19 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DFAAC331B65
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:07:28 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id FXk1XyS0A9wuZe5F for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:07:28 -0700 (PDT)
Date: Sat, 26 Jul 2008 19:07:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] update timestamp in xfs_ialloc manually
Message-ID: <20080726090725.GR5947@disturbed>
References: <20080726063331.GA22603@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080726063331.GA22603@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sat, Jul 26, 2008 at 08:33:31AM +0200, Christoph Hellwig wrote:
> In xfs_ialloc we just want to set all timestamps to the current time.
> We don't need to mark the inode dirty like xfs_ichgtime does, and we
> don't need nor want the opimizations in xfs_ichgtime that I will
> introduce in the next patch.

Looks sane, and solves an issue with code I'm working on, too.

FWIW, the conditional check against I_NEW before marking the
indo dirty can be removed as well, as this was call that required
avoiding avoiding it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
