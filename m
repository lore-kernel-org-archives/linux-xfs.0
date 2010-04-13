Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3D2tgIR184828 for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 21:55:42 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E89062BA67B
	for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 19:57:36 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.186]) by cuda.sgi.com with ESMTP id
	HLItfppOV2CxooqT for <xfs@oss.sgi.com>;
	Mon, 12 Apr 2010 19:57:36 -0700 (PDT)
Date: Mon, 12 Apr 2010 19:57:26 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.34-rc3: inode 0x401afe0 background reclaim flush failed with
	11
In-Reply-To: <20100413024946.GP2493@dastard>
Message-ID: <alpine.DEB.2.01.1004121950510.29272@bogon.housecafe.de>
References: <alpine.DEB.2.01.1004091348010.29272@bogon.housecafe.de>
	<20100413024946.GP2493@dastard>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, 13 Apr 2010 at 12:49, Dave Chinner wrote:
> No.
> 
> http://git.kernel.org/?p=linux/kernel/git/dgc/xfs.git;a=commit;h=7bb6049804717d4aa1f43f2abb50691c0df1d9f2

Ah, thanks. It's not in -rc4 yet, will it be included in the next release?

> > PS: Why is the inode shown in hex and not in decimal? Would something 
> > like this do:
> 
> Because I find that large inode numbers in hex are much easier to
> understand than huge decimal numbers. The inode number is a direct
> encoding of it's location on disk and these days I can generally
> decode them in my head direct from the hex value.

Hehe, OK. Will learn how to do that too :-)

> IOWs, the first
> thing I almost always do when looking at an inode number is convert
> it to hex, so I don't see any point in printing them in decimal...

I was tempted to "find . -inum" to find out which data might be in trouble 
but then noticed that I had to convert it to decimal first.

> e.g. without knowing the geometry of the filesystem, I'd guess that
> inode 0x401afe0 is inode 0x20 (32) of an inode allocation chunk,
> it's AG 2, 4, 8 or 16 (depends on the size of the AGs), and the
> block offset into the AG is 0xd7e (agbno 3454). From that I know a
> lot about the inode - it's the first in an inode cluster buffer and
> the other inodes reported are in the same buffer hence it's only one
> one busy buffer that caused the warnings, the agbno is small so it's
> near the start of the AG so there probably aren't a large number of
> inodes in the filesystem, etc.

Wow, OK. I respectfully withdraw my proposal then. Thanks for the 
explanation.

Christian.
-- 
BOFH excuse #267:

The UPS is on strike.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
