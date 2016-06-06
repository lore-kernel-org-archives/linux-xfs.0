Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BFF777CA0
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 01:51:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 824FF8F8040
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 23:51:05 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id mHmnppTtNnNC4DTW (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 23:51:03 -0700 (PDT)
Subject: Re: [PATCH 40/45] block: move bio io prio to a new field
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
	<1465155145-10812-41-git-send-email-mchristi@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <57551D55.8070200@suse.de>
Date: Mon, 6 Jun 2016 08:51:01 +0200
MIME-Version: 1.0
In-Reply-To: <1465155145-10812-41-git-send-email-mchristi@redhat.com>
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

On 06/05/2016 09:32 PM, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
> =

> In the next patch, we move drop the compat code and make
> the op a separate value that is hidden in bi_rw. To give
> the op and rq bits flags room to grow this moves prio to
> its own field.
> =

> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  include/linux/bio.h       | 14 ++------------
>  include/linux/blk_types.h |  5 ++---
>  2 files changed, 4 insertions(+), 15 deletions(-)
> =

> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 4568647..35108c2 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -47,18 +47,8 @@
>  #define bio_op(bio)				(op_from_rq_bits((bio)->bi_rw))
>  #define bio_set_op_attrs(bio, op, flags)	((bio)->bi_rw |=3D (op | flags))
>  =

> -/*
> - * upper 16 bits of bi_rw define the io priority of this bio
> - */
> -#define BIO_PRIO_SHIFT	(8 * sizeof(unsigned long) - IOPRIO_BITS)
> -#define bio_prio(bio)	((bio)->bi_rw >> BIO_PRIO_SHIFT)
> -#define bio_prio_valid(bio)	ioprio_valid(bio_prio(bio))
> -
> -#define bio_set_prio(bio, prio)		do {			\
> -	WARN_ON(prio >=3D (1 << IOPRIO_BITS));			\
> -	(bio)->bi_rw &=3D ((1UL << BIO_PRIO_SHIFT) - 1);		\
> -	(bio)->bi_rw |=3D ((unsigned long) (prio) << BIO_PRIO_SHIFT);	\
> -} while (0)
> +#define bio_prio(bio)			(bio)->bi_ioprio
> +#define bio_set_prio(bio, prio)		((bio)->bi_ioprio =3D prio)
>  =

>  /*
>   * various member access, note that bio_data should of course not be used
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 6e60baa..2738413 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -48,9 +48,8 @@ struct bio {
>  	struct block_device	*bi_bdev;
>  	unsigned int		bi_flags;	/* status, command, etc */
>  	int			bi_error;
> -	unsigned long		bi_rw;		/* bottom bits READ/WRITE,
> -						 * top bits priority
> -						 */
> +	unsigned long		bi_rw;		/* READ/WRITE */
> +	unsigned short		bi_ioprio;
>  =

>  	struct bvec_iter	bi_iter;
>  =

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
