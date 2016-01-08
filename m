Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 449807F37
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 17:07:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B80A2AC001
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 15:07:17 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xJdk5rUkKmq7DHWG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Jan 2016 15:07:15 -0800 (PST)
Date: Fri, 8 Jan 2016 18:07:10 -0500
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 00/35 v2] separate operations from flags in the
	bio/request structs
Message-ID: <20160108230709.GA15655@redhat.com>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
	<20160108133237.GA7663@infradead.org>
	<56902132.8080008@cs.wisc.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56902132.8080008@cs.wisc.edu>
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
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-block@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-bcache@vger.kernel.org, mchristi@redhat.com, linux-mtd@lists.infradead.org, osd-dev@open-osd.org, linux-fsdevel@vger.kernel.org, lars.ellenberg@linbit.com, philipp.reisner@linbit.com, drbd-dev@lists.linbit.com, ocfs2-devel@oss.oracle.com, target-devel@vger.kernel.org

On Fri, Jan 08 2016 at  3:50P -0500,
Mike Christie <michaelc@cs.wisc.edu> wrote:

> On 01/08/2016 07:32 AM, Christoph Hellwig wrote:
> > This looks good to me from a highlevel point of view.
> > Do you also have a git tree to take a look at all the changes in a
> > single big diff?
> 
> I uploaded a git tree here:
> 
> https://github.com/mikechristie/linux-kernel.git
> 
> based off of linux-next today. The patches are just in the master branch.

Hi Mike,

I had a look at your DM changes.  That sucked (but things looked good).
So much so that I want to thank you for tackling this task (and taking
one for the team).

I'll get this kernel built and tested (using the various DM testsuites:
lvm2, cryptsetup, device-mapper-test-suite for dm-thinp and dm-cache).

But I did make some changes during my review that I'd appreciate if
you'd fold in to wherever you think it appropriate in your series:

diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
index 96b5c1b..9e29dba 100644
--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -514,11 +514,10 @@ static void dm_stat_round(struct dm_stat *s, struct dm_stat_shared *shared,
 }
 
 static void dm_stat_for_entry(struct dm_stat *s, size_t entry,
-			      unsigned long bi_rw, sector_t len,
+			      int idx, sector_t len,
 			      struct dm_stats_aux *stats_aux, bool end,
 			      unsigned long duration_jiffies)
 {
-	unsigned long idx = bi_rw;
 	struct dm_stat_shared *shared = &s->stat_shared[entry];
 	struct dm_stat_percpu *p;
 
@@ -584,7 +583,7 @@ static void dm_stat_for_entry(struct dm_stat *s, size_t entry,
 #endif
 }
 
-static void __dm_stat_bio(struct dm_stat *s, unsigned long bi_rw,
+static void __dm_stat_bio(struct dm_stat *s, int bi_rw,
 			  sector_t bi_sector, sector_t end_sector,
 			  bool end, unsigned long duration_jiffies,
 			  struct dm_stats_aux *stats_aux)
@@ -622,7 +621,7 @@ static void __dm_stat_bio(struct dm_stat *s, unsigned long bi_rw,
 	} while (unlikely(todo != 0));
 }
 
-void dm_stats_account_io(struct dm_stats *stats, unsigned long bi_rw,
+void dm_stats_account_io(struct dm_stats *stats, int bi_rw,
 			 sector_t bi_sector, unsigned bi_sectors, bool end,
 			 unsigned long duration_jiffies,
 			 struct dm_stats_aux *stats_aux)
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 5e940f7..9a4b3cb 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1326,7 +1326,7 @@ static int device_fua_capable(struct dm_target *ti, struct dm_dev *dev,
 }
 
 static bool dm_table_supports_flush(struct dm_table *t,
-				    iterate_devices_callout_fn support_test)
+				    iterate_devices_callout_fn callout_fn)
 {
 	struct dm_target *ti;
 	unsigned i = 0;
@@ -1347,7 +1347,7 @@ static bool dm_table_supports_flush(struct dm_table *t,
 			return true;
 
 		if (ti->type->iterate_devices &&
-		    ti->type->iterate_devices(ti, support_test, NULL))
+		    ti->type->iterate_devices(ti, callout_fn, NULL))
 			return true;
 	}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
