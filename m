Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C53427979A;
	Wed, 18 Feb 2026 23:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771458558; cv=none; b=REDsxzZWEi50X2WxzaIpwuT9UXsHeZDdGlfxFFP2jjEqhVPUayUuag3WGx4+LsJcNvzpAwKlEQatanO5M69keF9xwjLUhq1avja987AUenCz8cuX+pkrQAmi3ffEc3so7VzdsHYSfLWBO5hLVVTr5uOL8wNpA6p6yArTfCCyKZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771458558; c=relaxed/simple;
	bh=+70HNPRBg9zMVWQc4KRyK67eVeHc7zQJrDejWG3WqBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tS/YWEu42Qswmfu9otuvthsELcxLR2MfGhiQIYS6qhR9N583X/nRywb9yGrSZFFUptZwZ3WZi9ByUA6V2roD7bDnNetEIIf4phHtoprPkMx8ptZh6iMMM16oUiO1wKNCcPFWVrZuHYvJE0OK1/LtZZ/o3NST30vuRkxryd/8SNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QB9rf0sN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QB9rf0sN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C77C116D0;
	Wed, 18 Feb 2026 23:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771458557;
	bh=+70HNPRBg9zMVWQc4KRyK67eVeHc7zQJrDejWG3WqBw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QB9rf0sNGLzURjmAexKtDrw62jEM4EwV2dPaBpMKF/j/Zdzqb/qVm2P0GBDsjIhlu
	 ox34wJOt9LnvAwVb0MyUh/aiVPqjURA0VNM7M5MTNFJix9mNF8WTd/jDQRJBTD5shi
	 RxhJ+tW9SLpHN5ssoT8242W8X6kJnxWo3JUxHiOQOoId6+XIBdrwuO2RxCXUT3Uv2R
	 MTucv2+BHvEK4t9a7rLK9akeEDBhD++YmqZNlVAtGnOMg9FIB2fM83D0gga2l0Jorn
	 Kz/PFwzZtY/17IYwKh0DRDawsajeJJ6Svr3dy9sELkoDzzuSUlWjD0LGlLbLvBCxTP
	 rO1lbpebq0LaQ==
Date: Wed, 18 Feb 2026 15:49:17 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Ethan Tidmore <ethantidmore06@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, NeilBrown <neil@brown.name>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Fix error pointer dereference
Message-ID: <20260218234917.GA6490@frogsfrogsfrogs>
References: <20260218195115.14049-1-ethantidmore06@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218195115.14049-1-ethantidmore06@gmail.com>

On Wed, Feb 18, 2026 at 01:51:15PM -0600, Ethan Tidmore wrote:
> The function try_lookup_noperm() can return an error pointer and is not
> checked for one. Add checks for error pointer.
> 
> Detected by Smatch:
> fs/xfs/scrub/orphanage.c:449 xrep_adoption_check_dcache() error: 
> 'd_child' dereferencing possible ERR_PTR()
> 
> fs/xfs/scrub/orphanage.c:485 xrep_adoption_zap_dcache() error: 
> 'd_child' dereferencing possible ERR_PTR()
> 
> Fixes: 06c567403ae5a ("Use try_lookup_noperm() instead of d_hash_and_lookup() outside of VFS")

Cc: <stable@vger.kernel.org> # v6.16

> Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
> ---
>  fs/xfs/scrub/orphanage.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
> index 52a108f6d5f4..cdb0f486f50c 100644
> --- a/fs/xfs/scrub/orphanage.c
> +++ b/fs/xfs/scrub/orphanage.c
> @@ -442,7 +442,7 @@ xrep_adoption_check_dcache(
>  		return 0;
>  
>  	d_child = try_lookup_noperm(&qname, d_orphanage);

"Look up a dentry by name in the dcache, returning NULL if it does not
currently exist."

Could you please fix the documentation since try_lookup_noperm can
return ERR_PTR values?

> -	if (d_child) {
> +	if (!IS_ERR_OR_NULL(d_child)) {

If d_child is an ERR_PTR, shouldn't we extract that error value and
return it instead of zero?

--D

>  		trace_xrep_adoption_check_child(sc->mp, d_child);
>  
>  		if (d_is_positive(d_child)) {
> @@ -479,7 +479,7 @@ xrep_adoption_zap_dcache(
>  		return;
>  
>  	d_child = try_lookup_noperm(&qname, d_orphanage);
> -	while (d_child != NULL) {
> +	while (!IS_ERR_OR_NULL(d_child)) {
>  		trace_xrep_adoption_invalidate_child(sc->mp, d_child);
>  
>  		ASSERT(d_is_negative(d_child));
> -- 
> 2.53.0
> 
> 
