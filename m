Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Jul 2006 10:02:43 -0700 (PDT)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6SH2DDW015221
	for <xfs@oss.sgi.com>; Fri, 28 Jul 2006 10:02:19 -0700
Date: Fri, 28 Jul 2006 17:01:24 +0000 (UTC)
From: Christian Kujau <evil@g-house.de>
Subject: Re: XFS breakage in 2.6.18-rc1
In-Reply-To: <20060724090138.C2083275@wobbly.melbourne.sgi.com>
Message-ID: <Pine.LNX.4.64.0607281526220.1882@sheep.housecafe.de>
References: <20060718222941.GA3801@stargate.galaxy>
 <20060719085731.C1935136@wobbly.melbourne.sgi.com>
 <Pine.LNX.4.64.0607221722500.8407@prinz64.housecafe.de>
 <20060724090138.C2083275@wobbly.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hello again,

On Mon, 24 Jul 2006, Nathan Scott wrote:
> filesystem too.  See the FAQ entry for a description on how to
> translate inums to paths, and also the repair -n step to detect
> any corruption ondisk.

I had two xfs filesystems and I first noticed that /data/Scratch was 
befallen from this bug. I did not care much about this (hence the
name :)) and I wanted to postpone the xfs_db surgery.

Unfortunately I forgot that "/" was also an XFS and it crashed 
yesterday. remounting ro helped a bit (so no process attempted to write 
on it. however, cp'ing from the ro-mounted xfs sometimes hung, 
unkillable), I setup a mini-root somewhere else and followed the
instructions in the FAQ. It did not go too well, lots of 
stuff was moved to lost+found, but every subsequent xfs_repair run 
found more and more errors. I decided to mkfs the partition and make use 
of my backups. my other "scratch" partition is still XFS but mounted ro 
and I'll try the xfsprogs fixes Nathan published on this one.

Oh, and I dd'ed the corrupt xfs-filesystem to a file, so I can play 
around with this one as well.

If anyone is interested, here are the typescripts from the horrible 
xfs_repair runs: http://nerdbynature.de/bits/2.6.18-rc2/log/

cheers,
Christian.
-- 
BOFH excuse #21:

POSIX compliance problem
