Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Jun 2007 00:08:33 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5T78PtL009302
	for <xfs@oss.sgi.com>; Fri, 29 Jun 2007 00:08:27 -0700
Date: Fri, 29 Jun 2007 17:08:14 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs_fsr, performance related tweaks
Message-ID: <20070629070814.GR31489@sgi.com>
References: <4683ADEB.3010106@corky.net> <46841C60.5030207@sandeen.net> <4684A506.4030705@corky.net> <op.tun7i8wd3jf8g2@pc-bnaujok.melbourne.sgi.com> <4684A98B.1030000@corky.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4684A98B.1030000@corky.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Just Marc <marc@corky.net>
Cc: Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com

On Fri, Jun 29, 2007 at 07:41:15AM +0100, Just Marc wrote:
> Barry Naujok wrote:
> >You can use the xfs_io chattr command to mark known files as
> >nodefrag. Using the chattr -R option can be used to recurse
> >directories.
> 
> That's right but I can't do this on a filesystem that's just been 
> defragged say a minute ago, and in the mean time 20 new files got added 
> (I don't know what these files are... ).

So walk the filesystem with a script that queries the number of
extents in each file, and if they have a single extent then
run the xfs_io on them.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
