Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA86F37F015;
	Tue, 22 Sep 2026 18:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790100153; cv=none; b=dBZd+2rK5HAESE12aFVU2UbX+6+5lUMjW69dReR7VRFcEg/7b4R/ERaYpF+X9LY9woC1gflenO3/OJ3/fA4k3fW3doudbqDA+vTwO2nA5AdmI1KNg0KwCF9le0wvKy0QPhQYsSll3EBYN0Y6ZAALOoVelq5eKNn5U18aN82TLSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790100153; c=relaxed/simple;
	bh=BcHBn2UZtUK7aNlCdO+R/2PD6ujgJGUXD8/c94ZM4Go=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qfjt/H10AhcO+kJzM+wjjsHgRLv6OW8iDkxn7W8WMYEM+m73HX/UzKgO4iDP/X2CmhbhfD2MjVZh/mEKcHF1DQEz21/D+7TsiaTFWzv9CR4KSLnCUmugmSOgUlzz6CL0ZwdNVcSgJRYCwSXwEsKUHjhE+jBmi7z1r0M2pabS3Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ma5VY+M4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ma5VY+M4"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A31731F000FF;
	Tue, 22 Sep 2026 18:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790100151;
	bh=H6j3A0y/Tme7E56rKeVsNuePB6a3BtF46Purg/cD7vE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ma5VY+M4GxwSzam50epjE1EDS+OqK5wBITylo8jWZB/eUMHJJR8FKWFFTtEVgkyZt
	 egBk3TK6PfSxQxeuTMZXrqnwhEVk/mkqfCWzgEJPUle78WrDDQLkzYNjv/yHVsQsEu
	 lupaoGDnMjy4dAezOlHNt5dnC2VxGp9vcaE5Lk3B48PJIo42cz73uNWiMYZdR955io
	 lwiifaUzLgT40z1vHr83mKr4e2B3bJ+XkPmLVE+hDll0dzoiKlp7MUgUzrlGaxJ2Tj
	 ZiHFaUHQIu/Txio26pOBHMzgXQAvaQWafqnaKrNyR6eG6SHnxE40R4EPQQ4t1wHDwM
	 Ap45iel3Yh1hw==
Date: Tue, 22 Sep 2026 11:02:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/14] xfs: online quotacheck must dirty dquot if
 enforcement adjustments needed
Message-ID: <20260922180231.GX2705364@frogsfrogsfrogs>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120594.181988.17443723006471773386.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178996120594.181988.17443723006471773386.stgit@frogsfrogsfrogs>

On Sun, Sep 20, 2026 at 11:15:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that we have no way to force xchk_commit_dquot to call
> xfs_qm_adjust_dqenforcement if nothing else is wrong with the dquot.
> Therefore, add a new predicate to force the dirty flag if the dquot has
> zero limits and there are default limits; or if the grace period timer
> needs adjusting.
> 
> Cc: <stable@vger.kernel.org> # v6.9
> Fixes: 96ed2ae4a9b06b ("xfs: repair dquots based on live quotacheck results")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Assisted-by: LOLLM # finding obvious bugs
> ---
>  fs/xfs/scrub/quotacheck_repair.c |   51 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
> 
> 
> diff --git a/fs/xfs/scrub/quotacheck_repair.c b/fs/xfs/scrub/quotacheck_repair.c
> index 48ee08df302a42..e2208510939f08 100644
> --- a/fs/xfs/scrub/quotacheck_repair.c
> +++ b/fs/xfs/scrub/quotacheck_repair.c
> @@ -39,6 +39,54 @@
>   * dquot is locked.
>   */
>  
> +static bool
> +xqcheck_dqres_force_dirty(
> +	const struct xfs_dquot_res	*res,
> +	const struct xfs_quota_limits	*qlim)
> +{
> +	/* zero limits mean that we should set the default limits */
> +	if (res->softlimit == 0 && qlim->soft != 0)
> +		return true;
> +	if (res->hardlimit == 0 && qlim->hard != 0)
> +		return true;
> +
> +	/* do we need to adjust the timer setting? */
> +	if ((res->softlimit && res->count > res->softlimit) ||
> +	    (res->hardlimit && res->count > res->hardlimit)) {
> +		if (res->timer == 0 && qlim->time != 0)

Shashiko says:

"Does this skip repairing missing grace period timers when the default grace
period is configured to 0?
If a quota usage exceeds its limit but has a missing or corrupt timer
(res->timer == 0) and the default grace period (qlim->time) is 0, this
condition evaluates to false. This causes the repair code to skip dirtying
the dquot, bypassing xfs_qm_adjust_dqenforcement().
When the unfixed dquot is subsequently flushed (e.g., via background
writeback or a log force), xfs_qm_dqflush_check() will find count > softlimit
but timer == 0. This is treated as a fatal inconsistency and triggers
SHUTDOWN_CORRUPT_INCORE, effectively turning a reparable condition into a
denial of service."

Yes, that should just be "if (!res->timer) return true;" since we want
to force xfs_qm_adjust_dqtimers to reset it.  I forgot that !qlim->time
just means "expires immediately", not "expires never".

Will fix in next revision.

--D

> +			return true;
> +	} else {
> +		if (res->timer)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +/* Decide if we need to adjust the dquot limits or timers */
> +static bool
> +xqcheck_dquot_force_dirty(
> +	const struct xfs_dquot	*dq)
> +{
> +	struct xfs_quotainfo	*qi = dq->q_mount->m_quotainfo;
> +	struct xfs_def_quota	*defq;
> +
> +	/* root dquot does not enforce limits */
> +	if (dq->q_id == 0)
> +		return false;
> +
> +	defq = xfs_get_defquota(qi, xfs_dquot_type(dq));
> +
> +	if (xqcheck_dqres_force_dirty(&dq->q_blk, &defq->blk))
> +		return true;
> +	if (xqcheck_dqres_force_dirty(&dq->q_ino, &defq->ino))
> +		return true;
> +	if (xqcheck_dqres_force_dirty(&dq->q_rtb, &defq->rtb))
> +		return true;
> +
> +	return false;
> +}
> +
>  /* Commit new counters to a dquot. */
>  static int
>  xqcheck_commit_dquot(
> @@ -91,6 +139,9 @@ xqcheck_commit_dquot(
>  		dirty = true;
>  	}
>  
> +	if (!dirty && xqcheck_dquot_force_dirty(dq))
> +		dirty = true;
> +
>  	xcdq.flags |= (XQCHECK_DQUOT_REPAIR_SCANNED | XQCHECK_DQUOT_WRITTEN);
>  	error = xfarray_store(counts, dq->q_id, &xcdq);
>  	if (error == -EFBIG) {
> 
> 
