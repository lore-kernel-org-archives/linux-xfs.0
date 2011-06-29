Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5TNrVTg152992 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 18:53:31 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 629BC15E8F0F
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 16:53:27 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	l99YGyhcAHHTHBfQ for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 16:53:27 -0700 (PDT)
Date: Thu, 30 Jun 2011 09:53:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: long hangs when deleting large directories (3.0-rc3)
Message-ID: <20110629235323.GT561@dastard>
References: <20110621185701.GB1723@x4.trippels.de>
	<20110622000449.GQ32466@dastard>
	<20110622070647.GA1744@x4.trippels.de>
	<20110622073047.GT32466@dastard> <20110629043143.GA1026@dastard>
	<20110629061954.GA1711@x4.trippels.de>
	<20110629072446.GR561@dastard>
	<20110629074127.GA1746@x4.trippels.de>
	<20110629121001.GS561@dastard>
	<20110629124814.GA1762@x4.trippels.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110629124814.GA1762@x4.trippels.de>
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
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: xfs@oss.sgi.com

On Wed, Jun 29, 2011 at 02:48:14PM +0200, Markus Trippelsdorf wrote:
> On 2011.06.29 at 22:10 +1000, Dave Chinner wrote:
> > On Wed, Jun 29, 2011 at 09:41:27AM +0200, Markus Trippelsdorf wrote:
> > > On 2011.06.29 at 17:24 +1000, Dave Chinner wrote:
> > > > On Wed, Jun 29, 2011 at 08:19:54AM +0200, Markus Trippelsdorf wrote:
> > > > > On 2011.06.29 at 14:31 +1000, Dave Chinner wrote:
> > > > > > On Wed, Jun 22, 2011 at 05:30:47PM +1000, Dave Chinner wrote:
> > > > > > > Jun 22 08:53:09 x4 kernel: XFS (sdb1): ail: ooo splice, tail 0x12000156e7, item 0x12000156e6
> > > > > > > Jun 22 08:53:09 x4 kernel: XFS (sdb1): ail: ooo splice, walked 15503 items      
> > > > > > > .....
> > > > > > > Jun 22 08:53:12 x4 kernel: XFS (sdb1): ail: ooo splice, tail 0x12000156e7, item 0x12000156e6
> > > > > > > Jun 22 08:53:12 x4 kernel: XFS (sdb1): ail: ooo splice, walked 16945 items
> > > > > > > 
> > > > > > > Interesting is the LSN of the tail - it's only one sector further on
> > > > > > > than the items being inserted. That's what I'd expect from a commit
> > > > > > > record write race between two checkpoints. I'll have a deeper look
> > > > > > > into whether this can be avoided later tonight and also whether I
> > > > > > > can easily implement a "last insert cursor" easily so subsequent
> > > > > > > inserts at the same LSN avoid the walk....
> > > > > > 
> > > > > > Ok, so here's a patch that does just this. I should probably also do
> > > > > > a little bit of cleanup on the cursor code as well, but this avoids
> > > > > > the repeated walks of the AIL to find the insert position.
> > > > > > 
> > > > > > Can you try it without the WQ changes you made, Marcus, and see if
> > > > > > the interactivity problems go away?
> > > > > 
> > > > > Sorry to be the bringer of bad news, but this made things much worse:
....
> > > > > As you can see in the table above (resolution 1sec) the hang is now
> > > > > 5-6 seconds long, instead of the 1-3 seconds seen before.
> > > > 
> > > > Interesting. I checked that the ordering was correct in each case
> > > > adn that it was behaving correctly here.
> > > > 
> > > > Can you add the following patch and send me the dmesg output over a
> > > > hang? It will tell me where the cursor is being initialised and when
> > > > it is being dropped, so should indicate if a specific insert chain
> > > > is getting stuck or doing something stoopid.
> > > 
> > > The kernel log is attached.
> > > rm -fr && sync starts at Jun 29 09:32:24.
> > 
> > Add this patch on top of the first one I sent. If it doesn't fix the
> > problem, can you readd the debug patch and send the log again?
> 
> This completely fixes the issue. As a bonus "rm -fr && sync" completes
> much quicker now.

Great to hear the hang has gone away.

I'm also seeing performance improvements on unlink workloads with
these two patches - quite significant, too. Cold cache parallel rm
-rf tests over tens of millions of inodes are finishing 15-20%
faster. Hot cache parallel rm -rf now go to being CPU bound on a
8p system with the unlink rate improving by about 50%....

As I always say, the hardest part of fixing a bug is getting a
reproducable test case to analyse and test. Thank's for providing
the test case and the testing, Markus!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
