Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 12:53:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6OJr4hK028884
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 12:53:05 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F2F132A7AD
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 12:54:14 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 2wxL0LrpQ9qg3eOy for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 12:54:14 -0700 (PDT)
Date: Thu, 24 Jul 2008 21:54:03 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/4] fix biosize option
Message-ID: <20080724195403.GB2962@lst.de>
References: <20080525190754.GD13372@lst.de> <20080724071519.GV6761@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724071519.GV6761@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Jul 24, 2008 at 05:15:19PM +1000, Dave Chinner wrote:
> On Sun, May 25, 2008 at 09:07:54PM +0200, Christoph Hellwig wrote:
> > iosizelog shouldn't be the same as iosize but the logarithm of it.  Then
> > again the current biosize option doesn't make much sense to me as it
> > doesn't set the preferred I/O size as mentioned in the comment next to
> 
> That's a hold-over from irix - biosize set the basic chunk size the
> cache used for mapping writes, so was effectively the size of write
> to use to avoid RMW cycles as well as the unit of delayed
> allocation. 
> 
> > it but rather the allocation size and thus is identical to the allocsize
> > option (except for the missing logarithm).  It's also not documented in
> > Documentation/filesystems/xfs.txt or the mount manpage.
> 
> So when it was first added (probably for compatibility) the
> allocation part was noticed and not the rest. Maybe we should
> hook it up to xfs_preferred_iosize() rather than allocation now
> that it exists...

Or just stop making the option have any effect and just print a message
that it's ignored..
