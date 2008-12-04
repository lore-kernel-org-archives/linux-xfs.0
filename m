Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB4JUib4028122 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 13:30:45 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C9C316A348C
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 11:30:41 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id 0Ge2zuAhoMFeCbba for <xfs@oss.sgi.com>;
	Thu, 04 Dec 2008 11:30:41 -0800 (PST)
Date: Thu, 4 Dec 2008 11:45:44 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Device loses barrier support (was: Fixed patch for simple
	barriers.)
In-Reply-To: <20081204145810.GR6703@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0812040009340.15169@hs20-bc2-1.build.redhat.com>
	<20081204100050.GN6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com>
	<20081204142015.GQ6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com>
	<20081204145810.GR6703@one.firstfloor.org>
MIME-Version: 1.0
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
To: Andi Kleen <andi@firstfloor.org>
Cc: Milan Broz <mbroz@redhat.com>, Andi Kleen <andi-suse@firstfloor.org>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, xfs@oss.sgi.com

> > > > finished after the 2nd write) and you are in an interrupt context, where 
> > > > you can't reissue -EOPNOTSUPP request. So what do you want to do?
> > > 
> > > The barrier aware file systems I know of just resubmit synchronously when 
> > > a barrier fails.
> > 
> > ... and produce structure corruption for certain period in time, because 
> > the writes meant to be ordered are submitted unordered.
> 
> No there is nothing unordered. The file system path typically looks like
> 
> commit of a transaction
> 	if (i have never seen a barrier failing) 
> 		write block with barrier
> 		if (EOPNOTSUPP) {
> 			record failure
> 			submit synchronously
> 		}
> 	} else
> 		submit synchronously
> 

If you view this as a "right" way of using barriers, then you can drop 
barrier support at all and replace this code sequence with:

 flush disk cache
 submit write synchronously
 flush disk cache

--- because synchronous barriers bring you no performance advantage over 
the above sequence.

> So if a pvmove barrier fails it will just submit synchronously.
> 
> The write block with barrier bit varies, jbd/gfs2 do it synchronously
> too and xfs does it asynchronously (with io done callbacks), but

And how does xfs preserve write ordering, if the barrier asynchronously 
fails with -EOPNOTSUPP and there are other writes submitted after the 
barrier?

> in both cases they handle an EOPNOTSUPP comming out in the final
> io done.

Mikulas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
