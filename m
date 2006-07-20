Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 15:26:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6KMPqDW029306
	for <xfs@oss.sgi.com>; Thu, 20 Jul 2006 15:26:04 -0700
Date: Fri, 21 Jul 2006 08:24:49 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: FAQ updated (was Re: XFS breakage...)
Message-ID: <20060721082448.C1990742@wobbly.melbourne.sgi.com>
References: <20060718222941.GA3801@stargate.galaxy> <20060719085731.C1935136@wobbly.melbourne.sgi.com> <1153304468.3706.4.camel@localhost> <20060720171310.B1970528@wobbly.melbourne.sgi.com> <44BF8500.1010708@dgreaves.com> <20060720161121.GA26748@tuatara.stupidest.org> <20060721081452.B1990742@wobbly.melbourne.sgi.com> <Pine.LNX.4.64.0607201817450.23697@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0607201817450.23697@p34.internal.lan>; from jpiszcz@lucidpixels.com on Thu, Jul 20, 2006 at 06:18:14PM -0400
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Chris Wedgwood <cw@f00f.org>, David Greaves <david@dgreaves.com>, Kasper Sandberg <lkml@metanurb.dk>, Torsten Landschoff <torsten@debian.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, ml@magog.se, radsaq@gmail.com

On Thu, Jul 20, 2006 at 06:18:14PM -0400, Justin Piszcz wrote:
> Nathan,
> 
> Does the bug only occur during a crash?

No, its unrelated to crashing.  Only when adding/removing from a
directory that is in a specific node/btree format (many entries),
and only under a specific set of conditions (like what directory
entry names were used, which blocks they've hashed to and how they
ended up being allocated and in what order each block gets removed
from the directory).

> I have been running 2.6.17.x for awhile now (multiple XFS filesystems, all 
> on UPS) - no issue?

Could be an issue, could be none.  xfs_check it to be sure.

cheers.

-- 
Nathan
