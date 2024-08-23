Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587D6188A1A
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 17:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724433430; cv=none; b=RmqOKsvlQJZBxg5Crv/LnPTUwVklrJm4L6Ie/cituFGfY8FMIYycx9pqbjLUSSdkaYzjdMnUQ69jNePaMV27jRHoRSt3DpxrgfAB7SY0mXnCe8PWu/rgfqcO+hD9ewbTKLnJBQJDXn+3+oKs2k4GNzKc9Ickwv+VI0pgN7RrHgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724433430; c=relaxed/simple;
	bh=rbCqnF4r3MDMS3QWIS9QX52j2obZoO+WTo29jrYmLjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EN+a4lAFrpCO1G6kLCa9IOp7F83SRO9eUniHgNY0Xl3E4VxG8FWGenSBxgEN4i8zmyWGPTnblSrC2A6CMyWt1pAPs9oOoQIzAt1OXIa5GmWlf1Wf2tQckc3Fv+fCiP1YlkvYezD6qua+S0N8DqgBWpH6DQNZKI5vw9ZhRVC87Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cbPCUah6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cbPCUah6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48FAC4AF0B;
	Fri, 23 Aug 2024 17:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724433429;
	bh=rbCqnF4r3MDMS3QWIS9QX52j2obZoO+WTo29jrYmLjw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cbPCUah6FQ6ymO+vaRIaxb++36ZSLxOmPaWbd75hbD2BfhtxwcwEdsT0YYDZnXrEF
	 26jN4l1fm71uPtipDvoX0wOTR++tieuTza7HtKterS8wiXYC5PSyP/f+hkIzkiolc2
	 uoBfRIuIs1hz2DwTaBFnjGWd/QUZu06yYPamc1a50H/K0qwyA5WPdQow+LjN92K6lX
	 dGQo1hB5c0wD09UTYXQqugOfnIgWbTY/6DnmtC/KBJIj5ENBopnLrAGuUnhkXeS6J+
	 mdybjgKiospnhEL2RvUvkYMY+G3sWk6b3+SL4jUpEQ3io1TWHaSibQoOJjReqQrQKe
	 hNDQ8N48L7ESw==
Date: Fri, 23 Aug 2024 10:17:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 3/5] xfs: add XFS_ITEM_UNSAFE for log item push return
 result
Message-ID: <20240823171709.GG865349@frogsfrogsfrogs>
References: <20240823110439.1585041-1-leo.lilong@huawei.com>
 <20240823110439.1585041-4-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823110439.1585041-4-leo.lilong@huawei.com>

On Fri, Aug 23, 2024 at 07:04:37PM +0800, Long Li wrote:
> After pushing log items, the log item may have been freed, making it
> unsafe to access in tracepoints. This commit introduces XFS_ITEM_UNSAFE
> to indicate when an item might be freed during the item push operation.
> 
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/xfs_stats.h     | 1 +
>  fs/xfs/xfs_trans.h     | 1 +
>  fs/xfs/xfs_trans_ail.c | 7 +++++++
>  3 files changed, 9 insertions(+)
> 
> diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
> index a61fb56ed2e6..9a7a020587cf 100644
> --- a/fs/xfs/xfs_stats.h
> +++ b/fs/xfs/xfs_stats.h
> @@ -86,6 +86,7 @@ struct __xfsstats {
>  	uint32_t		xs_push_ail_pushbuf;
>  	uint32_t		xs_push_ail_pinned;
>  	uint32_t		xs_push_ail_locked;
> +	uint32_t		xs_push_ail_unsafe;
>  	uint32_t		xs_push_ail_flushing;
>  	uint32_t		xs_push_ail_restarts;
>  	uint32_t		xs_push_ail_flush;
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index f06cc0f41665..fd4f04853fe2 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -117,6 +117,7 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
>  #define XFS_ITEM_PINNED		1
>  #define XFS_ITEM_LOCKED		2
>  #define XFS_ITEM_FLUSHING	3
> +#define XFS_ITEM_UNSAFE		4
>  
>  /*
>   * This is the structure maintained for every active transaction.
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 8ede9d099d1f..a5ab1ffb8937 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -561,6 +561,13 @@ xfsaild_push(
>  
>  			stuck++;
>  			break;
> +		case XFS_ITEM_UNSAFE:
> +			/*
> +			 * The item may have been freed, so we can't access the
> +			 * log item here.
> +			 */
> +			XFS_STATS_INC(mp, xs_push_ail_unsafe);

Aha, so this is in reaction to Dave's comment "So, yeah, these failure
cases need to return something different to xfsaild_push() so it knows
that it is unsafe to reference the log item, even for tracing purposes."

What we're trying to communicate through xfsaild_push_item is that we've
cycled the AIL lock and possibly done something (e.g. deleting the log
item from the AIL) such that the lip reference might be stale.

Can we call this XFS_ITEM_STALEREF?  "Unsafe" is vague.

--D

> +			break;
>  		default:
>  			ASSERT(0);
>  			break;
> -- 
> 2.39.2
> 
> 
