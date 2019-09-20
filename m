Return-Path: <SRS0=+mcJ=XP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B63EDC49ED7
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 13:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92B1E206C2
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 13:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387420AbfITNtg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Sep 2019 09:49:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49428 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387404AbfITNtg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Sep 2019 09:49:36 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BE093308212D;
        Fri, 20 Sep 2019 13:49:35 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6267F1001281;
        Fri, 20 Sep 2019 13:49:35 +0000 (UTC)
Date:   Fri, 20 Sep 2019 09:49:33 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 05/19] xfs: Factor out new helper functions
 xfs_attr_rmtval_set
Message-ID: <20190920134933.GC40150@bfoster>
References: <20190905221837.17388-1-allison.henderson@oracle.com>
 <20190905221837.17388-6-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905221837.17388-6-allison.henderson@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 20 Sep 2019 13:49:35 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 03:18:23PM -0700, Allison Collins wrote:
> Break xfs_attr_rmtval_set into two helper functions
> xfs_attr_rmt_find_hole and xfs_attr_rmtval_set_value.
> xfs_attr_rmtval_set rolls the transaction between the
> helpers, but delayed operations cannot.  We will use
> the helpers later when constructing new delayed
> attribute routines.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_remote.c | 72 +++++++++++++++++++++++++++++++----------
>  fs/xfs/libxfs/xfs_attr_remote.h |  3 +-
>  2 files changed, 57 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index db9247a..080a284 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
...
> @@ -500,6 +487,57 @@ xfs_attr_rmtval_set(
>  			return error;
>  	}
>  
> +	error = xfs_attr_rmtval_set_value(args);
> +	return error;

	return xfs_attr_rmtval_set_value(args);

> +}
> +
> +
> +/*
> + * Find a "hole" in the attribute address space large enough for us to drop the
> + * new attribute's value into
> + */
> +int
> +xfs_attr_rmt_find_hole(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_inode        *dp = args->dp;
> +	struct xfs_mount	*mp = dp->i_mount;
> +	int			error;
> +	int			blkcnt;
> +	xfs_fileoff_t		lfileoff = args->rmtblkno;

The init of lfileoff looks a little strange here. It was originally
initialized to zero, passed into the call below and then assigned to
->rmtblkno. Is this change intentional?

With those nits fixed:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +
> +	/*
> +	 * Because CRC enable attributes have headers, we can't just do a
> +	 * straight byte to FSB conversion and have to take the header space
> +	 * into account.
> +	 */
> +	blkcnt = xfs_attr3_rmt_blocks(mp, args->rmtvaluelen);
> +	error = xfs_bmap_first_unused(args->trans, args->dp, blkcnt, &lfileoff,
> +						   XFS_ATTR_FORK);
> +	if (error)
> +		return error;
> +
> +	args->rmtblkno = (xfs_dablk_t)lfileoff;
> +	args->rmtblkcnt = blkcnt;
> +
> +	return 0;
> +}
> +
> +int
> +xfs_attr_rmtval_set_value(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_inode	*dp = args->dp;
> +	struct xfs_mount	*mp = dp->i_mount;
> +	struct xfs_bmbt_irec	map;
> +	xfs_dablk_t		lblkno;
> +	uint8_t			*src = args->value;
> +	int			blkcnt;
> +	int			valuelen;
> +	int			nmap;
> +	int			error;
> +	int			offset = 0;
> +
>  	/*
>  	 * Roll through the "value", copying the attribute value to the
>  	 * already-allocated blocks.  Blocks are written synchronously
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index 9d20b66..cd7670d 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -11,5 +11,6 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
>  int xfs_attr_rmtval_get(struct xfs_da_args *args);
>  int xfs_attr_rmtval_set(struct xfs_da_args *args);
>  int xfs_attr_rmtval_remove(struct xfs_da_args *args);
> -
> +int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
> +int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
>  #endif /* __XFS_ATTR_REMOTE_H__ */
> -- 
> 2.7.4
> 
