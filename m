Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38CE5C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 23:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbiEJXMn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 19:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237958AbiEJXMg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 19:12:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CC653B57
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 16:12:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D33E618E2
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 23:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78415C385CE;
        Tue, 10 May 2022 23:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652224354;
        bh=NTQzjFQPEoGvZTfVUeQApWFcMpq/LYVlZTg1AB++5xQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ctRwYORL5aVcOp3xRRqmJJ9MXpdOOaFqGoN+XTuPb3oc4WxjlztbhDwgWoruFibbt
         YksDlHq4bdoVBRcD53QjzwV4XDomk7szYMEvqZG+IZH1GDFmDJS5cJ0JzPfxqX7836
         su6ZWTtXAMfOoQofO5OABULazKSZtbOAMQjNFj0eVOwatv6siJgcuZhChVaZExDjK3
         KxBxowx4zO6CZ2wuuTRHVWvIz2QbJUzJmyf2I5KEHeo1Puo3KGETEeqqGts/c4xBy5
         um9dEY+HCyYIIop9dkwZHZhvntaOWrE3ILbAFLII1pEt+euEpAXcWpUvWHoqZsHgd+
         zjcUaVJmFDUIg==
Date:   Tue, 10 May 2022 16:12:34 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/18] xfs: separate out initial attr_set states
Message-ID: <20220510231234.GI27195@magnolia>
References: <20220509004138.762556-1-david@fromorbit.com>
 <20220509004138.762556-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509004138.762556-6-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 09, 2022 at 10:41:25AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We current use XFS_DAS_UNINIT for several steps in the attr_set
> state machine. We use it for setting shortform xattrs, converting
> from shortform to leaf, leaf add, leaf-to-node and leaf add. All of
> these things are essentially known before we start the state machine
> iterating, so we really should separate them out:
> 
> XFS_DAS_SF_ADD:
> 	- tries to do a shortform add
> 	- on success -> done
> 	- on ENOSPC converts to leaf, -> XFS_DAS_LEAF_ADD
> 	- on error, dies.
> 
> XFS_DAS_LEAF_ADD:
> 	- tries to do leaf add
> 	- on success:
> 		- inline attr -> done
> 		- remote xattr || REPLACE -> XFS_DAS_FOUND_LBLK
> 	- on ENOSPC converts to node, -> XFS_DAS_NODE_ADD
> 	- on error, dies
> 
> XFS_DAS_NODE_ADD:
> 	- tries to do node add
> 	- on success:
> 		- inline attr -> done
> 		- remote xattr || REPLACE -> XFS_DAS_FOUND_NBLK
> 	- on error, dies
> 
> This makes it easier to understand how the state machine starts
> up and sets us up on the path to further state machine
> simplifications.

Yes!!

> This also converts the DAS state tracepoints to use strings rather
> than numbers, as converting between enums and numbers requires
> manual counting rather than just reading the name.
> 
> This also introduces a XFS_DAS_DONE state so that we can trace
> successful operation completions easily.

Yes!!

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Allison Henderson<allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c  | 161 +++++++++++++++++++-------------------
>  fs/xfs/libxfs/xfs_attr.h  |  80 ++++++++++++++++---
>  fs/xfs/libxfs/xfs_defer.c |   2 +
>  fs/xfs/xfs_acl.c          |   4 +-
>  fs/xfs/xfs_attr_item.c    |  13 ++-
>  fs/xfs/xfs_ioctl.c        |   4 +-
>  fs/xfs/xfs_trace.h        |  22 +++++-
>  fs/xfs/xfs_xattr.c        |   2 +-
>  8 files changed, 185 insertions(+), 103 deletions(-)
> 

<snip>

> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index c9c867e3406c..ad52b5dc59e4 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -530,4 +553,35 @@ void xfs_attri_destroy_cache(void);
>  int __init xfs_attrd_init_cache(void);
>  void xfs_attrd_destroy_cache(void);
>  
> +/*
> + * Check to see if the attr should be upgraded from non-existent or shortform to
> + * single-leaf-block attribute list.
> + */
> +static inline bool
> +xfs_attr_is_shortform(
> +	struct xfs_inode    *ip)
> +{
> +	return ip->i_afp->if_format == XFS_DINODE_FMT_LOCAL ||
> +	       (ip->i_afp->if_format == XFS_DINODE_FMT_EXTENTS &&
> +		ip->i_afp->if_nextents == 0);
> +}
> +
> +static inline enum xfs_delattr_state
> +xfs_attr_init_add_state(struct xfs_da_args *args)
> +{
> +	if (!args->dp->i_afp)
> +		return XFS_DAS_DONE;

If we're in add/replace attr call without an attr fork, why do we go
straight to finished?

--D
