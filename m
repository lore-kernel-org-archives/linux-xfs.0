Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5G7VIDt120861 for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 02:31:18 -0500
Received: from mga02.intel.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A3C112AF83B
	for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 00:37:32 -0700 (PDT)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
	cuda.sgi.com with ESMTP id kxGuTqxb0jU26UpK for
	<xfs@oss.sgi.com>; Wed, 16 Jun 2010 00:37:32 -0700 (PDT)
Message-ID: <4C187E56.70601@linux.intel.com>
Date: Wed, 16 Jun 2010 09:33:42 +0200
From: Andi Kleen <ak@linux.intel.com>
MIME-Version: 1.0
Subject: Re: [PATCH] XFS: Fix gcc 4.6 set but not read and unused statement
	warnings v2
References: <20100614081356.GA27499@basil.fritz.box>	<20100614083021.GA29354@lst.de>
	<4C15EF75.5080909@linux.intel.com>	<20100614124804.GA8547@lst.de>	<20100614133958.GH17092@basil.fritz.box>
	<20100614163122.GB369@basil.fritz.box>
	<4C183B63.5090306@sandeen.net>
In-Reply-To: <4C183B63.5090306@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@lst.de>, dgc@fromorbit.com, xfs@oss.sgi.com


> really?
>
> $ make SUBDIRS=fs/xfs
>    CC [M]  fs/xfs/linux-2.6/xfs_super.o
> fs/xfs/linux-2.6/xfs_super.c:73:2: error: #error DEBUG
> make[1]: *** [fs/xfs/linux-2.6/xfs_super.o] Error 1
>
> $ grep -A3 XFS_DEBUG fs/xfs/linux-2.6/xfs_super.c
> #ifdef CONFIG_XFS_DEBUG
> #error DEBUG
> #endif
>
> (above just for testing)
>
> Offtopic I guess, but it sure seems to set it for me.

You did a full build with XFS_DEBUG before without SUBDIRS, right?

Kbuild puts the options into special .cmd files and I think
those only get rebuild on a full build, not on a SUBDIRS
build. So it never picked up the changed option for me.

Anyways that's the current theory, haven't retested that.

-Andi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
