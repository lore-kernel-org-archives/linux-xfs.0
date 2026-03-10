Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1CF3CC9FE;
	Tue, 10 Mar 2026 20:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773175224; cv=none; b=UZ9kkOBEXf00nkJXvit32IrhxELgoyfYevov3GkqtnSRzEtsLbpmGf+SAOwojmChqAgfDYkh/V0GjBW+Mj4+QTllaMwlSwzCD6vn0tkusDMt7ND0peEE4y9yS2x03YIZlI8SRJFefqmQLQZuViCyPEqn5uMOHHqPb4K3yccGI6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773175224; c=relaxed/simple;
	bh=v/8cvbx1FTQXiLrXOt3PkldwRV+/59it+8MCtZU+xwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HXHydwBHOlsU67VKgSHw3K5r6vlfS1lwOVQ2twz3kB4zue54x+RviEt6nODaBaPwKf3cmcH27p2ysU+u0aw8zsRYO8wTNVYQl7XZFpD5fj13pDwjzc7lIoIB8L/y5u8FWcHuR13M6u7q5a2cGRt/gBltevxk/y8MVv8kJ2QQImU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sq842EEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sq842EEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BFEC19423;
	Tue, 10 Mar 2026 20:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773175224;
	bh=v/8cvbx1FTQXiLrXOt3PkldwRV+/59it+8MCtZU+xwg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sq842EEQjUvkUpsivAfE2mhuxYkcONOuNq4ig4hJqSEtK/WcpjTVRR7kvp85kr4MW
	 aVY1FNBRr08szcPqgcvAwvPYvfAvNMq60VPH9ur0tD4zMf2Znwv5MvUXw7eozTAxz2
	 2IIzy4DgTni+NJPhdiA7jrGer7APOSUjKewHKuz5eoRvOGPkDAdt1inaj6PeoWMXM1
	 QvtaCTUxtFVetO7D/V0kD3BSWjX/rXa7I9yyGpp8AUob5JbZyq+E18zYOjK8mSyskQ
	 us7pqKc8aDkvbZqIz/HcrYU8Wj+gPi98OYoTV75wJgFUob8Ju2TVKtzZFTtow5t2aX
	 S8XWh9kOgOsKg==
Date: Tue, 10 Mar 2026 13:40:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <darrick.wong@oracle.com>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/4] xfs: refactor xfsaild_push loop into helper
Message-ID: <20260310204023.GW1105363@frogsfrogsfrogs>
References: <20260310183835.89827-6-ytohnuki@amazon.com>
 <20260310183835.89827-10-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310183835.89827-10-ytohnuki@amazon.com>

On Tue, Mar 10, 2026 at 06:38:40PM +0000, Yuto Ohnuki wrote:
> Factor the loop body of xfsaild_push() into a separate
> xfsaild_process_logitem() helper to improve readability.
> 
> This is a pure code movement with no functional change.
> 
> Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>

