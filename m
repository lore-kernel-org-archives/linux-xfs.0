Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB4N8erM010804 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 17:08:40 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6767816AE1CD
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 15:08:39 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id towRRRbtIkh9V46d for <xfs@oss.sgi.com>;
	Thu, 04 Dec 2008 15:08:39 -0800 (PST)
Date: Thu, 4 Dec 2008 18:08:33 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Device loses barrier support (was: Fixed patch for simple
	barriers.)
In-Reply-To: <20081204221551.GV6703@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0812041756550.29638@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0812040009340.15169@hs20-bc2-1.build.redhat.com>
	<20081204100050.GN6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com>
	<20081204142015.GQ6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com>
	<20081204145810.GR6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com>
	<20081204174838.GS6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041401210.23079@hs20-bc2-1.build.redhat.com>
	<20081204221551.GV6703@one.firstfloor.org>
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

On Thu, 4 Dec 2008, Andi Kleen wrote:

> > If you are pushing what you are pushing --- barriers allowing to return 
> > EOPNOTSUPP anytime --- then asynchronous barrier submits can no longer be 
> > used, because by the time EOPNOTSUPP is detected, the filesystem is 
> > already corrupted.
> 
> Chris Mason pointed out that this can actually already happen. From
> a quick review this can happen in MD raid1 at least (their barriers_work
> flag is pretty similar to the DM implementation I did).  So everyone
> has to handle this already anyways.

So: remove barriers completely and use only blkdev_issue_flush to flush 
disk cache. Because none of the major filesystems learned to use 
barrier-optimized commits and this 
"barriers-randomly-fail-with-EOPNOTSUPP" fact makes it impossible to use 
them in an optimized way anyway.

There is another point:
"what is the main performance advantage of barriers?" - "that the user can 
turn on hardware write cache with hdparm -W 1 command".

And if barriers fail at random points, the user can't turn on disk cache 
anyway (he would get data corruption if barrier write failed and hardware 
write cache was enabled). So barriers make no sense here.

> > I'm wondering, where in fsync() does Linux wait for hardware disk cache to 
> > be flushed? Isn't there a bug that fsync() will return before the cache is 
> > flushed? I couldn't really find it. The last thing do_fsync calls is 
> > filemap_fdatawait and it doesn't do cache flush (blkdev_issue_flush).
> 
> At least in fsync() on journaling fs the metadata update should push it.
> 
> -Andi

And what about fdatasync()?

Mikulas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
