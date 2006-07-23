Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Jul 2006 16:03:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6NN2SDW019715
	for <xfs@oss.sgi.com>; Sun, 23 Jul 2006 16:02:39 -0700
Date: Mon, 24 Jul 2006 09:01:38 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: XFS breakage in 2.6.18-rc1
Message-ID: <20060724090138.C2083275@wobbly.melbourne.sgi.com>
References: <20060718222941.GA3801@stargate.galaxy> <20060719085731.C1935136@wobbly.melbourne.sgi.com> <Pine.LNX.4.64.0607221722500.8407@prinz64.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0607221722500.8407@prinz64.housecafe.de>; from evil@g-house.de on Sat, Jul 22, 2006 at 05:27:24PM +0100
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Kujau <evil@g-house.de>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sat, Jul 22, 2006 at 05:27:24PM +0100, Christian Kujau wrote:
> On Wed, 19 Jul 2006, Nathan Scott wrote:
> > 2.6.18-rc1 should be fine (contains the corruption fix).  Did you
> > mkfs and restore?  Or at least get a full repair run?  If you did,
> > and you still see issues in .18-rc1, please let me know asap.
> 
> well, at least for me, corruption/errors *started* with 2.6.18-rc1:
> ...
> I downgraded to 2.6.17.5 and the errors stopped. Now I've upgraded to 
> 2.6.18-rc2 and see the same errors:
> 
> xfs_da_do_buf: bno 16777216
> dir: inode 24472381

This is an ondisk corruption - downgrading the kernel will not
resolve it.  The problem must be triggered by a combination of
operations on a directory; I'm certain that if you access inode
24472381 on your filesystem on 2.6.17, that it'll shutdown your
filesystem too.  See the FAQ entry for a description on how to
translate inums to paths, and also the repair -n step to detect
any corruption ondisk.

cheers.

-- 
Nathan
