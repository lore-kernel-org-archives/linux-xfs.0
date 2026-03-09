Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A2E38E5F6;
	Mon,  9 Mar 2026 16:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773072870; cv=none; b=FYGd16U2ma/4BY+UfcdeGKb2OEKy4OGxaOnnsy9vPXP/E09ugro3xO3q1iy393/W+iZnCz+mkaojC3X3tXeIiKAmDreVE+sEzdh6wWKkDtuTzJL70abJSg2YEBLZggDNqVpK3UL1dpylu08vQFzmuVBuxfxZtF7qr5V2Y2BHImk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773072870; c=relaxed/simple;
	bh=2GLe1MxvGkFd8qezlDmdHOOwNVVe2wswrte9rhTlEAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UqbQN4YeMqZXA224QpLzTQurh/ZkjeX8L53K47CMrJNfUxVnI4ES/T92ROZP2X268MCMoE3seIeQa2IFi7WAdjl3U/v6fJ5dZQBPzGOKyfrbmlY65zE5YXBQAUXVk7mYvam5AL18lo3PSNmH1rygHfG0KlBqbTy8obtD3EDpCQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BKK4kJJg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BKK4kJJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75B9C4CEF7;
	Mon,  9 Mar 2026 16:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773072869;
	bh=2GLe1MxvGkFd8qezlDmdHOOwNVVe2wswrte9rhTlEAs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BKK4kJJgZkPmZiQkiHsVZb19ul68ziEZ6dwowPOtaPfONyELGjkFPozXeXT7EGzRN
	 lVlGyN2CdNqLkIgrb5Ty70uKPi1X6zOmzB0I+GkexoRNb9+N7ZmJEy/kvp4CVZs3j+
	 Da+nmK0hHlqZpJiw17yarnij4krY73ns4j3r+6XgcLSTHWvkoFMCETY4ndINwAM60I
	 5FehagCSYtZNfTHURyBpExjA4n4bZLwad9uiRkBTllEjqVipYYHFUZAwJ7nnpACvnF
	 FH2GsOUPWAlG7GLa1w5Rm52wRF7S+UIppM6UnKh9LUc8jAK5+8odMtUsTZMAyyHFMT
	 /XNNXEKK+wukw==
Date: Mon, 9 Mar 2026 09:14:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <darrick.wong@oracle.com>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/4] xfs: refactor xfsaild_push loop into helper
Message-ID: <20260309161427.GB6033@frogsfrogsfrogs>
References: <20260308182804.33127-6-ytohnuki@amazon.com>
 <20260308182804.33127-8-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260308182804.33127-8-ytohnuki@amazon.com>

On Sun, Mar 08, 2026 at 06:28:07PM +0000, Yuto Ohnuki wrote:
> Factor the loop body of xfsaild_push() into a separate
> xfsaild_process_logitem() helper to improve readability.
> 
> This is a pure code movement with no functional change. The
> subsequent patch to fix a use-after-free in the AIL push path
> depends on this refactoring.
> 
> Cc: <stable@vger.kernel.org> # v5.9
> Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>

Seems like a reasonable hoist to reduce the length of the function, but
in ordering the patches this way (cleanup, then bugfixes) the hoist also
has to be backported to 5.10/5.15/6.1/6.6/6.12/6.18/6.19.

--D

> ---
>  fs/xfs/xfs_trans_ail.c | 116 +++++++++++++++++++++++------------------
>  1 file changed, 64 insertions(+), 52 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 923729af4206..ac747804e1d6 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -458,6 +458,69 @@ xfs_ail_calc_push_target(
>  	return target_lsn;
>  }
>  
> +static void
> +xfsaild_process_logitem(
> +	struct xfs_ail		*ailp,
> +	struct xfs_log_item	*lip,
> +	xfs_lsn_t		lsn,
> +	int			*stuck,
> +	int			*flushing)
> +{
> +	struct xfs_mount	*mp = ailp->ail_log->l_mp;
> +	int			lock_result;
> +
> +	/*
> +	 * Note that iop_push may unlock and reacquire the AIL lock. We
> +	 * rely on the AIL cursor implementation to be able to deal with
> +	 * the dropped lock.
> +	 */
> +	lock_result = xfsaild_push_item(ailp, lip);
> +	switch (lock_result) {
> +	case XFS_ITEM_SUCCESS:
> +		XFS_STATS_INC(mp, xs_push_ail_success);
> +		trace_xfs_ail_push(lip);
> +
> +		ailp->ail_last_pushed_lsn = lsn;
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
> +		trace_xfs_ail_flushing(lip);
> +
> +		(*flushing)++;
> +		ailp->ail_last_pushed_lsn = lsn;
> +		break;
> +
> +	case XFS_ITEM_PINNED:
> +		XFS_STATS_INC(mp, xs_push_ail_pinned);
> +		trace_xfs_ail_pinned(lip);
> +
> +		(*stuck)++;
> +		ailp->ail_log_flush++;
> +		break;
> +	case XFS_ITEM_LOCKED:
> +		XFS_STATS_INC(mp, xs_push_ail_locked);
> +		trace_xfs_ail_locked(lip);
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
> @@ -505,62 +568,11 @@ xfsaild_push(
>  
>  	lsn = lip->li_lsn;
>  	while ((XFS_LSN_CMP(lip->li_lsn, ailp->ail_target) <= 0)) {
> -		int	lock_result;
>  
>  		if (test_bit(XFS_LI_FLUSHING, &lip->li_flags))
>  			goto next_item;
>  
> -		/*
> -		 * Note that iop_push may unlock and reacquire the AIL lock.  We
> -		 * rely on the AIL cursor implementation to be able to deal with
> -		 * the dropped lock.
> -		 */
> -		lock_result = xfsaild_push_item(ailp, lip);
> -		switch (lock_result) {
> -		case XFS_ITEM_SUCCESS:
> -			XFS_STATS_INC(mp, xs_push_ail_success);
> -			trace_xfs_ail_push(lip);
> -
> -			ailp->ail_last_pushed_lsn = lsn;
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
> -			trace_xfs_ail_flushing(lip);
> -
> -			flushing++;
> -			ailp->ail_last_pushed_lsn = lsn;
> -			break;
> -
> -		case XFS_ITEM_PINNED:
> -			XFS_STATS_INC(mp, xs_push_ail_pinned);
> -			trace_xfs_ail_pinned(lip);
> -
> -			stuck++;
> -			ailp->ail_log_flush++;
> -			break;
> -		case XFS_ITEM_LOCKED:
> -			XFS_STATS_INC(mp, xs_push_ail_locked);
> -			trace_xfs_ail_locked(lip);
> -
> -			stuck++;
> -			break;
> -		default:
> -			ASSERT(0);
> -			break;
> -		}
> -
> +		xfsaild_process_logitem(ailp, lip, lsn, &stuck, &flushing);
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
