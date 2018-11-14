Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39779 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbeKNMyg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Nov 2018 07:54:36 -0500
MIME-Version: 1.0
References: <20181113214337.20581-1-david@fromorbit.com>
In-Reply-To: <20181113214337.20581-1-david@fromorbit.com>
From: Ming Lei <tom.leiming@gmail.com>
Date: Wed, 14 Nov 2018 10:53:11 +0800
Message-ID: <CACVXFVPS8RRYw4g-UjaDFW1Mrx_tv5V6SsSyKeQ9pyBLi2zrFA@mail.gmail.com>
Subject: Re: [PATCH] block: fix 32 bit overflow in __blkdev_issue_discard()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>

On Wed, Nov 14, 2018 at 5:44 AM Dave Chinner <david@fromorbit.com> wrote:
>
> From: Dave Chinner <dchinner@redhat.com>
>
> A discard cleanup merged into 4.20-rc2 causes fstests xfs/259 to
> fall into an endless loop in the discard code. The test is creating
> a device that is exactly 2^32 sectors in size to test mkfs boundary
> conditions around the 32 bit sector overflow region.
>
> mkfs issues a discard for the entire device size by default, and
> hence this throws a sector count of 2^32 into
> blkdev_issue_discard(). It takes the number of sectors to discard as
> a sector_t - a 64 bit value.
>
> The commit ba5d73851e71 ("block: cleanup __blkdev_issue_discard")
> takes this sector count and casts it to a 32 bit value before
> comapring it against the maximum allowed discard size the device
> has. This truncates away the upper 32 bits, and so if the lower 32
> bits of the sector count is zero, it starts issuing discards of
> length 0. This causes the code to fall into an endless loop, issuing
> a zero length discards over and over again on the same sector.
>
> Fixes: ba5d73851e71 ("block: cleanup __blkdev_issue_discard")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  block/blk-lib.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index e8b3bb9bf375..144e156ed341 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -55,9 +55,12 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>                 return -EINVAL;
>
>         while (nr_sects) {
> -               unsigned int req_sects = min_t(unsigned int, nr_sects,
> +               sector_t req_sects = min_t(sector_t, nr_sects,
>                                 bio_allowed_max_sectors(q));

bio_allowed_max_sectors(q) is always < UINT_MAX, and 'sector_t' is only
required during the comparison, so another simpler fix might be the following,
could you test if it is workable?

diff --git a/block/blk-lib.c b/block/blk-lib.c
index e8b3bb9bf375..6ef44f99e83f 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -55,7 +55,7 @@ int __blkdev_issue_discard(struct block_device
*bdev, sector_t sector,
                return -EINVAL;

        while (nr_sects) {
-               unsigned int req_sects = min_t(unsigned int, nr_sects,
+               unsigned int req_sects = min_t(sector_t, nr_sects,
                                bio_allowed_max_sectors(q));
>
> +               WARN_ON_ONCE(req_sects == 0);

The above line isn't necessary given 'nr_sects' can't be zero.


Thanks,
Ming Lei
