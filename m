Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:53841 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750852AbeFAKwB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Jun 2018 06:52:01 -0400
MIME-Version: 1.0
In-Reply-To: <20180520222558.7053-7-kent.overstreet@gmail.com>
References: <20180520222558.7053-1-kent.overstreet@gmail.com> <20180520222558.7053-7-kent.overstreet@gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 1 Jun 2018 12:51:59 +0200
Message-ID: <CAK8P3a2mO1OaZOtB97-GtP4gDcmqgL1SMdwT7HJLdFrUutK4ZA@mail.gmail.com>
Subject: Re: [PATCH 06/12] md: convert to bioset_init()/mempool_init()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, colyli@suse.de, Mike Snitzer <snitzer@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Chris Mason <clm@fb.com>, bacik@fb.com, linux-xfs <linux-xfs@vger.kernel.org>, drbd-dev@lists.linbit.com, linux-btrfs <linux-btrfs@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>

On Mon, May 21, 2018 at 12:25 AM, Kent Overstreet
<kent.overstreet@gmail.com> wrote:

> @@ -510,7 +510,10 @@ static void mddev_delayed_delete(struct work_struct *ws);
>
>  static void mddev_put(struct mddev *mddev)
>  {
> -       struct bio_set *bs = NULL, *sync_bs = NULL;
> +       struct bio_set bs, sync_bs;
> +
> +       memset(&bs, 0, sizeof(bs));
> +       memset(&sync_bs, 0, sizeof(sync_bs));
>
>         if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
>                 return;
> @@ -521,8 +524,8 @@ static void mddev_put(struct mddev *mddev)
>                 list_del_init(&mddev->all_mddevs);
>                 bs = mddev->bio_set;
>                 sync_bs = mddev->sync_set;
> -               mddev->bio_set = NULL;
> -               mddev->sync_set = NULL;
> +               memset(&mddev->bio_set, 0, sizeof(mddev->bio_set));
> +               memset(&mddev->sync_set, 0, sizeof(mddev->sync_set));
>                 if (mddev->gendisk) {
>                         /* We did a probe so need to clean up.  Call
>                          * queue_work inside the spinlock so that
> @@ -535,10 +538,8 @@ static void mddev_put(struct mddev *mddev)
>                         kfree(mddev);
>         }
>         spin_unlock(&all_mddevs_lock);
> -       if (bs)
> -               bioset_free(bs);
> -       if (sync_bs)
> -               bioset_free(sync_bs);
> +       bioset_exit(&bs);
> +       bioset_exit(&sync_bs);
>  }

This has triggered a new warning in randconfig builds for me, on 32-bit:

drivers/md/md.c: In function 'mddev_put':
drivers/md/md.c:564:1: error: the frame size of 1096 bytes is larger
than 1024 bytes [-Werror=frame-larger-than=]

and on 64-bit:

drivers/md/md.c: In function 'mddev_put':
drivers/md/md.c:564:1: error: the frame size of 2112 bytes is larger
than 2048 bytes [-Werror=frame-larger-than=]

The size of bio_set is a bit configuration dependent, but it looks like this is
a bit too big to put on the stack either way, epsecially when you traverse
a list and copy two of them with assignments for each loop in 'bs =
mddev->bio_set'.

A related problem is that calling bioset_exit on a copy of the bio_set
might not do the right thing. The function is defined as

void bioset_exit(struct bio_set *bs)
{
        if (bs->rescue_workqueue)
                destroy_workqueue(bs->rescue_workqueue);
        bs->rescue_workqueue = NULL;

        mempool_exit(&bs->bio_pool);
        mempool_exit(&bs->bvec_pool);

        bioset_integrity_free(bs);
        if (bs->bio_slab)
                bio_put_slab(bs);
        bs->bio_slab = NULL;
}

So it calls a couple of functions (detroy_workqueue, mempool_exit,
bioset_integrity_free, bio_put_slab), each of which might rely on
a the structure being the same one that was originally allocated.
If the structure contains any kind of linked list entry, passing a copy
into the list management functions would guarantee corruption.

I could not come up with an obvious fix, but maybe it's possible
to change mddev_put() to do call bioset_exit() before the
structure gets freed? Something like the (completely untested
and probably wrong somewhere) patch below

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 411f60d591d1..3bf54591ddcd 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -531,11 +531,6 @@ static void mddev_delayed_delete(struct work_struct *ws);

 static void mddev_put(struct mddev *mddev)
 {
-       struct bio_set bs, sync_bs;
-
-       memset(&bs, 0, sizeof(bs));
-       memset(&sync_bs, 0, sizeof(sync_bs));
-
        if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
                return;
        if (!mddev->raid_disks && list_empty(&mddev->disks) &&
@@ -543,10 +538,14 @@ static void mddev_put(struct mddev *mddev)
                /* Array is not configured at all, and not held active,
                 * so destroy it */
                list_del_init(&mddev->all_mddevs);
-               bs = mddev->bio_set;
-               sync_bs = mddev->sync_set;
+               spin_unlock(&all_mddevs_lock);
+
+               bioset_exit(&mddev->bio_set);
                memset(&mddev->bio_set, 0, sizeof(mddev->bio_set));
+
+               bioset_exit(&mddev->sync_set);
                memset(&mddev->sync_set, 0, sizeof(mddev->sync_set));
+
                if (mddev->gendisk) {
                        /* We did a probe so need to clean up.  Call
                         * queue_work inside the spinlock so that
@@ -557,10 +556,9 @@ static void mddev_put(struct mddev *mddev)
                        queue_work(md_misc_wq, &mddev->del_work);
                } else
                        kfree(mddev);
+       } else {
+               spin_unlock(&all_mddevs_lock);
        }
-       spin_unlock(&all_mddevs_lock);
-       bioset_exit(&bs);
-       bioset_exit(&sync_bs);
 }

 static void md_safemode_timeout(struct timer_list *t);
