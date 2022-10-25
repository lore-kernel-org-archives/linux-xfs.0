Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DCE3FA373E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 19:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbiJYTJm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 15:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiJYTJl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 15:09:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78B41401D
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 12:09:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CCF261AFD
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 19:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEFF3C433C1;
        Tue, 25 Oct 2022 19:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666724978;
        bh=7zRSHOsFEtKSvKZULRuNhbV6wib6c+EfaSXpjHkUS1M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k+yLpj58W2pXoyohusXV9GbwIMEWh8iYsfFRbquIZPAWnIMuZez63gubN6xYm77zZ
         Y1cabWAW2monUN8ioATlykb4rRh+BlsbW/x+OuGKIav7tkxog09pjSxL1xvhSusIwG
         QUEZ/0paxUQPvDk4AQBMOZUky9QwBpJA470zOhxu2OOuCkXwTiK4p1i6SCfHbWnvv0
         Qyck6K12zKgmsVVZr2JQPjOhpf7/facamyb3Pub/jt5i+fuv2j1gZu5AYoiPWaA3uc
         6kLZtzgq0SHWVwohG1wkcczQw40WRcVuVhBlcx9nqhXuwoz7wcyMuxgBI7mkz5rfwK
         3bEXwYBUSsGwQ==
Date:   Tue, 25 Oct 2022 12:09:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 01/27] xfs: Add new name to attri/d
Message-ID: <Y1g0cp2c3k240r4P@magnolia>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
 <20221021222936.934426-2-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021222936.934426-2-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 21, 2022 at 03:29:10PM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> This patch adds two new fields to the atti/d.  They are nname and
> nnamelen.  This will be used for parent pointer updates since a
> rename operation may cause the parent pointer to update both the
> name and value.  So we need to carry both the new name as well as
> the target name in the attri/d.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c       |  12 +++-
>  fs/xfs/libxfs/xfs_attr.h       |   4 +-
>  fs/xfs/libxfs/xfs_da_btree.h   |   2 +
>  fs/xfs/libxfs/xfs_log_format.h |   6 +-
>  fs/xfs/xfs_attr_item.c         | 108 +++++++++++++++++++++++++++++----
>  fs/xfs/xfs_attr_item.h         |   1 +
>  6 files changed, 115 insertions(+), 18 deletions(-)

<snip all the way to the one thing I noticed>

> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index cf5ce607dc05..0c449fb606ed 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -731,10 +767,41 @@ xlog_recover_attri_commit_pass2(

Ahahaha this function.  Could you review this patch that strengthens the
length checking on the incoming recovery item buffers, please?

https://lore.kernel.org/linux-xfs/166664715731.2688790.9836328662603103847.stgit@magnolia/

>  	struct xfs_attri_log_nameval	*nv;
>  	const void			*attr_value = NULL;
>  	const void			*attr_name;
> -	int                             error;
> +	const void			*attr_nname = NULL;
> +	int				i = 0;
> +	int                             op, error = 0;
>  
> -	attri_formatp = item->ri_buf[0].i_addr;
> -	attr_name = item->ri_buf[1].i_addr;
> +	if (item->ri_total == 0) {

Do all the log intent item types need to check for a nonzero number of
recovery item buffers too?  I /think/ this is unnecessary because
xlog_recover_add_to_trans will abort recovery if ilf_size == 0, and
ri_total is assigned to ilf_size:

	if (item->ri_total == 0) {	/* first region to be added */
		if (in_f->ilf_size == 0 ||
		    in_f->ilf_size > XLOG_MAX_REGIONS_IN_ITEM) {
			xfs_warn(log->l_mp,
		"bad number of regions (%d) in inode log format",
				  in_f->ilf_size);
			ASSERT(0);
			kmem_free(ptr);
			return -EFSCORRUPTED;
		}

		item->ri_total = in_f->ilf_size;

Hm?

> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	attri_formatp = item->ri_buf[i].i_addr;
> +	i++;
> +
> +	op = attri_formatp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
> +	switch (op) {
> +	case XFS_ATTRI_OP_FLAGS_SET:
> +	case XFS_ATTRI_OP_FLAGS_REPLACE:
> +		if (item->ri_total != 3)
> +			error = -EFSCORRUPTED;
> +		break;
> +	case XFS_ATTRI_OP_FLAGS_REMOVE:
> +		if (item->ri_total != 2)
> +			error = -EFSCORRUPTED;
> +		break;
> +	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
> +		if (item->ri_total != 4)
> +			error = -EFSCORRUPTED;
> +		break;
> +	default:
> +		error = -EFSCORRUPTED;
> +	}
> +
> +	if (error) {
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);

XFS_ERROR_REPORT is a macro encodes the exact instruction pointer
location in the error report that it emits.  I know it'll make the code
more verbose, but the macros should be embedded in that switch statement
above.

> +		return error;
> +	}
>  
>  	/* Validate xfs_attri_log_format before the large memory allocation */
>  	if (!xfs_attri_validate(mp, attri_formatp)) {
> @@ -742,13 +809,27 @@ xlog_recover_attri_commit_pass2(
>  		return -EFSCORRUPTED;
>  	}
>  
> +	attr_name = item->ri_buf[i].i_addr;
> +	i++;
> +
>  	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
>  		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
>  		return -EFSCORRUPTED;
>  	}
>  
> +	if (attri_formatp->alfi_nname_len) {

This needs to check that the length of the new name iovec buffer is what
we're expecting:

	if (item->ri_buf[i].i_len !=
			xlog_calc_iovec_len(attri_formatp->alfi_nname_len)) {
		/* complain... */
	}

--D

> +		attr_nname = item->ri_buf[i].i_addr;
> +		i++;
> +
> +		if (!xfs_attr_namecheck(attr_nname,
> +				attri_formatp->alfi_nname_len)) {
> +			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
> +			return -EFSCORRUPTED;
> +		}
> +	}
> +
>  	if (attri_formatp->alfi_value_len)
> -		attr_value = item->ri_buf[2].i_addr;
> +		attr_value = item->ri_buf[i].i_addr;
>  
>  	/*
>  	 * Memory alloc failure will cause replay to abort.  We attach the
> @@ -756,7 +837,8 @@ xlog_recover_attri_commit_pass2(
>  	 * reference.
>  	 */
>  	nv = xfs_attri_log_nameval_alloc(attr_name,
> -			attri_formatp->alfi_name_len, attr_value,
> +			attri_formatp->alfi_name_len, attr_nname,
> +			attri_formatp->alfi_nname_len, attr_value,
>  			attri_formatp->alfi_value_len);
>  
>  	attrip = xfs_attri_init(mp, nv);
> diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
> index 3280a7930287..24d4968dd6cc 100644
> --- a/fs/xfs/xfs_attr_item.h
> +++ b/fs/xfs/xfs_attr_item.h
> @@ -13,6 +13,7 @@ struct kmem_zone;
>  
>  struct xfs_attri_log_nameval {
>  	struct xfs_log_iovec	name;
> +	struct xfs_log_iovec	nname;
>  	struct xfs_log_iovec	value;
>  	refcount_t		refcount;
>  
> -- 
> 2.25.1
> 
