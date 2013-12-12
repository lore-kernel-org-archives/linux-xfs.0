Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 809327F54
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 01:22:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 50E9530406B
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 23:22:34 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	x8KLZpqppLaUKtsV for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 23:22:32 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vr0bM-0000oE-KC
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 18:22:28 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vr0bM-0005Bl-J4
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 18:22:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/5] xfs_repair: scalability inmprovements
Date: Thu, 12 Dec 2013 18:22:20 +1100
Message-Id: <1386832945-19763-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

HI folks,

The following 5 patches to xfs_repair improve scalability on high
IOPS devices. They remove contention points that limit the number of
IO threads that we can use, whilst also protecting against using too
much concurrency.

The first patch removes a contention point in a 3rd party
translation library by avoiding translating static data repeatedly.

The second separates the per-ag locks into separate cachelines, so
we don't get threads working on different AGs contending on
cachelines shared by non-shared locks.

THe third parallelises phase 6, which was never done because the
original repair parallelism work didn't show it to be a significant
contributor to runtime. Even serialised it was as fast as the
parallelised phases. However, that's a different story now with SSDs
- it's the only phase that is CPU bound because it doesn't spread
the work across multiple CPUs, and so is by far the slowest phase of
repair on SSDs.

The fourht patch corrects a problem with CPU usage in the buffer
cache - the hash table distributions are awful.

Finally, the last patch fixes a problem reported by Michael Semon
where too much concurrency was being used by xfs_repair and hence
failing because it was unable to allocate threads.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
