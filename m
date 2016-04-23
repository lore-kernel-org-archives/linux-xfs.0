Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 34E4A7CBC
	for <xfs@oss.sgi.com>; Sat, 23 Apr 2016 18:27:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EFC198F8033
	for <xfs@oss.sgi.com>; Sat, 23 Apr 2016 16:27:03 -0700 (PDT)
Received: from mx0a-000cda01.pphosted.com (mx0a-00003501.pphosted.com
	[67.231.144.15]) by cuda.sgi.com with ESMTP id YhM4PIg1LBOGaj8N
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 23 Apr 2016 16:26:56 -0700 (PDT)
Received: from pps.filterd (m0075555.ppops.net [127.0.0.1])
	by mx0a-00003501.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id
	u3NNOooF023324 for <xfs@oss.sgi.com>; Sat, 23 Apr 2016 19:26:55 -0400
Received: from mail-qk0-f200.google.com (mail-qk0-f200.google.com
	[209.85.220.200])
	by mx0a-00003501.pphosted.com with ESMTP id 22gjptg03a-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NOT) for <xfs@oss.sgi.com>; Sat, 23 Apr 2016 19:26:54 -0400
Received: by mail-qk0-f200.google.com with SMTP id x7so311928903qkd.2
	for <xfs@oss.sgi.com>; Sat, 23 Apr 2016 16:26:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1460716802-2294-24-git-send-email-mchristi@redhat.com>
References: <1460716802-2294-1-git-send-email-mchristi@redhat.com>
	<1460716802-2294-24-git-send-email-mchristi@redhat.com>
From: Shaun Tancheff <shaun.tancheff@seagate.com>
Date: Sat, 23 Apr 2016 18:26:34 -0500
Message-ID: <CAJVOszDQz_NpOpU+V8nLJ8Za8Pqh4dx9yscKvfuEvQQiHb2UgA@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH 23/42] md/raid: set bi_op to REQ_OP
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6983356238070011113=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: mchristi@redhat.com
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, LKML <linux-kernel@vger.kernel.org>, philipp.reisner@linbit.com, linux-f2fs-devel@lists.sourceforge.net, linux-raid@vger.kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, osd-dev@open-osd.org, linux-fsdevel@vger.kernel.org, lars.ellenberg@linbit.com, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, drbd-dev@lists.linbit.com

--===============6983356238070011113==
Content-Type: multipart/alternative; boundary=94eb2c0766c65497ea05312f4703

--94eb2c0766c65497ea05312f4703
Content-Type: text/plain; charset=UTF-8

On Fri, Apr 15, 2016 at 5:39 AM, <mchristi@redhat.com> wrote:

> From: Mike Christie <mchristi@redhat.com>
>
> This patch has md use bio->bi_op for REQ_OPs and rq_flag_bits
> to bio->bi_rw.
>
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/md/bitmap.c      |  2 +-
>  drivers/md/dm-raid.c     |  5 +++--
>  drivers/md/md.c          | 11 +++++++----
>  drivers/md/md.h          |  3 ++-
>  drivers/md/raid1.c       | 34 ++++++++++++++++----------------
>  drivers/md/raid10.c      | 50
> ++++++++++++++++++++++++++----------------------
>  drivers/md/raid5-cache.c | 25 +++++++++++++++---------
>  drivers/md/raid5.c       | 48
> ++++++++++++++++++++++++++--------------------
>  8 files changed, 101 insertions(+), 77 deletions(-)
>
>
Sorry I though this would thread propertly:
https://lkml.kernel.org/r/1461452709-6702-1-git-send-email-shaun@tancheff.com

In raid0.c, raid10.c and raid5.c

A couple of checks for REQ_PREFLUSH flag should also check for
bi_op matching REQ_OP_FLUSH.

In raid1.c [r1_sync_page_io()] and raid10.c [r10_sync_page_io()]

Wrappers for sync_page_io() are passed READ/WRITE but need to
be passed REQ_OP_READ and REQ_OP_WRITE.

Anyway my raid testing was getting weird hangs and corruption
without the patch.

Thanks!



> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 8b2e16f..9e8019e 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -159,7 +159,7 @@ static int read_sb_page(struct mddev *mddev, loff_t
> offset,
>
>                 if (sync_page_io(rdev, target,
>                                  roundup(size,
> bdev_logical_block_size(rdev->bdev)),
> -                                page, READ, true)) {
> +                                page, REQ_OP_READ, 0, true)) {
>                         page->index = index;
>                         return 0;
>                 }
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index a090121..43a749c 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -792,7 +792,7 @@ static int read_disk_sb(struct md_rdev *rdev, int size)
>         if (rdev->sb_loaded)
>                 return 0;
>
> -       if (!sync_page_io(rdev, 0, size, rdev->sb_page, READ, 1)) {
> +       if (!sync_page_io(rdev, 0, size, rdev->sb_page, REQ_OP_READ, 0,
> 1)) {
>                 DMERR("Failed to read superblock of device at position %d",
>                       rdev->raid_disk);
>                 md_error(rdev->mddev, rdev);
> @@ -1646,7 +1646,8 @@ static void attempt_restore_of_faulty_devices(struct
> raid_set *rs)
>         for (i = 0; i < rs->md.raid_disks; i++) {
>                 r = &rs->dev[i].rdev;
>                 if (test_bit(Faulty, &r->flags) && r->sb_page &&
> -                   sync_page_io(r, 0, r->sb_size, r->sb_page, READ, 1)) {
> +                   sync_page_io(r, 0, r->sb_size, r->sb_page,
> REQ_OP_READ, 0,
> +                                1)) {
>                         DMINFO("Faulty %s device #%d has readable super
> block."
>                                "  Attempting to revive it.",
>                                rs->raid_type->name, i);
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ec3c98d..9c40368 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -392,6 +392,7 @@ static void submit_flushes(struct work_struct *ws)
>                         bi->bi_end_io = md_end_flush;
>                         bi->bi_private = rdev;
>                         bi->bi_bdev = rdev->bdev;
> +                       bi->bi_op = REQ_OP_WRITE;
>                         bi->bi_rw = WRITE_FLUSH;
>                         atomic_inc(&mddev->flush_pending);
>                         submit_bio(bi);
> @@ -741,6 +742,7 @@ void md_super_write(struct mddev *mddev, struct
> md_rdev *rdev,
>         bio_add_page(bio, page, size, 0);
>         bio->bi_private = rdev;
>         bio->bi_end_io = super_written;
> +       bio->bi_op = REQ_OP_WRITE;
>         bio->bi_rw = WRITE_FLUSH_FUA;
>
>         atomic_inc(&mddev->pending_writes);
> @@ -754,14 +756,15 @@ void md_super_wait(struct mddev *mddev)
>  }
>
>  int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
> -                struct page *page, int rw, bool metadata_op)
> +                struct page *page, int op, int op_flags, bool metadata_op)
>  {
>         struct bio *bio = bio_alloc_mddev(GFP_NOIO, 1, rdev->mddev);
>         int ret;
>
>         bio->bi_bdev = (metadata_op && rdev->meta_bdev) ?
>                 rdev->meta_bdev : rdev->bdev;
> -       bio->bi_rw = rw;
> +       bio->bi_op = op;
> +       bio->bi_rw = op_flags;
>         if (metadata_op)
>                 bio->bi_iter.bi_sector = sector + rdev->sb_start;
>         else if (rdev->mddev->reshape_position != MaxSector &&
> @@ -787,7 +790,7 @@ static int read_disk_sb(struct md_rdev *rdev, int size)
>         if (rdev->sb_loaded)
>                 return 0;
>
> -       if (!sync_page_io(rdev, 0, size, rdev->sb_page, READ, true))
> +       if (!sync_page_io(rdev, 0, size, rdev->sb_page, REQ_OP_READ, 0,
> true))
>                 goto fail;
>         rdev->sb_loaded = 1;
>         return 0;
> @@ -1473,7 +1476,7 @@ static int super_1_load(struct md_rdev *rdev, struct
> md_rdev *refdev, int minor_
>                         return -EINVAL;
>                 bb_sector = (long long)offset;
>                 if (!sync_page_io(rdev, bb_sector, sectors << 9,
> -                                 rdev->bb_page, READ, true))
> +                                 rdev->bb_page, REQ_OP_READ, 0, true))
>                         return -EIO;
>                 bbp = (u64 *)page_address(rdev->bb_page);
>                 rdev->badblocks.shift = sb->bblog_shift;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index b5c4be7..2e0918f 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -618,7 +618,8 @@ extern void md_super_write(struct mddev *mddev, struct
> md_rdev *rdev,
>                            sector_t sector, int size, struct page *page);
>  extern void md_super_wait(struct mddev *mddev);
>  extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
> -                       struct page *page, int rw, bool metadata_op);
> +                       struct page *page, int op, int op_flags,
> +                       bool metadata_op);
>  extern void md_do_sync(struct md_thread *thread);
>  extern void md_new_event(struct mddev *mddev);
>  extern int md_allow_write(struct mddev *mddev);
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 424df7e..c7abd2d 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -759,7 +759,7 @@ static void flush_pending_writes(struct r1conf *conf)
>                 while (bio) { /* submit pending writes */
>                         struct bio *next = bio->bi_next;
>                         bio->bi_next = NULL;
> -                       if (unlikely((bio->bi_rw & REQ_DISCARD) &&
> +                       if (unlikely((bio->bi_op == REQ_OP_DISCARD) &&
>
> !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
>                                 /* Just ignore it */
>                                 bio_endio(bio);
> @@ -1033,7 +1033,7 @@ static void raid1_unplug(struct blk_plug_cb *cb,
> bool from_schedule)
>         while (bio) { /* submit pending writes */
>                 struct bio *next = bio->bi_next;
>                 bio->bi_next = NULL;
> -               if (unlikely((bio->bi_rw & REQ_DISCARD) &&
> +               if (unlikely((bio->bi_op == REQ_OP_DISCARD) &&
>                     !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
>                         /* Just ignore it */
>                         bio_endio(bio);
> @@ -1053,12 +1053,11 @@ static void raid1_make_request(struct mddev
> *mddev, struct bio * bio)
>         int i, disks;
>         struct bitmap *bitmap;
>         unsigned long flags;
> +       const int op = bio->bi_op;
>         const int rw = bio_data_dir(bio);
>         const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
>         const unsigned long do_flush_fua = (bio->bi_rw & (REQ_FLUSH |
> REQ_FUA));
> -       const unsigned long do_discard = (bio->bi_rw
> -                                         & (REQ_DISCARD | REQ_SECURE));
> -       const unsigned long do_same = (bio->bi_rw & REQ_WRITE_SAME);
> +       const unsigned long do_sec = (bio->bi_rw & REQ_SECURE);
>         struct md_rdev *blocked_rdev;
>         struct blk_plug_cb *cb;
>         struct raid1_plug_cb *plug = NULL;
> @@ -1166,7 +1165,8 @@ read_again:
>                         mirror->rdev->data_offset;
>                 read_bio->bi_bdev = mirror->rdev->bdev;
>                 read_bio->bi_end_io = raid1_end_read_request;
> -               read_bio->bi_rw = READ | do_sync;
> +               read_bio->bi_op = op;
> +               read_bio->bi_rw = do_sync;
>                 read_bio->bi_private = r1_bio;
>
>                 if (max_sectors < r1_bio->sectors) {
> @@ -1376,8 +1376,9 @@ read_again:
>                                    conf->mirrors[i].rdev->data_offset);
>                 mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
>                 mbio->bi_end_io = raid1_end_write_request;
> +               mbio->bi_op = op;
>                 mbio->bi_rw =
> -                       WRITE | do_flush_fua | do_sync | do_discard |
> do_same;
> +                       do_flush_fua | do_sync | do_sec;
>                 mbio->bi_private = r1_bio;
>
>                 atomic_inc(&r1_bio->remaining);
> @@ -1771,7 +1772,7 @@ static void end_sync_write(struct bio *bio)
>  static int r1_sync_page_io(struct md_rdev *rdev, sector_t sector,
>                             int sectors, struct page *page, int rw)
>  {
> -       if (sync_page_io(rdev, sector, sectors << 9, page, rw, false))
> +       if (sync_page_io(rdev, sector, sectors << 9, page, rw, 0, false))
>                 /* success */
>                 return 1;
>         if (rw == WRITE) {
> @@ -1825,7 +1826,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
>                                 rdev = conf->mirrors[d].rdev;
>                                 if (sync_page_io(rdev, sect, s<<9,
>
>  bio->bi_io_vec[idx].bv_page,
> -                                                READ, false)) {
> +                                                REQ_OP_READ, 0, false)) {
>                                         success = 1;
>                                         break;
>                                 }
> @@ -2030,7 +2031,7 @@ static void sync_request_write(struct mddev *mddev,
> struct r1bio *r1_bio)
>                       !test_bit(MD_RECOVERY_SYNC, &mddev->recovery))))
>                         continue;
>
> -               wbio->bi_rw = WRITE;
> +               wbio->bi_op = REQ_OP_WRITE;
>                 wbio->bi_end_io = end_sync_write;
>                 atomic_inc(&r1_bio->remaining);
>                 md_sync_acct(conf->mirrors[i].rdev->bdev,
> bio_sectors(wbio));
> @@ -2090,7 +2091,7 @@ static void fix_read_error(struct r1conf *conf, int
> read_disk,
>                             is_badblock(rdev, sect, s,
>                                         &first_bad, &bad_sectors) == 0 &&
>                             sync_page_io(rdev, sect, s<<9,
> -                                        conf->tmppage, READ, false))
> +                                        conf->tmppage, REQ_OP_READ, 0,
> false))
>                                 success = 1;
>                         else {
>                                 d++;
> @@ -2201,7 +2202,7 @@ static int narrow_write_error(struct r1bio *r1_bio,
> int i)
>                         wbio = bio_clone_mddev(r1_bio->master_bio,
> GFP_NOIO, mddev);
>                 }
>
> -               wbio->bi_rw = WRITE;
> +               wbio->bi_op = REQ_OP_WRITE;
>                 wbio->bi_iter.bi_sector = r1_bio->sector;
>                 wbio->bi_iter.bi_size = r1_bio->sectors << 9;
>
> @@ -2344,7 +2345,8 @@ read_more:
>                 bio->bi_iter.bi_sector = r1_bio->sector +
> rdev->data_offset;
>                 bio->bi_bdev = rdev->bdev;
>                 bio->bi_end_io = raid1_end_read_request;
> -               bio->bi_rw = READ | do_sync;
> +               bio->bi_op = REQ_OP_READ;
> +               bio->bi_rw = do_sync;
>                 bio->bi_private = r1_bio;
>                 if (max_sectors < r1_bio->sectors) {
>                         /* Drat - have to split this up more */
> @@ -2572,7 +2574,7 @@ static sector_t raid1_sync_request(struct mddev
> *mddev, sector_t sector_nr,
>                         if (i < conf->raid_disks)
>                                 still_degraded = 1;
>                 } else if (!test_bit(In_sync, &rdev->flags)) {
> -                       bio->bi_rw = WRITE;
> +                       bio->bi_op = REQ_OP_WRITE;
>                         bio->bi_end_io = end_sync_write;
>                         write_targets ++;
>                 } else {
> @@ -2599,7 +2601,7 @@ static sector_t raid1_sync_request(struct mddev
> *mddev, sector_t sector_nr,
>                                         if (disk < 0)
>                                                 disk = i;
>                                 }
> -                               bio->bi_rw = READ;
> +                               bio->bi_op = REQ_OP_READ;
>                                 bio->bi_end_io = end_sync_read;
>                                 read_targets++;
>                         } else if (!test_bit(WriteErrorSeen, &rdev->flags)
> &&
> @@ -2611,7 +2613,7 @@ static sector_t raid1_sync_request(struct mddev
> *mddev, sector_t sector_nr,
>                                  * if we are doing resync or repair.
> Otherwise, leave
>                                  * this device alone for this sync request.
>                                  */
> -                               bio->bi_rw = WRITE;
> +                               bio->bi_op = REQ_OP_WRITE;
>                                 bio->bi_end_io = end_sync_write;
>                                 write_targets++;
>                         }
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 4736be8..63cd985 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -865,7 +865,7 @@ static void flush_pending_writes(struct r10conf *conf)
>                 while (bio) { /* submit pending writes */
>                         struct bio *next = bio->bi_next;
>                         bio->bi_next = NULL;
> -                       if (unlikely((bio->bi_rw & REQ_DISCARD) &&
> +                       if (unlikely((bio->bi_op ==  REQ_OP_DISCARD) &&
>
> !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
>                                 /* Just ignore it */
>                                 bio_endio(bio);
> @@ -1041,7 +1041,7 @@ static void raid10_unplug(struct blk_plug_cb *cb,
> bool from_schedule)
>         while (bio) { /* submit pending writes */
>                 struct bio *next = bio->bi_next;
>                 bio->bi_next = NULL;
> -               if (unlikely((bio->bi_rw & REQ_DISCARD) &&
> +               if (unlikely((bio->bi_op ==  REQ_OP_DISCARD) &&
>                     !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
>                         /* Just ignore it */
>                         bio_endio(bio);
> @@ -1058,12 +1058,11 @@ static void __make_request(struct mddev *mddev,
> struct bio *bio)
>         struct r10bio *r10_bio;
>         struct bio *read_bio;
>         int i;
> +       const int op = bio->bi_op;
>         const int rw = bio_data_dir(bio);
>         const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
>         const unsigned long do_fua = (bio->bi_rw & REQ_FUA);
> -       const unsigned long do_discard = (bio->bi_rw
> -                                         & (REQ_DISCARD | REQ_SECURE));
> -       const unsigned long do_same = (bio->bi_rw & REQ_WRITE_SAME);
> +       const unsigned long do_sec = (bio->bi_rw & REQ_SECURE);
>         unsigned long flags;
>         struct md_rdev *blocked_rdev;
>         struct blk_plug_cb *cb;
> @@ -1156,7 +1155,8 @@ read_again:
>                         choose_data_offset(r10_bio, rdev);
>                 read_bio->bi_bdev = rdev->bdev;
>                 read_bio->bi_end_io = raid10_end_read_request;
> -               read_bio->bi_rw = READ | do_sync;
> +               read_bio->bi_op = op;
> +               read_bio->bi_rw = do_sync;
>                 read_bio->bi_private = r10_bio;
>
>                 if (max_sectors < r10_bio->sectors) {
> @@ -1363,8 +1363,9 @@ retry_write:
>                                                               rdev));
>                         mbio->bi_bdev = rdev->bdev;
>                         mbio->bi_end_io = raid10_end_write_request;
> +                       mbio->bi_op = op;
>                         mbio->bi_rw =
> -                               WRITE | do_sync | do_fua | do_discard |
> do_same;
> +                               do_sync | do_fua | do_sec;
>                         mbio->bi_private = r10_bio;
>
>                         atomic_inc(&r10_bio->remaining);
> @@ -1406,8 +1407,9 @@ retry_write:
>                                                    r10_bio, rdev));
>                         mbio->bi_bdev = rdev->bdev;
>                         mbio->bi_end_io = raid10_end_write_request;
> +                       mbio->bi_op = op;
>                         mbio->bi_rw =
> -                               WRITE | do_sync | do_fua | do_discard |
> do_same;
> +                               do_sync | do_fua | do_sec;
>                         mbio->bi_private = r10_bio;
>
>                         atomic_inc(&r10_bio->remaining);
> @@ -1992,7 +1994,7 @@ static void sync_request_write(struct mddev *mddev,
> struct r10bio *r10_bio)
>
>                 tbio->bi_vcnt = vcnt;
>                 tbio->bi_iter.bi_size = fbio->bi_iter.bi_size;
> -               tbio->bi_rw = WRITE;
> +               tbio->bi_op = REQ_OP_WRITE;
>                 tbio->bi_private = r10_bio;
>                 tbio->bi_iter.bi_sector = r10_bio->devs[i].addr;
>                 tbio->bi_end_io = end_sync_write;
> @@ -2078,7 +2080,7 @@ static void fix_recovery_read_error(struct r10bio
> *r10_bio)
>                                   addr,
>                                   s << 9,
>                                   bio->bi_io_vec[idx].bv_page,
> -                                 READ, false);
> +                                 REQ_OP_READ, 0, false);
>                 if (ok) {
>                         rdev = conf->mirrors[dw].rdev;
>                         addr = r10_bio->devs[1].addr + sect;
> @@ -2086,7 +2088,7 @@ static void fix_recovery_read_error(struct r10bio
> *r10_bio)
>                                           addr,
>                                           s << 9,
>                                           bio->bi_io_vec[idx].bv_page,
> -                                         WRITE, false);
> +                                         REQ_OP_WRITE, 0, false);
>                         if (!ok) {
>                                 set_bit(WriteErrorSeen, &rdev->flags);
>                                 if (!test_and_set_bit(WantReplacement,
> @@ -2213,7 +2215,7 @@ static int r10_sync_page_io(struct md_rdev *rdev,
> sector_t sector,
>         if (is_badblock(rdev, sector, sectors, &first_bad, &bad_sectors)
>             && (rw == READ || test_bit(WriteErrorSeen, &rdev->flags)))
>                 return -1;
> -       if (sync_page_io(rdev, sector, sectors << 9, page, rw, false))
> +       if (sync_page_io(rdev, sector, sectors << 9, page, rw, 0, false))
>                 /* success */
>                 return 1;
>         if (rw == WRITE) {
> @@ -2299,7 +2301,8 @@ static void fix_read_error(struct r10conf *conf,
> struct mddev *mddev, struct r10
>
>  r10_bio->devs[sl].addr +
>                                                        sect,
>                                                        s<<9,
> -                                                      conf->tmppage,
> READ, false);
> +                                                      conf->tmppage,
> +                                                      REQ_OP_READ, 0,
> false);
>                                 rdev_dec_pending(rdev, mddev);
>                                 rcu_read_lock();
>                                 if (success)
> @@ -2474,7 +2477,7 @@ static int narrow_write_error(struct r10bio
> *r10_bio, int i)
>                                    choose_data_offset(r10_bio, rdev) +
>                                    (sector - r10_bio->sector));
>                 wbio->bi_bdev = rdev->bdev;
> -               wbio->bi_rw = WRITE;
> +               wbio->bi_op = REQ_OP_WRITE;
>
>                 if (submit_bio_wait(wbio) < 0)
>                         /* Failure! */
> @@ -2550,7 +2553,8 @@ read_more:
>         bio->bi_iter.bi_sector = r10_bio->devs[slot].addr
>                 + choose_data_offset(r10_bio, rdev);
>         bio->bi_bdev = rdev->bdev;
> -       bio->bi_rw = READ | do_sync;
> +       bio->bi_op = REQ_OP_READ;
> +       bio->bi_rw = do_sync;
>         bio->bi_private = r10_bio;
>         bio->bi_end_io = raid10_end_read_request;
>         if (max_sectors < r10_bio->sectors) {
> @@ -3040,7 +3044,7 @@ static sector_t raid10_sync_request(struct mddev
> *mddev, sector_t sector_nr,
>                                 biolist = bio;
>                                 bio->bi_private = r10_bio;
>                                 bio->bi_end_io = end_sync_read;
> -                               bio->bi_rw = READ;
> +                               bio->bi_op = REQ_OP_READ;
>                                 from_addr = r10_bio->devs[j].addr;
>                                 bio->bi_iter.bi_sector = from_addr +
>                                         rdev->data_offset;
> @@ -3066,7 +3070,7 @@ static sector_t raid10_sync_request(struct mddev
> *mddev, sector_t sector_nr,
>                                         biolist = bio;
>                                         bio->bi_private = r10_bio;
>                                         bio->bi_end_io = end_sync_write;
> -                                       bio->bi_rw = WRITE;
> +                                       bio->bi_op = REQ_OP_WRITE;
>                                         bio->bi_iter.bi_sector = to_addr
>                                                 + rdev->data_offset;
>                                         bio->bi_bdev = rdev->bdev;
> @@ -3095,7 +3099,7 @@ static sector_t raid10_sync_request(struct mddev
> *mddev, sector_t sector_nr,
>                                 biolist = bio;
>                                 bio->bi_private = r10_bio;
>                                 bio->bi_end_io = end_sync_write;
> -                               bio->bi_rw = WRITE;
> +                               bio->bi_op = REQ_OP_WRITE;
>                                 bio->bi_iter.bi_sector = to_addr +
>                                         rdev->data_offset;
>                                 bio->bi_bdev = rdev->bdev;
> @@ -3215,7 +3219,7 @@ static sector_t raid10_sync_request(struct mddev
> *mddev, sector_t sector_nr,
>                         biolist = bio;
>                         bio->bi_private = r10_bio;
>                         bio->bi_end_io = end_sync_read;
> -                       bio->bi_rw = READ;
> +                       bio->bi_op = REQ_OP_READ;
>                         bio->bi_iter.bi_sector = sector +
>                                 conf->mirrors[d].rdev->data_offset;
>                         bio->bi_bdev = conf->mirrors[d].rdev->bdev;
> @@ -3237,7 +3241,7 @@ static sector_t raid10_sync_request(struct mddev
> *mddev, sector_t sector_nr,
>                         biolist = bio;
>                         bio->bi_private = r10_bio;
>                         bio->bi_end_io = end_sync_write;
> -                       bio->bi_rw = WRITE;
> +                       bio->bi_op = REQ_OP_WRITE;
>                         bio->bi_iter.bi_sector = sector +
>                                 conf->mirrors[d].replacement->data_offset;
>                         bio->bi_bdev = conf->mirrors[d].replacement->bdev;
> @@ -4320,7 +4324,7 @@ read_more:
>                                + rdev->data_offset);
>         read_bio->bi_private = r10_bio;
>         read_bio->bi_end_io = end_sync_read;
> -       read_bio->bi_rw = READ;
> +       read_bio->bi_op = REQ_OP_READ;
>         read_bio->bi_flags &= (~0UL << BIO_RESET_BITS);
>         read_bio->bi_error = 0;
>         read_bio->bi_vcnt = 0;
> @@ -4354,7 +4358,7 @@ read_more:
>                         rdev2->new_data_offset;
>                 b->bi_private = r10_bio;
>                 b->bi_end_io = end_reshape_write;
> -               b->bi_rw = WRITE;
> +               b->bi_op = REQ_OP_WRITE;
>                 b->bi_next = blist;
>                 blist = b;
>         }
> @@ -4522,7 +4526,7 @@ static int handle_reshape_read_error(struct mddev
> *mddev,
>                                                addr,
>                                                s << 9,
>                                                bvec[idx].bv_page,
> -                                              READ, false);
> +                                              REQ_OP_READ, 0, false);
>                         if (success)
>                                 break;
>                 failed:
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 90c2618..56b20c3 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -261,7 +261,7 @@ static struct bio *r5l_bio_alloc(struct r5l_log *log)
>  {
>         struct bio *bio = bio_alloc_bioset(GFP_NOIO, BIO_MAX_PAGES,
> log->bs);
>
> -       bio->bi_rw = WRITE;
> +       bio->bi_op = REQ_OP_WRITE;
>         bio->bi_bdev = log->rdev->bdev;
>         bio->bi_iter.bi_sector = log->rdev->data_offset + log->log_start;
>
> @@ -686,6 +686,7 @@ void r5l_flush_stripe_to_raid(struct r5l_log *log)
>         bio_reset(&log->flush_bio);
>         log->flush_bio.bi_bdev = log->rdev->bdev;
>         log->flush_bio.bi_end_io = r5l_log_flush_endio;
> +       log->flush_bio.bi_op = REQ_OP_WRITE;
>         log->flush_bio.bi_rw = WRITE_FLUSH;
>         submit_bio(&log->flush_bio);
>  }
> @@ -882,7 +883,8 @@ static int r5l_read_meta_block(struct r5l_log *log,
>         struct r5l_meta_block *mb;
>         u32 crc, stored_crc;
>
> -       if (!sync_page_io(log->rdev, ctx->pos, PAGE_SIZE, page, READ,
> false))
> +       if (!sync_page_io(log->rdev, ctx->pos, PAGE_SIZE, page,
> REQ_OP_READ, 0,
> +                         false))
>                 return -EIO;
>
>         mb = page_address(page);
> @@ -927,7 +929,8 @@ static int r5l_recovery_flush_one_stripe(struct
> r5l_log *log,
>                                              &disk_index, sh);
>
>                         sync_page_io(log->rdev, *log_offset, PAGE_SIZE,
> -                                    sh->dev[disk_index].page, READ,
> false);
> +                                    sh->dev[disk_index].page,
> REQ_OP_READ, 0,
> +                                    false);
>                         sh->dev[disk_index].log_checksum =
>                                 le32_to_cpu(payload->checksum[0]);
>                         set_bit(R5_Wantwrite, &sh->dev[disk_index].flags);
> @@ -935,7 +938,8 @@ static int r5l_recovery_flush_one_stripe(struct
> r5l_log *log,
>                 } else {
>                         disk_index = sh->pd_idx;
>                         sync_page_io(log->rdev, *log_offset, PAGE_SIZE,
> -                                    sh->dev[disk_index].page, READ,
> false);
> +                                    sh->dev[disk_index].page,
> REQ_OP_READ, 0,
> +                                    false);
>                         sh->dev[disk_index].log_checksum =
>                                 le32_to_cpu(payload->checksum[0]);
>                         set_bit(R5_Wantwrite, &sh->dev[disk_index].flags);
> @@ -945,7 +949,7 @@ static int r5l_recovery_flush_one_stripe(struct
> r5l_log *log,
>                                 sync_page_io(log->rdev,
>                                              r5l_ring_add(log,
> *log_offset, BLOCK_SECTORS),
>                                              PAGE_SIZE,
> sh->dev[disk_index].page,
> -                                            READ, false);
> +                                            REQ_OP_READ, 0, false);
>                                 sh->dev[disk_index].log_checksum =
>                                         le32_to_cpu(payload->checksum[1]);
>                                 set_bit(R5_Wantwrite,
> @@ -987,11 +991,13 @@ static int r5l_recovery_flush_one_stripe(struct
> r5l_log *log,
>                 rdev = rcu_dereference(conf->disks[disk_index].rdev);
>                 if (rdev)
>                         sync_page_io(rdev, stripe_sect, PAGE_SIZE,
> -                                    sh->dev[disk_index].page, WRITE,
> false);
> +                                    sh->dev[disk_index].page,
> REQ_OP_WRITE, 0,
> +                                    false);
>                 rrdev =
> rcu_dereference(conf->disks[disk_index].replacement);
>                 if (rrdev)
>                         sync_page_io(rrdev, stripe_sect, PAGE_SIZE,
> -                                    sh->dev[disk_index].page, WRITE,
> false);
> +                                    sh->dev[disk_index].page,
> REQ_OP_WRITE, 0,
> +                                    false);
>         }
>         raid5_release_stripe(sh);
>         return 0;
> @@ -1063,7 +1069,8 @@ static int r5l_log_write_empty_meta_block(struct
> r5l_log *log, sector_t pos,
>         crc = crc32c_le(log->uuid_checksum, mb, PAGE_SIZE);
>         mb->checksum = cpu_to_le32(crc);
>
> -       if (!sync_page_io(log->rdev, pos, PAGE_SIZE, page, WRITE_FUA,
> false)) {
> +       if (!sync_page_io(log->rdev, pos, PAGE_SIZE, page, REQ_OP_WRITE,
> +                         WRITE_FUA, false)) {
>                 __free_page(page);
>                 return -EIO;
>         }
> @@ -1138,7 +1145,7 @@ static int r5l_load_log(struct r5l_log *log)
>         if (!page)
>                 return -ENOMEM;
>
> -       if (!sync_page_io(rdev, cp, PAGE_SIZE, page, READ, false)) {
> +       if (!sync_page_io(rdev, cp, PAGE_SIZE, page, REQ_OP_READ, 0,
> false)) {
>                 ret = -EIO;
>                 goto ioerr;
>         }
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 8ab8b65..c36b817 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -806,7 +806,8 @@ static void stripe_add_to_batch_list(struct r5conf
> *conf, struct stripe_head *sh
>         dd_idx = 0;
>         while (dd_idx == sh->pd_idx || dd_idx == sh->qd_idx)
>                 dd_idx++;
> -       if (head->dev[dd_idx].towrite->bi_rw !=
> sh->dev[dd_idx].towrite->bi_rw)
> +       if (head->dev[dd_idx].towrite->bi_rw !=
> sh->dev[dd_idx].towrite->bi_rw ||
> +           head->dev[dd_idx].towrite->bi_op !=
> sh->dev[dd_idx].towrite->bi_op)
>                 goto unlock_out;
>
>         if (head->batch_head) {
> @@ -891,29 +892,32 @@ static void ops_run_io(struct stripe_head *sh,
> struct stripe_head_state *s)
>         if (r5l_write_stripe(conf->log, sh) == 0)
>                 return;
>         for (i = disks; i--; ) {
> -               int rw;
> +               int op;
> +               int op_flags = 0;
>                 int replace_only = 0;
>                 struct bio *bi, *rbi;
>                 struct md_rdev *rdev, *rrdev = NULL;
>
>                 sh = head_sh;
>                 if (test_and_clear_bit(R5_Wantwrite, &sh->dev[i].flags)) {
> -                       if (test_and_clear_bit(R5_WantFUA,
> &sh->dev[i].flags))
> -                               rw = WRITE_FUA;
> -                       else
> -                               rw = WRITE;
> +                       if (test_and_clear_bit(R5_WantFUA,
> &sh->dev[i].flags)) {
> +                               op = REQ_OP_WRITE;
> +                               op_flags = WRITE_FUA;
> +                       } else {
> +                               op = REQ_OP_WRITE;
> +                       }
>                         if (test_bit(R5_Discard, &sh->dev[i].flags))
> -                               rw |= REQ_DISCARD;
> +                               op = REQ_OP_DISCARD;
>                 } else if (test_and_clear_bit(R5_Wantread,
> &sh->dev[i].flags))
> -                       rw = READ;
> +                       op = REQ_OP_READ;
>                 else if (test_and_clear_bit(R5_WantReplace,
>                                             &sh->dev[i].flags)) {
> -                       rw = WRITE;
> +                       op = REQ_OP_WRITE;
>                         replace_only = 1;
>                 } else
>                         continue;
>                 if (test_and_clear_bit(R5_SyncIO, &sh->dev[i].flags))
> -                       rw |= REQ_SYNC;
> +                       op_flags |= REQ_SYNC;
>
>  again:
>                 bi = &sh->dev[i].req;
> @@ -927,7 +931,7 @@ again:
>                         rdev = rrdev;
>                         rrdev = NULL;
>                 }
> -               if (rw & WRITE) {
> +               if (op_is_write(op)) {
>                         if (replace_only)
>                                 rdev = NULL;
>                         if (rdev == rrdev)
> @@ -953,7 +957,7 @@ again:
>                  * need to check for writes.  We never accept write errors
>                  * on the replacement, so we don't to check rrdev.
>                  */
> -               while ((rw & WRITE) && rdev &&
> +               while (op_is_write(op) && rdev &&
>                        test_bit(WriteErrorSeen, &rdev->flags)) {
>                         sector_t first_bad;
>                         int bad_sectors;
> @@ -995,8 +999,9 @@ again:
>
>                         bio_reset(bi);
>                         bi->bi_bdev = rdev->bdev;
> -                       bi->bi_rw = rw;
> -                       bi->bi_end_io = (rw & WRITE)
> +                       bi->bi_op = op;
> +                       bi->bi_rw = op_flags;
> +                       bi->bi_end_io = op_is_write(op)
>                                 ? raid5_end_write_request
>                                 : raid5_end_read_request;
>                         bi->bi_private = sh;
> @@ -1027,7 +1032,7 @@ again:
>                          * If this is discard request, set bi_vcnt 0. We
> don't
>                          * want to confuse SCSI because SCSI will replace
> payload
>                          */
> -                       if (rw & REQ_DISCARD)
> +                       if (op == REQ_OP_DISCARD)
>                                 bi->bi_vcnt = 0;
>                         if (rrdev)
>                                 set_bit(R5_DOUBLE_LOCKED,
> &sh->dev[i].flags);
> @@ -1047,8 +1052,9 @@ again:
>
>                         bio_reset(rbi);
>                         rbi->bi_bdev = rrdev->bdev;
> -                       rbi->bi_rw = rw;
> -                       BUG_ON(!(rw & WRITE));
> +                       rbi->bi_op = op;
> +                       rbi->bi_rw = op_flags;
> +                       BUG_ON(!op_is_write(op));
>                         rbi->bi_end_io = raid5_end_write_request;
>                         rbi->bi_private = sh;
>
> @@ -1076,7 +1082,7 @@ again:
>                          * If this is discard request, set bi_vcnt 0. We
> don't
>                          * want to confuse SCSI because SCSI will replace
> payload
>                          */
> -                       if (rw & REQ_DISCARD)
> +                       if (op == REQ_OP_DISCARD)
>                                 rbi->bi_vcnt = 0;
>                         if (conf->mddev->gendisk)
>
> trace_block_bio_remap(bdev_get_queue(rbi->bi_bdev),
> @@ -1085,7 +1091,7 @@ again:
>                         generic_make_request(rbi);
>                 }
>                 if (!rdev && !rrdev) {
> -                       if (rw & WRITE)
> +                       if (op_is_write(op))
>                                 set_bit(STRIPE_DEGRADED, &sh->state);
>                         pr_debug("skip op %ld on disc %d for sector
> %llu\n",
>                                 bi->bi_rw, i, (unsigned long
> long)sh->sector);
> @@ -1623,7 +1629,7 @@ again:
>                                         set_bit(R5_WantFUA, &dev->flags);
>                                 if (wbi->bi_rw & REQ_SYNC)
>                                         set_bit(R5_SyncIO, &dev->flags);
> -                               if (wbi->bi_rw & REQ_DISCARD)
> +                               if (wbi->bi_op == REQ_OP_DISCARD)
>                                         set_bit(R5_Discard, &dev->flags);
>                                 else {
>                                         tx = async_copy_data(1, wbi,
> &dev->page,
> @@ -5178,7 +5184,7 @@ static void raid5_make_request(struct mddev *mddev,
> struct bio * bi)
>                         return;
>         }
>
> -       if (unlikely(bi->bi_rw & REQ_DISCARD)) {
> +       if (unlikely(bi->bi_op == REQ_OP_DISCARD)) {
>                 make_discard_request(mddev, bi);
>                 return;
>         }
> --
> 2.7.2
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>



-- 
Shaun Tancheff

--94eb2c0766c65497ea05312f4703
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+PGRpdiBjbGFzcz0iZ21haWxfZXh0cmEiPjxkaXYgY2xhc3M9ImdtYWls
X3F1b3RlIj5PbiBGcmksIEFwciAxNSwgMjAxNiBhdCA1OjM5IEFNLCAgPHNwYW4gZGlyPSJsdHIi
PiZsdDs8YSBocmVmPSJtYWlsdG86bWNocmlzdGlAcmVkaGF0LmNvbSIgdGFyZ2V0PSJfYmxhbmsi
Pm1jaHJpc3RpQHJlZGhhdC5jb208L2E+Jmd0Ozwvc3Bhbj4gd3JvdGU6PGJyPjxibG9ja3F1b3Rl
IGNsYXNzPSJnbWFpbF9xdW90ZSIgc3R5bGU9Im1hcmdpbjowcHggMHB4IDBweCAwLjhleDtib3Jk
ZXItbGVmdC13aWR0aDoxcHg7Ym9yZGVyLWxlZnQtc3R5bGU6c29saWQ7Ym9yZGVyLWxlZnQtY29s
b3I6cmdiKDIwNCwyMDQsMjA0KTtwYWRkaW5nLWxlZnQ6MWV4Ij5Gcm9tOiBNaWtlIENocmlzdGll
ICZsdDs8YSBocmVmPSJtYWlsdG86bWNocmlzdGlAcmVkaGF0LmNvbSI+bWNocmlzdGlAcmVkaGF0
LmNvbTwvYT4mZ3Q7PGJyPg0KPGJyPg0KVGhpcyBwYXRjaCBoYXMgbWQgdXNlIGJpby0mZ3Q7Ymlf
b3AgZm9yIFJFUV9PUHMgYW5kIHJxX2ZsYWdfYml0czxicj4NCnRvIGJpby0mZ3Q7YmlfcncuPGJy
Pg0KPGJyPg0KU2lnbmVkLW9mZi1ieTogTWlrZSBDaHJpc3RpZSAmbHQ7PGEgaHJlZj0ibWFpbHRv
Om1jaHJpc3RpQHJlZGhhdC5jb20iPm1jaHJpc3RpQHJlZGhhdC5jb208L2E+Jmd0Ozxicj4NClJl
dmlld2VkLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyAmbHQ7PGEgaHJlZj0ibWFpbHRvOmhjaEBsc3Qu
ZGUiPmhjaEBsc3QuZGU8L2E+Jmd0Ozxicj4NClJldmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVja2Ug
Jmx0OzxhIGhyZWY9Im1haWx0bzpoYXJlQHN1c2UuY29tIj5oYXJlQHN1c2UuY29tPC9hPiZndDs8
YnI+DQotLS08YnI+DQrCoGRyaXZlcnMvbWQvYml0bWFwLmPCoCDCoCDCoCB8wqAgMiArLTxicj4N
CsKgZHJpdmVycy9tZC9kbS1yYWlkLmPCoCDCoCDCoHzCoCA1ICsrKy0tPGJyPg0KwqBkcml2ZXJz
L21kL21kLmPCoCDCoCDCoCDCoCDCoCB8IDExICsrKysrKystLS0tPGJyPg0KwqBkcml2ZXJzL21k
L21kLmjCoCDCoCDCoCDCoCDCoCB8wqAgMyArKy08YnI+DQrCoGRyaXZlcnMvbWQvcmFpZDEuY8Kg
IMKgIMKgIMKgfCAzNCArKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLTxicj4NCsKgZHJp
dmVycy9tZC9yYWlkMTAuY8KgIMKgIMKgIHwgNTAgKysrKysrKysrKysrKysrKysrKysrKysrKyst
LS0tLS0tLS0tLS0tLS0tLS0tLS0tPGJyPg0KwqBkcml2ZXJzL21kL3JhaWQ1LWNhY2hlLmMgfCAy
NSArKysrKysrKysrKysrKystLS0tLS0tLS08YnI+DQrCoGRyaXZlcnMvbWQvcmFpZDUuY8KgIMKg
IMKgIMKgfCA0OCArKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0t
PGJyPg0KwqA4IGZpbGVzIGNoYW5nZWQsIDEwMSBpbnNlcnRpb25zKCspLCA3NyBkZWxldGlvbnMo
LSk8YnI+DQo8YnI+PC9ibG9ja3F1b3RlPjxkaXY+PGJyPjwvZGl2PjxkaXY+U29ycnkgSSB0aG91
Z2ggdGhpcyB3b3VsZCB0aHJlYWQgcHJvcGVydGx5OsKgPC9kaXY+PGRpdj48YSBocmVmPSJodHRw
czovL2xrbWwua2VybmVsLm9yZy9yLzE0NjE0NTI3MDktNjcwMi0xLWdpdC1zZW5kLWVtYWlsLXNo
YXVuQHRhbmNoZWZmLmNvbSI+aHR0cHM6Ly9sa21sLmtlcm5lbC5vcmcvci8xNDYxNDUyNzA5LTY3
MDItMS1naXQtc2VuZC1lbWFpbC1zaGF1bkB0YW5jaGVmZi5jb208L2E+PGJyPjwvZGl2PjxkaXY+
PGJyPjwvZGl2PjxkaXY+SW4gcmFpZDAuYywgcmFpZDEwLmMgYW5kIHJhaWQ1LmM8L2Rpdj48ZGl2
Pjxicj48L2Rpdj48ZGl2PjxkaXY+QSBjb3VwbGUgb2YgY2hlY2tzIGZvciBSRVFfUFJFRkxVU0gg
ZmxhZyBzaG91bGQgYWxzbyBjaGVjayBmb3I8L2Rpdj48ZGl2PmJpX29wIG1hdGNoaW5nIFJFUV9P
UF9GTFVTSC48L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2PkluIHJhaWQxLmMgW3IxX3N5bmNfcGFn
ZV9pbygpXSBhbmQgcmFpZDEwLmMgW3IxMF9zeW5jX3BhZ2VfaW8oKV08L2Rpdj48ZGl2Pjxicj48
L2Rpdj48ZGl2PldyYXBwZXJzIGZvciBzeW5jX3BhZ2VfaW8oKSBhcmUgcGFzc2VkIFJFQUQvV1JJ
VEUgYnV0IG5lZWQgdG88L2Rpdj48ZGl2PmJlIHBhc3NlZCBSRVFfT1BfUkVBRCBhbmQgUkVRX09Q
X1dSSVRFLjwvZGl2PjwvZGl2PjxkaXY+PGJyPjwvZGl2PjxkaXY+QW55d2F5IG15IHJhaWQgdGVz
dGluZyB3YXMgZ2V0dGluZyB3ZWlyZCBoYW5ncyBhbmQgY29ycnVwdGlvbjwvZGl2PjxkaXY+d2l0
aG91dCB0aGUgcGF0Y2guPC9kaXY+PGRpdj48YnI+PC9kaXY+PGRpdj5UaGFua3MhPC9kaXY+PGRp
dj48YnI+PC9kaXY+PGRpdj7CoDwvZGl2PjxibG9ja3F1b3RlIGNsYXNzPSJnbWFpbF9xdW90ZSIg
c3R5bGU9Im1hcmdpbjowcHggMHB4IDBweCAwLjhleDtib3JkZXItbGVmdC13aWR0aDoxcHg7Ym9y
ZGVyLWxlZnQtc3R5bGU6c29saWQ7Ym9yZGVyLWxlZnQtY29sb3I6cmdiKDIwNCwyMDQsMjA0KTtw
YWRkaW5nLWxlZnQ6MWV4Ij4NCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2JpdG1hcC5jIGIvZHJp
dmVycy9tZC9iaXRtYXAuYzxicj4NCmluZGV4IDhiMmUxNmYuLjllODAxOWUgMTAwNjQ0PGJyPg0K
LS0tIGEvZHJpdmVycy9tZC9iaXRtYXAuYzxicj4NCisrKyBiL2RyaXZlcnMvbWQvYml0bWFwLmM8
YnI+DQpAQCAtMTU5LDcgKzE1OSw3IEBAIHN0YXRpYyBpbnQgcmVhZF9zYl9wYWdlKHN0cnVjdCBt
ZGRldiAqbWRkZXYsIGxvZmZfdCBvZmZzZXQsPGJyPg0KPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgaWYgKHN5bmNfcGFnZV9pbyhyZGV2LCB0YXJnZXQsPGJyPg0KwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqByb3VuZHVwKHNpemUsIGJkZXZfbG9n
aWNhbF9ibG9ja19zaXplKHJkZXYtJmd0O2JkZXYpKSw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgcGFnZSwgUkVBRCwgdHJ1ZSkpIHs8YnI+DQor
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgcGFnZSwgUkVR
X09QX1JFQUQsIDAsIHRydWUpKSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgcGFnZS0mZ3Q7aW5kZXggPSBpbmRleDs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCByZXR1cm4gMDs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCB9PGJy
Pg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0tcmFpZC5jIGIvZHJpdmVycy9tZC9kbS1yYWlk
LmM8YnI+DQppbmRleCBhMDkwMTIxLi40M2E3NDljIDEwMDY0NDxicj4NCi0tLSBhL2RyaXZlcnMv
bWQvZG0tcmFpZC5jPGJyPg0KKysrIGIvZHJpdmVycy9tZC9kbS1yYWlkLmM8YnI+DQpAQCAtNzky
LDcgKzc5Miw3IEBAIHN0YXRpYyBpbnQgcmVhZF9kaXNrX3NiKHN0cnVjdCBtZF9yZGV2ICpyZGV2
LCBpbnQgc2l6ZSk8YnI+DQrCoCDCoCDCoCDCoCBpZiAocmRldi0mZ3Q7c2JfbG9hZGVkKTxicj4N
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHJldHVybiAwOzxicj4NCjxicj4NCi3CoCDCoCDCoCDC
oGlmICghc3luY19wYWdlX2lvKHJkZXYsIDAsIHNpemUsIHJkZXYtJmd0O3NiX3BhZ2UsIFJFQUQs
IDEpKSB7PGJyPg0KK8KgIMKgIMKgIMKgaWYgKCFzeW5jX3BhZ2VfaW8ocmRldiwgMCwgc2l6ZSwg
cmRldi0mZ3Q7c2JfcGFnZSwgUkVRX09QX1JFQUQsIDAsIDEpKSB7PGJyPg0KwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgRE1FUlIoJnF1b3Q7RmFpbGVkIHRvIHJlYWQgc3VwZXJibG9jayBvZiBkZXZp
Y2UgYXQgcG9zaXRpb24gJWQmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgcmRldi0mZ3Q7cmFpZF9kaXNrKTs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBt
ZF9lcnJvcihyZGV2LSZndDttZGRldiwgcmRldik7PGJyPg0KQEAgLTE2NDYsNyArMTY0Niw4IEBA
IHN0YXRpYyB2b2lkIGF0dGVtcHRfcmVzdG9yZV9vZl9mYXVsdHlfZGV2aWNlcyhzdHJ1Y3QgcmFp
ZF9zZXQgKnJzKTxicj4NCsKgIMKgIMKgIMKgIGZvciAoaSA9IDA7IGkgJmx0OyBycy0mZ3Q7bWQu
cmFpZF9kaXNrczsgaSsrKSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgciA9ICZhbXA7
cnMtJmd0O2RldltpXS5yZGV2Ozxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGlmICh0ZXN0
X2JpdChGYXVsdHksICZhbXA7ci0mZ3Q7ZmxhZ3MpICZhbXA7JmFtcDsgci0mZ3Q7c2JfcGFnZSAm
YW1wOyZhbXA7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgc3luY19wYWdlX2lv
KHIsIDAsIHItJmd0O3NiX3NpemUsIHItJmd0O3NiX3BhZ2UsIFJFQUQsIDEpKSB7PGJyPg0KK8Kg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgc3luY19wYWdlX2lvKHIsIDAsIHItJmd0O3NiX3Np
emUsIHItJmd0O3NiX3BhZ2UsIFJFUV9PUF9SRUFELCAwLDxicj4NCivCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAxKSkgezxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIERNSU5GTygmcXVvdDtGYXVsdHkgJXMgZGV2aWNlICMlZCBo
YXMgcmVhZGFibGUgc3VwZXIgYmxvY2suJnF1b3Q7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAmcXVvdDvCoCBBdHRlbXB0aW5nIHRvIHJldml2ZSBp
dC4mcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqBycy0mZ3Q7cmFpZF90eXBlLSZndDtuYW1lLCBpKTs8YnI+DQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9tZC9tZC5jIGIvZHJpdmVycy9tZC9tZC5jPGJyPg0KaW5kZXggZWMzYzk4ZC4uOWM0MDM2
OCAxMDA2NDQ8YnI+DQotLS0gYS9kcml2ZXJzL21kL21kLmM8YnI+DQorKysgYi9kcml2ZXJzL21k
L21kLmM8YnI+DQpAQCAtMzkyLDYgKzM5Miw3IEBAIHN0YXRpYyB2b2lkIHN1Ym1pdF9mbHVzaGVz
KHN0cnVjdCB3b3JrX3N0cnVjdCAqd3MpPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgYmktJmd0O2JpX2VuZF9pbyA9IG1kX2VuZF9mbHVzaDs8YnI+DQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBiaS0mZ3Q7YmlfcHJpdmF0ZSA9IHJkZXY7PGJyPg0K
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgYmktJmd0O2JpX2JkZXYgPSByZGV2
LSZndDtiZGV2Ozxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGJpLSZn
dDtiaV9vcCA9IFJFUV9PUF9XUklURTs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCBiaS0mZ3Q7YmlfcncgPSBXUklURV9GTFVTSDs8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCBhdG9taWNfaW5jKCZhbXA7bWRkZXYtJmd0O2ZsdXNoX3BlbmRp
bmcpOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHN1Ym1pdF9iaW8o
YmkpOzxicj4NCkBAIC03NDEsNiArNzQyLDcgQEAgdm9pZCBtZF9zdXBlcl93cml0ZShzdHJ1Y3Qg
bWRkZXYgKm1kZGV2LCBzdHJ1Y3QgbWRfcmRldiAqcmRldiw8YnI+DQrCoCDCoCDCoCDCoCBiaW9f
YWRkX3BhZ2UoYmlvLCBwYWdlLCBzaXplLCAwKTs8YnI+DQrCoCDCoCDCoCDCoCBiaW8tJmd0O2Jp
X3ByaXZhdGUgPSByZGV2Ozxicj4NCsKgIMKgIMKgIMKgIGJpby0mZ3Q7YmlfZW5kX2lvID0gc3Vw
ZXJfd3JpdHRlbjs8YnI+DQorwqAgwqAgwqAgwqBiaW8tJmd0O2JpX29wID0gUkVRX09QX1dSSVRF
Ozxicj4NCsKgIMKgIMKgIMKgIGJpby0mZ3Q7YmlfcncgPSBXUklURV9GTFVTSF9GVUE7PGJyPg0K
PGJyPg0KwqAgwqAgwqAgwqAgYXRvbWljX2luYygmYW1wO21kZGV2LSZndDtwZW5kaW5nX3dyaXRl
cyk7PGJyPg0KQEAgLTc1NCwxNCArNzU2LDE1IEBAIHZvaWQgbWRfc3VwZXJfd2FpdChzdHJ1Y3Qg
bWRkZXYgKm1kZGV2KTxicj4NCsKgfTxicj4NCjxicj4NCsKgaW50IHN5bmNfcGFnZV9pbyhzdHJ1
Y3QgbWRfcmRldiAqcmRldiwgc2VjdG9yX3Qgc2VjdG9yLCBpbnQgc2l6ZSw8YnI+DQotwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgc3RydWN0IHBhZ2UgKnBhZ2UsIGludCBydywgYm9vbCBtZXRhZGF0
YV9vcCk8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgc3RydWN0IHBhZ2UgKnBhZ2UsIGlu
dCBvcCwgaW50IG9wX2ZsYWdzLCBib29sIG1ldGFkYXRhX29wKTxicj4NCsKgezxicj4NCsKgIMKg
IMKgIMKgIHN0cnVjdCBiaW8gKmJpbyA9IGJpb19hbGxvY19tZGRldihHRlBfTk9JTywgMSwgcmRl
di0mZ3Q7bWRkZXYpOzxicj4NCsKgIMKgIMKgIMKgIGludCByZXQ7PGJyPg0KPGJyPg0KwqAgwqAg
wqAgwqAgYmlvLSZndDtiaV9iZGV2ID0gKG1ldGFkYXRhX29wICZhbXA7JmFtcDsgcmRldi0mZ3Q7
bWV0YV9iZGV2KSA/PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgcmRldi0mZ3Q7bWV0YV9i
ZGV2IDogcmRldi0mZ3Q7YmRldjs8YnI+DQotwqAgwqAgwqAgwqBiaW8tJmd0O2JpX3J3ID0gcnc7
PGJyPg0KK8KgIMKgIMKgIMKgYmlvLSZndDtiaV9vcCA9IG9wOzxicj4NCivCoCDCoCDCoCDCoGJp
by0mZ3Q7YmlfcncgPSBvcF9mbGFnczs8YnI+DQrCoCDCoCDCoCDCoCBpZiAobWV0YWRhdGFfb3Ap
PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgYmlvLSZndDtiaV9pdGVyLmJpX3NlY3RvciA9
IHNlY3RvciArIHJkZXYtJmd0O3NiX3N0YXJ0Ozxicj4NCsKgIMKgIMKgIMKgIGVsc2UgaWYgKHJk
ZXYtJmd0O21kZGV2LSZndDtyZXNoYXBlX3Bvc2l0aW9uICE9IE1heFNlY3RvciAmYW1wOyZhbXA7
PGJyPg0KQEAgLTc4Nyw3ICs3OTAsNyBAQCBzdGF0aWMgaW50IHJlYWRfZGlza19zYihzdHJ1Y3Qg
bWRfcmRldiAqcmRldiwgaW50IHNpemUpPGJyPg0KwqAgwqAgwqAgwqAgaWYgKHJkZXYtJmd0O3Ni
X2xvYWRlZCk8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCByZXR1cm4gMDs8YnI+DQo8YnI+
DQotwqAgwqAgwqAgwqBpZiAoIXN5bmNfcGFnZV9pbyhyZGV2LCAwLCBzaXplLCByZGV2LSZndDtz
Yl9wYWdlLCBSRUFELCB0cnVlKSk8YnI+DQorwqAgwqAgwqAgwqBpZiAoIXN5bmNfcGFnZV9pbyhy
ZGV2LCAwLCBzaXplLCByZGV2LSZndDtzYl9wYWdlLCBSRVFfT1BfUkVBRCwgMCwgdHJ1ZSkpPGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgZ290byBmYWlsOzxicj4NCsKgIMKgIMKgIMKgIHJk
ZXYtJmd0O3NiX2xvYWRlZCA9IDE7PGJyPg0KwqAgwqAgwqAgwqAgcmV0dXJuIDA7PGJyPg0KQEAg
LTE0NzMsNyArMTQ3Niw3IEBAIHN0YXRpYyBpbnQgc3VwZXJfMV9sb2FkKHN0cnVjdCBtZF9yZGV2
ICpyZGV2LCBzdHJ1Y3QgbWRfcmRldiAqcmVmZGV2LCBpbnQgbWlub3JfPGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgcmV0dXJuIC1FSU5WQUw7PGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgYmJfc2VjdG9yID0gKGxvbmcgbG9uZylvZmZzZXQ7PGJyPg0KwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgaWYgKCFzeW5jX3BhZ2VfaW8ocmRldiwgYmJfc2VjdG9yLCBzZWN0
b3JzICZsdDsmbHQ7IDksPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgcmRldi0mZ3Q7YmJfcGFnZSwgUkVBRCwgdHJ1ZSkpPGJyPg0KK8KgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcmRldi0mZ3Q7YmJf
cGFnZSwgUkVRX09QX1JFQUQsIDAsIHRydWUpKTxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIHJldHVybiAtRUlPOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGJi
cCA9ICh1NjQgKilwYWdlX2FkZHJlc3MocmRldi0mZ3Q7YmJfcGFnZSk7PGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgcmRldi0mZ3Q7YmFkYmxvY2tzLnNoaWZ0ID0gc2ItJmd0O2JibG9nX3No
aWZ0Ozxicj4NCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL21kLmggYi9kcml2ZXJzL21kL21kLmg8
YnI+DQppbmRleCBiNWM0YmU3Li4yZTA5MThmIDEwMDY0NDxicj4NCi0tLSBhL2RyaXZlcnMvbWQv
bWQuaDxicj4NCisrKyBiL2RyaXZlcnMvbWQvbWQuaDxicj4NCkBAIC02MTgsNyArNjE4LDggQEAg
ZXh0ZXJuIHZvaWQgbWRfc3VwZXJfd3JpdGUoc3RydWN0IG1kZGV2ICptZGRldiwgc3RydWN0IG1k
X3JkZXYgKnJkZXYsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqBzZWN0b3JfdCBzZWN0b3IsIGludCBzaXplLCBzdHJ1Y3QgcGFnZSAqcGFnZSk7PGJyPg0KwqBl
eHRlcm4gdm9pZCBtZF9zdXBlcl93YWl0KHN0cnVjdCBtZGRldiAqbWRkZXYpOzxicj4NCsKgZXh0
ZXJuIGludCBzeW5jX3BhZ2VfaW8oc3RydWN0IG1kX3JkZXYgKnJkZXYsIHNlY3Rvcl90IHNlY3Rv
ciwgaW50IHNpemUsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgc3Ry
dWN0IHBhZ2UgKnBhZ2UsIGludCBydywgYm9vbCBtZXRhZGF0YV9vcCk7PGJyPg0KK8KgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgc3RydWN0IHBhZ2UgKnBhZ2UsIGludCBvcCwgaW50
IG9wX2ZsYWdzLDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGJvb2wg
bWV0YWRhdGFfb3ApOzxicj4NCsKgZXh0ZXJuIHZvaWQgbWRfZG9fc3luYyhzdHJ1Y3QgbWRfdGhy
ZWFkICp0aHJlYWQpOzxicj4NCsKgZXh0ZXJuIHZvaWQgbWRfbmV3X2V2ZW50KHN0cnVjdCBtZGRl
diAqbWRkZXYpOzxicj4NCsKgZXh0ZXJuIGludCBtZF9hbGxvd193cml0ZShzdHJ1Y3QgbWRkZXYg
Km1kZGV2KTs8YnI+DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9yYWlkMS5jIGIvZHJpdmVycy9t
ZC9yYWlkMS5jPGJyPg0KaW5kZXggNDI0ZGY3ZS4uYzdhYmQyZCAxMDA2NDQ8YnI+DQotLS0gYS9k
cml2ZXJzL21kL3JhaWQxLmM8YnI+DQorKysgYi9kcml2ZXJzL21kL3JhaWQxLmM8YnI+DQpAQCAt
NzU5LDcgKzc1OSw3IEBAIHN0YXRpYyB2b2lkIGZsdXNoX3BlbmRpbmdfd3JpdGVzKHN0cnVjdCBy
MWNvbmYgKmNvbmYpPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgd2hpbGUgKGJpbykgeyAv
KiBzdWJtaXQgcGVuZGluZyB3cml0ZXMgKi88YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCBzdHJ1Y3QgYmlvICpuZXh0ID0gYmlvLSZndDtiaV9uZXh0Ozxicj4NCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGJpby0mZ3Q7YmlfbmV4dCA9IE5VTEw7PGJy
Pg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaWYgKHVubGlrZWx5KChiaW8t
Jmd0O2JpX3J3ICZhbXA7IFJFUV9ESVNDQVJEKSAmYW1wOyZhbXA7PGJyPg0KK8KgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaWYgKHVubGlrZWx5KChiaW8tJmd0O2JpX29wID09IFJF
UV9PUF9ESVNDQVJEKSAmYW1wOyZhbXA7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgIWJsa19xdWV1ZV9kaXNjYXJkKGJkZXZfZ2V0X3F1ZXVlKGJpby0mZ3Q7
YmlfYmRldikpKSk8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCAvKiBKdXN0IGlnbm9yZSBpdCAqLzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGJpb19lbmRpbyhiaW8pOzxicj4NCkBAIC0xMDMzLDcg
KzEwMzMsNyBAQCBzdGF0aWMgdm9pZCByYWlkMV91bnBsdWcoc3RydWN0IGJsa19wbHVnX2NiICpj
YiwgYm9vbCBmcm9tX3NjaGVkdWxlKTxicj4NCsKgIMKgIMKgIMKgIHdoaWxlIChiaW8pIHsgLyog
c3VibWl0IHBlbmRpbmcgd3JpdGVzICovPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgc3Ry
dWN0IGJpbyAqbmV4dCA9IGJpby0mZ3Q7YmlfbmV4dDs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCBiaW8tJmd0O2JpX25leHQgPSBOVUxMOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oGlmICh1bmxpa2VseSgoYmlvLSZndDtiaV9ydyAmYW1wOyBSRVFfRElTQ0FSRCkgJmFtcDsmYW1w
Ozxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGlmICh1bmxpa2VseSgoYmlvLSZndDtiaV9v
cCA9PSBSRVFfT1BfRElTQ0FSRCkgJmFtcDsmYW1wOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgICFibGtfcXVldWVfZGlzY2FyZChiZGV2X2dldF9xdWV1ZShiaW8tJmd0O2JpX2Jk
ZXYpKSkpPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLyogSnVzdCBp
Z25vcmUgaXQgKi88YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBiaW9f
ZW5kaW8oYmlvKTs8YnI+DQpAQCAtMTA1MywxMiArMTA1MywxMSBAQCBzdGF0aWMgdm9pZCByYWlk
MV9tYWtlX3JlcXVlc3Qoc3RydWN0IG1kZGV2ICptZGRldiwgc3RydWN0IGJpbyAqIGJpbyk8YnI+
DQrCoCDCoCDCoCDCoCBpbnQgaSwgZGlza3M7PGJyPg0KwqAgwqAgwqAgwqAgc3RydWN0IGJpdG1h
cCAqYml0bWFwOzxicj4NCsKgIMKgIMKgIMKgIHVuc2lnbmVkIGxvbmcgZmxhZ3M7PGJyPg0KK8Kg
IMKgIMKgIMKgY29uc3QgaW50IG9wID0gYmlvLSZndDtiaV9vcDs8YnI+DQrCoCDCoCDCoCDCoCBj
b25zdCBpbnQgcncgPSBiaW9fZGF0YV9kaXIoYmlvKTs8YnI+DQrCoCDCoCDCoCDCoCBjb25zdCB1
bnNpZ25lZCBsb25nIGRvX3N5bmMgPSAoYmlvLSZndDtiaV9ydyAmYW1wOyBSRVFfU1lOQyk7PGJy
Pg0KwqAgwqAgwqAgwqAgY29uc3QgdW5zaWduZWQgbG9uZyBkb19mbHVzaF9mdWEgPSAoYmlvLSZn
dDtiaV9ydyAmYW1wOyAoUkVRX0ZMVVNIIHwgUkVRX0ZVQSkpOzxicj4NCi3CoCDCoCDCoCDCoGNv
bnN0IHVuc2lnbmVkIGxvbmcgZG9fZGlzY2FyZCA9IChiaW8tJmd0O2JpX3J3PGJyPg0KLcKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
JmFtcDsgKFJFUV9ESVNDQVJEIHwgUkVRX1NFQ1VSRSkpOzxicj4NCi3CoCDCoCDCoCDCoGNvbnN0
IHVuc2lnbmVkIGxvbmcgZG9fc2FtZSA9IChiaW8tJmd0O2JpX3J3ICZhbXA7IFJFUV9XUklURV9T
QU1FKTs8YnI+DQorwqAgwqAgwqAgwqBjb25zdCB1bnNpZ25lZCBsb25nIGRvX3NlYyA9IChiaW8t
Jmd0O2JpX3J3ICZhbXA7IFJFUV9TRUNVUkUpOzxicj4NCsKgIMKgIMKgIMKgIHN0cnVjdCBtZF9y
ZGV2ICpibG9ja2VkX3JkZXY7PGJyPg0KwqAgwqAgwqAgwqAgc3RydWN0IGJsa19wbHVnX2NiICpj
Yjs8YnI+DQrCoCDCoCDCoCDCoCBzdHJ1Y3QgcmFpZDFfcGx1Z19jYiAqcGx1ZyA9IE5VTEw7PGJy
Pg0KQEAgLTExNjYsNyArMTE2NSw4IEBAIHJlYWRfYWdhaW46PGJyPg0KwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgbWlycm9yLSZndDtyZGV2LSZndDtkYXRhX29mZnNldDs8YnI+
DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCByZWFkX2Jpby0mZ3Q7YmlfYmRldiA9IG1pcnJvci0m
Z3Q7cmRldi0mZ3Q7YmRldjs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCByZWFkX2Jpby0m
Z3Q7YmlfZW5kX2lvID0gcmFpZDFfZW5kX3JlYWRfcmVxdWVzdDs8YnI+DQotwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqByZWFkX2Jpby0mZ3Q7YmlfcncgPSBSRUFEIHwgZG9fc3luYzs8YnI+DQorwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqByZWFkX2Jpby0mZ3Q7Ymlfb3AgPSBvcDs8YnI+DQorwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqByZWFkX2Jpby0mZ3Q7YmlfcncgPSBkb19zeW5jOzxicj4NCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIHJlYWRfYmlvLSZndDtiaV9wcml2YXRlID0gcjFfYmlvOzxicj4N
Cjxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGlmIChtYXhfc2VjdG9ycyAmbHQ7IHIxX2Jp
by0mZ3Q7c2VjdG9ycykgezxicj4NCkBAIC0xMzc2LDggKzEzNzYsOSBAQCByZWFkX2FnYWluOjxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
Y29uZi0mZ3Q7bWlycm9yc1tpXS5yZGV2LSZndDtkYXRhX29mZnNldCk7PGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgbWJpby0mZ3Q7YmlfYmRldiA9IGNvbmYtJmd0O21pcnJvcnNbaV0ucmRl
di0mZ3Q7YmRldjs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBtYmlvLSZndDtiaV9lbmRf
aW8gPSByYWlkMV9lbmRfd3JpdGVfcmVxdWVzdDs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqBtYmlvLSZndDtiaV9vcCA9IG9wOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIG1iaW8t
Jmd0O2JpX3J3ID08YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBXUklU
RSB8IGRvX2ZsdXNoX2Z1YSB8IGRvX3N5bmMgfCBkb19kaXNjYXJkIHwgZG9fc2FtZTs8YnI+DQor
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBkb19mbHVzaF9mdWEgfCBkb19zeW5j
IHwgZG9fc2VjOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIG1iaW8tJmd0O2JpX3ByaXZh
dGUgPSByMV9iaW87PGJyPg0KPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgYXRvbWljX2lu
YygmYW1wO3IxX2Jpby0mZ3Q7cmVtYWluaW5nKTs8YnI+DQpAQCAtMTc3MSw3ICsxNzcyLDcgQEAg
c3RhdGljIHZvaWQgZW5kX3N5bmNfd3JpdGUoc3RydWN0IGJpbyAqYmlvKTxicj4NCsKgc3RhdGlj
IGludCByMV9zeW5jX3BhZ2VfaW8oc3RydWN0IG1kX3JkZXYgKnJkZXYsIHNlY3Rvcl90IHNlY3Rv
ciw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpbnQgc2Vj
dG9ycywgc3RydWN0IHBhZ2UgKnBhZ2UsIGludCBydyk8YnI+DQrCoHs8YnI+DQotwqAgwqAgwqAg
wqBpZiAoc3luY19wYWdlX2lvKHJkZXYsIHNlY3Rvciwgc2VjdG9ycyAmbHQ7Jmx0OyA5LCBwYWdl
LCBydywgZmFsc2UpKTxicj4NCivCoCDCoCDCoCDCoGlmIChzeW5jX3BhZ2VfaW8ocmRldiwgc2Vj
dG9yLCBzZWN0b3JzICZsdDsmbHQ7IDksIHBhZ2UsIHJ3LCAwLCBmYWxzZSkpPGJyPg0KwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgLyogc3VjY2VzcyAqLzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIHJldHVybiAxOzxicj4NCsKgIMKgIMKgIMKgIGlmIChydyA9PSBXUklURSkgezxicj4NCkBA
IC0xODI1LDcgKzE4MjYsNyBAQCBzdGF0aWMgaW50IGZpeF9zeW5jX3JlYWRfZXJyb3Ioc3RydWN0
IHIxYmlvICpyMV9iaW8pPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgcmRldiA9IGNvbmYtJmd0O21pcnJvcnNbZF0ucmRldjs8YnI+DQrCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAoc3luY19wYWdlX2lv
KHJkZXYsIHNlY3QsIHMmbHQ7Jmx0OzksPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBiaW8tJmd0O2Jp
X2lvX3ZlY1tpZHhdLmJ2X3BhZ2UsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIFJFQUQsIGZhbHNlKSkg
ezxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBSRVFfT1BfUkVBRCwgMCwgZmFsc2UpKSB7PGJyPg0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
c3VjY2VzcyA9IDE7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgYnJlYWs7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgfTxicj4NCkBAIC0yMDMwLDcgKzIwMzEsNyBAQCBzdGF0
aWMgdm9pZCBzeW5jX3JlcXVlc3Rfd3JpdGUoc3RydWN0IG1kZGV2ICptZGRldiwgc3RydWN0IHIx
YmlvICpyMV9iaW8pPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgIXRlc3Rf
Yml0KE1EX1JFQ09WRVJZX1NZTkMsICZhbXA7bWRkZXYtJmd0O3JlY292ZXJ5KSkpKTxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNvbnRpbnVlOzxicj4NCjxicj4NCi3C
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoHdiaW8tJmd0O2JpX3J3ID0gV1JJVEU7PGJyPg0KK8KgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgd2Jpby0mZ3Q7Ymlfb3AgPSBSRVFfT1BfV1JJVEU7PGJyPg0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgd2Jpby0mZ3Q7YmlfZW5kX2lvID0gZW5kX3N5bmNfd3JpdGU7
PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgYXRvbWljX2luYygmYW1wO3IxX2Jpby0mZ3Q7
cmVtYWluaW5nKTs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBtZF9zeW5jX2FjY3QoY29u
Zi0mZ3Q7bWlycm9yc1tpXS5yZGV2LSZndDtiZGV2LCBiaW9fc2VjdG9ycyh3YmlvKSk7PGJyPg0K
QEAgLTIwOTAsNyArMjA5MSw3IEBAIHN0YXRpYyB2b2lkIGZpeF9yZWFkX2Vycm9yKHN0cnVjdCBy
MWNvbmYgKmNvbmYsIGludCByZWFkX2Rpc2ssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgaXNfYmFkYmxvY2socmRldiwgc2VjdCwgcyw8YnI+DQrCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAmYW1w
O2ZpcnN0X2JhZCwgJmFtcDtiYWRfc2VjdG9ycykgPT0gMCAmYW1wOyZhbXA7PGJyPg0KwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgc3luY19wYWdlX2lvKHJkZXYsIHNl
Y3QsIHMmbHQ7Jmx0OzksPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNvbmYtJmd0O3RtcHBhZ2UsIFJFQUQsIGZhbHNlKSk8
YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgY29uZi0mZ3Q7dG1wcGFnZSwgUkVRX09QX1JFQUQsIDAsIGZhbHNlKSk8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBzdWNjZXNzID0g
MTs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBlbHNlIHs8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBkKys7PGJyPg0K
QEAgLTIyMDEsNyArMjIwMiw3IEBAIHN0YXRpYyBpbnQgbmFycm93X3dyaXRlX2Vycm9yKHN0cnVj
dCByMWJpbyAqcjFfYmlvLCBpbnQgaSk8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCB3YmlvID0gYmlvX2Nsb25lX21kZGV2KHIxX2Jpby0mZ3Q7bWFzdGVyX2JpbywgR0ZQ
X05PSU8sIG1kZGV2KTs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCB9PGJyPg0KPGJyPg0K
LcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgd2Jpby0mZ3Q7YmlfcncgPSBXUklURTs8YnI+DQorwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqB3YmlvLSZndDtiaV9vcCA9IFJFUV9PUF9XUklURTs8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCB3YmlvLSZndDtiaV9pdGVyLmJpX3NlY3RvciA9IHIxX2Jp
by0mZ3Q7c2VjdG9yOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHdiaW8tJmd0O2JpX2l0
ZXIuYmlfc2l6ZSA9IHIxX2Jpby0mZ3Q7c2VjdG9ycyAmbHQ7Jmx0OyA5Ozxicj4NCjxicj4NCkBA
IC0yMzQ0LDcgKzIzNDUsOCBAQCByZWFkX21vcmU6PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgYmlvLSZndDtiaV9pdGVyLmJpX3NlY3RvciA9IHIxX2Jpby0mZ3Q7c2VjdG9yICsgcmRldi0m
Z3Q7ZGF0YV9vZmZzZXQ7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgYmlvLSZndDtiaV9i
ZGV2ID0gcmRldi0mZ3Q7YmRldjs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBiaW8tJmd0
O2JpX2VuZF9pbyA9IHJhaWQxX2VuZF9yZWFkX3JlcXVlc3Q7PGJyPg0KLcKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgYmlvLSZndDtiaV9ydyA9IFJFQUQgfCBkb19zeW5jOzxicj4NCivCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoGJpby0mZ3Q7Ymlfb3AgPSBSRVFfT1BfUkVBRDs8YnI+DQorwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqBiaW8tJmd0O2JpX3J3ID0gZG9fc3luYzs8YnI+DQrCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCBiaW8tJmd0O2JpX3ByaXZhdGUgPSByMV9iaW87PGJyPg0KwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgaWYgKG1heF9zZWN0b3JzICZsdDsgcjFfYmlvLSZndDtzZWN0b3JzKSB7PGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLyogRHJhdCAtIGhhdmUgdG8g
c3BsaXQgdGhpcyB1cCBtb3JlICovPGJyPg0KQEAgLTI1NzIsNyArMjU3NCw3IEBAIHN0YXRpYyBz
ZWN0b3JfdCByYWlkMV9zeW5jX3JlcXVlc3Qoc3RydWN0IG1kZGV2ICptZGRldiwgc2VjdG9yX3Qg
c2VjdG9yX25yLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGlmIChp
ICZsdDsgY29uZi0mZ3Q7cmFpZF9kaXNrcyk8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBzdGlsbF9kZWdyYWRlZCA9IDE7PGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgfSBlbHNlIGlmICghdGVzdF9iaXQoSW5fc3luYywgJmFtcDtyZGV2LSZn
dDtmbGFncykpIHs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBiaW8t
Jmd0O2JpX3J3ID0gV1JJVEU7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgYmlvLSZndDtiaV9vcCA9IFJFUV9PUF9XUklURTs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCBiaW8tJmd0O2JpX2VuZF9pbyA9IGVuZF9zeW5jX3dyaXRlOzxicj4N
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHdyaXRlX3RhcmdldHMgKys7PGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgfSBlbHNlIHs8YnI+DQpAQCAtMjU5OSw3ICsyNjAx
LDcgQEAgc3RhdGljIHNlY3Rvcl90IHJhaWQxX3N5bmNfcmVxdWVzdChzdHJ1Y3QgbWRkZXYgKm1k
ZGV2LCBzZWN0b3JfdCBzZWN0b3JfbnIsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgaWYgKGRpc2sgJmx0OyAwKTxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIGRpc2sgPSBpOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIH08YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqBiaW8tJmd0O2JpX3J3ID0gUkVBRDs8YnI+DQorwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBiaW8tJmd0O2JpX29wID0gUkVRX09Q
X1JFQUQ7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgYmlvLSZndDtiaV9lbmRfaW8gPSBlbmRfc3luY19yZWFkOzxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHJlYWRfdGFyZ2V0cysrOzxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIH0gZWxzZSBpZiAoIXRlc3RfYml0KFdy
aXRlRXJyb3JTZWVuLCAmYW1wO3JkZXYtJmd0O2ZsYWdzKSAmYW1wOyZhbXA7PGJyPg0KQEAgLTI2
MTEsNyArMjYxMyw3IEBAIHN0YXRpYyBzZWN0b3JfdCByYWlkMV9zeW5jX3JlcXVlc3Qoc3RydWN0
IG1kZGV2ICptZGRldiwgc2VjdG9yX3Qgc2VjdG9yX25yLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgKiBpZiB3ZSBhcmUgZG9pbmcgcmVzeW5j
IG9yIHJlcGFpci4gT3RoZXJ3aXNlLCBsZWF2ZTxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgKiB0aGlzIGRldmljZSBhbG9uZSBmb3IgdGhpcyBz
eW5jIHJlcXVlc3QuPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAqLzxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoGJpby0mZ3Q7YmlfcncgPSBXUklURTs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBiaW8tJmd0O2JpX29wID0gUkVRX09QX1dSSVRF
Ozxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGJp
by0mZ3Q7YmlfZW5kX2lvID0gZW5kX3N5bmNfd3JpdGU7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgd3JpdGVfdGFyZ2V0cysrOzxicj4NCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIH08YnI+DQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9tZC9yYWlkMTAuYyBiL2RyaXZlcnMvbWQvcmFpZDEwLmM8YnI+DQppbmRleCA0NzM2YmU4Li42
M2NkOTg1IDEwMDY0NDxicj4NCi0tLSBhL2RyaXZlcnMvbWQvcmFpZDEwLmM8YnI+DQorKysgYi9k
cml2ZXJzL21kL3JhaWQxMC5jPGJyPg0KQEAgLTg2NSw3ICs4NjUsNyBAQCBzdGF0aWMgdm9pZCBm
bHVzaF9wZW5kaW5nX3dyaXRlcyhzdHJ1Y3QgcjEwY29uZiAqY29uZik8YnI+DQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCB3aGlsZSAoYmlvKSB7IC8qIHN1Ym1pdCBwZW5kaW5nIHdyaXRlcyAqLzxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHN0cnVjdCBiaW8gKm5leHQg
PSBiaW8tJmd0O2JpX25leHQ7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgYmlvLSZndDtiaV9uZXh0ID0gTlVMTDs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqBpZiAodW5saWtlbHkoKGJpby0mZ3Q7YmlfcncgJmFtcDsgUkVRX0RJU0NBUkQp
ICZhbXA7JmFtcDs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBpZiAo
dW5saWtlbHkoKGJpby0mZ3Q7Ymlfb3AgPT3CoCBSRVFfT1BfRElTQ0FSRCkgJmFtcDsmYW1wOzxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgICFibGtfcXVldWVf
ZGlzY2FyZChiZGV2X2dldF9xdWV1ZShiaW8tJmd0O2JpX2JkZXYpKSkpPGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLyogSnVzdCBpZ25vcmUgaXQg
Ki88YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBi
aW9fZW5kaW8oYmlvKTs8YnI+DQpAQCAtMTA0MSw3ICsxMDQxLDcgQEAgc3RhdGljIHZvaWQgcmFp
ZDEwX3VucGx1ZyhzdHJ1Y3QgYmxrX3BsdWdfY2IgKmNiLCBib29sIGZyb21fc2NoZWR1bGUpPGJy
Pg0KwqAgwqAgwqAgwqAgd2hpbGUgKGJpbykgeyAvKiBzdWJtaXQgcGVuZGluZyB3cml0ZXMgKi88
YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBzdHJ1Y3QgYmlvICpuZXh0ID0gYmlvLSZndDti
aV9uZXh0Ozxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGJpby0mZ3Q7YmlfbmV4dCA9IE5V
TEw7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaWYgKHVubGlrZWx5KChiaW8tJmd0O2Jp
X3J3ICZhbXA7IFJFUV9ESVNDQVJEKSAmYW1wOyZhbXA7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgaWYgKHVubGlrZWx5KChiaW8tJmd0O2JpX29wID09wqAgUkVRX09QX0RJU0NBUkQpICZh
bXA7JmFtcDs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAhYmxrX3F1ZXVlX2Rp
c2NhcmQoYmRldl9nZXRfcXVldWUoYmlvLSZndDtiaV9iZGV2KSkpKTxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC8qIEp1c3QgaWdub3JlIGl0ICovPGJyPg0KwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgYmlvX2VuZGlvKGJpbyk7PGJyPg0KQEAgLTEw
NTgsMTIgKzEwNTgsMTEgQEAgc3RhdGljIHZvaWQgX19tYWtlX3JlcXVlc3Qoc3RydWN0IG1kZGV2
ICptZGRldiwgc3RydWN0IGJpbyAqYmlvKTxicj4NCsKgIMKgIMKgIMKgIHN0cnVjdCByMTBiaW8g
KnIxMF9iaW87PGJyPg0KwqAgwqAgwqAgwqAgc3RydWN0IGJpbyAqcmVhZF9iaW87PGJyPg0KwqAg
wqAgwqAgwqAgaW50IGk7PGJyPg0KK8KgIMKgIMKgIMKgY29uc3QgaW50IG9wID0gYmlvLSZndDti
aV9vcDs8YnI+DQrCoCDCoCDCoCDCoCBjb25zdCBpbnQgcncgPSBiaW9fZGF0YV9kaXIoYmlvKTs8
YnI+DQrCoCDCoCDCoCDCoCBjb25zdCB1bnNpZ25lZCBsb25nIGRvX3N5bmMgPSAoYmlvLSZndDti
aV9ydyAmYW1wOyBSRVFfU1lOQyk7PGJyPg0KwqAgwqAgwqAgwqAgY29uc3QgdW5zaWduZWQgbG9u
ZyBkb19mdWEgPSAoYmlvLSZndDtiaV9ydyAmYW1wOyBSRVFfRlVBKTs8YnI+DQotwqAgwqAgwqAg
wqBjb25zdCB1bnNpZ25lZCBsb25nIGRvX2Rpc2NhcmQgPSAoYmlvLSZndDtiaV9ydzxicj4NCi3C
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCZhbXA7IChSRVFfRElTQ0FSRCB8IFJFUV9TRUNVUkUpKTs8YnI+DQotwqAgwqAgwqAgwqBj
b25zdCB1bnNpZ25lZCBsb25nIGRvX3NhbWUgPSAoYmlvLSZndDtiaV9ydyAmYW1wOyBSRVFfV1JJ
VEVfU0FNRSk7PGJyPg0KK8KgIMKgIMKgIMKgY29uc3QgdW5zaWduZWQgbG9uZyBkb19zZWMgPSAo
YmlvLSZndDtiaV9ydyAmYW1wOyBSRVFfU0VDVVJFKTs8YnI+DQrCoCDCoCDCoCDCoCB1bnNpZ25l
ZCBsb25nIGZsYWdzOzxicj4NCsKgIMKgIMKgIMKgIHN0cnVjdCBtZF9yZGV2ICpibG9ja2VkX3Jk
ZXY7PGJyPg0KwqAgwqAgwqAgwqAgc3RydWN0IGJsa19wbHVnX2NiICpjYjs8YnI+DQpAQCAtMTE1
Niw3ICsxMTU1LDggQEAgcmVhZF9hZ2Fpbjo8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCBjaG9vc2VfZGF0YV9vZmZzZXQocjEwX2JpbywgcmRldik7PGJyPg0KwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgcmVhZF9iaW8tJmd0O2JpX2JkZXYgPSByZGV2LSZndDtiZGV2Ozxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHJlYWRfYmlvLSZndDtiaV9lbmRfaW8gPSByYWlk
MTBfZW5kX3JlYWRfcmVxdWVzdDs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqByZWFkX2Jp
by0mZ3Q7YmlfcncgPSBSRUFEIHwgZG9fc3luYzs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqByZWFkX2Jpby0mZ3Q7Ymlfb3AgPSBvcDs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBy
ZWFkX2Jpby0mZ3Q7YmlfcncgPSBkb19zeW5jOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IHJlYWRfYmlvLSZndDtiaV9wcml2YXRlID0gcjEwX2Jpbzs8YnI+DQo8YnI+DQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCBpZiAobWF4X3NlY3RvcnMgJmx0OyByMTBfYmlvLSZndDtzZWN0b3JzKSB7
PGJyPg0KQEAgLTEzNjMsOCArMTM2Myw5IEBAIHJldHJ5X3dyaXRlOjxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHJkZXYpKTs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCBtYmlvLSZndDtiaV9iZGV2ID0gcmRldi0mZ3Q7YmRldjs8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBtYmlvLSZndDtiaV9lbmRfaW8gPSBy
YWlkMTBfZW5kX3dyaXRlX3JlcXVlc3Q7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgbWJpby0mZ3Q7Ymlfb3AgPSBvcDs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCBtYmlvLSZndDtiaV9ydyA9PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgV1JJVEUgfCBkb19zeW5jIHwgZG9fZnVhIHwgZG9f
ZGlzY2FyZCB8IGRvX3NhbWU7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgZG9fc3luYyB8IGRvX2Z1YSB8IGRvX3NlYzs8YnI+DQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBtYmlvLSZndDtiaV9wcml2YXRlID0gcjEwX2Jpbzs8
YnI+DQo8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBhdG9taWNfaW5j
KCZhbXA7cjEwX2Jpby0mZ3Q7cmVtYWluaW5nKTs8YnI+DQpAQCAtMTQwNiw4ICsxNDA3LDkgQEAg
cmV0cnlfd3JpdGU6PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqByMTBfYmlvLCByZGV2KSk7PGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgbWJpby0mZ3Q7YmlfYmRldiA9
IHJkZXYtJmd0O2JkZXY7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
bWJpby0mZ3Q7YmlfZW5kX2lvID0gcmFpZDEwX2VuZF93cml0ZV9yZXF1ZXN0Ozxicj4NCivCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1iaW8tJmd0O2JpX29wID0gb3A7PGJyPg0K
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgbWJpby0mZ3Q7YmlfcncgPTxicj4N
Ci3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoFdSSVRFIHwg
ZG9fc3luYyB8IGRvX2Z1YSB8IGRvX2Rpc2NhcmQgfCBkb19zYW1lOzxicj4NCivCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGRvX3N5bmMgfCBkb19mdWEgfCBk
b19zZWM7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgbWJpby0mZ3Q7
YmlfcHJpdmF0ZSA9IHIxMF9iaW87PGJyPg0KPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgYXRvbWljX2luYygmYW1wO3IxMF9iaW8tJmd0O3JlbWFpbmluZyk7PGJyPg0K
QEAgLTE5OTIsNyArMTk5NCw3IEBAIHN0YXRpYyB2b2lkIHN5bmNfcmVxdWVzdF93cml0ZShzdHJ1
Y3QgbWRkZXYgKm1kZGV2LCBzdHJ1Y3QgcjEwYmlvICpyMTBfYmlvKTxicj4NCjxicj4NCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIHRiaW8tJmd0O2JpX3ZjbnQgPSB2Y250Ozxicj4NCsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIHRiaW8tJmd0O2JpX2l0ZXIuYmlfc2l6ZSA9IGZiaW8tJmd0O2JpX2l0
ZXIuYmlfc2l6ZTs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqB0YmlvLSZndDtiaV9ydyA9
IFdSSVRFOzxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHRiaW8tJmd0O2JpX29wID0gUkVR
X09QX1dSSVRFOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHRiaW8tJmd0O2JpX3ByaXZh
dGUgPSByMTBfYmlvOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHRiaW8tJmd0O2JpX2l0
ZXIuYmlfc2VjdG9yID0gcjEwX2Jpby0mZ3Q7ZGV2c1tpXS5hZGRyOzxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIHRiaW8tJmd0O2JpX2VuZF9pbyA9IGVuZF9zeW5jX3dyaXRlOzxicj4NCkBA
IC0yMDc4LDcgKzIwODAsNyBAQCBzdGF0aWMgdm9pZCBmaXhfcmVjb3ZlcnlfcmVhZF9lcnJvcihz
dHJ1Y3QgcjEwYmlvICpyMTBfYmlvKTxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIGFkZHIsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgcyAmbHQ7Jmx0OyA5LDxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGJpby0mZ3Q7YmlfaW9fdmVj
W2lkeF0uYnZfcGFnZSw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqBSRUFELCBmYWxzZSk7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgUkVRX09QX1JFQUQsIDAsIGZhbHNlKTs8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAob2spIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCByZGV2ID0gY29uZi0mZ3Q7bWlycm9yc1tkd10ucmRldjs8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBhZGRyID0gcjEwX2Jpby0mZ3Q7ZGV2
c1sxXS5hZGRyICsgc2VjdDs8YnI+DQpAQCAtMjA4Niw3ICsyMDg4LDcgQEAgc3RhdGljIHZvaWQg
Zml4X3JlY292ZXJ5X3JlYWRfZXJyb3Ioc3RydWN0IHIxMGJpbyAqcjEwX2Jpbyk8YnI+DQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCBhZGRyLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIHMgJmx0OyZsdDsgOSw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBiaW8tJmd0O2JpX2lv
X3ZlY1tpZHhdLmJ2X3BhZ2UsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgV1JJVEUsIGZhbHNlKTs8YnI+DQorwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBS
RVFfT1BfV1JJVEUsIDAsIGZhbHNlKTs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCBpZiAoIW9rKSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgc2V0X2JpdChXcml0ZUVycm9yU2VlbiwgJmFtcDtyZGV2LSZndDtmbGFn
cyk7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
aWYgKCF0ZXN0X2FuZF9zZXRfYml0KFdhbnRSZXBsYWNlbWVudCw8YnI+DQpAQCAtMjIxMyw3ICsy
MjE1LDcgQEAgc3RhdGljIGludCByMTBfc3luY19wYWdlX2lvKHN0cnVjdCBtZF9yZGV2ICpyZGV2
LCBzZWN0b3JfdCBzZWN0b3IsPGJyPg0KwqAgwqAgwqAgwqAgaWYgKGlzX2JhZGJsb2NrKHJkZXYs
IHNlY3Rvciwgc2VjdG9ycywgJmFtcDtmaXJzdF9iYWQsICZhbXA7YmFkX3NlY3RvcnMpPGJyPg0K
wqAgwqAgwqAgwqAgwqAgwqAgJmFtcDsmYW1wOyAocncgPT0gUkVBRCB8fCB0ZXN0X2JpdChXcml0
ZUVycm9yU2VlbiwgJmFtcDtyZGV2LSZndDtmbGFncykpKTxicj4NCsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIHJldHVybiAtMTs8YnI+DQotwqAgwqAgwqAgwqBpZiAoc3luY19wYWdlX2lvKHJkZXYs
IHNlY3Rvciwgc2VjdG9ycyAmbHQ7Jmx0OyA5LCBwYWdlLCBydywgZmFsc2UpKTxicj4NCivCoCDC
oCDCoCDCoGlmIChzeW5jX3BhZ2VfaW8ocmRldiwgc2VjdG9yLCBzZWN0b3JzICZsdDsmbHQ7IDks
IHBhZ2UsIHJ3LCAwLCBmYWxzZSkpPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLyogc3Vj
Y2VzcyAqLzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHJldHVybiAxOzxicj4NCsKgIMKg
IMKgIMKgIGlmIChydyA9PSBXUklURSkgezxicj4NCkBAIC0yMjk5LDcgKzIzMDEsOCBAQCBzdGF0
aWMgdm9pZCBmaXhfcmVhZF9lcnJvcihzdHJ1Y3QgcjEwY29uZiAqY29uZiwgc3RydWN0IG1kZGV2
ICptZGRldiwgc3RydWN0IHIxMDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcjEwX2Jp
by0mZ3Q7ZGV2c1tzbF0uYWRkciArPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBzZWN0
LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcyZsdDsmbHQ7OSw8YnI+DQotwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgY29uZi0mZ3Q7dG1wcGFnZSwgUkVBRCwgZmFsc2UpOzxicj4NCivC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBjb25mLSZndDt0bXBwYWdlLDxicj4NCivCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCBSRVFfT1BfUkVBRCwgMCwgZmFsc2UpOzxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHJkZXZfZGVjX3BlbmRpbmcocmRldiwg
bWRkZXYpOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIHJjdV9yZWFkX2xvY2soKTs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCBpZiAoc3VjY2Vzcyk8YnI+DQpAQCAtMjQ3NCw3ICsyNDc3LDcgQEAg
c3RhdGljIGludCBuYXJyb3dfd3JpdGVfZXJyb3Ioc3RydWN0IHIxMGJpbyAqcjEwX2JpbywgaW50
IGkpPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqBjaG9vc2VfZGF0YV9vZmZzZXQocjEwX2JpbywgcmRldikgKzxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgKHNlY3RvciAtIHIxMF9i
aW8tJmd0O3NlY3RvcikpOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHdiaW8tJmd0O2Jp
X2JkZXYgPSByZGV2LSZndDtiZGV2Ozxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHdiaW8t
Jmd0O2JpX3J3ID0gV1JJVEU7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgd2Jpby0mZ3Q7
Ymlfb3AgPSBSRVFfT1BfV1JJVEU7PGJyPg0KPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
aWYgKHN1Ym1pdF9iaW9fd2FpdCh3YmlvKSAmbHQ7IDApPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgLyogRmFpbHVyZSEgKi88YnI+DQpAQCAtMjU1MCw3ICsyNTUzLDgg
QEAgcmVhZF9tb3JlOjxicj4NCsKgIMKgIMKgIMKgIGJpby0mZ3Q7YmlfaXRlci5iaV9zZWN0b3Ig
PSByMTBfYmlvLSZndDtkZXZzW3Nsb3RdLmFkZHI8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCArIGNob29zZV9kYXRhX29mZnNldChyMTBfYmlvLCByZGV2KTs8YnI+DQrCoCDCoCDCoCDCoCBi
aW8tJmd0O2JpX2JkZXYgPSByZGV2LSZndDtiZGV2Ozxicj4NCi3CoCDCoCDCoCDCoGJpby0mZ3Q7
YmlfcncgPSBSRUFEIHwgZG9fc3luYzs8YnI+DQorwqAgwqAgwqAgwqBiaW8tJmd0O2JpX29wID0g
UkVRX09QX1JFQUQ7PGJyPg0KK8KgIMKgIMKgIMKgYmlvLSZndDtiaV9ydyA9IGRvX3N5bmM7PGJy
Pg0KwqAgwqAgwqAgwqAgYmlvLSZndDtiaV9wcml2YXRlID0gcjEwX2Jpbzs8YnI+DQrCoCDCoCDC
oCDCoCBiaW8tJmd0O2JpX2VuZF9pbyA9IHJhaWQxMF9lbmRfcmVhZF9yZXF1ZXN0Ozxicj4NCsKg
IMKgIMKgIMKgIGlmIChtYXhfc2VjdG9ycyAmbHQ7IHIxMF9iaW8tJmd0O3NlY3RvcnMpIHs8YnI+
DQpAQCAtMzA0MCw3ICszMDQ0LDcgQEAgc3RhdGljIHNlY3Rvcl90IHJhaWQxMF9zeW5jX3JlcXVl
c3Qoc3RydWN0IG1kZGV2ICptZGRldiwgc2VjdG9yX3Qgc2VjdG9yX25yLDxicj4NCsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGJpb2xpc3QgPSBiaW87PGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgYmlvLSZn
dDtiaV9wcml2YXRlID0gcjEwX2Jpbzs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCBiaW8tJmd0O2JpX2VuZF9pbyA9IGVuZF9zeW5jX3JlYWQ7PGJy
Pg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgYmlvLSZn
dDtiaV9ydyA9IFJFQUQ7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgYmlvLSZndDtiaV9vcCA9IFJFUV9PUF9SRUFEOzxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGZyb21fYWRkciA9IHIxMF9iaW8t
Jmd0O2RldnNbal0uYWRkcjs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCBiaW8tJmd0O2JpX2l0ZXIuYmlfc2VjdG9yID0gZnJvbV9hZGRyICs8YnI+
DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCByZGV2LSZndDtkYXRhX29mZnNldDs8YnI+DQpAQCAtMzA2Niw3ICszMDcwLDcgQEAgc3Rh
dGljIHNlY3Rvcl90IHJhaWQxMF9zeW5jX3JlcXVlc3Qoc3RydWN0IG1kZGV2ICptZGRldiwgc2Vj
dG9yX3Qgc2VjdG9yX25yLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGJpb2xpc3QgPSBiaW87PGJyPg0KwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgYmlvLSZndDti
aV9wcml2YXRlID0gcjEwX2Jpbzs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBiaW8tJmd0O2JpX2VuZF9pbyA9IGVuZF9zeW5j
X3dyaXRlOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoGJpby0mZ3Q7YmlfcncgPSBXUklURTs8YnI+DQorwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBiaW8tJmd0O2Jp
X29wID0gUkVRX09QX1dSSVRFOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGJpby0mZ3Q7YmlfaXRlci5iaV9zZWN0b3IgPSB0
b19hZGRyPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgKyByZGV2LSZndDtkYXRhX29mZnNldDs8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCBiaW8tJmd0O2JpX2JkZXYgPSByZGV2LSZndDtiZGV2Ozxicj4NCkBAIC0zMDk1LDcgKzMwOTks
NyBAQCBzdGF0aWMgc2VjdG9yX3QgcmFpZDEwX3N5bmNfcmVxdWVzdChzdHJ1Y3QgbWRkZXYgKm1k
ZGV2LCBzZWN0b3JfdCBzZWN0b3JfbnIsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgYmlvbGlzdCA9IGJpbzs8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBiaW8tJmd0O2JpX3ByaXZhdGUgPSByMTBf
YmlvOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IGJpby0mZ3Q7YmlfZW5kX2lvID0gZW5kX3N5bmNfd3JpdGU7PGJyPg0KLcKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgYmlvLSZndDtiaV9ydyA9IFdSSVRFOzxi
cj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGJpby0m
Z3Q7Ymlfb3AgPSBSRVFfT1BfV1JJVEU7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgYmlvLSZndDtiaV9pdGVyLmJpX3NlY3RvciA9IHRvX2FkZHIg
Kzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIHJkZXYtJmd0O2RhdGFfb2Zmc2V0Ozxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGJpby0mZ3Q7YmlfYmRldiA9IHJkZXYtJmd0O2Jk
ZXY7PGJyPg0KQEAgLTMyMTUsNyArMzIxOSw3IEBAIHN0YXRpYyBzZWN0b3JfdCByYWlkMTBfc3lu
Y19yZXF1ZXN0KHN0cnVjdCBtZGRldiAqbWRkZXYsIHNlY3Rvcl90IHNlY3Rvcl9uciw8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBiaW9saXN0ID0gYmlvOzxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGJpby0mZ3Q7YmlfcHJpdmF0ZSA9IHIx
MF9iaW87PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgYmlvLSZndDti
aV9lbmRfaW8gPSBlbmRfc3luY19yZWFkOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoGJpby0mZ3Q7YmlfcncgPSBSRUFEOzxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoGJpby0mZ3Q7Ymlfb3AgPSBSRVFfT1BfUkVBRDs8YnI+DQrCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBiaW8tJmd0O2JpX2l0ZXIuYmlfc2VjdG9yID0g
c2VjdG9yICs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCBjb25mLSZndDttaXJyb3JzW2RdLnJkZXYtJmd0O2RhdGFfb2Zmc2V0Ozxicj4NCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGJpby0mZ3Q7YmlfYmRldiA9IGNvbmYtJmd0
O21pcnJvcnNbZF0ucmRldi0mZ3Q7YmRldjs8YnI+DQpAQCAtMzIzNyw3ICszMjQxLDcgQEAgc3Rh
dGljIHNlY3Rvcl90IHJhaWQxMF9zeW5jX3JlcXVlc3Qoc3RydWN0IG1kZGV2ICptZGRldiwgc2Vj
dG9yX3Qgc2VjdG9yX25yLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IGJpb2xpc3QgPSBiaW87PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
YmlvLSZndDtiaV9wcml2YXRlID0gcjEwX2Jpbzs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCBiaW8tJmd0O2JpX2VuZF9pbyA9IGVuZF9zeW5jX3dyaXRlOzxicj4NCi3C
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGJpby0mZ3Q7YmlfcncgPSBXUklURTs8
YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBiaW8tJmd0O2JpX29wID0g
UkVRX09QX1dSSVRFOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGJp
by0mZ3Q7YmlfaXRlci5iaV9zZWN0b3IgPSBzZWN0b3IgKzxicj4NCsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNvbmYtJmd0O21pcnJvcnNbZF0ucmVwbGFj
ZW1lbnQtJmd0O2RhdGFfb2Zmc2V0Ozxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIGJpby0mZ3Q7YmlfYmRldiA9IGNvbmYtJmd0O21pcnJvcnNbZF0ucmVwbGFjZW1lbnQt
Jmd0O2JkZXY7PGJyPg0KQEAgLTQzMjAsNyArNDMyNCw3IEBAIHJlYWRfbW9yZTo8YnI+DQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCsgcmRldi0mZ3Q7ZGF0
YV9vZmZzZXQpOzxicj4NCsKgIMKgIMKgIMKgIHJlYWRfYmlvLSZndDtiaV9wcml2YXRlID0gcjEw
X2Jpbzs8YnI+DQrCoCDCoCDCoCDCoCByZWFkX2Jpby0mZ3Q7YmlfZW5kX2lvID0gZW5kX3N5bmNf
cmVhZDs8YnI+DQotwqAgwqAgwqAgwqByZWFkX2Jpby0mZ3Q7YmlfcncgPSBSRUFEOzxicj4NCivC
oCDCoCDCoCDCoHJlYWRfYmlvLSZndDtiaV9vcCA9IFJFUV9PUF9SRUFEOzxicj4NCsKgIMKgIMKg
IMKgIHJlYWRfYmlvLSZndDtiaV9mbGFncyAmYW1wOz0gKH4wVUwgJmx0OyZsdDsgQklPX1JFU0VU
X0JJVFMpOzxicj4NCsKgIMKgIMKgIMKgIHJlYWRfYmlvLSZndDtiaV9lcnJvciA9IDA7PGJyPg0K
wqAgwqAgwqAgwqAgcmVhZF9iaW8tJmd0O2JpX3ZjbnQgPSAwOzxicj4NCkBAIC00MzU0LDcgKzQz
NTgsNyBAQCByZWFkX21vcmU6PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgcmRldjItJmd0O25ld19kYXRhX29mZnNldDs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCBiLSZndDtiaV9wcml2YXRlID0gcjEwX2Jpbzs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCBiLSZndDtiaV9lbmRfaW8gPSBlbmRfcmVzaGFwZV93cml0ZTs8YnI+DQotwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqBiLSZndDtiaV9ydyA9IFdSSVRFOzxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoGItJmd0O2JpX29wID0gUkVRX09QX1dSSVRFOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIGItJmd0O2JpX25leHQgPSBibGlzdDs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBi
bGlzdCA9IGI7PGJyPg0KwqAgwqAgwqAgwqAgfTxicj4NCkBAIC00NTIyLDcgKzQ1MjYsNyBAQCBz
dGF0aWMgaW50IGhhbmRsZV9yZXNoYXBlX3JlYWRfZXJyb3Ioc3RydWN0IG1kZGV2ICptZGRldiw8
YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoGFkZHIsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBzICZsdDsmbHQ7IDks
PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqBidmVjW2lkeF0uYnZfcGFnZSw8YnI+DQotwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
UkVBRCwgZmFsc2UpOzxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBSRVFfT1BfUkVBRCwgMCwgZmFsc2UpOzxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGlmIChzdWNjZXNzKTxicj4N
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGJyZWFrOzxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGZhaWxlZDo8YnI+DQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9tZC9yYWlkNS1jYWNoZS5jIGIvZHJpdmVycy9tZC9yYWlkNS1jYWNoZS5jPGJyPg0KaW5k
ZXggOTBjMjYxOC4uNTZiMjBjMyAxMDA2NDQ8YnI+DQotLS0gYS9kcml2ZXJzL21kL3JhaWQ1LWNh
Y2hlLmM8YnI+DQorKysgYi9kcml2ZXJzL21kL3JhaWQ1LWNhY2hlLmM8YnI+DQpAQCAtMjYxLDcg
KzI2MSw3IEBAIHN0YXRpYyBzdHJ1Y3QgYmlvICpyNWxfYmlvX2FsbG9jKHN0cnVjdCByNWxfbG9n
ICpsb2cpPGJyPg0KwqB7PGJyPg0KwqAgwqAgwqAgwqAgc3RydWN0IGJpbyAqYmlvID0gYmlvX2Fs
bG9jX2Jpb3NldChHRlBfTk9JTywgQklPX01BWF9QQUdFUywgbG9nLSZndDticyk7PGJyPg0KPGJy
Pg0KLcKgIMKgIMKgIMKgYmlvLSZndDtiaV9ydyA9IFdSSVRFOzxicj4NCivCoCDCoCDCoCDCoGJp
by0mZ3Q7Ymlfb3AgPSBSRVFfT1BfV1JJVEU7PGJyPg0KwqAgwqAgwqAgwqAgYmlvLSZndDtiaV9i
ZGV2ID0gbG9nLSZndDtyZGV2LSZndDtiZGV2Ozxicj4NCsKgIMKgIMKgIMKgIGJpby0mZ3Q7Ymlf
aXRlci5iaV9zZWN0b3IgPSBsb2ctJmd0O3JkZXYtJmd0O2RhdGFfb2Zmc2V0ICsgbG9nLSZndDts
b2dfc3RhcnQ7PGJyPg0KPGJyPg0KQEAgLTY4Niw2ICs2ODYsNyBAQCB2b2lkIHI1bF9mbHVzaF9z
dHJpcGVfdG9fcmFpZChzdHJ1Y3QgcjVsX2xvZyAqbG9nKTxicj4NCsKgIMKgIMKgIMKgIGJpb19y
ZXNldCgmYW1wO2xvZy0mZ3Q7Zmx1c2hfYmlvKTs8YnI+DQrCoCDCoCDCoCDCoCBsb2ctJmd0O2Zs
dXNoX2Jpby5iaV9iZGV2ID0gbG9nLSZndDtyZGV2LSZndDtiZGV2Ozxicj4NCsKgIMKgIMKgIMKg
IGxvZy0mZ3Q7Zmx1c2hfYmlvLmJpX2VuZF9pbyA9IHI1bF9sb2dfZmx1c2hfZW5kaW87PGJyPg0K
K8KgIMKgIMKgIMKgbG9nLSZndDtmbHVzaF9iaW8uYmlfb3AgPSBSRVFfT1BfV1JJVEU7PGJyPg0K
wqAgwqAgwqAgwqAgbG9nLSZndDtmbHVzaF9iaW8uYmlfcncgPSBXUklURV9GTFVTSDs8YnI+DQrC
oCDCoCDCoCDCoCBzdWJtaXRfYmlvKCZhbXA7bG9nLSZndDtmbHVzaF9iaW8pOzxicj4NCsKgfTxi
cj4NCkBAIC04ODIsNyArODgzLDggQEAgc3RhdGljIGludCByNWxfcmVhZF9tZXRhX2Jsb2NrKHN0
cnVjdCByNWxfbG9nICpsb2csPGJyPg0KwqAgwqAgwqAgwqAgc3RydWN0IHI1bF9tZXRhX2Jsb2Nr
ICptYjs8YnI+DQrCoCDCoCDCoCDCoCB1MzIgY3JjLCBzdG9yZWRfY3JjOzxicj4NCjxicj4NCi3C
oCDCoCDCoCDCoGlmICghc3luY19wYWdlX2lvKGxvZy0mZ3Q7cmRldiwgY3R4LSZndDtwb3MsIFBB
R0VfU0laRSwgcGFnZSwgUkVBRCwgZmFsc2UpKTxicj4NCivCoCDCoCDCoCDCoGlmICghc3luY19w
YWdlX2lvKGxvZy0mZ3Q7cmRldiwgY3R4LSZndDtwb3MsIFBBR0VfU0laRSwgcGFnZSwgUkVRX09Q
X1JFQUQsIDAsPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgZmFs
c2UpKTxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHJldHVybiAtRUlPOzxicj4NCjxicj4N
CsKgIMKgIMKgIMKgIG1iID0gcGFnZV9hZGRyZXNzKHBhZ2UpOzxicj4NCkBAIC05MjcsNyArOTI5
LDggQEAgc3RhdGljIGludCByNWxfcmVjb3ZlcnlfZmx1c2hfb25lX3N0cmlwZShzdHJ1Y3QgcjVs
X2xvZyAqbG9nLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgJmFtcDtkaXNrX2luZGV4LCBzaCk7PGJyPg0KPGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgc3luY19wYWdlX2lvKGxvZy0m
Z3Q7cmRldiwgKmxvZ19vZmZzZXQsIFBBR0VfU0laRSw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgc2gtJmd0O2RldltkaXNrX2luZGV4
XS5wYWdlLCBSRUFELCBmYWxzZSk7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHNoLSZndDtkZXZbZGlza19pbmRleF0ucGFnZSwgUkVR
X09QX1JFQUQsIDAsPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIGZhbHNlKTs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCBzaC0mZ3Q7ZGV2W2Rpc2tfaW5kZXhdLmxvZ19jaGVja3N1bSA9PGJyPg0KwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgbGUzMl90b19jcHUocGF5
bG9hZC0mZ3Q7Y2hlY2tzdW1bMF0pOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIHNldF9iaXQoUjVfV2FudHdyaXRlLCAmYW1wO3NoLSZndDtkZXZbZGlza19pbmRleF0u
ZmxhZ3MpOzxicj4NCkBAIC05MzUsNyArOTM4LDggQEAgc3RhdGljIGludCByNWxfcmVjb3Zlcnlf
Zmx1c2hfb25lX3N0cmlwZShzdHJ1Y3QgcjVsX2xvZyAqbG9nLDxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIH0gZWxzZSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgZGlza19pbmRleCA9IHNoLSZndDtwZF9pZHg7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgc3luY19wYWdlX2lvKGxvZy0mZ3Q7cmRldiwgKmxvZ19vZmZzZXQsIFBB
R0VfU0laRSw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgc2gtJmd0O2RldltkaXNrX2luZGV4XS5wYWdlLCBSRUFELCBmYWxzZSk7PGJy
Pg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IHNoLSZndDtkZXZbZGlza19pbmRleF0ucGFnZSwgUkVRX09QX1JFQUQsIDAsPGJyPg0KK8KgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGZhbHNlKTs8
YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBzaC0mZ3Q7ZGV2W2Rpc2tf
aW5kZXhdLmxvZ19jaGVja3N1bSA9PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgbGUzMl90b19jcHUocGF5bG9hZC0mZ3Q7Y2hlY2tzdW1bMF0pOzxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHNldF9iaXQoUjVfV2FudHdy
aXRlLCAmYW1wO3NoLSZndDtkZXZbZGlza19pbmRleF0uZmxhZ3MpOzxicj4NCkBAIC05NDUsNyAr
OTQ5LDcgQEAgc3RhdGljIGludCByNWxfcmVjb3ZlcnlfZmx1c2hfb25lX3N0cmlwZShzdHJ1Y3Qg
cjVsX2xvZyAqbG9nLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIHN5bmNfcGFnZV9pbyhsb2ctJmd0O3JkZXYsPGJyPg0KwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqByNWxf
cmluZ19hZGQobG9nLCAqbG9nX29mZnNldCwgQkxPQ0tfU0VDVE9SUyksPGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqBQQUdFX1NJWkUsIHNoLSZndDtkZXZbZGlza19pbmRleF0ucGFnZSw8YnI+DQotwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
UkVBRCwgZmFsc2UpOzxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBSRVFfT1BfUkVBRCwgMCwgZmFsc2UpOzxicj4N
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHNoLSZndDtk
ZXZbZGlza19pbmRleF0ubG9nX2NoZWNrc3VtID08YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBsZTMyX3RvX2NwdShwYXlsb2Fk
LSZndDtjaGVja3N1bVsxXSk7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgc2V0X2JpdChSNV9XYW50d3JpdGUsPGJyPg0KQEAgLTk4NywxMSArOTkx
LDEzIEBAIHN0YXRpYyBpbnQgcjVsX3JlY292ZXJ5X2ZsdXNoX29uZV9zdHJpcGUoc3RydWN0IHI1
bF9sb2cgKmxvZyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCByZGV2ID0gcmN1X2RlcmVm
ZXJlbmNlKGNvbmYtJmd0O2Rpc2tzW2Rpc2tfaW5kZXhdLnJkZXYpOzxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIGlmIChyZGV2KTxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIHN5bmNfcGFnZV9pbyhyZGV2LCBzdHJpcGVfc2VjdCwgUEFHRV9TSVpFLDxicj4NCi3C
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBzaC0m
Z3Q7ZGV2W2Rpc2tfaW5kZXhdLnBhZ2UsIFdSSVRFLCBmYWxzZSk7PGJyPg0KK8KgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHNoLSZndDtkZXZbZGlz
a19pbmRleF0ucGFnZSwgUkVRX09QX1dSSVRFLCAwLDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBmYWxzZSk7PGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgcnJkZXYgPSByY3VfZGVyZWZlcmVuY2UoY29uZi0mZ3Q7ZGlza3NbZGlz
a19pbmRleF0ucmVwbGFjZW1lbnQpOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGlmIChy
cmRldik8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBzeW5jX3BhZ2Vf
aW8ocnJkZXYsIHN0cmlwZV9zZWN0LCBQQUdFX1NJWkUsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHNoLSZndDtkZXZbZGlza19pbmRl
eF0ucGFnZSwgV1JJVEUsIGZhbHNlKTs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgc2gtJmd0O2RldltkaXNrX2luZGV4XS5wYWdlLCBS
RVFfT1BfV1JJVEUsIDAsPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIGZhbHNlKTs8YnI+DQrCoCDCoCDCoCDCoCB9PGJyPg0KwqAgwqAg
wqAgwqAgcmFpZDVfcmVsZWFzZV9zdHJpcGUoc2gpOzxicj4NCsKgIMKgIMKgIMKgIHJldHVybiAw
Ozxicj4NCkBAIC0xMDYzLDcgKzEwNjksOCBAQCBzdGF0aWMgaW50IHI1bF9sb2dfd3JpdGVfZW1w
dHlfbWV0YV9ibG9jayhzdHJ1Y3QgcjVsX2xvZyAqbG9nLCBzZWN0b3JfdCBwb3MsPGJyPg0KwqAg
wqAgwqAgwqAgY3JjID0gY3JjMzJjX2xlKGxvZy0mZ3Q7dXVpZF9jaGVja3N1bSwgbWIsIFBBR0Vf
U0laRSk7PGJyPg0KwqAgwqAgwqAgwqAgbWItJmd0O2NoZWNrc3VtID0gY3B1X3RvX2xlMzIoY3Jj
KTs8YnI+DQo8YnI+DQotwqAgwqAgwqAgwqBpZiAoIXN5bmNfcGFnZV9pbyhsb2ctJmd0O3JkZXYs
IHBvcywgUEFHRV9TSVpFLCBwYWdlLCBXUklURV9GVUEsIGZhbHNlKSkgezxicj4NCivCoCDCoCDC
oCDCoGlmICghc3luY19wYWdlX2lvKGxvZy0mZ3Q7cmRldiwgcG9zLCBQQUdFX1NJWkUsIHBhZ2Us
IFJFUV9PUF9XUklURSw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqBXUklURV9GVUEsIGZhbHNlKSkgezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIF9fZnJl
ZV9wYWdlKHBhZ2UpOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHJldHVybiAtRUlPOzxi
cj4NCsKgIMKgIMKgIMKgIH08YnI+DQpAQCAtMTEzOCw3ICsxMTQ1LDcgQEAgc3RhdGljIGludCBy
NWxfbG9hZF9sb2coc3RydWN0IHI1bF9sb2cgKmxvZyk8YnI+DQrCoCDCoCDCoCDCoCBpZiAoIXBh
Z2UpPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgcmV0dXJuIC1FTk9NRU07PGJyPg0KPGJy
Pg0KLcKgIMKgIMKgIMKgaWYgKCFzeW5jX3BhZ2VfaW8ocmRldiwgY3AsIFBBR0VfU0laRSwgcGFn
ZSwgUkVBRCwgZmFsc2UpKSB7PGJyPg0KK8KgIMKgIMKgIMKgaWYgKCFzeW5jX3BhZ2VfaW8ocmRl
diwgY3AsIFBBR0VfU0laRSwgcGFnZSwgUkVRX09QX1JFQUQsIDAsIGZhbHNlKSkgezxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIHJldCA9IC1FSU87PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgZ290byBpb2Vycjs8YnI+DQrCoCDCoCDCoCDCoCB9PGJyPg0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbWQvcmFpZDUuYyBiL2RyaXZlcnMvbWQvcmFpZDUuYzxicj4NCmluZGV4IDhhYjhiNjUu
LmMzNmI4MTcgMTAwNjQ0PGJyPg0KLS0tIGEvZHJpdmVycy9tZC9yYWlkNS5jPGJyPg0KKysrIGIv
ZHJpdmVycy9tZC9yYWlkNS5jPGJyPg0KQEAgLTgwNiw3ICs4MDYsOCBAQCBzdGF0aWMgdm9pZCBz
dHJpcGVfYWRkX3RvX2JhdGNoX2xpc3Qoc3RydWN0IHI1Y29uZiAqY29uZiwgc3RydWN0IHN0cmlw
ZV9oZWFkICpzaDxicj4NCsKgIMKgIMKgIMKgIGRkX2lkeCA9IDA7PGJyPg0KwqAgwqAgwqAgwqAg
d2hpbGUgKGRkX2lkeCA9PSBzaC0mZ3Q7cGRfaWR4IHx8IGRkX2lkeCA9PSBzaC0mZ3Q7cWRfaWR4
KTxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGRkX2lkeCsrOzxicj4NCi3CoCDCoCDCoCDC
oGlmIChoZWFkLSZndDtkZXZbZGRfaWR4XS50b3dyaXRlLSZndDtiaV9ydyAhPSBzaC0mZ3Q7ZGV2
W2RkX2lkeF0udG93cml0ZS0mZ3Q7YmlfcncpPGJyPg0KK8KgIMKgIMKgIMKgaWYgKGhlYWQtJmd0
O2RldltkZF9pZHhdLnRvd3JpdGUtJmd0O2JpX3J3ICE9IHNoLSZndDtkZXZbZGRfaWR4XS50b3dy
aXRlLSZndDtiaV9ydyB8fDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoGhlYWQtJmd0O2RldltkZF9p
ZHhdLnRvd3JpdGUtJmd0O2JpX29wICE9IHNoLSZndDtkZXZbZGRfaWR4XS50b3dyaXRlLSZndDti
aV9vcCk8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBnb3RvIHVubG9ja19vdXQ7PGJyPg0K
PGJyPg0KwqAgwqAgwqAgwqAgaWYgKGhlYWQtJmd0O2JhdGNoX2hlYWQpIHs8YnI+DQpAQCAtODkx
LDI5ICs4OTIsMzIgQEAgc3RhdGljIHZvaWQgb3BzX3J1bl9pbyhzdHJ1Y3Qgc3RyaXBlX2hlYWQg
KnNoLCBzdHJ1Y3Qgc3RyaXBlX2hlYWRfc3RhdGUgKnMpPGJyPg0KwqAgwqAgwqAgwqAgaWYgKHI1
bF93cml0ZV9zdHJpcGUoY29uZi0mZ3Q7bG9nLCBzaCkgPT0gMCk8YnI+DQrCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCByZXR1cm47PGJyPg0KwqAgwqAgwqAgwqAgZm9yIChpID0gZGlza3M7IGktLTsg
KSB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaW50IHJ3Ozxicj4NCivCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoGludCBvcDs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBpbnQgb3Bf
ZmxhZ3MgPSAwOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGludCByZXBsYWNlX29ubHkg
PSAwOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHN0cnVjdCBiaW8gKmJpLCAqcmJpOzxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHN0cnVjdCBtZF9yZGV2ICpyZGV2LCAqcnJkZXYg
PSBOVUxMOzxicj4NCjxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHNoID0gaGVhZF9zaDs8
YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAodGVzdF9hbmRfY2xlYXJfYml0KFI1X1dh
bnR3cml0ZSwgJmFtcDtzaC0mZ3Q7ZGV2W2ldLmZsYWdzKSkgezxicj4NCi3CoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoGlmICh0ZXN0X2FuZF9jbGVhcl9iaXQoUjVfV2FudEZVQSwg
JmFtcDtzaC0mZ3Q7ZGV2W2ldLmZsYWdzKSk8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBydyA9IFdSSVRFX0ZVQTs8YnI+DQotwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBlbHNlPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcncgPSBXUklURTs8YnI+DQorwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqBpZiAodGVzdF9hbmRfY2xlYXJfYml0KFI1X1dhbnRGVUEsICZh
bXA7c2gtJmd0O2RldltpXS5mbGFncykpIHs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBvcCA9IFJFUV9PUF9XUklURTs8YnI+DQorwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBvcF9mbGFncyA9IFdSSVRFX0ZV
QTs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqB9IGVsc2Ugezxicj4N
CivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG9wID0gUkVR
X09QX1dSSVRFOzxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoH08YnI+
DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAodGVzdF9iaXQoUjVfRGlz
Y2FyZCwgJmFtcDtzaC0mZ3Q7ZGV2W2ldLmZsYWdzKSk8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBydyB8PSBSRVFfRElTQ0FSRDs8YnI+DQorwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBvcCA9IFJFUV9PUF9E
SVNDQVJEOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIH0gZWxzZSBpZiAodGVzdF9hbmRf
Y2xlYXJfYml0KFI1X1dhbnRyZWFkLCAmYW1wO3NoLSZndDtkZXZbaV0uZmxhZ3MpKTxicj4NCi3C
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHJ3ID0gUkVBRDs8YnI+DQorwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBvcCA9IFJFUV9PUF9SRUFEOzxicj4NCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIGVsc2UgaWYgKHRlc3RfYW5kX2NsZWFyX2JpdChSNV9XYW50UmVw
bGFjZSw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAmYW1wO3NoLSZndDtkZXZbaV0uZmxhZ3MpKSB7PGJyPg0KLcKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcncgPSBXUklURTs8YnI+DQorwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBvcCA9IFJFUV9PUF9XUklURTs8YnI+DQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCByZXBsYWNlX29ubHkgPSAxOzxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIH0gZWxzZTxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIGNvbnRpbnVlOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGlmICh0
ZXN0X2FuZF9jbGVhcl9iaXQoUjVfU3luY0lPLCAmYW1wO3NoLSZndDtkZXZbaV0uZmxhZ3MpKTxi
cj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHJ3IHw9IFJFUV9TWU5DOzxi
cj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG9wX2ZsYWdzIHw9IFJFUV9T
WU5DOzxicj4NCjxicj4NCsKgYWdhaW46PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgYmkg
PSAmYW1wO3NoLSZndDtkZXZbaV0ucmVxOzxicj4NCkBAIC05MjcsNyArOTMxLDcgQEAgYWdhaW46
PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgcmRldiA9IHJyZGV2Ozxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHJyZGV2ID0gTlVMTDs8YnI+
DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCB9PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
aWYgKHJ3ICZhbXA7IFdSSVRFKSB7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaWYgKG9w
X2lzX3dyaXRlKG9wKSkgezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IGlmIChyZXBsYWNlX29ubHkpPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgcmRldiA9IE5VTEw7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgaWYgKHJkZXYgPT0gcnJkZXYpPGJyPg0KQEAgLTk1Myw3ICs5NTcsNyBAQCBh
Z2Fpbjo8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCogbmVlZCB0byBjaGVjayBmb3Ig
d3JpdGVzLsKgIFdlIG5ldmVyIGFjY2VwdCB3cml0ZSBlcnJvcnM8YnI+DQrCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCogb24gdGhlIHJlcGxhY2VtZW50LCBzbyB3ZSBkb24mIzM5O3QgdG8gY2hl
Y2sgcnJkZXYuPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAqLzxicj4NCi3CoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoHdoaWxlICgocncgJmFtcDsgV1JJVEUpICZhbXA7JmFtcDsgcmRldiAm
YW1wOyZhbXA7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgd2hpbGUgKG9wX2lzX3dyaXRl
KG9wKSAmYW1wOyZhbXA7IHJkZXYgJmFtcDsmYW1wOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgdGVzdF9iaXQoV3JpdGVFcnJvclNlZW4sICZhbXA7cmRldi0mZ3Q7Zmxh
Z3MpKSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgc2VjdG9yX3Qg
Zmlyc3RfYmFkOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGludCBi
YWRfc2VjdG9yczs8YnI+DQpAQCAtOTk1LDggKzk5OSw5IEBAIGFnYWluOjxicj4NCjxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGJpb19yZXNldChiaSk7PGJyPg0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgYmktJmd0O2JpX2JkZXYgPSByZGV2LSZn
dDtiZGV2Ozxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGJpLSZndDti
aV9ydyA9IHJ3Ozxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGJpLSZn
dDtiaV9lbmRfaW8gPSAocncgJmFtcDsgV1JJVEUpPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgYmktJmd0O2JpX29wID0gb3A7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgYmktJmd0O2JpX3J3ID0gb3BfZmxhZ3M7PGJyPg0KK8KgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgYmktJmd0O2JpX2VuZF9pbyA9IG9wX2lzX3dyaXRl
KG9wKTxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
ID8gcmFpZDVfZW5kX3dyaXRlX3JlcXVlc3Q8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCA6IHJhaWQ1X2VuZF9yZWFkX3JlcXVlc3Q7PGJyPg0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgYmktJmd0O2JpX3ByaXZhdGUgPSBzaDs8
YnI+DQpAQCAtMTAyNyw3ICsxMDMyLDcgQEAgYWdhaW46PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAqIElmIHRoaXMgaXMgZGlzY2FyZCByZXF1ZXN0LCBzZXQgYmlf
dmNudCAwLiBXZSBkb24mIzM5O3Q8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCogd2FudCB0byBjb25mdXNlIFNDU0kgYmVjYXVzZSBTQ1NJIHdpbGwgcmVwbGFjZSBw
YXlsb2FkPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAqLzxicj4N
Ci3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGlmIChydyAmYW1wOyBSRVFfRElT
Q0FSRCk8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBpZiAob3AgPT0g
UkVRX09QX0RJU0NBUkQpPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgYmktJmd0O2JpX3ZjbnQgPSAwOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIGlmIChycmRldik8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBzZXRfYml0KFI1X0RPVUJMRV9MT0NLRUQsICZhbXA7c2gt
Jmd0O2RldltpXS5mbGFncyk7PGJyPg0KQEAgLTEwNDcsOCArMTA1Miw5IEBAIGFnYWluOjxicj4N
Cjxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGJpb19yZXNldChyYmkp
Ozxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHJiaS0mZ3Q7YmlfYmRl
diA9IHJyZGV2LSZndDtiZGV2Ozxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoHJiaS0mZ3Q7YmlfcncgPSBydzs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqBCVUdfT04oIShydyAmYW1wOyBXUklURSkpOzxicj4NCivCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoHJiaS0mZ3Q7Ymlfb3AgPSBvcDs8YnI+DQorwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqByYmktJmd0O2JpX3J3ID0gb3BfZmxhZ3M7PGJyPg0KK8Kg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgQlVHX09OKCFvcF9pc193cml0ZShvcCkp
Ozxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHJiaS0mZ3Q7YmlfZW5k
X2lvID0gcmFpZDVfZW5kX3dyaXRlX3JlcXVlc3Q7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgcmJpLSZndDtiaV9wcml2YXRlID0gc2g7PGJyPg0KPGJyPg0KQEAgLTEw
NzYsNyArMTA4Miw3IEBAIGFnYWluOjxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgKiBJZiB0aGlzIGlzIGRpc2NhcmQgcmVxdWVzdCwgc2V0IGJpX3ZjbnQgMC4gV2Ug
ZG9uJiMzOTt0PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAqIHdh
bnQgdG8gY29uZnVzZSBTQ1NJIGJlY2F1c2UgU0NTSSB3aWxsIHJlcGxhY2UgcGF5bG9hZDxicj4N
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgKi88YnI+DQotwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBpZiAocncgJmFtcDsgUkVRX0RJU0NBUkQpPGJyPg0K
K8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaWYgKG9wID09IFJFUV9PUF9ESVND
QVJEKTxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IHJiaS0mZ3Q7YmlfdmNudCA9IDA7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgaWYgKGNvbmYtJmd0O21kZGV2LSZndDtnZW5kaXNrKTxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHRyYWNlX2Jsb2NrX2Jpb19yZW1hcChi
ZGV2X2dldF9xdWV1ZShyYmktJmd0O2JpX2JkZXYpLDxicj4NCkBAIC0xMDg1LDcgKzEwOTEsNyBA
QCBhZ2Fpbjo8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBnZW5lcmlj
X21ha2VfcmVxdWVzdChyYmkpOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIH08YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAoIXJkZXYgJmFtcDsmYW1wOyAhcnJkZXYpIHs8YnI+
DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBpZiAocncgJmFtcDsgV1JJVEUp
PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaWYgKG9wX2lzX3dyaXRl
KG9wKSk8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCBzZXRfYml0KFNUUklQRV9ERUdSQURFRCwgJmFtcDtzaC0mZ3Q7c3RhdGUpOzxicj4NCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHByX2RlYnVnKCZxdW90O3NraXAgb3AgJWxk
IG9uIGRpc2MgJWQgZm9yIHNlY3RvciAlbGx1XG4mcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgYmktJmd0O2JpX3J3LCBpLCAodW5zaWdu
ZWQgbG9uZyBsb25nKXNoLSZndDtzZWN0b3IpOzxicj4NCkBAIC0xNjIzLDcgKzE2MjksNyBAQCBh
Z2Fpbjo8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCBzZXRfYml0KFI1X1dhbnRGVUEsICZhbXA7ZGV2LSZndDtmbGFncyk7PGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgaWYgKHdi
aS0mZ3Q7YmlfcncgJmFtcDsgUkVRX1NZTkMpPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgc2V0X2JpdChSNV9TeW5jSU8sICZh
bXA7ZGV2LSZndDtmbGFncyk7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgaWYgKHdiaS0mZ3Q7YmlfcncgJmFtcDsgUkVRX0RJU0NBUkQpPGJyPg0K
K8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaWYgKHdiaS0m
Z3Q7Ymlfb3AgPT0gUkVRX09QX0RJU0NBUkQpPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgc2V0X2JpdChSNV9EaXNjYXJkLCAm
YW1wO2Rldi0mZ3Q7ZmxhZ3MpOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIGVsc2Ugezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHR4ID0gYXN5bmNfY29weV9kYXRhKDEsIHdi
aSwgJmFtcDtkZXYtJmd0O3BhZ2UsPGJyPg0KQEAgLTUxNzgsNyArNTE4NCw3IEBAIHN0YXRpYyB2
b2lkIHJhaWQ1X21ha2VfcmVxdWVzdChzdHJ1Y3QgbWRkZXYgKm1kZGV2LCBzdHJ1Y3QgYmlvICog
YmkpPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgcmV0dXJuOzxicj4N
CsKgIMKgIMKgIMKgIH08YnI+DQo8YnI+DQotwqAgwqAgwqAgwqBpZiAodW5saWtlbHkoYmktJmd0
O2JpX3J3ICZhbXA7IFJFUV9ESVNDQVJEKSkgezxicj4NCivCoCDCoCDCoCDCoGlmICh1bmxpa2Vs
eShiaS0mZ3Q7Ymlfb3AgPT0gUkVRX09QX0RJU0NBUkQpKSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgbWFrZV9kaXNjYXJkX3JlcXVlc3QobWRkZXYsIGJpKTs8YnI+DQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCByZXR1cm47PGJyPg0KwqAgwqAgwqAgwqAgfTxicj4NCjxzcGFuIGNsYXNz
PSIiPjxmb250IGNvbG9yPSIjODg4ODg4Ij4tLTxicj4NCjIuNy4yPGJyPg0KPGJyPg0KLS08YnI+
DQpkbS1kZXZlbCBtYWlsaW5nIGxpc3Q8YnI+DQo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVk
aGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQo8YSBocmVmPSJodHRwczovL3d3
dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIg
dGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9k
bS1kZXZlbDwvYT48YnI+DQo8L2ZvbnQ+PC9zcGFuPjwvYmxvY2txdW90ZT48L2Rpdj48YnI+PGJy
IGNsZWFyPSJhbGwiPjxkaXY+PGJyPjwvZGl2Pi0tIDxicj48ZGl2IGNsYXNzPSJnbWFpbF9zaWdu
YXR1cmUiPjxkaXYgZGlyPSJsdHIiPjxkaXY+PGRpdiBkaXI9Imx0ciI+PGRpdj5TaGF1biBUYW5j
aGVmZjwvZGl2PjxkaXY+PGJyPjwvZGl2PjwvZGl2PjwvZGl2PjwvZGl2PjwvZGl2Pg0KPC9kaXY+
PC9kaXY+DQo=
--94eb2c0766c65497ea05312f4703--


--===============6983356238070011113==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6983356238070011113==--
