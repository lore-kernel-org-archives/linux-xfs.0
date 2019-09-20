Return-Path: <SRS0=+mcJ=XP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2CFDC4CEC9
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 13:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83B25206C2
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 13:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbfITNvp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Sep 2019 09:51:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52658 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728683AbfITNvo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Sep 2019 09:51:44 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7122A85536;
        Fri, 20 Sep 2019 13:51:44 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B53119C68;
        Fri, 20 Sep 2019 13:51:44 +0000 (UTC)
Date:   Fri, 20 Sep 2019 09:51:42 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 13/19] xfs: Add delay context to xfs_da_args
Message-ID: <20190920135142.GK40150@bfoster>
References: <20190905221837.17388-1-allison.henderson@oracle.com>
 <20190905221837.17388-14-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905221837.17388-14-allison.henderson@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Fri, 20 Sep 2019 13:51:44 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 03:18:31PM -0700, Allison Collins wrote:
> This patch adds a new struct xfs_delay_context, which we
> will use to keep track of the current state of a delayed
> attribute operation.
> 
> The flags member is used to track various operations that
> are in progress so that we know not to repeat them, and
> resume where we left off before EAGAIN was returned to
> cycle out the transaction.  Other members take the place
> of local variables that need to retain their values
> across multiple function recalls.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---

Ok, I'll have to get further along in the usage of these bits to fully
grok this one. One quick note in the meantime...

>  fs/xfs/libxfs/xfs_da_btree.h | 23 +++++++++++++++++++++++
>  fs/xfs/scrub/common.c        |  2 ++
>  fs/xfs/xfs_acl.c             |  2 ++
>  fs/xfs/xfs_attr_list.c       |  1 +
>  fs/xfs/xfs_ioctl.c           |  2 ++
>  fs/xfs/xfs_ioctl32.c         |  2 ++
>  fs/xfs/xfs_iops.c            |  2 ++
>  fs/xfs/xfs_xattr.c           |  1 +
>  8 files changed, 35 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index bed4f40..ebe1295 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -42,6 +42,28 @@ enum xfs_dacmp {
>  	XFS_CMP_CASE		/* names are same but differ in case */
>  };
>  
> +#define		XFS_DC_INIT		0x01 /* Init delay info */
> +#define		XFS_DC_FOUND_LBLK	0x02 /* We found leaf blk for attr */
> +#define		XFS_DC_FOUND_NBLK	0x04 /* We found node blk for attr */
> +#define		XFS_DC_ALLOC_LEAF	0x08 /* We are allocating leaf blocks */
> +#define		XFS_DC_ALLOC_NODE	0x10 /* We are allocating node blocks */
> +#define		XFS_DC_RM_LEAF_BLKS	0x20 /* We are removing leaf blocks */
> +#define		XFS_DC_RM_NODE_BLKS	0x40 /* We are removing node blocks */
> +
> +/*
> + * Context used for keeping track of delayed attribute operations
> + */
> +struct xfs_delay_context {
> +	unsigned int		flags;
> +	struct xfs_buf		*leaf_bp;
> +	struct xfs_bmbt_irec	map;
> +	xfs_dablk_t		lblkno;
> +	xfs_fileoff_t		lfileoff;
> +	int			blkcnt;
> +	struct xfs_da_state	*state;
> +	struct xfs_da_state_blk *blk;
> +};
> +

The mixed size of the various fields leaves some holes in the structure.
See 'pahole xfs.ko' output for how this struct could be reordered to
reduce the overall size a bit..

Brian

>  /*
>   * Structure to ease passing around component names.
>   */
> @@ -69,6 +91,7 @@ typedef struct xfs_da_args {
>  	int		rmtvaluelen2;	/* remote attr value length in bytes */
>  	int		op_flags;	/* operation flags */
>  	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
> +	struct xfs_delay_context  dc;	/* context used for delay attr ops */
>  } xfs_da_args_t;
>  
>  /*
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 1887605..9a649d1 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -24,6 +24,8 @@
>  #include "xfs_rmap_btree.h"
>  #include "xfs_log.h"
>  #include "xfs_trans_priv.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  #include "xfs_reflink.h"
>  #include "scrub/scrub.h"
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index f8fb6e10..4e85b38 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -10,6 +10,8 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  #include "xfs_trace.h"
>  #include <linux/posix_acl_xattr.h>
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 00758fd..467c53c 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -12,6 +12,7 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
>  #include "xfs_bmap.h"
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 626420d..2cabdc2 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -15,6 +15,8 @@
>  #include "xfs_iwalk.h"
>  #include "xfs_itable.h"
>  #include "xfs_error.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  #include "xfs_bmap.h"
>  #include "xfs_bmap_util.h"
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 1e08bf7..7153780 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -17,6 +17,8 @@
>  #include "xfs_itable.h"
>  #include "xfs_fsops.h"
>  #include "xfs_rtalloc.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  #include "xfs_ioctl.h"
>  #include "xfs_ioctl32.h"
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 469e8e2..57de5f1 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -13,6 +13,8 @@
>  #include "xfs_inode.h"
>  #include "xfs_acl.h"
>  #include "xfs_quota.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  #include "xfs_trans.h"
>  #include "xfs_trace.h"
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 6309da4..470e605 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -10,6 +10,7 @@
>  #include "xfs_log_format.h"
>  #include "xfs_da_format.h"
>  #include "xfs_inode.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  
>  #include <linux/posix_acl_xattr.h>
> -- 
> 2.7.4
> 
