Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6531CC4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 03:27:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C169610A0
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 03:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbhHBD1d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Aug 2021 23:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbhHBD1c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Aug 2021 23:27:32 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF91C06175F
        for <linux-xfs@vger.kernel.org>; Sun,  1 Aug 2021 20:27:23 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id nh14so11647309pjb.2
        for <linux-xfs@vger.kernel.org>; Sun, 01 Aug 2021 20:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=99jLd1Prfa6EmY07kRlfnt0raS4EPBZdr51zCuhNeqE=;
        b=KpG3Z2eqhpwtdR3fGTNQpI8p9vHDcRlGTDrd3eGHZnJpVMqq6sL9K/U3P01CtnZOU2
         TJ4gD68dK3S+EE1Wn6no83nCZYzeQdLxiZ4+K55L9qzgP+lR8v8RnqtRqRjuEwGYyOZq
         gu12Hm/zx8Vst+mvzQgJwbpwbMszMbIBueZGqoz84HWto/zCWXUrMnHM8uWoWRENMInY
         j6j9Z7+4n3FhgE1JvTYOTcGqfAYD19aZoxiGXmYwXnuzh6BfP/O7XyOsFSe9qd0Agqsk
         vC0hrk2zvBjymo9WXShupkUGaEm+DgSYuSdfW7tlNYUlNNJlQX3FBI3trDAr4mlv6qWy
         RH1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=99jLd1Prfa6EmY07kRlfnt0raS4EPBZdr51zCuhNeqE=;
        b=nwV5dNLKzd3/11xjTkRyGleszq1JC5xMfpbGaS3bMNkYCtV/K9bgWzSJXjzcI7vWl+
         e5t26up9btkUvr3UpMwUrWQpmucBNr5DlKlv0AazIHRkBZluCTaCMrr4ud1KjquKW3Lr
         YLBgZXWYig6RIcfusWuHANUqLDUkOnxYrI6enKm4EYkRsFwAq09509itYKudaukbShND
         MH0rC47AJCwZUHcIVAGUUNIbGuA637dxhceS4/wKnWlHePkgYyqIwz6fntrMjF40CXQb
         6FoI82n+KhC0uP+Es55qQVcsnWSNloTqQApRLJe1tqUJOPLUTaCYld+liwyZCYXBPNRc
         CDoA==
X-Gm-Message-State: AOAM533fgJ6jy2XvHC+4gSNYUJYaBcAf8oQwjS6ojqTJX6l56hXjDpKE
        aTpcEUeeC4lHryqU7Ec239OLtDfRtcKOTA==
X-Google-Smtp-Source: ABdhPJwwTzCvRMTxXKUslObxPRMdEyJrMQaI041h3nsGTPA6LUatsSwYtgZL8Cizi9A0KqpIzby/0Q==
X-Received: by 2002:a17:90a:c085:: with SMTP id o5mr5676322pjs.9.1627874842531;
        Sun, 01 Aug 2021 20:27:22 -0700 (PDT)
Received: from garuda ([122.172.177.63])
        by smtp.gmail.com with ESMTPSA id b17sm9505411pfm.54.2021.08.01.20.27.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 01 Aug 2021 20:27:22 -0700 (PDT)
References: <20210727062053.11129-1-allison.henderson@oracle.com> <20210727062053.11129-16-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v22 15/16] xfs: Merge xfs_delattr_context into xfs_attr_item
In-reply-to: <20210727062053.11129-16-allison.henderson@oracle.com>
Date:   Mon, 02 Aug 2021 08:57:19 +0530
Message-ID: <87zgu0msq0.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 27 Jul 2021 at 11:50, Allison Henderson wrote:
> This is a clean up patch that merges xfs_delattr_context into
> xfs_attr_item.  Now that the refactoring is complete and the delayed
> operation infrastructure is in place, we can combine these to eliminate
> the extra struct
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>


> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c        | 142 ++++++++++++++++++++--------------------
>  fs/xfs/libxfs/xfs_attr.h        |  40 +++++------
>  fs/xfs/libxfs/xfs_attr_remote.c |  36 +++++-----
>  fs/xfs/libxfs/xfs_attr_remote.h |   6 +-
>  fs/xfs/xfs_attr_item.c          |  43 ++++++------
>  5 files changed, 130 insertions(+), 137 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index ec03a7b..811288d 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -56,10 +56,9 @@ STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
>   */
>  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>  STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
> -STATIC int xfs_attr_node_addname(struct xfs_delattr_context *dac);
> -STATIC int xfs_attr_node_addname_find_attr(struct xfs_delattr_context *dac);
> -STATIC int xfs_attr_node_addname_clear_incomplete(
> -				struct xfs_delattr_context *dac);
> +STATIC int xfs_attr_node_addname(struct xfs_attr_item *attr);
> +STATIC int xfs_attr_node_addname_find_attr(struct xfs_attr_item *attr);
> +STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_attr_item *attr);
>  STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>  				 struct xfs_da_state **state);
>  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
> @@ -246,11 +245,11 @@ xfs_attr_is_shortform(
>  
>  STATIC int
>  xfs_attr_sf_addname(
> -	struct xfs_delattr_context	*dac)
> +	struct xfs_attr_item		*attr)
>  {
> -	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_da_args		*args = attr->xattri_da_args;
>  	struct xfs_inode		*dp = args->dp;
> -	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
> +	struct xfs_buf			**leaf_bp = &attr->xattri_leaf_bp;
>  	int				error = 0;
>  
>  	/*
> @@ -295,17 +294,17 @@ xfs_attr_sf_addname(
>   */
>  int
>  xfs_attr_set_iter(
> -	struct xfs_delattr_context	*dac)
> +	struct xfs_attr_item		*attr)
>  {
> -	struct xfs_da_args              *args = dac->da_args;
> -	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
> +	struct xfs_da_args              *args = attr->xattri_da_args;
> +	struct xfs_buf			**leaf_bp = &attr->xattri_leaf_bp;
>  	struct xfs_inode		*dp = args->dp;
>  	struct xfs_buf			*bp = NULL;
>  	int				forkoff, error = 0;
>  	struct xfs_mount		*mp = args->dp->i_mount;
>  
>  	/* State machine switch */
> -	switch (dac->dela_state) {
> +	switch (attr->xattri_dela_state) {
>  	case XFS_DAS_UNINIT:
>  		/*
>  		 * If the fork is shortform, attempt to add the attr. If there
> @@ -315,7 +314,7 @@ xfs_attr_set_iter(
>  		 * release the hold once we return with a clean transaction.
>  		 */
>  		if (xfs_attr_is_shortform(dp))
> -			return xfs_attr_sf_addname(dac);
> +			return xfs_attr_sf_addname(attr);
>  		if (*leaf_bp != NULL) {
>  			xfs_trans_bhold_release(args->trans, *leaf_bp);
>  			*leaf_bp = NULL;
> @@ -342,19 +341,19 @@ xfs_attr_set_iter(
>  				 * handling code below
>  				 */
>  				trace_xfs_attr_set_iter_return(
> -					dac->dela_state, args->dp);
> +					attr->xattri_dela_state, args->dp);
>  				return -EAGAIN;
>  			} else if (error) {
>  				return error;
>  			}
>  
> -			dac->dela_state = XFS_DAS_FOUND_LBLK;
> +			attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
>  		} else {
> -			error = xfs_attr_node_addname_find_attr(dac);
> +			error = xfs_attr_node_addname_find_attr(attr);
>  			if (error)
>  				return error;
>  
> -			error = xfs_attr_node_addname(dac);
> +			error = xfs_attr_node_addname(attr);
>  			if (error)
>  				return error;
>  
> @@ -365,9 +364,10 @@ xfs_attr_set_iter(
>  			if (!args->rmtblkno && !args->rmtblkno2)
>  				return 0;
>  
> -			dac->dela_state = XFS_DAS_FOUND_NBLK;
> +			attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
>  		}
> -		trace_xfs_attr_set_iter_return(dac->dela_state,	args->dp);
> +		trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
> +					       args->dp);
>  		return -EAGAIN;
>  	case XFS_DAS_FOUND_LBLK:
>  		/*
> @@ -378,10 +378,10 @@ xfs_attr_set_iter(
>  		 */
>  
>  		/* Open coded xfs_attr_rmtval_set without trans handling */
> -		if ((dac->flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
> -			dac->flags |= XFS_DAC_LEAF_ADDNAME_INIT;
> +		if ((attr->xattri_flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
> +			attr->xattri_flags |= XFS_DAC_LEAF_ADDNAME_INIT;
>  			if (args->rmtblkno > 0) {
> -				error = xfs_attr_rmtval_find_space(dac);
> +				error = xfs_attr_rmtval_find_space(attr);
>  				if (error)
>  					return error;
>  			}
> @@ -391,11 +391,11 @@ xfs_attr_set_iter(
>  		 * Repeat allocating remote blocks for the attr value until
>  		 * blkcnt drops to zero.
>  		 */
> -		if (dac->blkcnt > 0) {
> -			error = xfs_attr_rmtval_set_blk(dac);
> +		if (attr->xattri_blkcnt > 0) {
> +			error = xfs_attr_rmtval_set_blk(attr);
>  			if (error)
>  				return error;
> -			trace_xfs_attr_set_iter_return(dac->dela_state,
> +			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
>  						       args->dp);
>  			return -EAGAIN;
>  		}
> @@ -431,8 +431,8 @@ xfs_attr_set_iter(
>  			 * Commit the flag value change and start the next trans
>  			 * in series.
>  			 */
> -			dac->dela_state = XFS_DAS_FLIP_LFLAG;
> -			trace_xfs_attr_set_iter_return(dac->dela_state,
> +			attr->xattri_dela_state = XFS_DAS_FLIP_LFLAG;
> +			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
>  						       args->dp);
>  			return -EAGAIN;
>  		}
> @@ -451,16 +451,16 @@ xfs_attr_set_iter(
>  		/* fallthrough */
>  	case XFS_DAS_RM_LBLK:
>  		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
> -		dac->dela_state = XFS_DAS_RM_LBLK;
> +		attr->xattri_dela_state = XFS_DAS_RM_LBLK;
>  		if (args->rmtblkno) {
> -			error = xfs_attr_rmtval_remove(dac);
> +			error = xfs_attr_rmtval_remove(attr);
>  			if (error == -EAGAIN)
>  				trace_xfs_attr_set_iter_return(
> -					dac->dela_state, args->dp);
> +					attr->xattri_dela_state, args->dp);
>  			if (error)
>  				return error;
>  
> -			dac->dela_state = XFS_DAS_RD_LEAF;
> +			attr->xattri_dela_state = XFS_DAS_RD_LEAF;
>  			return -EAGAIN;
>  		}
>  
> @@ -491,7 +491,7 @@ xfs_attr_set_iter(
>  		 * state.
>  		 */
>  		if (args->rmtblkno > 0) {
> -			error = xfs_attr_rmtval_find_space(dac);
> +			error = xfs_attr_rmtval_find_space(attr);
>  			if (error)
>  				return error;
>  		}
> @@ -504,14 +504,14 @@ xfs_attr_set_iter(
>  		 * after we create the attribute so that we don't overflow the
>  		 * maximum size of a transaction and/or hit a deadlock.
>  		 */
> -		dac->dela_state = XFS_DAS_ALLOC_NODE;
> +		attr->xattri_dela_state = XFS_DAS_ALLOC_NODE;
>  		if (args->rmtblkno > 0) {
> -			if (dac->blkcnt > 0) {
> -				error = xfs_attr_rmtval_set_blk(dac);
> +			if (attr->xattri_blkcnt > 0) {
> +				error = xfs_attr_rmtval_set_blk(attr);
>  				if (error)
>  					return error;
>  				trace_xfs_attr_set_iter_return(
> -					dac->dela_state, args->dp);
> +					attr->xattri_dela_state, args->dp);
>  				return -EAGAIN;
>  			}
>  
> @@ -547,8 +547,8 @@ xfs_attr_set_iter(
>  			 * Commit the flag value change and start the next trans
>  			 * in series
>  			 */
> -			dac->dela_state = XFS_DAS_FLIP_NFLAG;
> -			trace_xfs_attr_set_iter_return(dac->dela_state,
> +			attr->xattri_dela_state = XFS_DAS_FLIP_NFLAG;
> +			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
>  						       args->dp);
>  			return -EAGAIN;
>  		}
> @@ -568,17 +568,17 @@ xfs_attr_set_iter(
>  		/* fallthrough */
>  	case XFS_DAS_RM_NBLK:
>  		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
> -		dac->dela_state = XFS_DAS_RM_NBLK;
> +		attr->xattri_dela_state = XFS_DAS_RM_NBLK;
>  		if (args->rmtblkno) {
> -			error = xfs_attr_rmtval_remove(dac);
> +			error = xfs_attr_rmtval_remove(attr);
>  			if (error == -EAGAIN)
>  				trace_xfs_attr_set_iter_return(
> -					dac->dela_state, args->dp);
> +					attr->xattri_dela_state, args->dp);
>  
>  			if (error)
>  				return error;
>  
> -			dac->dela_state = XFS_DAS_CLR_FLAG;
> +			attr->xattri_dela_state = XFS_DAS_CLR_FLAG;
>  			return -EAGAIN;
>  		}
>  
> @@ -588,7 +588,7 @@ xfs_attr_set_iter(
>  		 * The last state for node format. Look up the old attr and
>  		 * remove it.
>  		 */
> -		error = xfs_attr_node_addname_clear_incomplete(dac);
> +		error = xfs_attr_node_addname_clear_incomplete(attr);
>  		break;
>  	default:
>  		ASSERT(0);
> @@ -785,7 +785,7 @@ xfs_attr_item_init(
>  
>  	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
>  	new->xattri_op_flags = op_flags;
> -	new->xattri_dac.da_args = args;
> +	new->xattri_da_args = args;
>  
>  	*attr = new;
>  	return 0;
> @@ -1098,16 +1098,16 @@ xfs_attr_node_hasname(
>  
>  STATIC int
>  xfs_attr_node_addname_find_attr(
> -	struct xfs_delattr_context	*dac)
> +	 struct xfs_attr_item		*attr)
>  {
> -	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_da_args		*args = attr->xattri_da_args;
>  	int				retval;
>  
>  	/*
>  	 * Search to see if name already exists, and get back a pointer
>  	 * to where it should go.
>  	 */
> -	retval = xfs_attr_node_hasname(args, &dac->da_state);
> +	retval = xfs_attr_node_hasname(args, &attr->xattri_da_state);
>  	if (retval != -ENOATTR && retval != -EEXIST)
>  		return retval;
>  
> @@ -1135,8 +1135,8 @@ xfs_attr_node_addname_find_attr(
>  
>  	return 0;
>  error:
> -	if (dac->da_state)
> -		xfs_da_state_free(dac->da_state);
> +	if (attr->xattri_da_state)
> +		xfs_da_state_free(attr->xattri_da_state);
>  	return retval;
>  }
>  
> @@ -1157,10 +1157,10 @@ xfs_attr_node_addname_find_attr(
>   */
>  STATIC int
>  xfs_attr_node_addname(
> -	struct xfs_delattr_context	*dac)
> +	struct xfs_attr_item		*attr)
>  {
> -	struct xfs_da_args		*args = dac->da_args;
> -	struct xfs_da_state		*state = dac->da_state;
> +	struct xfs_da_args		*args = attr->xattri_da_args;
> +	struct xfs_da_state		*state = attr->xattri_da_state;
>  	struct xfs_da_state_blk		*blk;
>  	int				error;
>  
> @@ -1191,7 +1191,7 @@ xfs_attr_node_addname(
>  			 * this point.
>  			 */
>  			trace_xfs_attr_node_addname_return(
> -					dac->dela_state, args->dp);
> +					attr->xattri_dela_state, args->dp);
>  			return -EAGAIN;
>  		}
>  
> @@ -1220,9 +1220,9 @@ xfs_attr_node_addname(
>  
>  STATIC int
>  xfs_attr_node_addname_clear_incomplete(
> -	struct xfs_delattr_context	*dac)
> +	struct xfs_attr_item		*attr)
>  {
> -	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_da_args		*args = attr->xattri_da_args;
>  	struct xfs_da_state		*state = NULL;
>  	int				retval = 0;
>  	int				error = 0;
> @@ -1323,10 +1323,10 @@ xfs_attr_leaf_mark_incomplete(
>   */
>  STATIC
>  int xfs_attr_node_removename_setup(
> -	struct xfs_delattr_context	*dac)
> +	struct xfs_attr_item		*attr)
>  {
> -	struct xfs_da_args		*args = dac->da_args;
> -	struct xfs_da_state		**state = &dac->da_state;
> +	struct xfs_da_args		*args = attr->xattri_da_args;
> +	struct xfs_da_state		**state = &attr->xattri_da_state;
>  	int				error;
>  
>  	error = xfs_attr_node_hasname(args, state);
> @@ -1385,16 +1385,16 @@ xfs_attr_node_removename(
>   */
>  int
>  xfs_attr_remove_iter(
> -	struct xfs_delattr_context	*dac)
> +	struct xfs_attr_item		*attr)
>  {
> -	struct xfs_da_args		*args = dac->da_args;
> -	struct xfs_da_state		*state = dac->da_state;
> +	struct xfs_da_args		*args = attr->xattri_da_args;
> +	struct xfs_da_state		*state = attr->xattri_da_state;
>  	int				retval, error = 0;
>  	struct xfs_inode		*dp = args->dp;
>  
>  	trace_xfs_attr_node_removename(args);
>  
> -	switch (dac->dela_state) {
> +	switch (attr->xattri_dela_state) {
>  	case XFS_DAS_UNINIT:
>  		if (!xfs_inode_hasattr(dp))
>  			return -ENOATTR;
> @@ -1413,16 +1413,16 @@ xfs_attr_remove_iter(
>  		 * Node format may require transaction rolls. Set up the
>  		 * state context and fall into the state machine.
>  		 */
> -		if (!dac->da_state) {
> -			error = xfs_attr_node_removename_setup(dac);
> +		if (!attr->xattri_da_state) {
> +			error = xfs_attr_node_removename_setup(attr);
>  			if (error)
>  				return error;
> -			state = dac->da_state;
> +			state = attr->xattri_da_state;
>  		}
>  
>  		/* fallthrough */
>  	case XFS_DAS_RMTBLK:
> -		dac->dela_state = XFS_DAS_RMTBLK;
> +		attr->xattri_dela_state = XFS_DAS_RMTBLK;
>  
>  		/*
>  		 * If there is an out-of-line value, de-allocate the blocks.
> @@ -1435,10 +1435,10 @@ xfs_attr_remove_iter(
>  			 * May return -EAGAIN. Roll and repeat until all remote
>  			 * blocks are removed.
>  			 */
> -			error = xfs_attr_rmtval_remove(dac);
> +			error = xfs_attr_rmtval_remove(attr);
>  			if (error == -EAGAIN) {
>  				trace_xfs_attr_remove_iter_return(
> -						dac->dela_state, args->dp);
> +					attr->xattri_dela_state, args->dp);
>  				return error;
>  			} else if (error) {
>  				goto out;
> @@ -1453,7 +1453,7 @@ xfs_attr_remove_iter(
>  			error = xfs_attr_refillstate(state);
>  			if (error)
>  				goto out;
> -			dac->dela_state = XFS_DAS_RM_NAME;
> +			attr->xattri_dela_state = XFS_DAS_RM_NAME;
>  			return -EAGAIN;
>  		}
>  
> @@ -1463,7 +1463,7 @@ xfs_attr_remove_iter(
>  		 * If we came here fresh from a transaction roll, reattach all
>  		 * the buffers to the current transaction.
>  		 */
> -		if (dac->dela_state == XFS_DAS_RM_NAME) {
> +		if (attr->xattri_dela_state == XFS_DAS_RM_NAME) {
>  			error = xfs_attr_refillstate(state);
>  			if (error)
>  				goto out;
> @@ -1480,9 +1480,9 @@ xfs_attr_remove_iter(
>  			if (error)
>  				goto out;
>  
> -			dac->dela_state = XFS_DAS_RM_SHRINK;
> +			attr->xattri_dela_state = XFS_DAS_RM_SHRINK;
>  			trace_xfs_attr_remove_iter_return(
> -					dac->dela_state, args->dp);
> +					attr->xattri_dela_state, args->dp);
>  			return -EAGAIN;
>  		}
>  
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index d4e7521..b5f8351 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -430,7 +430,7 @@ struct xfs_attr_list_context {
>   */
>  
>  /*
> - * Enum values for xfs_delattr_context.da_state
> + * Enum values for xfs_attr_item.xattri_da_state
>   *
>   * These values are used by delayed attribute operations to keep track  of where
>   * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
> @@ -455,7 +455,7 @@ enum xfs_delattr_state {
>  };
>  
>  /*
> - * Defines for xfs_delattr_context.flags
> + * Defines for xfs_attr_item.xattri_flags
>   */
>  #define XFS_DAC_LEAF_ADDNAME_INIT	0x01 /* xfs_attr_leaf_addname init*/
>  #define XFS_DAC_DELAYED_OP_INIT		0x02 /* delayed operations init*/
> @@ -463,32 +463,25 @@ enum xfs_delattr_state {
>  /*
>   * Context used for keeping track of delayed attribute operations
>   */
> -struct xfs_delattr_context {
> -	struct xfs_da_args      *da_args;
> +struct xfs_attr_item {
> +	struct xfs_da_args		*xattri_da_args;
>  
>  	/*
>  	 * Used by xfs_attr_set to hold a leaf buffer across a transaction roll
>  	 */
> -	struct xfs_buf		*leaf_bp;
> +	struct xfs_buf			*xattri_leaf_bp;
>  
>  	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
> -	struct xfs_bmbt_irec	map;
> -	xfs_dablk_t		lblkno;
> -	int			blkcnt;
> +	struct xfs_bmbt_irec		xattri_map;
> +	xfs_dablk_t			xattri_lblkno;
> +	int				xattri_blkcnt;
>  
>  	/* Used in xfs_attr_node_removename to roll through removing blocks */
> -	struct xfs_da_state     *da_state;
> +	struct xfs_da_state		*xattri_da_state;
>  
>  	/* Used to keep track of current state of delayed operation */
> -	unsigned int            flags;
> -	enum xfs_delattr_state  dela_state;
> -};
> -
> -/*
> - * List of attrs to commit later.
> - */
> -struct xfs_attr_item {
> -	struct xfs_delattr_context	xattri_dac;
> +	unsigned int			xattri_flags;
> +	enum xfs_delattr_state		xattri_dela_state;
>  
>  	/*
>  	 * Indicates if the attr operation is a set or a remove
> @@ -496,7 +489,10 @@ struct xfs_attr_item {
>  	 */
>  	unsigned int			xattri_op_flags;
>  
> -	/* used to log this item to an intent */
> +	/*
> +	 * used to log this item to an intent containing a list of attrs to
> +	 * commit later
> +	 */
>  	struct list_head		xattri_list;
>  };
>  
> @@ -516,12 +512,10 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
>  int xfs_attr_get_ilocked(struct xfs_da_args *args);
>  int xfs_attr_get(struct xfs_da_args *args);
>  int xfs_attr_set(struct xfs_da_args *args);
> -int xfs_attr_set_iter(struct xfs_delattr_context *dac);
> +int xfs_attr_set_iter(struct xfs_attr_item *attr);
>  int xfs_has_attr(struct xfs_da_args *args);
> -int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
> +int xfs_attr_remove_iter(struct xfs_attr_item *attr);
>  bool xfs_attr_namecheck(const void *name, size_t length);
> -void xfs_delattr_context_init(struct xfs_delattr_context *dac,
> -			      struct xfs_da_args *args);
>  int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>  int xfs_attr_set_deferred(struct xfs_da_args *args);
>  int xfs_attr_remove_deferred(struct xfs_da_args *args);
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index e29c2b9..db5f004 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -568,14 +568,14 @@ xfs_attr_rmtval_stale(
>   */
>  int
>  xfs_attr_rmtval_find_space(
> -	struct xfs_delattr_context	*dac)
> +	struct xfs_attr_item		*attr)
>  {
> -	struct xfs_da_args		*args = dac->da_args;
> -	struct xfs_bmbt_irec		*map = &dac->map;
> +	struct xfs_da_args		*args = attr->xattri_da_args;
> +	struct xfs_bmbt_irec		*map = &attr->xattri_map;
>  	int				error;
>  
> -	dac->lblkno = 0;
> -	dac->blkcnt = 0;
> +	attr->xattri_lblkno = 0;
> +	attr->xattri_blkcnt = 0;
>  	args->rmtblkcnt = 0;
>  	args->rmtblkno = 0;
>  	memset(map, 0, sizeof(struct xfs_bmbt_irec));
> @@ -584,8 +584,8 @@ xfs_attr_rmtval_find_space(
>  	if (error)
>  		return error;
>  
> -	dac->blkcnt = args->rmtblkcnt;
> -	dac->lblkno = args->rmtblkno;
> +	attr->xattri_blkcnt = args->rmtblkcnt;
> +	attr->xattri_lblkno = args->rmtblkno;
>  
>  	return 0;
>  }
> @@ -598,17 +598,18 @@ xfs_attr_rmtval_find_space(
>   */
>  int
>  xfs_attr_rmtval_set_blk(
> -	struct xfs_delattr_context	*dac)
> +	struct xfs_attr_item		*attr)
>  {
> -	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_da_args		*args = attr->xattri_da_args;
>  	struct xfs_inode		*dp = args->dp;
> -	struct xfs_bmbt_irec		*map = &dac->map;
> +	struct xfs_bmbt_irec		*map = &attr->xattri_map;
>  	int nmap;
>  	int error;
>  
>  	nmap = 1;
> -	error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)dac->lblkno,
> -			dac->blkcnt, XFS_BMAPI_ATTRFORK, args->total,
> +	error = xfs_bmapi_write(args->trans, dp,
> +			(xfs_fileoff_t)attr->xattri_lblkno,
> +			attr->xattri_blkcnt, XFS_BMAPI_ATTRFORK, args->total,
>  			map, &nmap);
>  	if (error)
>  		return error;
> @@ -618,8 +619,8 @@ xfs_attr_rmtval_set_blk(
>  	       (map->br_startblock != HOLESTARTBLOCK));
>  
>  	/* roll attribute extent map forwards */
> -	dac->lblkno += map->br_blockcount;
> -	dac->blkcnt -= map->br_blockcount;
> +	attr->xattri_lblkno += map->br_blockcount;
> +	attr->xattri_blkcnt -= map->br_blockcount;
>  
>  	return 0;
>  }
> @@ -673,9 +674,9 @@ xfs_attr_rmtval_invalidate(
>   */
>  int
>  xfs_attr_rmtval_remove(
> -	struct xfs_delattr_context	*dac)
> +	struct xfs_attr_item		*attr)
>  {
> -	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_da_args		*args = attr->xattri_da_args;
>  	int				error, done;
>  
>  	/*
> @@ -695,7 +696,8 @@ xfs_attr_rmtval_remove(
>  	 * the parent
>  	 */
>  	if (!done) {
> -		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
> +		trace_xfs_attr_rmtval_remove_return(attr->xattri_dela_state,
> +						    args->dp);
>  		return -EAGAIN;
>  	}
>  
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index d72eff3..62b398e 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -12,9 +12,9 @@ int xfs_attr_rmtval_get(struct xfs_da_args *args);
>  int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>  		xfs_buf_flags_t incore_flags);
>  int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
> -int xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
> +int xfs_attr_rmtval_remove(struct xfs_attr_item *attr);
>  int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
>  int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
> -int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
> -int xfs_attr_rmtval_find_space(struct xfs_delattr_context *dac);
> +int xfs_attr_rmtval_set_blk(struct xfs_attr_item *attr);
> +int xfs_attr_rmtval_find_space(struct xfs_attr_item *attr);
>  #endif /* __XFS_ATTR_REMOTE_H__ */
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 2efd94f..18fc202 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -284,11 +284,11 @@ xfs_attrd_item_release(
>   */
>  STATIC int
>  xfs_trans_attr_finish_update(
> -	struct xfs_delattr_context	*dac,
> +	struct xfs_attr_item		*attr,
>  	struct xfs_attrd_log_item	*attrdp,
>  	uint32_t			op_flags)
>  {
> -	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_da_args		*args = attr->xattri_da_args;
>  	unsigned int			op = op_flags &
>  					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
>  	int				error;
> @@ -305,11 +305,11 @@ xfs_trans_attr_finish_update(
>  	switch (op) {
>  	case XFS_ATTR_OP_FLAGS_SET:
>  		args->op_flags |= XFS_DA_OP_ADDNAME;
> -		error = xfs_attr_set_iter(dac);
> +		error = xfs_attr_set_iter(attr);
>  		break;
>  	case XFS_ATTR_OP_FLAGS_REMOVE:
>  		ASSERT(XFS_IFORK_Q(args->dp));
> -		error = xfs_attr_remove_iter(dac);
> +		error = xfs_attr_remove_iter(attr);
>  		break;
>  	default:
>  		error = -EFSCORRUPTED;
> @@ -353,16 +353,16 @@ xfs_attr_log_item(
>  	 * structure with fields from this xfs_attr_item
>  	 */
>  	attrp = &attrip->attri_format;
> -	attrp->alfi_ino = attr->xattri_dac.da_args->dp->i_ino;
> +	attrp->alfi_ino = attr->xattri_da_args->dp->i_ino;
>  	attrp->alfi_op_flags = attr->xattri_op_flags;
> -	attrp->alfi_value_len = attr->xattri_dac.da_args->valuelen;
> -	attrp->alfi_name_len = attr->xattri_dac.da_args->namelen;
> -	attrp->alfi_attr_flags = attr->xattri_dac.da_args->attr_filter;
> -
> -	attrip->attri_name = (void *)attr->xattri_dac.da_args->name;
> -	attrip->attri_value = attr->xattri_dac.da_args->value;
> -	attrip->attri_name_len = attr->xattri_dac.da_args->namelen;
> -	attrip->attri_value_len = attr->xattri_dac.da_args->valuelen;
> +	attrp->alfi_value_len = attr->xattri_da_args->valuelen;
> +	attrp->alfi_name_len = attr->xattri_da_args->namelen;
> +	attrp->alfi_attr_flags = attr->xattri_da_args->attr_filter;
> +
> +	attrip->attri_name = (void *)attr->xattri_da_args->name;
> +	attrip->attri_value = attr->xattri_da_args->value;
> +	attrip->attri_name_len = attr->xattri_da_args->namelen;
> +	attrip->attri_value_len = attr->xattri_da_args->valuelen;
>  }
>  
>  /* Get an ATTRI. */
> @@ -403,10 +403,8 @@ xfs_attr_finish_item(
>  	struct xfs_attr_item		*attr;
>  	struct xfs_attrd_log_item	*done_item = NULL;
>  	int				error;
> -	struct xfs_delattr_context	*dac;
>  
>  	attr = container_of(item, struct xfs_attr_item, xattri_list);
> -	dac = &attr->xattri_dac;
>  	if (done)
>  		done_item = ATTRD_ITEM(done);
>  
> @@ -418,19 +416,18 @@ xfs_attr_finish_item(
>  	 * in a standard delay op, so we need to catch this here and rejoin the
>  	 * leaf to the new transaction
>  	 */
> -	if (attr->xattri_dac.leaf_bp &&
> -	    attr->xattri_dac.leaf_bp->b_transp != tp) {
> -		xfs_trans_bjoin(tp, attr->xattri_dac.leaf_bp);
> -		xfs_trans_bhold(tp, attr->xattri_dac.leaf_bp);
> +	if (attr->xattri_leaf_bp && attr->xattri_leaf_bp->b_transp != tp) {
> +		xfs_trans_bjoin(tp, attr->xattri_leaf_bp);
> +		xfs_trans_bhold(tp, attr->xattri_leaf_bp);
>  	}
>  
>  	/*
>  	 * Always reset trans after EAGAIN cycle
>  	 * since the transaction is new
>  	 */
> -	dac->da_args->trans = tp;
> +	attr->xattri_da_args->trans = tp;
>  
> -	error = xfs_trans_attr_finish_update(dac, done_item,
> +	error = xfs_trans_attr_finish_update(attr, done_item,
>  					     attr->xattri_op_flags);
>  	if (error != -EAGAIN)
>  		kmem_free(attr);
> @@ -608,7 +605,7 @@ xfs_attri_item_recover(
>  	args = (struct xfs_da_args *)((char *)attr +
>  		   sizeof(struct xfs_attr_item));
>  
> -	attr->xattri_dac.da_args = args;
> +	attr->xattri_da_args = args;
>  	attr->xattri_op_flags = attrp->alfi_op_flags;
>  
>  	args->dp = ip;
> @@ -645,7 +642,7 @@ xfs_attri_item_recover(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	ret = xfs_trans_attr_finish_update(&attr->xattri_dac, done_item,
> +	ret = xfs_trans_attr_finish_update(attr, done_item,
>  					   attrp->alfi_op_flags);
>  	if (ret == -EAGAIN) {
>  		/* There's more work to do, so add it to this transaction */


-- 
chandan
