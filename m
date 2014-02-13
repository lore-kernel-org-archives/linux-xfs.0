Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7E7727F55
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 16:12:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 52C288F8039
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 14:12:06 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	cT3Rz7XbqyGlHbX4 for <xfs@oss.sgi.com>;
	Thu, 13 Feb 2014 14:12:04 -0800 (PST)
Date: Fri, 14 Feb 2014 09:11:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.14-rc2: RECLAIM_FS-safe -> RECLAIM_FS-unsafe lock order detected
Message-ID: <20140213221128.GJ13997@dastard>
References: <alpine.DEB.2.19.4.1402120008320.6233@trent.utfs.org>
	<alpine.DEB.2.19.4.1402131153300.6233@trent.utfs.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.19.4.1402131153300.6233@trent.utfs.org>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: xfs@oss.sgi.com

On Thu, Feb 13, 2014 at 11:56:36AM -0800, Christian Kujau wrote:
> On Wed, 12 Feb 2014 at 00:11, Christian Kujau wrote:
> > After upgrading from 3.13-rc8 to 3.14-rc2 on this PowerPC G4 machine, this 
> > happened:
> 
> Yesterday a slighly different lockdep warning was printed:
> 
>  =========================================================
>  [ INFO: possible irq lock inversion dependency detected ]
>  3.14.0-rc2 #1 Tainted: G        W   
>  ---------------------------------------------------------
>  kswapd0/279 just changed the state of lock:
>   (&(&ip->i_lock)->mr_lock){++++.?}, at: [<c01c213c>] 
> xfs_free_eofblocks+0xe8/0x2e0
>  but this lock took another, RECLAIM_FS-unsafe lock in the past:
>   (&mm->mmap_sem){++++++}
>  
>  and interrupts could create inverse lock ordering between them.

False positive - it's confusing directory locking orders with
regular files. Already reported, but the devs responsible for the
lockdep regression have not responded. Looks like I'll have to
fix it myself. I'll see what I can do today.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
