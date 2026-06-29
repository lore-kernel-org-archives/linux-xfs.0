Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4E53F9263;
	Mon, 29 Jun 2026 10:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782727235; cv=none; b=TGlf8NZhK3jem4c+WBIoGsnAGKI0plk56buBpLG+AkEFlnBW31NmBTN7xIeZmBritJ4tDw4UKMTz78PE6HHZuabFk8iHRwtwfGMykc+4ROArS3gT0ONhy9HVrW8883BglkjNlJZokCRysOtmPo6AX9BOTfOEBi1FXtWIzy12wRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782727235; c=relaxed/simple;
	bh=X8PtuZLzSkJ3USDH/ZZQK3OyKvWTlNkUfYXM49WvPiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hgwb+mFqjN6ZvP7hmpVTiHzdrPvgHLX+xbnTprvaQVZfdsLnl9sOXcB5zMeiLbSgOUo9coCzzs9kbaUtXonAQr7YL9Ytm9AEhM8fnYfiWjWXMwB2EEVFgopsf0hUtXcMAuiadzz2C9a4pyxkgtg1qM10ByA7SHeunIWX7oAEZ6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YcFP6Zoq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YcFP6Zoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5581A1F000E9;
	Mon, 29 Jun 2026 10:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782727234;
	bh=XFbSgoT3v9Lc0N+N0KQoRYtjyHAg8Fp+UTBKlIGQhAI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YcFP6ZoqG+Kbmx7namjVkxbCxJNRv1Ayy6BYmB9EPtWvPOMqzdjSbHwFdL9LwkjPv
	 kcpWtqEfhJ/8ZdFvPlS38zH7yfLM4U7jZ0xAd08GAvkhOanNs9NCB2PUXTaYDHpZ2z
	 uIYc02ZvwUeP8KBhrA7U31cNjQUPZ4a0hptZQnmgietslm3lFj5gjtgOlY3appKbEF
	 9n8pIkDJc+0BOsOwjifoqINfzIUsoIqiPl0npDxnZZD9evg333HbDk33+/pUEZiCGQ
	 hrhqT/Kew+KcLNe4+hMsBE6pVC6KSpZ5diFBnVQ1mLuJ/VKZjDpVvSLjZVoX9uT1oT
	 B+OhgffTCyTdA==
Date: Mon, 29 Jun 2026 12:00:30 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Tsu-chieh Chen <tsuchieh.chen@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: clarify sb_qflags locking in xfs_qm_mount_quotas
Message-ID: <akJBqrxeo9yU7_Tg@nidhogg.toxiclabs.cc>
References: <20260627223910.129798-1-tsuchieh.chen@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260627223910.129798-1-tsuchieh.chen@gmail.com>

On Sat, Jun 27, 2026 at 06:39:10PM -0400, Tsu-chieh Chen wrote:
> xfs_qm_mount_quotas() is only called from the mount path, so
> m_sb_lock is not needed for serialization when updating sb_qflags.
> 
> The code still takes m_sb_lock around the sb_qflags update. Replace the
> old XXX comment with an explanation that the lock is taken to keep the
> mount-time update consistent with the runtime quota update paths.
> 
> No functional change.
> 
> Signed-off-by: Tsu-chieh Chen <tsuchieh.chen@gmail.com>
> ---
>  fs/xfs/xfs_qm.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index aa0d2976f1c3..c2bab12643d3 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1663,8 +1663,9 @@ xfs_qm_mount_quotas(
>  
>   write_changes:
>  	/*
> -	 * We actually don't have to acquire the m_sb_lock at all.
> -	 * This can only be called from mount, and that's single threaded. XXX
> +	 * Mount is single-threaded, so this does not need m_sb_lock for
> +	 * serialization. Take it anyway to keep sb_qflags updates consistent
> +	 * with the runtime quota update paths.

Why? What's the actual clarification this change makes? Indeed the XXX
does not need to be there but I don't see any improvement in this change
comment-wise. XXX removal could be embedded on any other patch that
touches code around it.

>  	 */
>  	spin_lock(&mp->m_sb_lock);
>  	sbf = mp->m_sb.sb_qflags;
> 
> base-commit: 804826eac53cff44f88f42989fcc601c2612c0ed
> -- 
> 2.43.0
> 
> 
