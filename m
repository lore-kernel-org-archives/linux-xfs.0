Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 01 Jul 2007 15:43:52 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l61MhktL023774
	for <xfs@oss.sgi.com>; Sun, 1 Jul 2007 15:43:48 -0700
Date: Mon, 2 Jul 2007 08:43:39 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs_fsr, performance related tweaks
Message-ID: <20070701224339.GV31489@sgi.com>
References: <4683ADEB.3010106@corky.net> <46841C60.5030207@sandeen.net> <4684A506.4030705@corky.net> <op.tun7i8wd3jf8g2@pc-bnaujok.melbourne.sgi.com> <4684A98B.1030000@corky.net> <20070629070814.GR31489@sgi.com> <4684B1CC.60004@corky.net> <20070629074114.GS31489@sgi.com> <46869029.3040704@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46869029.3040704@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, Just Marc <marc@corky.net>, Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com

On Sat, Jun 30, 2007 at 01:17:29PM -0400, Eric Sandeen wrote:
> David Chinner wrote:
> > On Fri, Jun 29, 2007 at 08:16:28AM +0100, Just Marc wrote:
> >> David,
> >>
> >> In my first post I already said something like that can be done but it's 
> >> just an ugly hack.   Don't you think it would best be handled cleanly 
> >> and correctly by fsr itself?
> > 
> > No, I don't - if you want files not to be defragmented, then you
> > have to set the flags yourself in some way. You have a specific need
> > that can be solved by some scripting to describe your defrag/no
> > defrag policy. xfs_fsr has no place is setting defrag policy; it's
> > function is simply to find and defrag files.
> 
> I wouldn't mind seeing a way to tell fsr to not worry about defragging
> some files based on current layout; say if the avg extent in the file is
> > 100MB, or > 1G, don't bother... if today you have a 4.7G DVD iso image
> in 3 extents (not bad) fsr will try to "fix" it for you right?

That could be easily done with command line options, I think. Define
the minimum extent length or number of extents we want files to have
and ignore those that are outside that criteria.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
