Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 00:14:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6O7EHF8021075
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 00:14:18 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49031E93189
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 00:15:27 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 327dAbE2TibWLc6H for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 00:15:27 -0700 (PDT)
Date: Thu, 24 Jul 2008 17:15:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] fix biosize option
Message-ID: <20080724071519.GV6761@disturbed>
References: <20080525190754.GD13372@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080525190754.GD13372@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sun, May 25, 2008 at 09:07:54PM +0200, Christoph Hellwig wrote:
> iosizelog shouldn't be the same as iosize but the logarithm of it.  Then
> again the current biosize option doesn't make much sense to me as it
> doesn't set the preferred I/O size as mentioned in the comment next to

That's a hold-over from irix - biosize set the basic chunk size the
cache used for mapping writes, so was effectively the size of write
to use to avoid RMW cycles as well as the unit of delayed
allocation. 

> it but rather the allocation size and thus is identical to the allocsize
> option (except for the missing logarithm).  It's also not documented in
> Documentation/filesystems/xfs.txt or the mount manpage.

So when it was first added (probably for compatibility) the
allocation part was noticed and not the rest. Maybe we should
hook it up to xfs_preferred_iosize() rather than allocation now
that it exists...

Apart from that, yes it should be the logarithm, so ACK for this
minor mod...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
