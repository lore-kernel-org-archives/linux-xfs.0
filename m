Return-Path: <SRS0=jVwY=2D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52987C7CFC6
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7952B246B3
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:39:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sjw+Tdo9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbfLMRax (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Dec 2019 12:30:53 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25106 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728445AbfLMRax (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Dec 2019 12:30:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576258251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NjJHnFCWa7FCL2EYzc8iQh2uP01n1szCdgzdQgYzmDc=;
        b=Sjw+Tdo93EPUaCc/Z9XWRi9vb8tiHhql4iEz/0qg1yNKi899HuNxxOeeVWLbeKqQZzeYBr
        o2+M3PUY/OU+YiXWrzFZSvPejTwbohoYuFf6+u1V/CSZGDS87/NJQJ82nP7OgotLO7zPQU
        wXjw61gkjL98fU0/y+yULPdqQGTvQxE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-ydbL3nENMviE3yhlccby7Q-1; Fri, 13 Dec 2019 12:30:48 -0500
X-MC-Unique: ydbL3nENMviE3yhlccby7Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A4DE107ACFA;
        Fri, 13 Dec 2019 17:30:47 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1099760C88;
        Fri, 13 Dec 2019 17:30:46 +0000 (UTC)
Date:   Fri, 13 Dec 2019 12:30:46 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 13/14] xfs: Add delay ready attr remove routines
Message-ID: <20191213173046.GG43376@bfoster>
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-14-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212041513.13855-14-allison.henderson@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 11, 2019 at 09:15:12PM -0700, Allison Collins wrote:
> This patch modifies the attr remove routines to be delay ready. This
> means they no longer roll or commit transactions, but instead return
> -EAGAIN to have the calling routine roll and refresh the transaction.
> In this series, xfs_attr_remove_args has become
> xfs_attr_remove_iter, which uses a sort of state machine like switch
> to keep track of where it was when EAGAIN was returned.
> xfs_attr_node_removename has also been modified to use the switch,
> and a  new version of xfs_attr_remove_args consists of a simple loop
> to refresh the transaction until the operation is completed.
> 
> This patch also adds a new struct xfs_delattr_context, which we will
> use to keep track of the current state of an attribute operation.
> The new xfs_delattr_state enum is used to track various operations
> that are in progress so that we know not to repeat them, and resume
> where we left off before EAGAIN was returned to cycle out the
> transaction. Other members take the place of local variables that
> need to retain their values across multiple function recalls.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c     | 127 ++++++++++++++++++++++++++++++++++++-------
>  fs/xfs/libxfs/xfs_attr.h     |   1 +
>  fs/xfs/libxfs/xfs_da_btree.h |  16 ++++++
>  fs/xfs/scrub/common.c        |   2 +
>  fs/xfs/xfs_acl.c             |   2 +
>  fs/xfs/xfs_attr_list.c       |   1 +
>  fs/xfs/xfs_ioctl.c           |   2 +
>  fs/xfs/xfs_ioctl32.c         |   2 +
>  fs/xfs/xfs_iops.c            |   2 +
>  fs/xfs/xfs_xattr.c           |   1 +
>  10 files changed, 137 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index b5a5c84..726b75e 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
...
> @@ -1206,12 +1249,29 @@ xfs_attr_node_removename(
>  	struct xfs_buf		*bp;
>  	int			retval, error, forkoff;
>  	struct xfs_inode	*dp = args->dp;
> +	int			done = 0;
>  
>  	trace_xfs_attr_node_removename(args);
> +	state = args->dac.da_state;
> +	blk = args->dac.blk;
> +
> +	/* State machine switch */
> +	switch (args->dac.dela_state) {
> +	case XFS_DAS_RM_NODE_BLKS:
> +		goto rm_node_blks;
> +	case XFS_DAS_RM_INVALIDATE:
> +		goto rm_invalidate;
> +	case XFS_DAS_RM_SHRINK:
> +		goto rm_shrink;
> +	default:
> +		break;
> +	}

I think this function could use at least a couple more prepatory
refactoring patches before we introduce the state machine...

>  
>  	error = xfs_attr_node_hasname(args, &state);
>  	if (error != -EEXIST)
>  		goto out;
> +	else
> +		error = 0;
>  
>  	/*
>  	 * If there is an out-of-line value, de-allocate the blocks.
> @@ -1221,6 +1281,14 @@ xfs_attr_node_removename(
>  	blk = &state->path.blk[ state->path.active-1 ];
>  	ASSERT(blk->bp != NULL);
>  	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> +
> +	/*
> +	 * Store blk and state in the context incase we need to cycle out the
> +	 * transaction
> +	 */
> +	args->dac.blk = blk;
> +	args->dac.da_state = state;
> +
>  	if (args->rmtblkno > 0) {
>  		/*
>  		 * Fill in disk block numbers in the state structure
> @@ -1239,13 +1307,40 @@ xfs_attr_node_removename(
>  		if (error)
>  			goto out;
>  
> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
> -		if (error)
> -			goto out;
> +		args->dac.dela_state = XFS_DAS_RM_INVALIDATE;
> +		return -EAGAIN;
> +	}

The entire (args->rmtblkno > 0) branch above could be reduced into a
helper function. BTW, does it matter whether the invalidate occurs
before or after this particular transaction roll? It looks to me it just
makes in-core changes. I'm wondering if we could just fold that in as
well and eliminate that state entirely.

> +
> +rm_invalidate:
> +	args->dac.dela_state = XFS_DAS_RM_INVALIDATE;
>  
> -		error = xfs_attr_rmtval_remove(args);
> +	if (args->rmtblkno > 0) {
> +		error = xfs_attr_rmtval_invalidate(args);
>  		if (error)
>  			goto out;
> +	}
> +
> +rm_node_blks:
> +
> +	args->dac.dela_state = XFS_DAS_RM_NODE_BLKS;
> +	if (args->rmtblkno > 0) {
> +		/*
> +		 * Unmap value blocks for this attr.  This is similar to
> +		 * xfs_attr_rmtval_remove, but open coded here to return EAGAIN
> +		 * for new transactions
> +		 */
> +		while (!done && !error) {
> +			error = xfs_bunmapi(args->trans, args->dp,
> +				    args->rmtblkno, args->rmtblkcnt,
> +				    XFS_BMAPI_ATTRFORK, 1, &done);
> +			if (error)
> +				return error;
> +
> +			if (!done) {
> +				args->dac.dela_state = XFS_DAS_RM_NODE_BLKS;
> +				return -EAGAIN;
> +			}
> +		}
>  

The above could use the helper function treatment as well. E.g.,
something like xfs_attr_rmtval_unmap() that has a *done param this
function can check to determine whether to return -EAGAIN or proceed.

>  		/*
>  		 * Refill the state structure with buffers, the prior calls
> @@ -1271,17 +1366,14 @@ xfs_attr_node_removename(
>  		error = xfs_da3_join(state);
>  		if (error)
>  			goto out;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			goto out;

Hmm.. I think we might want to lift the xfs_defer_finish() call up into
the iter() function rather than just drop it. Otherwise this changes
behavior in that the transaction roll doesn't complete pending deferred
operations.

> -		/*
> -		 * Commit the Btree join operation and start a new trans.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			goto out;
> +
> +		args->dac.dela_state = XFS_DAS_RM_SHRINK;
> +		return -EAGAIN;
>  	}
>  
> +rm_shrink:
> +	args->dac.dela_state = XFS_DAS_RM_SHRINK;
> +
>  	/*
>  	 * If the result is small enough, push it all into the inode.
>  	 */
> @@ -1302,9 +1394,6 @@ xfs_attr_node_removename(
>  			/* bp is gone due to xfs_da_shrink_inode */
>  			if (error)
>  				goto out;
> -			error = xfs_defer_finish(&args->trans);
> -			if (error)
> -				goto out;
>  		} else
>  			xfs_trans_brelse(args->trans, bp);
>  	}

Same deal here (and same fundamental comment for the next patch)..
create a xfs_attr_node_shrink() or some such helper to make functions
that handle state smaller and easier to follow once the state bits are
introduced.

Brian

> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 3b5dad4..f6ac571 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -152,6 +152,7 @@ int xfs_attr_set_args(struct xfs_da_args *args);
>  int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
>  int xfs_has_attr(struct xfs_da_args *args);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
> +int xfs_attr_remove_iter(struct xfs_da_args *args);
>  int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>  		  int flags, struct attrlist_cursor_kern *cursor);
>  bool xfs_attr_namecheck(const void *name, size_t length);
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 580fb72..137ec29 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -49,10 +49,26 @@ enum xfs_dacmp {
>  	XFS_CMP_CASE		/* names are same but differ in case */
>  };
>  
> +enum xfs_delattr_state {
> +	XFS_DAS_RM_INVALIDATE	= 1, /* We are invalidating blocks */
> +	XFS_DAS_RM_SHRINK	= 2, /* We are shrinking the tree */
> +	XFS_DAS_RM_NODE_BLKS	= 3,/* We are removing node blocks */
> +};
> +
> +/*
> + * Context used for keeping track of delayed attribute operations
> + */
> +struct xfs_delattr_context {
> +	struct xfs_da_state	*da_state;
> +	struct xfs_da_state_blk *blk;
> +	enum xfs_delattr_state	dela_state;
> +};
> +
>  /*
>   * Structure to ease passing around component names.
>   */
>  typedef struct xfs_da_args {
> +	struct xfs_delattr_context dac;/* context used for delay attr ops */
>  	struct xfs_da_geometry *geo;	/* da block geometry */
>  	struct xfs_name	name;		/* name, length and argument  flags*/
>  	uint8_t		filetype;	/* filetype of inode for directories */
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
> index 7b0e5b7..573e47e 100644
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
>  #include "xfs_error.h"
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index d37743b..881b9a4 100644
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
> index 4fc8698..a31753f 100644
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
> index c4c4f09..4b693e3 100644
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
> index e85bbf5..a2d299f 100644
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
> index 5623682..8bdb972 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -10,6 +10,7 @@
>  #include "xfs_log_format.h"
>  #include "xfs_da_format.h"
>  #include "xfs_inode.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  #include "xfs_acl.h"
>  
> -- 
> 2.7.4
> 

