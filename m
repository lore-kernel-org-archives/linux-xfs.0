Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Jul 2008 02:21:33 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6Q9LVGQ022054
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:21:31 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BCF00192E6E7
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:22:41 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 3JCKth2njDOLV3FG for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:22:41 -0700 (PDT)
Date: Sat, 26 Jul 2008 19:22:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] stop using file_update_time
Message-ID: <20080726092238.GU5947@disturbed>
References: <20080726063339.GC22603@lst.de> <20080726091348.GT5947@disturbed> <20080726091428.GA29710@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080726091428.GA29710@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sat, Jul 26, 2008 at 11:14:28AM +0200, Christoph Hellwig wrote:
> On Sat, Jul 26, 2008 at 07:13:48PM +1000, Dave Chinner wrote:
> > I don't think you meant to remove the xfs_ichgtime() prototype
> > as well...
> 
> Actually I did, but I forgot to mention why.  There's a second prototype
> in xfs_inode.h which is enough.

Ah, ok, so there is. Looks good, then ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
