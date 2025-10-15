Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06482475CB
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 21:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760563178; cv=none; b=CZiILmLNM8kUyglxjiVXDBR5y/n66XEC6ITeg9+JhO3tAwr+ElkUWcQdoAuXXC08HgLD1KRhi9S1/b3y4Uv6f2nNvUUfr9cZxv79gL5KkIc0huYXuK3AOnQTtqENK4hABdam22lYkPxeRkz726io4b+aqZ1Lkaye5jfR+TrAt7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760563178; c=relaxed/simple;
	bh=o1f9eQ54nUKLg5tag+oAB+0VGltmwDq2m7UXDAvn8WM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OWbU2/XCE1X9P6h4ABLFO5Z1NNOFW1mG8qNrK0RmDsfNdtdQZuiujuSnh3RBPDohcw/OmD/tY1KWsvAneJwnTMREmjjhkPhc0C22QrFCWNauXHpl66s5t5oh8/IKpy5T/7YfXZ5+eOy4QbuR9xGXduhF5Y/CBLpup6qYYDa4xIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QkTHrgRK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QkTHrgRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D37BC4CEF8;
	Wed, 15 Oct 2025 21:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760563178;
	bh=o1f9eQ54nUKLg5tag+oAB+0VGltmwDq2m7UXDAvn8WM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QkTHrgRKnuLg7G5plH/zZtvh1BhLa0BsBGYte/cMJ1LP5e9CTSlHQajhmK0Rk3yoz
	 nfDLTiMFZdbnxR8mayE8OqJo70UPW3hTzG1neOc6CqdtfHnVO61nfh4WKI5uOVl+iJ
	 anpsY4eLanTvJCljpoDQNaAyiuNrvsc7czPlB/OFdPoVQMBQjHxjpSIMezDsz4qB4o
	 DqbpzY5fPPaeaSo4RhAnndk2FwRWl9q+qNIq92F0LXmKj0RTVnCzNwMhznbHXPhURR
	 gijwrndIw8p+xC6peS+/uFM3HD2nZYXG4VlW/7lRP8Dp9FewZ3u+cS7wHFAlPixYY4
	 sE+BCcwgU8+Sg==
Date: Wed, 15 Oct 2025 14:19:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/17] xfs: push q_qlock acquisition from xchk_dquot_iter
 to the callers.
Message-ID: <20251015211937.GH2591640@frogsfrogsfrogs>
References: <20251013024851.4110053-1-hch@lst.de>
 <20251013024851.4110053-13-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013024851.4110053-13-hch@lst.de>

On Mon, Oct 13, 2025 at 11:48:13AM +0900, Christoph Hellwig wrote:
> There is no good reason to take q_qlock in xchk_dquot_iter, which just
> provides a reference to the dquot.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yep.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/dqiterate.c         | 1 -
>  fs/xfs/scrub/quota.c             | 1 +
>  fs/xfs/scrub/quota_repair.c      | 1 +
>  fs/xfs/scrub/quotacheck.c        | 1 +
>  fs/xfs/scrub/quotacheck_repair.c | 1 +
>  5 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/dqiterate.c b/fs/xfs/scrub/dqiterate.c
> index 6f1185afbf39..20c4daedd48d 100644
> --- a/fs/xfs/scrub/dqiterate.c
> +++ b/fs/xfs/scrub/dqiterate.c
> @@ -205,7 +205,6 @@ xchk_dquot_iter(
>  	if (error)
>  		return error;
>  
> -	mutex_lock(&dq->q_qlock);
>  	cursor->id = dq->q_id + 1;
>  	*dqpp = dq;
>  	return 1;
> diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> index cfcd0fb66845..b711d36c5ec9 100644
> --- a/fs/xfs/scrub/quota.c
> +++ b/fs/xfs/scrub/quota.c
> @@ -329,6 +329,7 @@ xchk_quota(
>  	/* Now look for things that the quota verifiers won't complain about. */
>  	xchk_dqiter_init(&cursor, sc, dqtype);
>  	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
> +		mutex_lock(&dq->q_qlock);
>  		error = xchk_quota_item(&sqi, dq);
>  		mutex_unlock(&dq->q_qlock);
>  		xfs_qm_dqrele(dq);
> diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
> index 00a4d2e75797..7897b93c639a 100644
> --- a/fs/xfs/scrub/quota_repair.c
> +++ b/fs/xfs/scrub/quota_repair.c
> @@ -510,6 +510,7 @@ xrep_quota_problems(
>  
>  	xchk_dqiter_init(&cursor, sc, dqtype);
>  	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
> +		mutex_lock(&dq->q_qlock);
>  		error = xrep_quota_item(&rqi, dq);
>  		xfs_qm_dqrele(dq);
>  		if (error)
> diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
> index bef63f19cd87..20220afd90f1 100644
> --- a/fs/xfs/scrub/quotacheck.c
> +++ b/fs/xfs/scrub/quotacheck.c
> @@ -675,6 +675,7 @@ xqcheck_compare_dqtype(
>  	/* Compare what we observed against the actual dquots. */
>  	xchk_dqiter_init(&cursor, sc, dqtype);
>  	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
> +		mutex_lock(&dq->q_qlock);
>  		error = xqcheck_compare_dquot(xqc, dqtype, dq);
>  		mutex_unlock(&dq->q_qlock);
>  		xfs_qm_dqrele(dq);
> diff --git a/fs/xfs/scrub/quotacheck_repair.c b/fs/xfs/scrub/quotacheck_repair.c
> index f7b1add43a2c..de1521739ec9 100644
> --- a/fs/xfs/scrub/quotacheck_repair.c
> +++ b/fs/xfs/scrub/quotacheck_repair.c
> @@ -150,6 +150,7 @@ xqcheck_commit_dqtype(
>  	 */
>  	xchk_dqiter_init(&cursor, sc, dqtype);
>  	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
> +		mutex_lock(&dq->q_qlock);
>  		error = xqcheck_commit_dquot(xqc, dqtype, dq);
>  		xfs_qm_dqrele(dq);
>  		if (error)
> -- 
> 2.47.3
> 
> 
