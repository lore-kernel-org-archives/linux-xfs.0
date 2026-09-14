Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4009A47F2CC
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 14:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789395601; cv=none; b=WKYqSS+m03ukfk6Gy0eb3O+Oc5V6uLIzaKw+KpyT/3FRXmq4ROJyOuExHKjjX0+FRhW0g07goqhvpvPLzbznIZQba1AYQS+3PNvzpKT52kCE/hpK/9t7qKejcjie8xrjD7ReoT6zh8kVjIHmsyItKCurOk+hVSRq9uS9GOQ1YI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789395601; c=relaxed/simple;
	bh=AkYW9aXIrTs0+7f5k3zU1bLqag0rUwzi4UqMSgXFtjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=smnQLHx9q7H0mz955JMGRNrpC7BsFToTbshQmAJI4n+9gfR7KOZ35xXCn3gruzPr5soOPl67o/E9kMyKFSRzDdNmK9zOT1LOnfawnDPweJYehchdQexZSaQ4CXJlkMq1w+U0gN9KlBLxhY11WI1TzX7sEfvPwINg8W35Aku/1n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Czo24Vz1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Czo24Vz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A181F00893;
	Mon, 14 Sep 2026 14:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789395595;
	bh=GOtKfnFlEGj1FKe6IkAAQe68BGQcpFMzdKzcPRVVEi0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Czo24Vz1ZSFoDUuLumApW2CwRWyKi2pZtfLC97y0QPAjPPI7N1jW0e3n8lqy2xB08
	 oWnHIr9NyJwRnkmotZhQsQWJlXogRsmU00q14bDxPPc8kae0n+uoWdxdFs1oISw85h
	 PVp3onmlz2Zk2SUJxD7C/tPTU0dn4JtZ3NnLTBBfMMWyjMWZx8Ob9gaUXuAHZsOiPg
	 S5GiFEeux3fw5P5xlMnIUGey1mVYB/3K+E+57liWRUlIf4sBVmsz+5lNUw9tgS163K
	 G0M+ab8GtJvv2/XRFdVknp4jQsvCc3+8QY1OZRo7se8VzQeDeToHSQPfZngcYS7CU5
	 7Sy0UfLV99pWA==
Date: Mon, 14 Sep 2026 16:19:51 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, hans.holmberg@wdc.com, dlemoal@kernel.org, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't try to get a reference to a NULL oz in
 xfs_get_cached_zone
Message-ID: <aqgCfgjor88fFagE@nidhogg.toxiclabs.cc>
References: <20260914113538.2448661-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914113538.2448661-1-hch@lst.de>

On Mon, Sep 14, 2026 at 01:35:38PM +0200, Christoph Hellwig wrote:
> oz can be NULL when we resample it after taking i_flags_lock, so account
> for that.
> 
> Fixes: 2d829cc76777 ("xfs: fix racy open zone caching")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_zone_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index bede79859671..8cdd473d8144 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -819,7 +819,7 @@ xfs_get_cached_zone(
>  		spin_unlock(&ip->i_flags_lock);
>  	}
>  
> -	if (!atomic_inc_not_zero(&oz->oz_ref))
> +	if (oz && !atomic_inc_not_zero(&oz->oz_ref))
>  		oz = NULL;
>  out_unlock:
>  	rcu_read_unlock();
> -- 
> 2.53.0
> 
> 
