Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 14:26:58 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9TLQnBV012360
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 14:26:52 -0700
Date: Tue, 30 Oct 2007 08:26:49 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Default mount options (that suck less).
Message-ID: <20071029212649.GL995458@sgi.com>
References: <20071029075657.GA84369978@melbourne.sgi.com> <20071029085502.GI995458@sgi.com> <4725E7D0.8090400@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4725E7D0.8090400@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, Niv Sardi <xaiki@sgi.com>, xfs@oss.sgi.com

On Mon, Oct 29, 2007 at 09:01:52AM -0500, Eric Sandeen wrote:
> David Chinner wrote:
> > On Mon, Oct 29, 2007 at 06:56:57PM +1100, Niv Sardi wrote:
> >> Hello,
> >>
> >> XFS's default mount options are in most cases sub-optimal, we should try
> > 
> > Mkfs options ;)
> > 
> >> to have more sensible defaults, so far I'm following some quick dave-powered
> >> recomendations:
> >>
> >> - version 2 logs
> >> - attr2
> >> - lazy superblock counters
> >> - less allocation groups for single disk configs
> >>
> >> - imaxpct default can be reduced
> >>
> >> it is currently 25, what would be reasonable ?
> > 
> > Given that 25% on a 4GB filesystem will allow about 5million inodes,
> > I think it's probably reasonable to bring it down to 5% by the time we
> > pass 1TB and 1% by 50TB.....
> 
> But what does this affect?  It's a cap, but it doesn't affect allocation
> policy or anything does it?  What's the downside to 25%?

It reserves allocation groups as "metadata only" for inode32 filesystems
so data doesn't get placed in them untill all other space is full. So at
1TB, we don't use 25% of the filesystem until the other 75% is full, yet
to hold 4 million inodes we only need about 1GB of space. so 5GB out of
1TB gives us space in the filesystem for ~20m million inodes by default.
AFAICT, this is the only place it is used.

Likewise, at 50TB, we're only going to be able to use 2% of the filesystem
for inodes with inode32. At 100TB, it's meaningless.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
