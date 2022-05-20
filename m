Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B22CCC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 03:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241520AbiETDmO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 May 2022 23:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345180AbiETDmN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 May 2022 23:42:13 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 861EE14641F
        for <linux-xfs@vger.kernel.org>; Thu, 19 May 2022 20:42:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B8EF810E6793;
        Fri, 20 May 2022 13:42:11 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nrtWk-00E6Tc-66; Fri, 20 May 2022 13:42:10 +1000
Date:   Fri, 20 May 2022 13:42:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: clean up xfs_attr_node_hasname
Message-ID: <20220520034210.GD1098723@dread.disaster.area>
References: <165290014409.1647637.4876706578208264219.stgit@magnolia>
 <165290014984.1647637.6457441230229883518.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165290014984.1647637.6457441230229883518.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62870e13
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=HdPbKLDlAzUX-oBP0bwA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 18, 2022 at 11:55:49AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The calling conventions of this function are a mess -- callers /can/
> provide a pointer to a pointer to a state structure, but it's not
> required, and as evidenced by the last two patches, the callers that do
> weren't be careful enough about how to deal with an existing da state.
> 
> Push the allocation and freeing responsibilty to the callers, which
> means that callers from the xattr node state machine steps now have the
> visibility to allocate or free the da state structure as they please.
> As a bonus, the node remove/add paths for larp-mode replaces can reset
> the da state structure instead of freeing and immediately reallocating
> it.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c     |   63 +++++++++++++++++++++---------------------
>  fs/xfs/libxfs/xfs_da_btree.c |   11 +++++++
>  fs/xfs/libxfs/xfs_da_btree.h |    1 +
>  3 files changed, 44 insertions(+), 31 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 576de34cfca0..3838109ef288 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -61,8 +61,8 @@ STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
>  static int xfs_attr_node_try_addname(struct xfs_attr_item *attr);
>  STATIC int xfs_attr_node_addname_find_attr(struct xfs_attr_item *attr);
>  STATIC int xfs_attr_node_remove_attr(struct xfs_attr_item *attr);
> -STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> -				 struct xfs_da_state **state);
> +STATIC int xfs_attr_node_lookup(struct xfs_da_args *args,
> +		struct xfs_da_state *state);
>  
>  int
>  xfs_inode_hasattr(
> @@ -594,6 +594,19 @@ xfs_attr_leaf_mark_incomplete(
>  	return xfs_attr3_leaf_setflag(args);
>  }
>  
> +/* Ensure the da state of an xattr deferred work item is ready to go. */
> +static inline void
> +xfs_attr_item_ensure_da_state(

xfs_attr_item_init_da_state().

Other than that, it's a nice cleanup. I can rename the function
locally if you want.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
