Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0879963B9;
	Thu,  2 Jul 2026 15:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783007938; cv=none; b=HdwncO5n22wNooMLAdlBBu/9RdZzRMjRRbEaaUG0BY1OyhGyvchu8TdxYoa4qSwvAlnP6FqKbr/wuS1udmC/nKoV5ZIHVVD0RAGgTDodhG7xLeBltsVb5mi6GuwsKJ1XZLke3Hb/EncZcIZKHBvRpyTnlegpzKxKH/+wjmrQVng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783007938; c=relaxed/simple;
	bh=RprhDtbjBCEDJBBbHfkqgxvWVw/cP/XZU9HVk2Xy71o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UBPpg7jQV7tN1319pLVNp028Uh3sAKD8UbXGMiJw/m5H8/KbHkiIGucMrVSmvg8ZeyjObyuM2HaKuZxPxdfJ88YfjGt/+jSz0tWOKGHUubCfOXlEqHdwoZXCkWzyTDGhZoUDGckKuMa3myKIwMKAs6q7n4CHPCfEC3fQE+dfIt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=okD9fsm5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="okD9fsm5"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D4DA51F000E9;
	Thu,  2 Jul 2026 15:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783007936;
	bh=nmF+6XVozXIfJxI+LoZYp6B+n3oGwZjpJIHtCIgVm/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=okD9fsm5DdsOnriwUYpcovohCHiEO0vNXLpvqdr6b+PcaQgfaarVBB1cP3tg/VEOF
	 xJLIJVm54/kjCava4xB3UpUaR4rLQtcc91/PgOdRQOxDdmwtHGl9/DWSmr7ee2FrQy
	 ZNMGo3oS+ytvFSy66cFKoo4s9lukpDwsFs7TzU0D5cEdk8+/4dV5GhNYGbLsAz6B0a
	 TxL+azkx8pEqpXVNtAZFExyweg8Tr7+9IUJmLyGKjKdTQV/DA2aVWNGeR4OmWI1YEL
	 u+aPexSLdTC9JXrolLvGEaXq+xto7PGamDu9F6j9FwnattHv72ehhfIdhXtxdO3PS2
	 sYiEvUMnXXESw==
Date: Thu, 2 Jul 2026 08:58:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/5] xfs: replace ns_capable_noaudit
Message-ID: <20260702155856.GF9392@frogsfrogsfrogs>
References: <20260702093324.127450-1-cem@kernel.org>
 <20260702093324.127450-9-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702093324.127450-9-cem@kernel.org>

On Thu, Jul 02, 2026 at 11:33:23AM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Now that capable_noaudit() is available, we don't need to keep
> using ns_capable_noaudit() and specifying the usernaspace every single
> time.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Serge E. Hallyn <serge@hallyn.com>
> Cc: Darrick J. Wong <djwong@kernel.org>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Eric Sandeen <sandeen@redhat.com>
> Cc: Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
> Cc: linux-xfs@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-security-module@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  fs/xfs/xfs_fsmap.c | 3 +--
>  fs/xfs/xfs_ioctl.c | 2 +-
>  fs/xfs/xfs_iops.c  | 2 +-
>  3 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 7c79fbe0a74c..041bb2105ec6 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -1174,8 +1174,7 @@ xfs_getfsmap(
>  	if (!xfs_getfsmap_check_keys(&head->fmh_keys[0], &head->fmh_keys[1]))
>  		return -EINVAL;
>  
> -	use_rmap = xfs_has_rmapbt(mp) &&
> -		   ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN);
> +	use_rmap = xfs_has_rmapbt(mp) && capable_noaudit(CAP_SYS_ADMIN);
>  	head->fmh_entries = 0;
>  
>  	/* Set up our device handlers. */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 1a8af827dde1..374b488f0416 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -647,7 +647,7 @@ xfs_ioctl_setattr_get_trans(
>  		goto out_error;
>  
>  	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp,
> -			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
> +					capable_noaudit(CAP_FOWNER), &tp);

Not sure why the indentation changed, otherwise the patch looks fine to
me.

--D

>  	if (error)
>  		goto out_error;
>  
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 205fe2dae732..ce9f8b8468fc 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -835,7 +835,7 @@ xfs_setattr_nonsize(
>  	}
>  
>  	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
> -					ns_capable_noaudit(&init_user_ns, CAP_FOWNER),
> +					capable_noaudit(CAP_FOWNER),
>  					&tp);
>  	if (error)
>  		goto out_dqrele;
> -- 
> 2.54.0
> 
> 
