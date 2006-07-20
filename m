Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 15:54:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6KMrQDW000790
	for <xfs@oss.sgi.com>; Thu, 20 Jul 2006 15:53:38 -0700
Date: Fri, 21 Jul 2006 08:52:30 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: FAQ updated (was Re: XFS breakage...)
Message-ID: <20060721085230.F1990742@wobbly.melbourne.sgi.com>
References: <20060718222941.GA3801@stargate.galaxy> <20060719085731.C1935136@wobbly.melbourne.sgi.com> <1153304468.3706.4.camel@localhost> <20060720171310.B1970528@wobbly.melbourne.sgi.com> <44BF8500.1010708@dgreaves.com> <20060720161121.GA26748@tuatara.stupidest.org> <20060721081452.B1990742@wobbly.melbourne.sgi.com> <Pine.LNX.4.64.0607201817450.23697@p34.internal.lan> <20060721082448.C1990742@wobbly.melbourne.sgi.com> <Pine.LNX.4.64.0607201843020.2619@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0607201843020.2619@p34.internal.lan>; from jpiszcz@lucidpixels.com on Thu, Jul 20, 2006 at 06:43:34PM -0400
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Chris Wedgwood <cw@f00f.org>, David Greaves <david@dgreaves.com>, Kasper Sandberg <lkml@metanurb.dk>, Torsten Landschoff <torsten@debian.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, ml@magog.se, radsaq@gmail.com

On Thu, Jul 20, 2006 at 06:43:34PM -0400, Justin Piszcz wrote:
> p34:~# xfs_check -v /dev/md3
> xfs_check: out of memory
> p34:~#
> 
> D'oh...

xfs_repair -n is another option, it has a cheaper (memory wise,
usually) checking algorithm.

> As long as it mounted ok with the patched kernel, should one be ok?

Not necessarily, no - mount will only read the root inode.

cheers.

-- 
Nathan
