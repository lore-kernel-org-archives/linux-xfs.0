Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34371 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728956AbfC2Pjf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Mar 2019 11:39:35 -0400
MIME-Version: 1.0
References: <20190329142346.1677-1-bob.liu@oracle.com> <20190329142346.1677-3-bob.liu@oracle.com>
In-Reply-To: <20190329142346.1677-3-bob.liu@oracle.com>
From: Ming Lei <tom.leiming@gmail.com>
Date: Fri, 29 Mar 2019 23:39:19 +0800
Message-ID: <CACVXFVO58YmCHdZiopxysjPoWzLEQpZYoogrYcXDTGc0B5f0qg@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] block: verify data when endio
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bob Liu <bob.liu@oracle.com>
Cc: linux-block <linux-block@vger.kernel.org>, "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, shirley.ma@oracle.com, allison.henderson@oracle.com, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger@dilger.ca>, Jens Axboe <axboe@kernel.dk>, Ted Tso <tytso@mit.edu>

Hi Bob,

On Fri, Mar 29, 2019 at 10:25 PM Bob Liu <bob.liu@oracle.com> wrote:
>
> Call verify callback same as bio integrity.
> If verify fail, drivers like MD will try other mirrors until get a correct
> one or return failure after all mirrors are tried.
> The MD driver already works like this, so no extra changed.
>
> Todo:
> - union with "struct bio_integrity_payload *bi_integrity" to save bio space.
>
> Signed-off-by: Bob Liu <bob.liu@oracle.com>
> ---
>  block/bio-integrity.c     | 45 +++++++++++++++++++++++++++++++++++++++
>  block/bio.c               |  3 +++
>  block/blk-core.c          |  4 ++++
>  block/blk.h               |  8 +++++++
>  block/bounce.c            |  1 +
>  drivers/md/raid1.c        |  1 +
>  drivers/md/raid5-ppl.c    |  1 +
>  include/linux/blk_types.h |  5 +++++
>  8 files changed, 68 insertions(+)
>
> diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> index 1b633a3526d4..90a47ad31dbf 100644
> --- a/block/bio-integrity.c
> +++ b/block/bio-integrity.c
> @@ -372,6 +372,51 @@ bool __bio_integrity_endio(struct bio *bio)
>         return true;
>  }
>
> +/**
> + * bio_verify_fn - Verify I/O completion worker
> + * @work:      Work struct stored in bio to be verified
> + *
> + * Description: This workqueue function is called to complete a READ
> + * request.  The function call verifier callack that fs pass down
> + * and then calls the original bio end_io function.
> + */
> +static void bio_verify_fn(struct work_struct *work)
> +{
> +       struct bio *bio =
> +               container_of(work, struct bio, bi_work);
> +
> +       bio->bi_status = bio->bi_verifier(bio);
> +       /* Clear flag if verify succeed to avoid verifing
> +        * it unnecessary by parent bio
> +        */
> +       if (!bio->bi_status)
> +               bio->bi_opf &= ~REQ_VERIFY;
> +       bio_endio(bio);
> +}

1) why is bio->bi_verifier run from workqueue context instead of being
called directly
from bio_endio()?

2) the followings part of bio_endio(bio) may be run twice, will this
way work correctly?

        if (!bio_remaining_done(bio))
                return;
        if (!bio_integrity_endio(bio))
                return;

> +
> +/**
> + * __bio_verify_endio - Verify I/O completion function
> + * @bio:       Protected bio
> + *
> + * Description: Completion for verify I/O
> + *
> + * Normally I/O completion is done in interrupt context.  However,
> + * verifying I/O is a time-consuming task which must be run
> + * in process context. This function postpones completion
> + * accordingly.
> + */
> +bool __bio_verify_endio(struct bio *bio)
> +{
> +       if (bio_op(bio) == REQ_OP_READ && !bio->bi_status &&
> +           (bio->bi_opf & REQ_VERIFY) && bio->bi_verifier) {
> +               INIT_WORK(&bio->bi_work, bio_verify_fn);
> +               queue_work(kintegrityd_wq, &bio->bi_work);
> +               return false;
> +       }
> +
> +       return true;
> +}
> +
>  /**
>   * bio_integrity_advance - Advance integrity vector
>   * @bio:       bio whose integrity vector to update
> diff --git a/block/bio.c b/block/bio.c
> index 4db1008309ed..8928806acda6 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -608,6 +608,7 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
>         bio->bi_write_hint = bio_src->bi_write_hint;
>         bio->bi_iter = bio_src->bi_iter;
>         bio->bi_io_vec = bio_src->bi_io_vec;
> +       bio->bi_verifier = bio_src->bi_verifier;

->bi_verifier is cloned along the IO stack, is this .bi_verifier
capable of covering
the cloned bio which may be just a part of original bio? such as, bio split.

Given in the 3rd patch, .bi_verifier is implemented in fs, I guess it should
only work for the bio submitted from fs because the verifier uses fs's
knowledge.

If yes, looks not necessary to clone .bi_verifier here. Otherwise, could you
explain a bit how ->bi_verifier can work for the cloned bio in the stack?


Thanks,
Ming Lei
