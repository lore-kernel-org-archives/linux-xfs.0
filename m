Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6D42EC0A2
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 15:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785252461; cv=none; b=GhqLilcFp7L6LGl0ZYihwNP+JnP00FVG1Ji1SNIbGA23Ers2NuoaeGZ9U7DMoDT8eq1Uj4tnSK9fXnyItpY49UJSs1SM4VBypMAgcf5Q3ig33ejH7FSUvmIfmuy1xYwWOskF3unMdiHzgIV9JLycq2EjGGGzUpaCIDyq+5wZrWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785252461; c=relaxed/simple;
	bh=JJPfB3HjPWFvVc6MLCP02KF0/79roPOc8Q4xxMjk7Z4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hF8n7FLfaB7dQWAoEIFpA5hEL+6e6b2YtLR4MzGy0ZAq66W7S+E8LE3uTTQ8zzfJZyFuyAQwtukegziDtwckyJ1NUNjJx7DieBlOOCJuCw+tDd6OHDuCgWqOnS6qZdaZu3DHfiSzM7TSsZFs4scyKuPT42olbuCQfwfxN5WN3pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F2q7qlPl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F2q7qlPl"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5757D1F000E9;
	Tue, 28 Jul 2026 15:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785252460;
	bh=+0K0bzi/EuHubk46PA2o9n1EZMKfRaPQKojWjYoatb8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F2q7qlPlgN0tY58k825XUYTozJoLnoVae8gc5p2ZcnetjbYWRnlvXlzuVosegtkDy
	 Sr03b6ICZm9yNTzj0ajn+TdfvBVtE3gfvrv27kcniJTMPZlMwM5K5UxW9p0L6pIOoK
	 gviRghW9Qef13rPYFZv6exVr5bCL2pNlvzAyfuFlA3Jh3Jea3k4mxo7H12GCOb3kQn
	 geVBuuE9zsCXbjC80yySrTwVV4ThtVGQVKBw8t/nCuUa4d6JGWggyq+9G0vLrhCy+Y
	 +lUQqKJoFAVhHdLUoAQ0UjhsbTbfteKEkZPlej6K0Rj4KYnxVhQelElyE/5Ey6apY1
	 izxGs4va5PMtA==
Date: Tue, 28 Jul 2026 08:27:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Cc : Hans Holmberg" <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: add a comment to describe xfs_gc_bio.victim_rtg
Message-ID: <20260728152740.GP2901224@frogsfrogsfrogs>
References: <20260728080650.1777545-1-hch@lst.de>
 <20260728080650.1777545-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728080650.1777545-3-hch@lst.de>

On Tue, Jul 28, 2026 at 10:06:45AM +0200, Christoph Hellwig wrote:
> All other fields have comments describing them, add one for this field
> as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Excellent!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_zone_gc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index e4f70e024632..e2bad83b10f6 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -103,6 +103,7 @@ struct xfs_gc_bio {
>  	/* Open Zone being written to */
>  	struct xfs_open_zone		*oz;
>  
> +	/* Realtime group currently evacuated */
>  	struct xfs_rtgroup		*victim_rtg;
>  
>  	/* Bio used for reads and writes, including the bvec used by it */
> -- 
> 2.53.0
> 
> 
