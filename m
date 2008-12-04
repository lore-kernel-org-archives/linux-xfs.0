Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB4Hh45J020875 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 11:43:04 -0600
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E6EC16982F9
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 09:43:02 -0800 (PST)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id x1GBTiZ7dOtzTh5f for
	<xfs@oss.sgi.com>; Thu, 04 Dec 2008 09:43:02 -0800 (PST)
Date: Thu, 4 Dec 2008 18:48:38 +0100
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Device loses barrier support (was: Fixed patch for simple
	barriers.)
Message-ID: <20081204174838.GS6703@one.firstfloor.org>
References: <Pine.LNX.4.64.0812040009340.15169@hs20-bc2-1.build.redhat.com>
	<20081204100050.GN6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com>
	<20081204142015.GQ6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com>
	<20081204145810.GR6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andi Kleen <andi-suse@firstfloor.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Andi Kleen <andi@firstfloor.org>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>

On Thu, Dec 04, 2008 at 11:45:44AM -0500, Mikulas Patocka wrote:
> > No there is nothing unordered. The file system path typically looks like
> > 
> > commit of a transaction
> > 	if (i have never seen a barrier failing) 
> > 		write block with barrier
> > 		if (EOPNOTSUPP) {
> > 			record failure
> > 			submit synchronously
> > 		}
> > 	} else
> > 		submit synchronously
> > 
> 
> If you view this as a "right" way of using barriers, then you can drop 

It's the way the file systems do it. If you don't believe me feel
free to read the code for yourself.

> barrier support at all and replace this code sequence with:
> 
>  flush disk cache
>  submit write synchronously
>  flush disk cache
> 
> --- because synchronous barriers bring you no performance advantage over 
> the above sequence.

Remember this is done by a commit thread in a journaling file system. 
Commits are ordered so the thread cannot really order out of order 
anyways. And yes the barriers are essentially a way to flush the cache
regularly for selected commits. The alternative (if you
want to guarantee transaction order) would be to disable
the write cache completely and do it synchronous on each IO.

> 
> > So if a pvmove barrier fails it will just submit synchronously.
> > 
> > The write block with barrier bit varies, jbd/gfs2 do it synchronously
> > too and xfs does it asynchronously (with io done callbacks), but
> 
> And how does xfs preserve write ordering, if the barrier asynchronously 
> fails with -EOPNOTSUPP and there are other writes submitted after the 
> barrier?

>From the high level journaling perspective they are not asynchronous
I think. Just the low level xfs_buf interface happens to use the asynchronous
callbacks instead of calling into the block layer directly like jbd et.al.
do.

-Andi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
