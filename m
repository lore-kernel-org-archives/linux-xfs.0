Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 243057F53
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 13:30:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A6919AC002
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 11:30:00 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	6n7getHstFZvASAv for <xfs@oss.sgi.com>;
	Sun, 20 Dec 2015 11:29:57 -0800 (PST)
Date: Mon, 21 Dec 2015 06:29:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Integer truncation in fs/xfs/libxfs/xfs_da_btree.c
Message-ID: <20151220192932.GR26718@dastard>
References: <5676A0C6.9000407@posteo.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5676A0C6.9000407@posteo.de>
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
To: Kristian <kbx@posteo.de>
Cc: xfs@oss.sgi.com

On Sun, Dec 20, 2015 at 01:36:22PM +0100, Kristian wrote:
> Hello,
> 
> there is an integer truncation in
> 
> fs/xfs/libxfs/xfs_da_btree.c +2081
> 
> /* account for newly allocated blocks in reserved blocks total */
> args->total -= dp->i_d.di_nblocks - nblks;
> 
> with the types: uint32 -= uint64 - uint64
> 
> On a hardened kernel with grsecurity enabled, this leads to a fault.
> 
> https://forums.grsecurity.net/viewtopic.php?f=3&t=4346&sid=3200600c0faaab4bf8779a95c549a737
> 
> Is this intentional and safe?

Yes and yes. We can be, at most, asking for 128 blocks to be
allocated in this function, so that  "uint64 - uint64" will
typically have a value of 1 or 2. the worst case is about 130 in the
most extreme, never-used-but-still-possible filesystem
configuration.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
