Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D8E42980B
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 09:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791191236; cv=none; b=KEb4j8iNCNvTgcKI7DjKok006JddSs17/DHeOl0vCCYgfhjRoR2YvuJa4ZFOZc0GovRrL5LUxsKgP/oEbdMjSdGlBem3iCrmzk1Jt6C4I+uEQ3CkTFRD3MEaxVV8Du2STzhouMRVPfno9jH468qoJ1lZbi/unQgmjGWD1TCGR98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791191236; c=relaxed/simple;
	bh=chut492ipdBm8PkncCvbAYaFgRYC8lYAyzI6kReDlnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s7dsUKdzm9E+85oYZLhYavT8f9rjUaCvyz82VrgpPloIQhHOzsDW0TfHZnCzvMZX4BIBLtzvGIsPceNNlnvFbFU6R3G8o/7BZBkA3bXIw8A684nGX7LhsPGBmVvzoJQT6BDBAkDW/KDJYvZjCO98VjyKD9jJIoL6choaxIdB55U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XwsrgRRO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XwsrgRRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6401F00893;
	Mon,  5 Oct 2026 09:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791191235;
	bh=sanBq0Lw6W8UIzIz/9GFGJqJPRqGqT7fjrfq6YSN+C4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XwsrgRROU3c6Mk9S5AWmnJzaWXrD04J/8Ja7FC3TVsrwBuInuvOSxtSEWBd0Of0LI
	 PDpgekHKUbDegK7240lpViv/ImECNuHTmGMVVzjnkZIAqIW03N4ZswI6q+My5Ur9bF
	 0BHMz0gWCp5lMYa1h/MnocNu+PTmvOpj0775QC4Fzd0yo+Qpgp+5vvZ41g8Mia+9+m
	 DfF6beZRGSveKNQb4iEYHZ5Nv3gAiMTleVMLzWZUQuOtUjGyxYdQ/IY14I8RAEMbBN
	 2UJ3gkh58/weV+IY2rgcbXAusv/gFU+ooCYKcDclgNAEjSgZPtwjx+rQRAhf3c9eMj
	 AdfmSKavPICTA==
Date: Mon, 5 Oct 2026 11:07:11 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: clean up xfs_fsync_flush_log a bit
Message-ID: <asNoryoMK0f_gI_w@nidhogg.toxiclabs.cc>
References: <20260925151543.3382123-1-hch@lst.de>
 <20260925151543.3382123-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925151543.3382123-2-hch@lst.de>

On Fri, Sep 25, 2026 at 05:15:36PM +0200, Christoph Hellwig wrote:
> The log_flushed parameter still fits on the previous line, so move it up.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

No brainer.
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_file.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index dd6d2e08faff..1eabd436ce59 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -117,8 +117,7 @@ xfs_fsync_flush_log(
>  	if (!seq)
>  		return 0;
>  
> -	return xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC,
> -					  log_flushed);
> +	return xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC, log_flushed);
>  }
>  
>  STATIC int
> -- 
> 2.53.0
> 
> 
