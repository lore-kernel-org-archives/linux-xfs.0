Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 30 Jul 2007 12:50:02 -0700 (PDT)
Received: from mail-gw3.sa.ew.hu (mail-gw3.sa.ew.hu [212.108.200.82])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6UJntbm017010
	for <xfs@oss.sgi.com>; Mon, 30 Jul 2007 12:49:56 -0700
In-reply-to: <200707302207.02672.a1426z@gawab.com> (message from Al Boldi on
	Mon, 30 Jul 2007 22:07:02 +0300)
Subject: Re: bonnie++ benchmarks for ext2,ext3,ext4,jfs,reiserfs,xfs,zfs on software raid 5
References: <Pine.LNX.4.64.0707301021090.12456@p34.internal.lan> <200707302207.02672.a1426z@gawab.com>
Message-Id: <E1IFb5f-00006O-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 30 Jul 2007 21:39:39 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: a1426z@gawab.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-raid@vger.kernel.org

> Extrapolating these %cpu number makes ZFS the fastest.
> 
> Are you sure these numbers are correct?

Note, that %cpu numbers for fuse filesystems are inherently skewed,
because the CPU usage of the filesystem process itself is not taken
into account.

So the numbers are not all that good, but according to the zfs-fuse
author it hasn't been optimized yet, so they may improve.

Miklos
