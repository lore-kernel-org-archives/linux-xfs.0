Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E48D57CA0
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 01:20:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A86CB30404E
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 23:20:20 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id wDc2hSItEmpDyD50 (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 23:20:18 -0700 (PDT)
Subject: Re: [PATCH 08/45] block, fs, mm, drivers: use bio set/get op accessors
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
	<1465155145-10812-9-git-send-email-mchristi@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <57551620.3070801@suse.de>
Date: Mon, 6 Jun 2016 08:20:16 +0200
MIME-Version: 1.0
In-Reply-To: <1465155145-10812-9-git-send-email-mchristi@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: mchristi@redhat.com, linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

On 06/05/2016 09:31 PM, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
> =

> This patch converts the simple bi_rw use cases in the block,
> drivers, mm and fs code to set/get the bio operation using
> bio_set_op_attrs/bio_op
> =

> These should be simple one or two liner cases, so I just did them
> in one patch. The next patches handle the more complicated
> cases in a module per patch.
> =

> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
> =

> v5:
> 1. Add missed crypto call.
> 2. Change nfs bi_rw check to bi_op.
> =

>  block/bio.c                                 | 13 ++++++-------
>  block/blk-core.c                            |  6 +++---
>  block/blk-flush.c                           |  2 +-
>  block/blk-lib.c                             |  4 ++--
>  block/blk-map.c                             |  2 +-
>  block/blk-merge.c                           | 12 ++++++------
>  drivers/block/brd.c                         |  2 +-
>  drivers/block/floppy.c                      |  2 +-
>  drivers/block/pktcdvd.c                     |  4 ++--
>  drivers/block/rsxx/dma.c                    |  2 +-
>  drivers/block/zram/zram_drv.c               |  2 +-
>  drivers/lightnvm/rrpc.c                     |  6 +++---
>  drivers/scsi/osd/osd_initiator.c            |  8 ++++----
>  drivers/staging/lustre/lustre/llite/lloop.c |  6 +++---
>  fs/crypto/crypto.c                          |  2 +-
>  fs/exofs/ore.c                              |  2 +-
>  fs/ext4/page-io.c                           |  6 +++---
>  fs/ext4/readpage.c                          |  2 +-
>  fs/jfs/jfs_logmgr.c                         |  4 ++--
>  fs/jfs/jfs_metapage.c                       |  4 ++--
>  fs/logfs/dev_bdev.c                         | 12 ++++++------
>  fs/nfs/blocklayout/blocklayout.c            |  4 ++--
>  include/linux/bio.h                         | 15 ++++++++++-----
>  mm/page_io.c                                |  4 ++--
>  24 files changed, 65 insertions(+), 61 deletions(-)
> =

[ .. ]
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 09c5308..4568647 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -109,18 +109,23 @@ static inline bool bio_has_data(struct bio *bio)
>  {
>  	if (bio &&
>  	    bio->bi_iter.bi_size &&
> -	    !(bio->bi_rw & REQ_DISCARD))
> +	    bio_op(bio) !=3D REQ_OP_DISCARD)
>  		return true;
>  =

>  	return false;
>  }
>  =

> +static inline bool bio_no_advance_iter(struct bio *bio)
> +{
> +	return bio_op(bio) =3D=3D REQ_OP_DISCARD || bio_op(bio) =3D=3D REQ_OP_W=
RITE_SAME;
> +}
> +
>  static inline bool bio_is_rw(struct bio *bio)
>  {
>  	if (!bio_has_data(bio))
>  		return false;
>  =

> -	if (bio->bi_rw & BIO_NO_ADVANCE_ITER_MASK)
> +	if (bio_no_advance_iter(bio))
>  		return false;
>  =

>  	return true;
> @@ -228,7 +233,7 @@ static inline void bio_advance_iter(struct bio *bio, =
struct bvec_iter *iter,
>  {
>  	iter->bi_sector +=3D bytes >> 9;
>  =

> -	if (bio->bi_rw & BIO_NO_ADVANCE_ITER_MASK)
> +	if (bio_no_advance_iter(bio))
>  		iter->bi_size -=3D bytes;
>  	else
>  		bvec_iter_advance(bio->bi_io_vec, iter, bytes);
Hmm. Can't you drop 'BIO_NO_ADVANCE_ITER_MASK' after this patch?

> @@ -256,10 +261,10 @@ static inline unsigned bio_segments(struct bio *bio)
>  	 * differently:
>  	 */
>  =

> -	if (bio->bi_rw & REQ_DISCARD)
> +	if (bio_op(bio) =3D=3D REQ_OP_DISCARD)
>  		return 1;
>  =

> -	if (bio->bi_rw & REQ_WRITE_SAME)
> +	if (bio_op(bio) =3D=3D REQ_OP_WRITE_SAME)
>  		return 1;
>  =

>  	bio_for_each_segment(bv, bio, iter)
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 5a5fd66..dcc5d37 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -317,7 +317,7 @@ int __swap_writepage(struct page *page, struct writeb=
ack_control *wbc,
>  		ret =3D -ENOMEM;
>  		goto out;
>  	}
> -	bio->bi_rw =3D WRITE;
> +	bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
>  	if (wbc->sync_mode =3D=3D WB_SYNC_ALL)
>  		bio->bi_rw |=3D REQ_SYNC;
>  	count_vm_event(PSWPOUT);
> @@ -370,7 +370,7 @@ int swap_readpage(struct page *page)
>  		ret =3D -ENOMEM;
>  		goto out;
>  	}
> -	bio->bi_rw =3D READ;
> +	bio_set_op_attrs(bio, REQ_OP_READ, 0);
>  	count_vm_event(PSWPIN);
>  	submit_bio(bio);
>  out:
> =

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
