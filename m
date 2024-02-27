Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC8A4D9E4
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 04:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709007938; cv=none; b=HUssKXVgBuohJnZgfw9YdZ2NdEkkYq00UKqez9+sYtg+/E6ixHhiedmm39b2dVW4kzMBocE+L7LpS+P+wfWTrtp82FJZrkcugYvnLWdIYW42e6NWZHIlfMjA2zdtWz3leAF1z9xBT1WUM9q0nSrY15R0i36KlxZPslBK9KOHRXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709007938; c=relaxed/simple;
	bh=CpCMXZodgsf/v3FVDC1YmXt7N3p0K/luh/KTVwt7OxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lXhL7sBm02fzXXawV5lRASUIckKNDubNZYZfkVFy+Nqy14XxG4dARLiGRBmNRcYegHZAcQrjfB/jMvOZ9r3DzjbYN0oNwMXNudjjEK9H0ijNJSEMmxjFiJj8nvWBk4Ti6bz7+t2xchC6C1azXfncq0fK73v0MBDstg1Doavo6vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sd/d/5rW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sd/d/5rW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB23C433C7;
	Tue, 27 Feb 2024 04:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709007938;
	bh=CpCMXZodgsf/v3FVDC1YmXt7N3p0K/luh/KTVwt7OxY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sd/d/5rWHpyWgcFrj49vjdWfgq6WR0p/uPgSEg3EzitlPmydGuXOlBNtFP73yXhgY
	 YLAaIME/U/t3x9D9AIG5Fbod/607+mWOTjDnHE1mal/A1igYoVxdWOkuGWQqIVHm3K
	 JCrBdYBAyjocxtTAXojRUuKG/UgspfHbN0ygldNNxiwifrnxqkZUKBEDrwTNnKp69P
	 4qL+LWidabO9FUJstIQRCAnHKG7xks3+4RQisQXFL9BZoSZ+zB+iuzb+r3h7k1v9Zx
	 QWCP0WnOIu+ZgJPHyAlPtdE+7te5p0r01RVsaHIa1lbxMiZ9VUByJyqf17tF5iQxeE
	 Vvf0C95zXlRUA==
Date: Mon, 26 Feb 2024 20:25:37 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: Re: [PATCH v2 2/2] xfs: use kvfree() in xlog_cil_free_logvec()
Message-ID: <20240227042537.GQ616564@frogsfrogsfrogs>
References: <20240227001135.718165-1-david@fromorbit.com>
 <20240227001135.718165-3-david@fromorbit.com>
 <20240227004621.GN616564@frogsfrogsfrogs>
 <Zd1QhmIB/SzPDoDf@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd1QhmIB/SzPDoDf@dread.disaster.area>

On Tue, Feb 27, 2024 at 02:01:26PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The xfs_log_vec items are allocated by xlog_kvmalloc(), and so need
> to be freed with kvfree. This was missed when coverting from the
> kmem_free() API.
> 
> Reported-by: Chandan Babu R <chandanbabu@kernel.org>
> Fixes: 49292576136f ("xfs: convert kmem_free() for kvmalloc users to kvfree()")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good to me, will run this one through fstestsclod overnight...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> 
> Version 2:
> - also fix kfree() in xlog_cil_process_intents().
> - checked that kvfree() is used for all lip->li_lv_shadow freeing
>   calls.
> 
>  fs/xfs/xfs_log_cil.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index f15735d0296a..4d52854bcb29 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -877,7 +877,7 @@ xlog_cil_free_logvec(
>  	while (!list_empty(lv_chain)) {
>  		lv = list_first_entry(lv_chain, struct xfs_log_vec, lv_list);
>  		list_del_init(&lv->lv_list);
> -		kfree(lv);
> +		kvfree(lv);
>  	}
>  }
>  
> @@ -1717,7 +1717,7 @@ xlog_cil_process_intents(
>  		set_bit(XFS_LI_WHITEOUT, &ilip->li_flags);
>  		trace_xfs_cil_whiteout_mark(ilip);
>  		len += ilip->li_lv->lv_bytes;
> -		kfree(ilip->li_lv);
> +		kvfree(ilip->li_lv);
>  		ilip->li_lv = NULL;
>  
>  		xfs_trans_del_item(lip);
> 
