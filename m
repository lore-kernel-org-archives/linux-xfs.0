Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0CCD57F72
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 04:48:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F0F6A8F8050
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 02:48:51 -0700 (PDT)
Received: from merlin.infradead.org (merlin.infradead.org [205.233.59.134]) by
	cuda.sgi.com with ESMTP id euDKnocIpwFDRZJ8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Apr 2013 02:48:37 -0700 (PDT)
Date: Tue, 2 Apr 2013 11:48:34 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running
	xfstests case #78]
Message-ID: <20130402094834.GA4667@kernel.dk>
References: <1462091996.435156.1364882416199.JavaMail.root@redhat.com>
	<247719576.438259.1364882929749.JavaMail.root@redhat.com>
	<20130402070537.GP6369@dastard> <20130402071937.GC3670@kernel.dk>
	<20130402073035.GD3670@kernel.dk>
	<14055702.547701.1364891947331.JavaMail.root@redhat.com>
	<20130402090047.GF3670@kernel.dk>
	<985125161.581860.1364895066584.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <985125161.581860.1364895066584.JavaMail.root@redhat.com>
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
To: CAI Qian <caiqian@redhat.com>
Cc: psusi@ubuntu.com, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Tue, Apr 02 2013, CAI Qian wrote:
> 
> 
> ----- Original Message -----
> > From: "Jens Axboe" <axboe@kernel.dk>
> > To: "CAI Qian" <caiqian@redhat.com>
> > Cc: "Dave Chinner" <david@fromorbit.com>, xfs@oss.sgi.com, "LKML" <linux-kernel@vger.kernel.org>
> > Sent: Tuesday, April 2, 2013 5:00:47 PM
> > Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running xfstests case #78]
> > 
> > On Tue, Apr 02 2013, CAI Qian wrote:
> > > 
> > > 
> > > ----- Original Message -----
> > > > From: "Jens Axboe" <axboe@kernel.dk>
> > > > To: "Dave Chinner" <david@fromorbit.com>
> > > > Cc: "CAI Qian" <caiqian@redhat.com>, xfs@oss.sgi.com, "LKML"
> > > > <linux-kernel@vger.kernel.org>
> > > > Sent: Tuesday, April 2, 2013 3:30:35 PM
> > > > Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5
> > > > running xfstests case #78]
> > > > 
> > > > On Tue, Apr 02 2013, Jens Axboe wrote:
> > > > > On Tue, Apr 02 2013, Dave Chinner wrote:
> > > > > > [Added jens Axboe to CC]
> > > > > > 
> > > > > > On Tue, Apr 02, 2013 at 02:08:49AM -0400, CAI Qian wrote:
> > > > > > > Saw on almost all the servers range from x64, ppc64 and s390x with
> > > > > > > kernel
> > > > > > > 3.9-rc5 and xfsprogs-3.1.10. Never caught this in 3.9-rc4, so looks
> > > > > > > like
> > > > > > > something new broke this. Log is here with sysrq debug info.
> > > > > > > http://people.redhat.com/qcai/stable/log
> > > > > 
> > > > > CAI Qian, can you try and back the below out and test again?
> > > > 
> > > > Nevermind, it's clearly that one. The below should improve the
> > > > situation, but it's not pretty. A better fix would be to allow
> > > > auto-deletion even if PART_NO_SCAN is set.
> > > Jens, when compiled the mainline (up to fefcdbe) with this patch,
> > > it error-ed out,
> > 
> > Looks like I sent the wrong one, updated below.
> The patch works well. Thanks!

Thanks for testing! I don't particularly like this stuff in loop,
though. It's quite nasty and depends on other behaviour. It would be
prettier if we just had rescan_partitions() do the right thing, and only
drop partitions and not rescan if NO_PART_SCAN is set.

Ala the below, dropping the loop change and implementing that change in
the core code. Phillip, can you check whether this does the right thing
for your bug too?

diff --git a/block/ioctl.c b/block/ioctl.c
index a31d91d..8b78b5a 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -155,7 +155,7 @@ static int blkdev_reread_part(struct block_device *bdev)
 	struct gendisk *disk = bdev->bd_disk;
 	int res;
 
-	if (!disk_part_scan_enabled(disk) || bdev != bdev->bd_contains)
+	if (bdev != bdev->bd_contains)
 		return -EINVAL;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
diff --git a/block/partition-generic.c b/block/partition-generic.c
index ae95ee6..bf4bb60 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -431,6 +431,15 @@ rescan:
 		disk->fops->revalidate_disk(disk);
 	check_disk_size_change(disk, bdev);
 	bdev->bd_invalidated = 0;
+
+	/*
+	 * If partition scanning is disabled, we are done.
+	 */
+	if (!disk_part_scan_enabled(disk)) {
+		kobject_uevent(&disk_to_dev(disk)->kobj, KOBJ_CHANGE);
+		return 0;
+	}
+
 	if (!get_capacity(disk) || !(state = check_partition(disk, bdev)))
 		return 0;
 	if (IS_ERR(state)) {
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 2c127f9..8b6df76 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1057,24 +1057,6 @@ static int loop_clr_fd(struct loop_device *lo)
 	mutex_unlock(&lo->lo_ctl_mutex);
 
 	/*
-	 * Remove all partitions, since BLKRRPART won't remove user
-	 * added partitions when max_part=0
-	 */
-	if (bdev) {
-		struct disk_part_iter piter;
-		struct hd_struct *part;
-
-		mutex_lock_nested(&bdev->bd_mutex, 1);
-		invalidate_partition(bdev->bd_disk, 0);
-		disk_part_iter_init(&piter, bdev->bd_disk,
-					DISK_PITER_INCL_EMPTY);
-		while ((part = disk_part_iter_next(&piter)))
-			delete_partition(bdev->bd_disk, part->partno);
-		disk_part_iter_exit(&piter);
-		mutex_unlock(&bdev->bd_mutex);
-	}
-
-	/*
 	 * Need not hold lo_ctl_mutex to fput backing file.
 	 * Calling fput holding lo_ctl_mutex triggers a circular
 	 * lock dependency possibility warning as fput can take

-- 
Jens Axboe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
