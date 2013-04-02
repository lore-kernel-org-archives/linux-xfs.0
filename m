Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D08697F6B
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 02:30:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2578FAC005
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 00:30:40 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	EigroOSVkZEjt7Ev (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Apr 2013 00:30:39 -0700 (PDT)
Date: Tue, 2 Apr 2013 09:30:35 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running
	xfstests case #78]
Message-ID: <20130402073035.GD3670@kernel.dk>
References: <1462091996.435156.1364882416199.JavaMail.root@redhat.com>
	<247719576.438259.1364882929749.JavaMail.root@redhat.com>
	<20130402070537.GP6369@dastard> <20130402071937.GC3670@kernel.dk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130402071937.GC3670@kernel.dk>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: LKML <linux-kernel@vger.kernel.org>, CAI Qian <caiqian@redhat.com>, xfs@oss.sgi.com

On Tue, Apr 02 2013, Jens Axboe wrote:
> On Tue, Apr 02 2013, Dave Chinner wrote:
> > [Added jens Axboe to CC]
> > 
> > On Tue, Apr 02, 2013 at 02:08:49AM -0400, CAI Qian wrote:
> > > Saw on almost all the servers range from x64, ppc64 and s390x with kernel
> > > 3.9-rc5 and xfsprogs-3.1.10. Never caught this in 3.9-rc4, so looks like
> > > something new broke this. Log is here with sysrq debug info.
> > > http://people.redhat.com/qcai/stable/log
> 
> CAI Qian, can you try and back the below out and test again?

Nevermind, it's clearly that one. The below should improve the
situation, but it's not pretty. A better fix would be to allow
auto-deletion even if PART_NO_SCAN is set.

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index fe5f640..d6c5764 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1057,14 +1057,15 @@ static int loop_clr_fd(struct loop_device *lo)
 		struct disk_part_iter piter;
 		struct hd_struct *part;
 
-		mutex_lock_nested(&bdev->bd_mutex, 1);
-		invalidate_partition(bdev->bd_disk, 0);
-		disk_part_iter_init(&piter, bdev->bd_disk,
-					DISK_PITER_INCL_EMPTY);
-		while ((part = disk_part_iter_next(&piter)))
-			delete_partition(bdev->bd_disk, part->partno);
-		disk_part_iter_exit(&piter);
-		mutex_unlock(&bdev->bd_mutex);
+		if (mutex_trylock(&bdev->bd_mutex, 1))
+			invalidate_partition(bdev->bd_disk, 0);
+			disk_part_iter_init(&piter, bdev->bd_disk,
+						DISK_PITER_INCL_EMPTY);
+			while ((part = disk_part_iter_next(&piter)))
+				delete_partition(bdev->bd_disk, part->partno);
+			disk_part_iter_exit(&piter);
+			mutex_unlock(&bdev->bd_mutex);
+		}
 	}
 
 	/*

-- 
Jens Axboe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
