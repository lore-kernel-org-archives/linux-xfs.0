Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB5341w1027558 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 21:04:03 -0600
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 426AD16AF36C
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 19:04:00 -0800 (PST)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id SXdtZocLjdfsoDUv for
	<xfs@oss.sgi.com>; Thu, 04 Dec 2008 19:04:00 -0800 (PST)
Date: Fri, 5 Dec 2008 04:09:38 +0100
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Device loses barrier support (was: Fixed patch for simple
	barriers.)
Message-ID: <20081205030938.GA6703@one.firstfloor.org>
References: <20081204145810.GR6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com>
	<20081204174838.GS6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041401210.23079@hs20-bc2-1.build.redhat.com>
	<20081204221551.GV6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041756550.29638@hs20-bc2-1.build.redhat.com>
	<20081205004849.GX6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041948400.14114@hs20-bc2-1.build.redhat.com>
	<20081205013739.GZ6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812042036540.25436@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812042036540.25436@hs20-bc2-1.build.redhat.com>
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

> The only one offender is "md". 

I'm not sure. It wouldn't surprise me if it can happen with other setups
too. Perhaps Chris knows more.

> It is less overhead to change "md" to play 
> nice and be reliable than to double-submit requests in all the places that 
> needs write ordering.

They do that already anyways.

> 
> > > * the filesystems developed hacks to work around this issue, the hacks 
> > > involve not submitting more requests after the barrier request, 
> > 
> > I suspect the reason the file systems did it this way is that
> > it was a much simpler change than to rewrite the transaction
> > manager for this.
> 
> It could be initial reason. But this unreliability also disallows any 
> improvement in filesystems. No one can write asynchronous transaction 
> manager because of that evil EOPNOTSUPP.

Doesn't seem right. It would be a simple state machine
to handle it fully asynchronous. Alternatively you could
always use empty barriers.

But we can worry about that when some in tree file system
actually tries to do that.

-Andi

-- 
ak@linux.intel.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
