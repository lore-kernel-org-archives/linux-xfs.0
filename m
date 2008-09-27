Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 26 Sep 2008 18:18:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8R1IkZb020793
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 18:18:46 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BED7048BAB2
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 18:20:21 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id yH3NrCkuGEELkDGS for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 18:20:21 -0700 (PDT)
Date: Sat, 27 Sep 2008 11:20:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: inode64 question
Message-ID: <20080927012019.GT27997@disturbed>
References: <alpine.DEB.1.10.0809251943420.5846@p34.internal.lan> <20080926063050.GA20516@infradead.org> <48DCF1FE.3080305@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DCF1FE.3080305@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com

On Fri, Sep 26, 2008 at 09:30:22AM -0500, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > On Thu, Sep 25, 2008 at 07:44:33PM -0400, Justin Piszcz wrote:
> >> If I mount the fs with -o inode64, can I mount it again later say under  
> >> knoppix 32bit without any options, will the FS still mount?  The 64-bit  
> >> rescue cd/dvds--I have had problems with to say the least.
> > 
> > Not yet.  I'll hopefully get a patch for it into 2.6.28.
> 
> Actually it *will* at least mount, won't it?  But that's dangerous.  I
> don't think xfs sets any kind of superblock flag saying "I contain
> inodes past 2^32, don't mount on 32-bit boxes" does it?

Right. It will mount, but what happens with inodes past 2^32 is
undefined. You might be lucky - you might not....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
