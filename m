Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB53LFgf029021 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 21:21:16 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ACE5316B0ACB
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 19:21:14 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id qVdNJpfu8WGFkDV7 for <xfs@oss.sgi.com>;
	Thu, 04 Dec 2008 19:21:14 -0800 (PST)
Date: Thu, 4 Dec 2008 21:21:44 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Device loses barrier support (was: Fixed patch for simple
	barriers.)
In-Reply-To: <20081205013739.GZ6703@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0812042036540.25436@hs20-bc2-1.build.redhat.com>
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
	<20081205013739.GZ6703@one.firstfloor.org>
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

> > * barrier support in md-raid1 deviates from the specification at 
> > Documentation/block/barrier.txt. The specification says that requests 
> > submitted after the barrier request hit the media after the barrier 
> > request hits the media. The reality is that the barrier request can be 
> > randomly aborted and the requests submitted after it hit the media before 
> > the barrier request.
> 
> Yes the spec should be probably updated.
> 
> But also see Linus' rant from yesterday about code vs documentation.
> When in doubt the code wins.

The only one offender is "md". It is less overhead to change "md" to play 
nice and be reliable than to double-submit requests in all the places that 
needs write ordering.

> > * the filesystems developed hacks to work around this issue, the hacks 
> > involve not submitting more requests after the barrier request, 
> 
> I suspect the reason the file systems did it this way is that
> it was a much simpler change than to rewrite the transaction
> manager for this.

It could be initial reason. But this unreliability also disallows any 
improvement in filesystems. No one can write asynchronous transaction 
manager because of that evil EOPNOTSUPP.

> > synchronously waiting for the barrier request and eventually retrying it. 
> > These hacks suppress any performance advantage barriers could bring.
> > 
> > * you submit a patch that makes barriers even more often deviate from the 
> > specification and you argue that the patch is correct because filesystems 
> > handle this deviation.
> 
> Sorry what counts is the code behaviour, not the specification.

Better interface is that one that has less maintenance overhead. And I 
don't see requiring the programmers of all IO code to double-submit 
requests as less maintenance overhead.

> -Andi

Mikulas

---

If you want to make it easier to infer functionality from the code, apply 
this patch :)

---
 block/blk-core.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6.28-rc5-devel/block/blk-core.c
===================================================================
--- linux-2.6.28-rc5-devel.orig/block/blk-core.c	2008-12-05 02:54:25.000000000 +0100
+++ linux-2.6.28-rc5-devel/block/blk-core.c	2008-12-05 03:14:23.000000000 +0100
@@ -28,6 +28,7 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/blktrace_api.h>
 #include <linux/fault-inject.h>
+#include <linux/random.h>
 
 #include "blk.h"
 
@@ -1528,6 +1529,13 @@ void submit_bio(int rw, struct bio *bio)
 
 	bio->bi_rw |= rw;
 
+	/* At least, make the true nature of write barriers obvious. */
+
+	if (bio_barrier(bio) && !(random32() % 42)) {
+		bio_endio(bio, -EOPNOTSUPP);
+		return;
+	}
+
 	/*
 	 * If it's a regular read/write or a barrier with data attached,
 	 * go through the normal accounting stuff before submission.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
