Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 084C87CA0
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 01:46:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 722C7AC007
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 23:46:51 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id z1GosjrLuX2wEAh1 (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 23:46:49 -0700 (PDT)
Subject: Re: [PATCH 28/45] target: use bio op accessors
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
	<1465155145-10812-29-git-send-email-mchristi@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <57551C57.5090507@suse.de>
Date: Mon, 6 Jun 2016 08:46:47 +0200
MIME-Version: 1.0
In-Reply-To: <1465155145-10812-29-git-send-email-mchristi@redhat.com>
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

> Separate the op from the rq_flag_bits and have the target layer
> set/get the bio using bio_set_op_attrs/bio_op.
> =

> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/target/target_core_iblock.c | 29 ++++++++++++++---------------
>  drivers/target/target_core_pscsi.c  |  2 +-
>  2 files changed, 15 insertions(+), 16 deletions(-)
> =

> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_=
core_iblock.c
> index c25109c..22af12f 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
[ .. ]
> @@ -689,18 +690,15 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatte=
rlist *sgl, u32 sgl_nents,
>  		 * Force writethrough using WRITE_FUA if a volatile write cache
>  		 * is not enabled, or if initiator set the Force Unit Access bit.
>  		 */
> +		op =3D REQ_OP_WRITE;
>  		if (test_bit(QUEUE_FLAG_FUA, &q->queue_flags)) {
>  			if (cmd->se_cmd_flags & SCF_FUA)
> -				rw =3D WRITE_FUA;
> +				op_flags =3D WRITE_FUA;
>  			else if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
> -				rw =3D WRITE_FUA;
> -			else
> -				rw =3D WRITE;
> -		} else {
> -			rw =3D WRITE;
> +				op_flags =3D WRITE_FUA;
>  		}
Wrong intendation.

>  	} else {
> -		rw =3D READ;
> +		op =3D REQ_OP_READ;
>  	}
>  =

>  	ibr =3D kzalloc(sizeof(struct iblock_req), GFP_KERNEL);
> @@ -714,7 +712,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterl=
ist *sgl, u32 sgl_nents,
>  		return 0;
>  	}
>  =

> -	bio =3D iblock_get_bio(cmd, block_lba, sgl_nents, rw);
> +	bio =3D iblock_get_bio(cmd, block_lba, sgl_nents, op, op_flags);
>  	if (!bio)
>  		goto fail_free_ibr;
>  =

> @@ -738,7 +736,8 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterl=
ist *sgl, u32 sgl_nents,
>  				bio_cnt =3D 0;
>  			}
>  =

> -			bio =3D iblock_get_bio(cmd, block_lba, sg_num, rw);
> +			bio =3D iblock_get_bio(cmd, block_lba, sg_num, op,
> +					     op_flags);
>  			if (!bio)
>  				goto fail_put_bios;
>  =

> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_c=
ore_pscsi.c
> index de18790..81564c8 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -922,7 +922,7 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *=
sgl, u32 sgl_nents,
>  					goto fail;
>  =

>  				if (rw)
> -					bio->bi_rw |=3D REQ_WRITE;
> +					bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
>  =

>  				pr_debug("PSCSI: Allocated bio: %p,"
>  					" dir: %s nr_vecs: %d\n", bio,
> =

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
