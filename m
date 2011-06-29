Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5TLsTKg144792 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 16:54:30 -0500
Received: from e33.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 46A5414FA5D6
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 14:54:28 -0700 (PDT)
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151]) by
	cuda.sgi.com with ESMTP id CEShJazZPDt8LKmL for
	<xfs@oss.sgi.com>; Wed, 29 Jun 2011 14:54:28 -0700 (PDT)
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by e33.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5TLkrmv023556
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 15:46:53 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5TLsNb9180252 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 15:54:23 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p5TFsMdE004232
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 09:54:22 -0600
Subject: Re: xfstests test case 180 fails often
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20110629010457.GR32466@dastard>
References: <1308077464.7661.473.camel@chandra-lucid.beaverton.ibm.com>
	<1308259762.2717.31.camel@doink>
	<1309304361.5505.6211.camel@chandra-lucid.beaverton.ibm.com>
	<20110629010457.GR32466@dastard>
Date: Wed, 29 Jun 2011 14:54:22 -0700
Message-ID: <1309384462.5505.6279.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: aelder@sgi.com, XFS Mailing List <xfs@oss.sgi.com>

On Wed, 2011-06-29 at 11:04 +1000, Dave Chinner wrote:
> On Tue, Jun 28, 2011 at 04:39:21PM -0700, Chandra Seetharaman wrote:
> > On Thu, 2011-06-16 at 16:29 -0500, Alex Elder wrote:
> > > On Tue, 2011-06-14 at 11:51 -0700, Chandra Seetharaman wrote:
> > > > Hello All,
> > > > 
> > > > test case 180 fails often (4 out of 5) in my x86_64 system.
> > > > Any suggestions on how to proceed to debug ?
> > > 
> > > I have been seeing failures like that sometimes
> > > (more often recently I think) for a while.  I
> > > have not had the chance to really chase it down.
> > > 
> > > If you can reproduce it pretty relibly you could
> > > use "git bisect" to try to find out whether the
> > > failures started to occur after a particular
> > > commit.
> > 
> > I tried git bisect and it ended up in a qla2xxx fix (and I do not even
> > have qlogic card in that system).
> > 
> > I did it couple more times and landed on different patches.
> 
> That indicates your test case is not 100% reliable. :/
> 
Agreed. That is why I tested the "supposedly"(thru git bisect) good one 
for about 500 iterations to verfify the failing patch.

OTOH, can you suggest a test that does what 180 does in a reliable way ?

> I haven't seen a failure in 180 on any of my test machines for some
> time (32 or 64 bit).
> 
> > My latest (fourth ot fifth, I forgot :) bisect landed on the patch with
> > commit 546a1924224078c6f582e68f890b05b387b42653 ( writeback:
> > write_cache_pages doesn't terminate at nr_to_write <= 0)
> 
> That was merged in 2.6.36-rc2, and shouldn't have any sync
> implications at all....
> 
> > I verified that this is valid patch by running the test script 180 for
> > nearly 500 times on the tree just prior to this patch.
> 
> Ok, more details about your test setup is needed.  What kernel are
> you running? What storage are you using? How much RAM/CPU, etc?
> 
Kernel: mainline with up to commit #546a1924224078c6f582e68f890b05b387b42653
Storage: 2TB megaraid (IBM ServeRAID M1015) local storage.
Partition: only 20GB
RAM: 25GB
Proc: Intel(R) Xeon(R) CPU E5607  @ 2.27GHz
#of procs: 4

> Also, what are the sizes of the files that had reported incorrect
> size?
It failed with varied sizes. Here are the 10 failures from 3.0.0-rc5
kernel:

+file /mnt/xfsScratchMntPt/966 has incorrect size - sync failed
+-rw-------. 1 root root 8663040 Jun 29 13:46 /mnt/xfsScratchMntPt/966

+file /mnt/xfsScratchMntPt/644 has incorrect size - sync failed
+-rw-------. 1 root root 8724480 Jun 29 13:53 /mnt/xfsScratchMntPt/644

+file /mnt/xfsScratchMntPt/381 has incorrect size - sync failed
+-rw-------. 1 root root 10096640 Jun 29 14:03 /mnt/xfsScratchMntPt/381
+file /mnt/xfsScratchMntPt/569 has incorrect size - sync failed
+-rw-------. 1 root root 10383360 Jun 29 14:04 /mnt/xfsScratchMntPt/569
+file /mnt/xfsScratchMntPt/650 has incorrect size - sync failed
+-rw-------. 1 root root 9216000 Jun 29 14:04 /mnt/xfsScratchMntPt/650
+file /mnt/xfsScratchMntPt/947 has incorrect size - sync failed
+-rw-------. 1 root root 8663040 Jun 29 14:04 /mnt/xfsScratchMntPt/947

+file /mnt/xfsScratchMntPt/569 has incorrect size - sync failed
+-rw-------. 1 root root 7761920 Jun 29 14:10 /mnt/xfsScratchMntPt/569
+file /mnt/xfsScratchMntPt/905 has incorrect size - sync failed
+-rw-------. 1 root root 8417280 Jun 29 14:11 /mnt/xfsScratchMntPt/905

+file /mnt/xfsScratchMntPt/617 has incorrect size - sync failed
+-rw-------. 1 root root 10403840 Jun 29 14:13 /mnt/xfsScratchMntPt/617

+file /mnt/xfsScratchMntPt/654 has incorrect size - sync failed
+-rw-------. 1 root root 9216000 Jun 29 14:15 /mnt/xfsScratchMntPt/654

+file /mnt/xfsScratchMntPt/569 has incorrect size - sync failed
+-rw-------. 1 root root 7802880 Jun 29 14:17 /mnt/xfsScratchMntPt/569
+file /mnt/xfsScratchMntPt/740 has incorrect size - sync failed
+-rw-------. 1 root root 9216000 Jun 29 14:17 /mnt/xfsScratchMntPt/740

+file /mnt/xfsScratchMntPt/574 has incorrect size - sync failed
+-rw-------. 1 root root 10260480 Jun 29 14:26 /mnt/xfsScratchMntPt/574
+file /mnt/xfsScratchMntPt/655 has incorrect size - sync failed
+-rw-------. 1 root root 9216000 Jun 29 14:26 /mnt/xfsScratchMntPt/655
+file /mnt/xfsScratchMntPt/952 has incorrect size - sync failed
+-rw-------. 1 root root 8663040 Jun 29 14:27 /mnt/xfsScratchMntPt/952

+file /mnt/xfsScratchMntPt/575 has incorrect size - sync failed
+-rw-------. 1 root root 10260480 Jun 29 14:28 /mnt/xfsScratchMntPt/575
+file /mnt/xfsScratchMntPt/656 has incorrect size - sync failed
+-rw-------. 1 root root 9216000 Jun 29 14:28 /mnt/xfsScratchMntPt/656
+file /mnt/xfsScratchMntPt/926 has incorrect size - sync failed
+-rw-------. 1 root root 8663040 Jun 29 14:29 /mnt/xfsScratchMntPt/926

+file /mnt/xfsScratchMntPt/941 has incorrect size - sync failed
+-rw-------. 1 root root 8417280 Jun 29 14:31 /mnt/xfsScratchMntPt/941

+file /mnt/xfsScratchMntPt/544 has incorrect size - sync failed
+-rw-------. 1 root root 7413760 Jun 29 14:35 /mnt/xfsScratchMntPt/544


> 
> Cheers,
> 
> Dave.
> 
> PS: Please don't top post replies. Please quote and reply inline so
> that the thread flow is easy to follow.

sorry :(

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
