Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5T7Opk8064589 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 02:24:51 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C7BF23DB08
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 00:24:49 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Xh8Hdr5ydbyhHcj3 for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 00:24:49 -0700 (PDT)
Date: Wed, 29 Jun 2011 17:24:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: long hangs when deleting large directories (3.0-rc3)
Message-ID: <20110629072446.GR561@dastard>
References: <20110621212201.GA1755@x4.trippels.de>
	<20110621185701.GB1723@x4.trippels.de>
	<20110622000449.GQ32466@dastard>
	<20110622070647.GA1744@x4.trippels.de>
	<20110622073047.GT32466@dastard> <20110629043143.GA1026@dastard>
	<20110629061954.GA1711@x4.trippels.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110629061954.GA1711@x4.trippels.de>
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

On Wed, Jun 29, 2011 at 08:19:54AM +0200, Markus Trippelsdorf wrote:
> On 2011.06.29 at 14:31 +1000, Dave Chinner wrote:
> > On Wed, Jun 22, 2011 at 05:30:47PM +1000, Dave Chinner wrote:
> > > Jun 22 08:53:09 x4 kernel: XFS (sdb1): ail: ooo splice, tail 0x12000156e7, item 0x12000156e6
> > > Jun 22 08:53:09 x4 kernel: XFS (sdb1): ail: ooo splice, walked 15503 items      
> > > .....
> > > Jun 22 08:53:12 x4 kernel: XFS (sdb1): ail: ooo splice, tail 0x12000156e7, item 0x12000156e6
> > > Jun 22 08:53:12 x4 kernel: XFS (sdb1): ail: ooo splice, walked 16945 items
> > > 
> > > Interesting is the LSN of the tail - it's only one sector further on
> > > than the items being inserted. That's what I'd expect from a commit
> > > record write race between two checkpoints. I'll have a deeper look
> > > into whether this can be avoided later tonight and also whether I
> > > can easily implement a "last insert cursor" easily so subsequent
> > > inserts at the same LSN avoid the walk....
> > 
> > Ok, so here's a patch that does just this. I should probably also do
> > a little bit of cleanup on the cursor code as well, but this avoids
> > the repeated walks of the AIL to find the insert position.
> > 
> > Can you try it without the WQ changes you made, Marcus, and see if
> > the interactivity problems go away?
> 
> Sorry to be the bringer of bad news, but this made things much worse:
> 
> -------cpu0-usage--------------cpu1-usage--------------cpu2-usage--------------cpu3-usage------ --dsk/sdc-- ---system-- ---load-avg--- --dsk/sdc--
> usr sys idl wai hiq siq:usr sys idl wai hiq siq:usr sys idl wai hiq siq:usr sys idl wai hiq siq| read  writ| int   csw | 1m   5m  15m |reads writs
>   1   1  98   0   0   0:  0   1  99   0   0   0:  0   1  99   0   0   0:  0   1  99   0   0   0|   0     0 | 603   380 |0.66 0.55 0.28|   0     0 
>   1   0  99   0   0   0:  1   0  99   0   0   0:  1  19  80   0   0   0:  0   0 100   0   0   0|   0     0 | 719   383 |0.66 0.55 0.28|   0     0 
>   3   1  96   0   0   0:  3   1  96   0   0   0:  1  52  47   0   0   0:  0   0 100   0   0   0|   0  6464k|1847   919 |0.66 0.55 0.28|   0   202 
>   2  13  85   0   0   0:  2   2  96   0   0   0:  1  56  43   0   0   0:  1  31  69   0   0   0|4096B  256k|1910  1280 |0.68 0.56 0.28|   1     8 
> > 0   1  99   0   0   0:  0   0 100   0   0   0:  0   1  99   0   0   0:  0 100   0   0   0   0|   0     0 |1256   170 |0.68 0.56 0.28|   0     0 
> > 0   1  99   0   0   0:  1   1  98   0   0   0:  1   0  99   0   0   0:  0  99   0   0   0   1|   0     0 |1395   229 |0.68 0.56 0.28|   0     0 
> > 0   0 100   0   0   0:  0   0 100   0   0   0:  0   3  97   0   0   0:  0 100   0   0   0   0|   0   512B|1304   167 |0.68 0.56 0.28|   0     1 
> > 1   1  98   0   0   0:  1   1  98   0   0   0:  0   0 100   0   0   0:  0  99   0   0   0   1|   0     0 |1211   146 |0.68 0.56 0.28|   0     0 
> > 0   0 100   0   0   0:  0   0 100   0   0   0:  0   1  99   0   0   0:  0  97   0   0   0   3|   0     0 |1270   149 |0.87 0.60 0.30|   0     0 
>   5   2  65  29   0   0:  2   3  95   0   0   0:  1   0  99   0   0   0:  2  24  72   0   0   1|   0  8866k|2654  2398 |0.87 0.60 0.30|   0   496 
>   6   2  25  67   0   0:  3   1  59  37   0   0:  0   0 100   0   0   0:  4   4  92   0   0   0|   0  4554k|2224  2494 |0.87 0.60 0.30|   0   399 
>   1   1  98   0   0   0:  0   0  83  17   0   0:  1   3  96   0   0   0:  0   1  99   0   0   0|   0  2270k|1079  1030 |0.87 0.60 0.30|   0   200 
>   1   1  98   0   0   0:  1   1  98   0   0   0:  0   1  99   0   0   0:  1   0  99   0   0   0|   0  9216B| 713   567 |0.87 0.60 0.30|   0     2 
>   0   0 100   0   0   0:  1   1  98   0   0   0:  0   0 100   0   0   0:  0   1  99   0   0   0|   0     0 | 492   386 |0.80 0.59 0.30|   0     0 
> 
> As you can see in the table above (resolution 1sec) the hang is now
> 5-6 seconds long, instead of the 1-3 seconds seen before.

Interesting. I checked that the ordering was correct in each case
adn that it was behaving correctly here.

Can you add the following patch and send me the dmesg output over a
hang? It will tell me where the cursor is being initialised and when
it is being dropped, so should indicate if a specific insert chain
is getting stuck or doing something stoopid.

Cheers,

Dave
-- 
Dave Chinner
david@fromorbit.com

---
 fs/xfs/xfs_trans_ail.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 272e7fa..a087cbb 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -234,6 +234,8 @@ xfs_trans_ail_cursor_done(
 	struct xfs_ail_cursor	*prev = NULL;
 	struct xfs_ail_cursor	*cur;
 
+	printk(KERN_WARNING "done cur %p, lip %p/0x%llx\n",
+		done, done->item, done->item ? done->item->li_lsn : 0);
 	done->item = NULL;
 	if (done == &ailp->xa_cursors)
 		return;
@@ -323,6 +325,8 @@ __xfs_trans_ail_cursor_last(
 			break;
 	}
 out:
+	printk(KERN_WARNING "last cur %p, init %d lsn 0x%llx, lip %p/0x%llx\n",
+		cur, do_init, lsn, lip, lip ? lip->li_lsn : 0);
 	if (cur)
 		cur->item = lip;
 	return lip;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
