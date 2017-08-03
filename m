Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47388 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751244AbdHCQCS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Aug 2017 12:02:18 -0400
Subject: Re: [PATCH 6/7] xfs_db: write values into dir/attr blocks and
 recalculate CRCs
References: <150153520589.26081.8786864874176090813.stgit@magnolia>
 <150153524586.26081.6633141009302900940.stgit@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <b024574b-7cb4-c0d7-3c8c-d586b1d46c47@redhat.com>
Date: Thu, 3 Aug 2017 11:02:15 -0500
MIME-Version: 1.0
In-Reply-To: <150153524586.26081.6633141009302900940.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 7/31/17 4:07 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Extend typ_t to (optionally) store a pointer to a function to calculate
> the CRC of the block, provide functions to do this for the dir3 and
> attr3 types, and then wire up the write command so that we can modify
> directory and extended attribute block fields.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/attr.c  |   32 ++++++++++++++++++++++++++++++++
>  db/attr.h  |    1 +
>  db/dir2.c  |   37 +++++++++++++++++++++++++++++++++++++
>  db/dir2.h  |    1 +
>  db/type.c  |    8 ++++----
>  db/type.h  |    2 ++
>  db/write.c |    3 +++
>  7 files changed, 80 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/db/attr.c b/db/attr.c
> index 98fb069..2fa6690 100644
> --- a/db/attr.c
> +++ b/db/attr.c
> @@ -602,6 +602,38 @@ const struct field	attr3_remote_crc_flds[] = {
>  	{ NULL }
>  };
>  
> +/* Set the CRC. */
> +void
> +xfs_attr3_set_crc(
> +	struct xfs_buf		*bp)
> +{
> +	__be32			magic32;
> +	__be16			magic16;
> +
> +	magic32 = *(__be32 *)bp->b_addr;
> +	magic16 = ((struct xfs_da_blkinfo *)bp->b_addr)->magic;
> +
> +	switch (magic16) {
> +	case cpu_to_be16(XFS_ATTR3_LEAF_MAGIC):

Isn't it more typical to endian-swap magic16 and not have the
swap in each case statement?  *shrug*

> +		xfs_buf_update_cksum(bp, XFS_ATTR3_LEAF_CRC_OFF);
> +		return;
> +	case cpu_to_be16(XFS_DA3_NODE_MAGIC):
> +		xfs_buf_update_cksum(bp, XFS_DA3_NODE_CRC_OFF);
> +		return;
> +	default:
> +		break;
> +	}

...

>  
> diff --git a/db/write.c b/db/write.c
> index d24ea05..266bde4 100644
> --- a/db/write.c
> +++ b/db/write.c
> @@ -173,6 +173,9 @@ write_f(
>  	} else if (iocur_top->dquot_buf) {
>  		local_ops.verify_write = xfs_verify_recalc_dquot_crc;
>  		dbprintf(_("Allowing write of corrupted dquot with good CRC\n"));
> +	} else if (iocur_top->typ->crc_off == TYP_F_CRC_FUNC) {
> +		local_ops.verify_write = iocur_top->typ->set_crc;
> +		dbprintf(_("Allowing write of corrupted data with good CRC\n"));
>  	} else { /* invalid data */
>  		local_ops.verify_write = xfs_verify_recalc_crc;
>  		dbprintf(_("Allowing write of corrupted data with good CRC\n"));

looking at this else if else if else if gunk makes me think that this has
grown a bit out of control.

We have other special types that require unique crc setting functions - dquots
and inodes.  In those cases, we have TYP_F_NO_CRC_OFF but a special indicator
that they are of this type (ino_buf, dquot_buf), with a hard-coded recalculation
routine (xfs_verify_recalc_dquot_crc, xfs_verify_recalc_inode_crc).  Now for /other/
types you've extended typ_t and put the function in there as an op, which makes
sense.

It seems to me that it would be logical to move the existing crc recalculation
routines for dquots & inodes into this new op as well, and locate & name everything
consistently, no?

Thanks,
-Eric


