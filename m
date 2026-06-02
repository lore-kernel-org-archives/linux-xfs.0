Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCEC3932F0;
	Tue,  2 Jun 2026 14:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780408869; cv=none; b=PciytJ2CA7B8sOuoFz4hPagSVHlMfKL5ZJ9QB+gsFz7DZfnEguX/6uMs5KTJYKwMIj7xalQU8QznPtBw4XEbs/pkcLTVM1HhpkQLBhHhTWvgAYEM85UH+679K0JJkFHKjr4IJtCPcX70ltIHKfwQgcNMY/kI77Tor2D1QbhwNwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780408869; c=relaxed/simple;
	bh=HICMSlqBz9lP3Vcxswiw6mBgi6DKmmz+TF3+lWBdels=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OeBavYxaWejmRmglncQVmHji/BMMgyhaqp8OuXHfzpN6qBvX5Kw/OUv8yvLxsW9+i11UaueGbRclgt81R84n3EA/G3WAcJkwat/bNkUz0yjJLhLeD35LR9icID+8xXKw2MD5hJrLdaAskscwRK/LwH+6szb8388XmKHdWUBxUek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nUDT92wz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nUDT92wz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2621F00893;
	Tue,  2 Jun 2026 14:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780408868;
	bh=yRRAhPc6LK2UaiVusmP0q3NytyamS5Qy7GEygynMdA4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nUDT92wzPLj8vBf9Np56cVtJplqaSVECxY79KF//9Z/6IaC+XivAoTQ4m9ubRbThj
	 8Tv02TFVJL1UkWM3zDHZlorOQtyv2siyxIcWR5sodKJk6C0iHzioBJsfN4HUAx8voH
	 vbmVZseKzdVYAiYpnzuadr8PCFzjNfrFMD8xsWBt7nryMFA3D2nUqYqdiq00wYYieL
	 v/zE7LG5hkfdswoIZxiByCEZ/hCULutwVDQpasI8gqGOsOdVCfNXjRnuwe2ADzM3xU
	 x7HrZH/Nk+W26KQ0CThIzLlTM362JX5IjDIhd1mHHKELeeDqCY7+ctu2CCJSxFN7JO
	 e3fnv+4wQUIQQ==
Date: Tue, 2 Jun 2026 16:01:04 +0200
From: Carlos Maiolino <cem@kernel.org>
To: William Theesfeld <william@theesfeld.net>
Cc: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfs: convert dquot iterator map allocation to
 kmalloc_objs()
Message-ID: <ah7iCVsVJO8jpzlS@nidhogg.toxiclabs.cc>
References: <20260601191858.608270-1-william@theesfeld.net>
 <20260602112508.25581-1-william@theesfeld.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602112508.25581-1-william@theesfeld.net>

On Tue, Jun 02, 2026 at 07:25:08AM -0400, William Theesfeld wrote:
> v1 converted the open-coded kmalloc(N * sizeof(*p), ...) in
> xfs_qm_reset_dqcounts_buf() to kmalloc_array().  Per review feedback
> from Carlos Maiolino on the v1 thread, switch instead to the

Me? Wasn't Christoph?

> kmalloc_objs() helper, which is the preferred form for new XFS code
> and matches the style of recent conversions elsewhere in fs/xfs/.
> 
> While touching this, also drop the __GFP_NOFAIL flag and handle the
> allocation failure explicitly by returning -ENOMEM.  The function
> already has callers that propagate errors out of quotacheck setup,
> so an early -ENOMEM is harmless and avoids relying on the allocator
> to retry forever on memory pressure.
> 
> No functional change for the success path.
> 
> Signed-off-by: William Theesfeld <william@theesfeld.net>
> ---
>  fs/xfs/xfs_qm.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 7bd15d9e7..83e8d80bc 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1170,8 +1170,9 @@ xfs_qm_reset_dqcounts_buf(
>  	if (qip->i_nblocks == 0)
>  		return 0;
>  
> -	map = kmalloc(XFS_DQITER_MAP_SIZE * sizeof(*map),
> -			GFP_KERNEL | __GFP_NOFAIL);
> +	map = kmalloc_objs(*map, XFS_DQITER_MAP_SIZE, GFP_KERNEL);
> +	if (!map)
> +		return -ENOMEM;
>  
>  	lblkno = 0;
>  	maxlblkcnt = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
> -- 
> 2.54.0
> 