Neat hoist!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_trans_ail.c | 127 ++++++++++++++++++++++-------------------
>  1 file changed, 69 insertions(+), 58 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 63266d31b514..99a9bf3762b7 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -464,6 +464,74 @@ xfs_ail_calc_push_target(
>  	return target_lsn;
>  }
>  
> +static void
> +xfsaild_process_logitem(
> +	struct xfs_ail		*ailp,
> +	struct xfs_log_item	*lip,
> +	int			*stuck,
> +	int			*flushing)
> +{
> +	struct xfs_mount	*mp = ailp->ail_log->l_mp;
> +	uint			type = lip->li_type;
> +	unsigned long		flags = lip->li_flags;
> +	xfs_lsn_t		item_lsn = lip->li_lsn;
> +	int			lock_result;
> +
> +	/*
> +	 * Note that iop_push may unlock and reacquire the AIL lock. We
> +	 * rely on the AIL cursor implementation to be able to deal with
> +	 * the dropped lock.
> +	 *
> +	 * The log item may have been freed by the push, so it must not
> +	 * be accessed or dereferenced below this line.
> +	 */
> +	lock_result = xfsaild_push_item(ailp, lip);
> +	switch (lock_result) {
> +	case XFS_ITEM_SUCCESS:
> +		XFS_STATS_INC(mp, xs_push_ail_success);
> +		trace_xfs_ail_push(ailp, type, flags, item_lsn);
> +
> +		ailp->ail_last_pushed_lsn = item_lsn;
> +		break;
> +
> +	case XFS_ITEM_FLUSHING:
> +		/*
> +		 * The item or its backing buffer is already being
> +		 * flushed.  The typical reason for that is that an
> +		 * inode buffer is locked because we already pushed the
> +		 * updates to it as part of inode clustering.
> +		 *
> +		 * We do not want to stop flushing just because lots
> +		 * of items are already being flushed, but we need to
> +		 * re-try the flushing relatively soon if most of the
> +		 * AIL is being flushed.
> +		 */
> +		XFS_STATS_INC(mp, xs_push_ail_flushing);
> +		trace_xfs_ail_flushing(ailp, type, flags, item_lsn);
> +
> +		(*flushing)++;
> +		ailp->ail_last_pushed_lsn = item_lsn;
> +		break;
> +
> +	case XFS_ITEM_PINNED:
> +		XFS_STATS_INC(mp, xs_push_ail_pinned);
> +		trace_xfs_ail_pinned(ailp, type, flags, item_lsn);
> +
> +		(*stuck)++;
> +		ailp->ail_log_flush++;
> +		break;
> +	case XFS_ITEM_LOCKED:
> +		XFS_STATS_INC(mp, xs_push_ail_locked);
> +		trace_xfs_ail_locked(ailp, type, flags, item_lsn);
> +
> +		(*stuck)++;
> +		break;
> +	default:
> +		ASSERT(0);
> +		break;
> +	}
> +}
> +
>  static long
>  xfsaild_push(
>  	struct xfs_ail		*ailp)
> @@ -511,68 +579,11 @@ xfsaild_push(
>  
>  	lsn = lip->li_lsn;
>  	while ((XFS_LSN_CMP(lip->li_lsn, ailp->ail_target) <= 0)) {
> -		int		lock_result;
> -		uint		type = lip->li_type;
> -		unsigned long	flags = lip->li_flags;
> -		xfs_lsn_t	item_lsn = lip->li_lsn;
>  
>  		if (test_bit(XFS_LI_FLUSHING, &lip->li_flags))
>  			goto next_item;
>  
> -		/*
> -		 * Note that iop_push may unlock and reacquire the AIL lock.  We
> -		 * rely on the AIL cursor implementation to be able to deal with
> -		 * the dropped lock.
> -		 *
> -		 * The log item may have been freed by the push, so it must not
> -		 * be accessed or dereferenced below this line.
> -		 */
> -		lock_result = xfsaild_push_item(ailp, lip);
> -		switch (lock_result) {
> -		case XFS_ITEM_SUCCESS:
> -			XFS_STATS_INC(mp, xs_push_ail_success);
> -			trace_xfs_ail_push(ailp, type, flags, item_lsn);
> -
> -			ailp->ail_last_pushed_lsn = item_lsn;
> -			break;
> -
> -		case XFS_ITEM_FLUSHING:
> -			/*
> -			 * The item or its backing buffer is already being
> -			 * flushed.  The typical reason for that is that an
> -			 * inode buffer is locked because we already pushed the
> -			 * updates to it as part of inode clustering.
> -			 *
> -			 * We do not want to stop flushing just because lots
> -			 * of items are already being flushed, but we need to
> -			 * re-try the flushing relatively soon if most of the
> -			 * AIL is being flushed.
> -			 */
> -			XFS_STATS_INC(mp, xs_push_ail_flushing);
> -			trace_xfs_ail_flushing(ailp, type, flags, item_lsn);
> -
> -			flushing++;
> -			ailp->ail_last_pushed_lsn = item_lsn;
> -			break;
> -
> -		case XFS_ITEM_PINNED:
> -			XFS_STATS_INC(mp, xs_push_ail_pinned);
> -			trace_xfs_ail_pinned(ailp, type, flags, item_lsn);
> -
> -			stuck++;
> -			ailp->ail_log_flush++;
> -			break;
> -		case XFS_ITEM_LOCKED:
> -			XFS_STATS_INC(mp, xs_push_ail_locked);
> -			trace_xfs_ail_locked(ailp, type, flags, item_lsn);
> -
> -			stuck++;
> -			break;
> -		default:
> -			ASSERT(0);
> -			break;
> -		}
> -
> +		xfsaild_process_logitem(ailp, lip, &stuck, &flushing);
>  		count++;
>  
>  		/*
> -- 
> 2.50.1
> 
> 
> 
> 
> Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284
> 
> Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705
> 
> 
> 
> 
