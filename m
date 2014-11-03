Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 957007F57
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 15:56:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7482F304039
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 13:56:21 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	yrSWrexKyPTU56DP for <xfs@oss.sgi.com>;
	Mon, 03 Nov 2014 13:56:18 -0800 (PST)
Date: Tue, 4 Nov 2014 08:56:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: clone of filesystem across network preserving ionodes
Message-ID: <20141103215604.GA23575@dastard>
References: <8688BD11DAC0574AA90295127E9E9F4AC047F1CA@exchangewes8.wesad.wesleyan.edu>
	<5457E813.6030606@sandeen.net>
	<8688BD11DAC0574AA90295127E9E9F4AC047F22D@exchangewes8.wesad.wesleyan.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8688BD11DAC0574AA90295127E9E9F4AC047F22D@exchangewes8.wesad.wesleyan.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Meij, Henk" <hmeij@wesleyan.edu>
Cc: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Nov 03, 2014 at 09:10:10PM +0000, Meij, Henk wrote:
> inodes, yes, yes.  I tried xfs_copy but ran into a problem.
> server1 and server2 each have 4x28T partitions and on server1
> writing the file to one empty partition mounted never finishes,
> hangs at 90%...presumably because it runs out of space (file size
> == sdbx).

Sure, but it's a sparse copy. It only copies the allocated blocks in
the filesystem, so the actual space required is the used space int
eh filesystem (i.e. what df reports as used).

> there is no "skip empty inodes" option and perhaps there
> can't be...

Of course not - you're wanting identical inode numbers on
either end, so your only option is and identical copy. Otherwise
you'd use xfsdump/xfsrestore to skip empty inodes...

> and I have nothing larger. I guess I could attempt
> making sdb4 slightly larger by reducing sdb1-3.

Exactly why do you need an *identical* copy of 28TB filesystems?
What is the problem with inode numbers being different?  And that
begs the question: if you need the filesystems to be completely
identical yet exist on separate systems, then why aren't you using a
block layer construct designed for such operation (e.g. drdb)?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
