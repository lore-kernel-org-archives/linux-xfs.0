Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4F1295D90
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 16:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762275335; cv=none; b=UL/QR3uY3cLV19X5uN3dKmItO80IEnPnROXIhoiRrpM12aX2LnxCXUuS9Kin15qaAYwgQAwEhZR/NHgriderWCB5kCpAB3G+MY3xY+Yhxf/g82xetrl5svFn40vT65txF6ibWE0yVu3s8o2BCfJFkswi+GvpwW12Tu1bEln/f5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762275335; c=relaxed/simple;
	bh=NkepNBE1VN9aItCx9nFtx4evJgPP6Tc2SO17AAZfXiY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IXJgbd4piyM1RXR1d+3cVSGvxi0JQuJlH7TT6hg0go1djVnZGBKGjVVLT+Mbg2T/OgbNUGFmKCmK3D4czEirHQdx02XhoYtbn+bAAObCtQcSVicmaSHDwkZoia1REanxdp4/MXvAZLpi2Y9OMrgLgNoVli4OnZUW7ONM4/Ni3tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EuwypYbt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EuwypYbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25852C4CEF7;
	Tue,  4 Nov 2025 16:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762275335;
	bh=NkepNBE1VN9aItCx9nFtx4evJgPP6Tc2SO17AAZfXiY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EuwypYbt38ab+nX+GoGgG8sYXhvbfOL9ZjrdEZ0UU6hLSpvVTWzk5FPIsD6xaifSB
	 j64uCAk0lDuRPDcRsgqWsO2yPcv3b6SwlIF2rBpAburKQ6z549kce3DtC/ElYJSxTr
	 sdK0LviXoCrlHXul3mAxJZ27BUd1PNhFLdhnFH495PgKxrnHa+H4qk0DdG00WWsJiD
	 ieXrOQw8MpFEZnhJpyDe4AC2MBXQTiU2Wy7ekA8WAr2wlzuGIM/wxXZ0y4kIR1WC6T
	 02b74vGpJ6kaEroNHxmQyXtBNlZnRRqLNgEWPDQzk2O33nyqkkLGmMs4rTBKJDA7Nb
	 2H6aHaYTbAOJQ==
Date: Tue, 4 Nov 2025 08:55:34 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 2/2] repair/prefetch.c: Create one workqueue with
 multiple workers
Message-ID: <20251104165534.GH196370@frogsfrogsfrogs>
References: <20251104091439.1276907-1-chandanbabu@kernel.org>
 <20251104091439.1276907-2-chandanbabu@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104091439.1276907-2-chandanbabu@kernel.org>

On Tue, Nov 04, 2025 at 02:44:37PM +0530, Chandan Babu R wrote:
> When xfs_repair is executed with a non-zero value for ag_stride,
> do_inode_prefetch() create multiple workqueues with each of them having just
> one worker thread.
> 
> Since commit 12838bda12e669 ("libfrog: fix overly sleep workqueues"), a
> workqueue can process multiple work items concurrently. Hence, this commit
> replaces the above logic with just one workqueue having multiple workers.
> 
> Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>

Yeah, this also makes sense to me.  I wonder if this odd code was some
sort of workaround for the pre-12838bd workqueue behavior?

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  repair/prefetch.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/repair/prefetch.c b/repair/prefetch.c
> index 5ecf19ae9..8cd3416fa 100644
> --- a/repair/prefetch.c
> +++ b/repair/prefetch.c
> @@ -1024,7 +1024,6 @@ do_inode_prefetch(
>  {
>  	int			i;
>  	struct workqueue	queue;
> -	struct workqueue	*queues;
>  	int			queues_started = 0;
>  
>  	/*
> @@ -1056,7 +1055,7 @@ do_inode_prefetch(
>  	/*
>  	 * create one worker thread for each segment of the volume
>  	 */
> -	queues = malloc(thread_count * sizeof(struct workqueue));
> +	create_work_queue(&queue, mp, thread_count);
>  	for (i = 0; i < thread_count; i++) {
>  		struct pf_work_args *wargs;
>  
> @@ -1067,8 +1066,7 @@ do_inode_prefetch(
>  		wargs->dirs_only = dirs_only;
>  		wargs->func = func;
>  
> -		create_work_queue(&queues[i], mp, 1);
> -		queue_work(&queues[i], prefetch_ag_range_work, 0, wargs);
> +		queue_work(&queue, prefetch_ag_range_work, 0, wargs);
>  		queues_started++;
>  
>  		if (wargs->end_ag >= mp->m_sb.sb_agcount)
> @@ -1078,9 +1076,7 @@ do_inode_prefetch(
>  	/*
>  	 * wait for workers to complete
>  	 */
> -	for (i = 0; i < queues_started; i++)
> -		destroy_work_queue(&queues[i]);
> -	free(queues);
> +	destroy_work_queue(&queue);
>  }
>  
>  void
> -- 
> 2.45.2
> 
> 
