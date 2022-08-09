Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E98DC19F2D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 16:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244296AbiHIQw6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 12:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242649AbiHIQw5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 12:52:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A2E220CC
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 09:52:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C31A60CF2
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 16:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4954C433D6;
        Tue,  9 Aug 2022 16:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660063975;
        bh=u4YMniR1LvSoCcLgb6GABtEDjxBVUh07wYeFXcCSOtY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qPxdFDvslRPCxahhii20oWVGjZabpJDbuQmcCU3c/PkaovV4WV1aJ7lVMwcTaTgJB
         GkGTHMoO/fPUGEm5ZunZG0l6oCjQepJc0l6I7qHYUNtiecwWcMWM5wokV5LcufBTdo
         TF+TNbEri3h0LscedDp6uhrpGrMyAZtmdr2XQ64EyMkTdF6q8HxkR7+BLvRLxo6IgZ
         mb1eFhBOePIDZrjlnxD8rDGqAo9FpnT4s+gL5YqUDjNkppciPaIWzeiyeJ+tVP1aLl
         613VP6XyOGGABmC5PaL9h8/khx3xefFYzVE8HFXYyn0BsSqbIzXf+6StIpJYCmF8Xa
         9p/wgTL7jA9ZQ==
Date:   Tue, 9 Aug 2022 09:52:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RESEND v2 01/18] xfs: Fix multi-transaction larp replay
Message-ID: <YvKQ5+XotiXFDpTA@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
 <20220804194013.99237-2-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804194013.99237-2-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 04, 2022 at 12:39:56PM -0700, Allison Henderson wrote:
> Recent parent pointer testing has exposed a bug in the underlying
> attr replay.  A multi transaction replay currently performs a
> single step of the replay, then deferrs the rest if there is more
> to do.  This causes race conditions with other attr replays that
> might be recovered before the remaining deferred work has had a
> chance to finish.  This can lead to interleaved set and remove
> operations that may clobber the attribute fork.  Fix this by
> deferring all work for any attribute operation.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_attr_item.c | 35 ++++++++---------------------------
>  1 file changed, 8 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 5077a7ad5646..c13d724a3e13 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -635,52 +635,33 @@ xfs_attri_item_recover(
>  		break;
>  	case XFS_ATTRI_OP_FLAGS_REMOVE:
>  		if (!xfs_inode_hasattr(args->dp))
> -			goto out;
> +			return 0;
>  		attr->xattri_dela_state = xfs_attr_init_remove_state(args);
>  		break;
>  	default:
>  		ASSERT(0);
> -		error = -EFSCORRUPTED;
> -		goto out;
> +		return -EFSCORRUPTED;
>  	}
>  
>  	xfs_init_attr_trans(args, &tres, &total);
>  	error = xfs_trans_alloc(mp, &tres, total, 0, XFS_TRANS_RESERVE, &tp);
>  	if (error)
> -		goto out;
> +		return error;
>  
>  	args->trans = tp;
>  	done_item = xfs_trans_get_attrd(tp, attrip);
> +	args->trans->t_flags |= XFS_TRANS_HAS_INTENT_DONE;
> +	set_bit(XFS_LI_DIRTY, &done_item->attrd_item.li_flags);
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	error = xfs_xattri_finish_update(attr, done_item);
> -	if (error == -EAGAIN) {
> -		/*
> -		 * There's more work to do, so add the intent item to this
> -		 * transaction so that we can continue it later.
> -		 */
> -		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
> -		error = xfs_defer_ops_capture_and_commit(tp, capture_list);
> -		if (error)
> -			goto out_unlock;
> -
> -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -		xfs_irele(ip);
> -		return 0;
> -	}
> -	if (error) {
> -		xfs_trans_cancel(tp);
> -		goto out_unlock;
> -	}
> -
> +	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);

This seems a little convoluted to me.  Maybe?  Maybe not?

1. Log recovery recreates an incore xfs_attri_log_item from what it
finds in the log.

2. This function then logs an xattrd for the recovered xattri item.

3. Then it creates a new xfs_attr_intent to complete the operation.

4. Finally, it calls xfs_defer_ops_capture_and_commit, which logs a new
xattri for the intent created in step 3 and also commits the xattrd for
the first xattri.

IOWs, the only difference between before and after is that we're not
advancing one more step through the state machine as part of log
recovery.  From the perspective of the log, the recovery function merely
replaces the recovered xattri log item with a new one.

Why can't we just attach the recovered xattri to the xfs_defer_pending
that is created to point to the xfs_attr_intent that's created in step
3, and skip the xattrd?

I /think/ the answer to that question is that we might need to move the
log tail forward to free enough log space to finish the intent items, so
creating the extra xattrd/xattri (a) avoid the complexity of submitting
an incore intent item *and* a log intent item to the defer ops
machinery; and (b) avoid livelocks in log recovery.  Therefore, we
actually need to do it this way.

IOWS, I *think* this is ok, but want to see if others have differing
perspectives on how log item recovery works?

--D

>  	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
> -out_unlock:
> +
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	xfs_irele(ip);
> -out:
> -	xfs_attr_free_item(attr);
> +
>  	return error;
>  }
>  
> -- 
> 2.25.1
> 
