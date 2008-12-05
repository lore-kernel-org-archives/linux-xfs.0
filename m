Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB51LBDD020663 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 19:21:12 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F129D16AF26B
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 17:21:10 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id BMoHB2dhbbHJd8ev for <xfs@oss.sgi.com>;
	Thu, 04 Dec 2008 17:21:10 -0800 (PST)
Date: Thu, 4 Dec 2008 20:16:23 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Device loses barrier support (was: Fixed patch for simple
	barriers.)
In-Reply-To: <20081205004849.GX6703@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0812041948400.14114@hs20-bc2-1.build.redhat.com>
References: <20081204100050.GN6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com>
	<20081204142015.GQ6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com>
	<20081204145810.GR6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com>
	<20081204174838.GS6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041401210.23079@hs20-bc2-1.build.redhat.com>
	<20081204221551.GV6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041756550.29638@hs20-bc2-1.build.redhat.com>
	<20081205004849.GX6703@one.firstfloor.org>
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

On Fri, 5 Dec 2008, Andi Kleen wrote:

> > And if barriers fail at random points, the user can't turn on disk cache 
> > anyway (he would get data corruption if barrier write failed and hardware 
> 
> I think we already established earlier in the thread that there is no disk
> corruption

So, the facts are:

* barrier support in md-raid1 deviates from the specification at 
Documentation/block/barrier.txt. The specification says that requests 
submitted after the barrier request hit the media after the barrier 
request hits the media. The reality is that the barrier request can be 
randomly aborted and the requests submitted after it hit the media before 
the barrier request.

* the filesystems developed hacks to work around this issue, the hacks 
involve not submitting more requests after the barrier request, 
synchronously waiting for the barrier request and eventually retrying it. 
These hacks suppress any performance advantage barriers could bring.

* you submit a patch that makes barriers even more often deviate from the 
specification and you argue that the patch is correct because filesystems 
handle this deviation.

This is runaway logic that will eventually turn Linux into unmaintainable 
mess. What do you think we'll be doing when we'll be implementing barriers 
into other dm targets? Do you really think it'll be fun to write code to 
double-submit all metadata writes just because you and some person at 
md-raid1 provided an unreliable interface?

I am again repeating: either make barriers consistent with the 
specification, or remove them at all.

Mikulas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
