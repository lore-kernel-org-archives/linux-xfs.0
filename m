Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CAABC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 18:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiF2SdK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 14:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiF2SdJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 14:33:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2CDE4E
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 11:33:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A97BE61FCC
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 18:33:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F034C341C8;
        Wed, 29 Jun 2022 18:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656527587;
        bh=tj4qTY/rqXShQEaJ1HSjTPENx1USAmvawWb5HsDmS4E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bV/QzgUmb9xxg/2X66zVhozesmSyWhkwJNULZXHprlmmTx0Jndbj0pmqcWzxS4Lum
         gl4kqu7edYqVtuoj2jB2sLgOClCl0khhT1YX1qQacbm4mj/Z3nxyxcYqVXu9r8JQIh
         w2onBxxmlTSCf4QMgUJEyTeaWUhU4Dk2w14Cmk4asIvqOSTVxbzO9EfUDevVjP1BbI
         RGKnOISSa7b1Dw6kAfJzb2r/fM16A95j4uTC8CKs/8dq4xUEaTyPuAyFZr7i4QpPp9
         bPSEYw8hB/V0pyU3mkak2H6HEPGh6kMn6QRb8vDz3vikWCKF1iwdwC39sQEu7uVU5g
         T721Jw5jhp9ew==
Date:   Wed, 29 Jun 2022 11:33:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 06/17] xfs: add parent pointer support to attribute
 code
Message-ID: <Yrya4nPix+tL803D@magnolia>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-7-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611094200.129502-7-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 11, 2022 at 02:41:49AM -0700, Allison Henderson wrote:
> Add the new parent attribute type. XFS_ATTR_PARENT is used only for parent pointer
> entries; it uses reserved blocks like XFS_ATTR_ROOT.
> 
> [dchinner: forward ported and cleaned up]
> [achender: rebased]
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c       | 4 +++-
>  fs/xfs/libxfs/xfs_da_format.h  | 5 ++++-
>  fs/xfs/libxfs/xfs_log_format.h | 1 +
>  3 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index a94850d9b8b1..ee5dfebcf163 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -996,11 +996,13 @@ xfs_attr_set(
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_mount	*mp = dp->i_mount;
>  	struct xfs_trans_res	tres;
> -	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
> +	bool			rsvd;
>  	int			error, local;
>  	int			rmt_blks = 0;
>  	unsigned int		total;
>  
> +	rsvd = (args->attr_filter & (XFS_ATTR_ROOT | XFS_ATTR_PARENT)) != 0;
> +
>  	if (xfs_is_shutdown(dp->i_mount))
>  		return -EIO;
>  
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index 25e2841084e1..2d771e6429f2 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -688,12 +688,15 @@ struct xfs_attr3_leafblock {
>  #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
>  #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
>  #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
> +#define 	XFS_ATTR_PARENT_BIT	3	/* parent pointer secure attrs */

          ^ whitespace

What is 'secure' about parent pointers?  Could the comment simply read:

	/* parent pointer attrs */

?

(The rest looks fine...)

--D

>  #define	XFS_ATTR_INCOMPLETE_BIT	7	/* attr in middle of create/delete */
>  #define XFS_ATTR_LOCAL		(1u << XFS_ATTR_LOCAL_BIT)
>  #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
>  #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
> +#define XFS_ATTR_PARENT		(1u << XFS_ATTR_PARENT_BIT)
>  #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
> -#define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
> +#define XFS_ATTR_NSP_ONDISK_MASK \
> +			(XFS_ATTR_ROOT | XFS_ATTR_SECURE | XFS_ATTR_PARENT)
>  
>  /*
>   * Alignment for namelist and valuelist entries (since they are mixed
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index b351b9dc6561..eea53874fde8 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -917,6 +917,7 @@ struct xfs_icreate_log {
>   */
>  #define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
>  					 XFS_ATTR_SECURE | \
> +					 XFS_ATTR_PARENT | \
>  					 XFS_ATTR_INCOMPLETE)
>  
>  /*
> -- 
> 2.25.1
> 
