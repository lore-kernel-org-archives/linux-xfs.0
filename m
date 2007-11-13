Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 Nov 2007 13:09:02 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lADL8rDD009492
	for <xfs@oss.sgi.com>; Tue, 13 Nov 2007 13:08:57 -0800
Date: Wed, 14 Nov 2007 08:08:53 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs_repair - what's the damage?
Message-ID: <20071113210853.GY995458@sgi.com>
References: <4739F2CD.2020800@synplicity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4739F2CD.2020800@synplicity.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Eddington <chrise@synplicity.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Nov 13, 2007 at 10:54:05AM -0800, Chris Eddington wrote:
> Hi,
> 
> Can someone point me to instructions on how to understand the scope of
> damage to this filesystem based on the output from xfs_repair below?
> What is it repairing, and what data is lost?  I'm not sure how to interpret
> these messages or where to go to find out.

Looks like you had something write crap over various parts of
the filesystem. Both AG 2 and ag 24 have header problems, and
then there's a bunch of freespace and allocated inode problems
because the indexes were lost due ot the header corruption.

Who knows how much else is broken - it depends on how much
bad data got written into the filesystem. best you can do is
to run xfs_repair and sift through the debris in lost+found
and try to work out what the lost data is...

As I always ask - how did the filesytem get into this state?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
