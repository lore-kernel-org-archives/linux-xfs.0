Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB51VWts021275 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 19:31:32 -0600
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6905B16AEEA5
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 17:31:30 -0800 (PST)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id hBJwDSgRygFB8DY7 for
	<xfs@oss.sgi.com>; Thu, 04 Dec 2008 17:31:30 -0800 (PST)
Date: Fri, 5 Dec 2008 02:37:39 +0100
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Device loses barrier support (was: Fixed patch for simple
	barriers.)
Message-ID: <20081205013739.GZ6703@one.firstfloor.org>
References: <20081204142015.GQ6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com>
	<20081204145810.GR6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com>
	<20081204174838.GS6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041401210.23079@hs20-bc2-1.build.redhat.com>
	<20081204221551.GV6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041756550.29638@hs20-bc2-1.build.redhat.com>
	<20081205004849.GX6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041948400.14114@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812041948400.14114@hs20-bc2-1.build.redhat.com>
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

> * barrier support in md-raid1 deviates from the specification at 
> Documentation/block/barrier.txt. The specification says that requests 
> submitted after the barrier request hit the media after the barrier 
> request hits the media. The reality is that the barrier request can be 
> randomly aborted and the requests submitted after it hit the media before 
> the barrier request.

Yes the spec should be probably updated.

But also see Linus' rant from yesterday about code vs documentation.
When in doubt the code wins.
> 
> * the filesystems developed hacks to work around this issue, the hacks 
> involve not submitting more requests after the barrier request, 

I suspect the reason the file systems did it this way is that
it was a much simpler change than to rewrite the transaction
manager for this.

> synchronously waiting for the barrier request and eventually retrying it. 
> These hacks suppress any performance advantage barriers could bring.
> 
> * you submit a patch that makes barriers even more often deviate from the 
> specification and you argue that the patch is correct because filesystems 
> handle this deviation.

Sorry what counts is the code behaviour, not the specification.

-Andi

-- 
ak@linux.intel.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
