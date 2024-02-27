Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1497136A
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 00:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708994783; cv=none; b=V980PgOmNBPV/n/C2Wa9RU+MO1wkyyk2gTcwLYAVNj/MoY1pWO2Ab/o/Khhot2RM3ZpYyxGbgVN8EJcmmVRM541x+UCvij3td3r8tW8lG1KPEy9JB0ThfCcqMaycSwkYzlIoaQr1UJ8GY30Hx4J7XFHOvzlHQipk/bmsFvu5QQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708994783; c=relaxed/simple;
	bh=FWsRix9FJDmMcSPz1NQuHWOQ3cQ+F10rZfTM5s2EKrA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kJhNGxOH9BJXxwxl9J9ZD1mCVaWlkbf4E7OE7nzvnL33kGVxUalIiOHE3e+zJhUIlLW9WkEhTHvDQXaQDA8AQZxhB/2dmWIzE6V5MNWMOWTfDGz9Kf728RUXl2ra7a9pFjAdgXcqu8iFi3BHorOdypX+wZsxZXPlpAQ081sPmoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jrj3Z1d4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jrj3Z1d4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A93EC433F1;
	Tue, 27 Feb 2024 00:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708994782;
	bh=FWsRix9FJDmMcSPz1NQuHWOQ3cQ+F10rZfTM5s2EKrA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jrj3Z1d4VQYMdMla4c0LGOPafQgB4zihGtSnB5WckWafYmbLzb+dXboeLPP9tpXSS
	 AJ9ogZAD4ksHkcR1QTkrTyG5IxqRjbMJq7AjxBvpL3881OH/5w6Gg9nUGnE+JtQo69
	 PiM9jkthzEfXqRvhxbcHF3XyfWRK/sS4/LGFeuaq+/lH3rHPA5da5Lnac5rhoe4+Nh
	 3FMJIWB+f7JbSVBoWcJd5ubZAB8H+5JffwLsB9P0IyJELuMOqtS6vKxGBv5bdHrTS5
	 RBqTdY/xaG1NedYSwagNR/ujG9pjWBdRP66SvNEqPYxDYm2e9RhfNCtIYLzpruMxB8
	 oNZyBNkOSz0/w==
Date: Mon, 26 Feb 2024 16:46:21 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: Re: [PATCH 2/2] xfs: use kvfree() in xlog_cil_free_logvec()
Message-ID: <20240227004621.GN616564@frogsfrogsfrogs>
References: <20240227001135.718165-1-david@fromorbit.com>
 <20240227001135.718165-3-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227001135.718165-3-david@fromorbit.com>

On Tue, Feb 27, 2024 at 11:05:32AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The xfs_log_vec items are allocated by xlog_kvmalloc(), and so need
> to be freed with kvfree. This was missed when coverting from the
> kmem_free() API.
> 
> Reported-by: Chandan Babu R <chandanbabu@kernel.org>
> Fixes: 49292576136f ("xfs: convert kmem_free() for kvmalloc users to kvfree()")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index f15735d0296a..9544ddaef066 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -877,7 +877,7 @@ xlog_cil_free_logvec(
>  	while (!list_empty(lv_chain)) {
>  		lv = list_first_entry(lv_chain, struct xfs_log_vec, lv_list);
>  		list_del_init(&lv->lv_list);
> -		kfree(lv);
> +		kvfree(lv);

Is it necessary to s/kfree/kvfree/ in xlog_cil_process_intents when we
free the xfs_log_vec that's attached to a xfs_log_item?

--D

>  	}
>  }
>  
> -- 
> 2.43.0
> 
> 
