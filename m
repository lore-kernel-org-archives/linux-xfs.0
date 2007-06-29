Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Jun 2007 00:41:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5T7fItL019805
	for <xfs@oss.sgi.com>; Fri, 29 Jun 2007 00:41:21 -0700
Date: Fri, 29 Jun 2007 17:41:14 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs_fsr, performance related tweaks
Message-ID: <20070629074114.GS31489@sgi.com>
References: <4683ADEB.3010106@corky.net> <46841C60.5030207@sandeen.net> <4684A506.4030705@corky.net> <op.tun7i8wd3jf8g2@pc-bnaujok.melbourne.sgi.com> <4684A98B.1030000@corky.net> <20070629070814.GR31489@sgi.com> <4684B1CC.60004@corky.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4684B1CC.60004@corky.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Just Marc <marc@corky.net>
Cc: David Chinner <dgc@sgi.com>, Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com

On Fri, Jun 29, 2007 at 08:16:28AM +0100, Just Marc wrote:
> David,
> 
> In my first post I already said something like that can be done but it's 
> just an ugly hack.   Don't you think it would best be handled cleanly 
> and correctly by fsr itself?

No, I don't - if you want files not to be defragmented, then you
have to set the flags yourself in some way. You have a specific need
that can be solved by some scripting to describe your defrag/no
defrag policy. xfs_fsr has no place is setting defrag policy; it's
function is simply to find and defrag files.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
