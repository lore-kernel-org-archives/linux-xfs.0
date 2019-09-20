Return-Path: <SRS0=+mcJ=XP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F25CDC49ED7
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 13:51:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D19F9206C2
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 13:51:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387501AbfITNvX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Sep 2019 09:51:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52178 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387500AbfITNvX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Sep 2019 09:51:23 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 328718665D;
        Fri, 20 Sep 2019 13:51:23 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CDF6819C5B;
        Fri, 20 Sep 2019 13:51:22 +0000 (UTC)
Date:   Fri, 20 Sep 2019 09:51:21 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 11/19] xfs: Factor out xfs_attr_rmtval_invalidate
Message-ID: <20190920135121.GI40150@bfoster>
References: <20190905221837.17388-1-allison.henderson@oracle.com>
 <20190905221837.17388-12-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905221837.17388-12-allison.henderson@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 20 Sep 2019 13:51:23 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 03:18:29PM -0700, Allison Collins wrote:
> Because new delayed attribute routines cannot roll
> transactions, we carve off the parts of
> xfs_attr_rmtval_remove that we can use.  This will help to
> reduce repetitive code later when we introduce delayed
> attributes.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_remote.c | 29 +++++++++++++++++++++--------
>  fs/xfs/libxfs/xfs_attr_remote.h |  1 +
>  2 files changed, 22 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 080a284..1b13795 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
...
> @@ -645,7 +638,27 @@ xfs_attr_rmtval_remove(
>  		lblkno += map.br_blockcount;
>  		blkcnt -= map.br_blockcount;
>  	}
> +	return 0;
> +}
>  
> +/*
> + * Remove the value associated with an attribute by deleting the
> + * out-of-line buffer that it is stored on.
> + */
> +int
> +xfs_attr_rmtval_remove(
> +	struct xfs_da_args      *args)
> +{
> +	xfs_dablk_t		lblkno;
> +	int			blkcnt;
> +	int			error = 0;
> +	int			done = 0;

Nit: with done initialized here, you can remove the done = 0 further
down in the function. That aside:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +
> +	trace_xfs_attr_rmtval_remove(args);
> +
> +	error = xfs_attr_rmtval_invalidate(args);
> +	if (error)
> +		return error;
>  	/*
>  	 * Keep de-allocating extents until the remote-value region is gone.
>  	 */
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index cd7670d..b6fd35a 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -11,6 +11,7 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
>  int xfs_attr_rmtval_get(struct xfs_da_args *args);
>  int xfs_attr_rmtval_set(struct xfs_da_args *args);
>  int xfs_attr_rmtval_remove(struct xfs_da_args *args);
> +int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>  int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
>  int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
>  #endif /* __XFS_ATTR_REMOTE_H__ */
> -- 
> 2.7.4
> 
