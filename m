Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F8AC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Feb 2022 20:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236674AbiBAUFo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 15:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbiBAUFm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 15:05:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109FFC061714
        for <linux-xfs@vger.kernel.org>; Tue,  1 Feb 2022 12:05:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C102FB82DE5
        for <linux-xfs@vger.kernel.org>; Tue,  1 Feb 2022 20:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A65C340EB;
        Tue,  1 Feb 2022 20:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643745939;
        bh=dGzwa34ns3qIE6PTiVr7aGEaHJqKfQ8+rpyhuxoLDrE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XQYhFxcoiZ546L80joWfPMW0pf+t5nvLs1HNk4Oaz1i9Z8e30PtnN5mHcCjG/BfyW
         coV/8Fxa4AmQ+SHKhL921WWA5oZS5ct+cuOCRk3Vj/J7uKhmr+VxHaKVrOQI4ZPJBd
         TVU5kTvI9DODli7gHs4PHu4vAy51pwKjZabKcGgEM+u8fJotL1dsVzMs3v694+9acc
         ySzqOFOWk9NgCtvkoGnytxREDJcx7nng26vxuYebWnvnI1xm1H+OygFVJDcJnOfTfZ
         cBVZrMAlhOMzA8WIg91aqRv/oKZpCBVfiXla3IisCu2K9bTo6DF7Zs317EdJ63tOgU
         aNHfOcCRve2OQ==
Date:   Tue, 1 Feb 2022 12:05:39 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v3 2/2] xfs: add leaf to node error tag
Message-ID: <20220201200539.GO8313@magnolia>
References: <20220201171430.22586-1-catherine.hoang@oracle.com>
 <20220201171430.22586-3-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201171430.22586-3-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 01, 2022 at 05:14:30PM +0000, Catherine Hoang wrote:
> Add an error tag on xfs_attr3_leaf_to_node to test log attribute
> recovery and replay.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 6 ++++++
>  fs/xfs/libxfs/xfs_errortag.h  | 4 +++-
>  fs/xfs/xfs_error.c            | 3 +++
>  3 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 74b76b09509f..0fe028d95c77 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -28,6 +28,7 @@
>  #include "xfs_dir2.h"
>  #include "xfs_log.h"
>  #include "xfs_ag.h"
> +#include "xfs_errortag.h"
>  
>  
>  /*
> @@ -1189,6 +1190,11 @@ xfs_attr3_leaf_to_node(
>  
>  	trace_xfs_attr_leaf_to_node(args);
>  
> +	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_LARP_LEAF_TO_NODE)) {

Sorry for the long trickle of random post-review comments, but ...

This error injection knob isn't specifically tied to LARP mode, right?

i.e. one can trigger it on /any/ expansion of an xattr data structure
from leaf to node format, right?  Even if LARP isn't enabled?

Can this be renamed to XFS_ERRTAG_ATTR_LEAF_TO_NODE, please?
You can keep the RVB tag. :)

--D

> +		error = -EIO;
> +		goto out;
> +	}
> +
>  	error = xfs_da_grow_inode(args, &blkno);
>  	if (error)
>  		goto out;
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 6d06a502bbdf..74b753194615 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -61,7 +61,8 @@
>  #define XFS_ERRTAG_AG_RESV_FAIL				38
>  #define XFS_ERRTAG_LARP					39
>  #define XFS_ERRTAG_DA_LEAF_SPLIT			40
> -#define XFS_ERRTAG_MAX					41
> +#define XFS_ERRTAG_LARP_LEAF_TO_NODE			41
> +#define XFS_ERRTAG_MAX					42
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -107,5 +108,6 @@
>  #define XFS_RANDOM_AG_RESV_FAIL				1
>  #define XFS_RANDOM_LARP					1
>  #define XFS_RANDOM_DA_LEAF_SPLIT			1
> +#define XFS_RANDOM_LARP_LEAF_TO_NODE			1
>  
>  #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 2aa5d4d2b30a..94ae630dc819 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -59,6 +59,7 @@ static unsigned int xfs_errortag_random_default[] = {
>  	XFS_RANDOM_AG_RESV_FAIL,
>  	XFS_RANDOM_LARP,
>  	XFS_RANDOM_DA_LEAF_SPLIT,
> +	XFS_RANDOM_LARP_LEAF_TO_NODE,
>  };
>  
>  struct xfs_errortag_attr {
> @@ -174,6 +175,7 @@ XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTE
>  XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
>  XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
>  XFS_ERRORTAG_ATTR_RW(da_leaf_split,	XFS_ERRTAG_DA_LEAF_SPLIT);
> +XFS_ERRORTAG_ATTR_RW(larp_leaf_to_node,	XFS_ERRTAG_LARP_LEAF_TO_NODE);
>  
>  static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -217,6 +219,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
>  	XFS_ERRORTAG_ATTR_LIST(larp),
>  	XFS_ERRORTAG_ATTR_LIST(da_leaf_split),
> +	XFS_ERRORTAG_ATTR_LIST(larp_leaf_to_node),
>  	NULL,
>  };
>  ATTRIBUTE_GROUPS(xfs_errortag);
> -- 
> 2.25.1
> 
