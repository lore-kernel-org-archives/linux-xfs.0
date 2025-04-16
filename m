Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE101A2658
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 01:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744767151; cv=none; b=QyyvMtA4OF60UmAvQEPjO+7Cm5EkedGk/Ppc0hH7pMcKnMaXMQ8hwhEfGsCg2ZS2FMhlfyj+rAAM5gL+fGOYWwnpKrg2nQP0s6CLQil93x7TWsgV1wdrQhT0FQPi+qIiN0WlozvK7AjPQbHr+Eau/mN4v8MvTQS8I+D5FGCUvRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744767151; c=relaxed/simple;
	bh=BvHVzMvlBv4RaPMh8O3iYLWw99ksh+o9StakOfyogf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sO+P3c9ihvuM8PVokn/7vE0TzxtDKIWJ9Lxuy6YoHuoRKsfCmSe3kW6m1a2sC0qGs2/8Sup8tVTkKiZRPah4f1w6WmuSGGHezNu/vJcEYJ830+B/PRXoavSX8BzxeqrPWnkbi6O4HfslgEn9WSV4lBpFvTYfSgPCDbnXjxRfOe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j3JGaUGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j3JGaUGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85051C4CEE7;
	Wed, 16 Apr 2025 01:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744767150;
	bh=BvHVzMvlBv4RaPMh8O3iYLWw99ksh+o9StakOfyogf8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j3JGaUGVLa8reRtKIhvCTwOGIH2Dm3ONEqDqCaRSO+ivVV1unvdiGw4dM7VN/PAyV
	 oTpjpMZSdaoCDmTl/fqYtQUunptn4iEFK1ie9zopGWbYcDlnsHa7SkWzpErKHRUceT
	 Xch2PT9YeX6xu394NRslm6EQAq/VKEbXx4WU3aJ7pxXvne6bT7ugYSt8M93wsKC04H
	 kmsaUivMWqtgEYAF905fSUmsaVxZJrwHs427FZr581NlEEr29AaLwSLPbIdCM0shSy
	 Mj9C+VN9t9914q7hW0om7V0PdjawAwPJ5hizdthhfuXrdBzik4QQxYM8M6Gz+PEooz
	 TfKJylgCUqJGQ==
Date: Tue, 15 Apr 2025 18:32:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "user.mail" <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org, bodonnel@redhat.com
Subject: Re: [PATCH] xfs_repair: Bump link count if longform_dir2_rebuild
 yields shortform dir
Message-ID: <20250416013229.GY25675@frogsfrogsfrogs>
References: <20250415180923.264941-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250415180923.264941-1-sandeen@redhat.com>

On Tue, Apr 15, 2025 at 01:09:23PM -0500, user.mail wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> If longform_dir2_rebuild() has so few entries in *hashtab that it results
> in a short form directory, bump the link count manually as shortform
> directories have no explicit "." entry.
> 
> Without this, repair will end with i.e.:
> 
> resetting inode 131 nlinks from 2 to 1
> 
> in this case, because it thinks this directory inode only has 1 link
> discovered, and then a 2nd repair will fix it:
> 
> resetting inode 131 nlinks from 1 to 2
> 
> because shortform_dir2_entry_check() explicitly adds the extra ref when
> the (newly-created)shortform directory is checked:
> 
>         /*
>          * no '.' entry in shortform dirs, just bump up ref count by 1
>          * '..' was already (or will be) accounted for and checked when
>          * the directory is reached or will be taken care of when the
>          * directory is moved to orphanage.
>          */
>         add_inode_ref(current_irec, current_ino_offset);
> 
> Avoid this by adding the extra ref if we convert from longform to
> shortform.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: user.mail <sandeen@redhat.com>

Whoever this is  ^^^^^^^^^, the change makes sense to me. ;)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  repair/phase6.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index dbc090a5..8804278a 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -1392,6 +1392,13 @@ _("name create failed in ino %" PRIu64 " (%d)\n"), ino, error);
>  _("name create failed (%d) during rebuild\n"), error);
>  	}
>  
> +	/*
> +	 * If we added too few entries to retain longform, add the extra
> +	 * ref for . as this is now a shortform directory.
> +	 */
> +	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL)
> +		add_inode_ref(irec, ino_offset);
> +
>  	return;
>  
>  out_bmap_cancel:
> -- 
> 2.49.0
> 
> 
