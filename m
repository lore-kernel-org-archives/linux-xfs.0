Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C8D47F4A
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738902756; cv=none; b=no9SeH7pcM001cBnuErjKSgGjw0s/Als+bVXWduA9vgQD2kZ0UM/XUAoLIyMV9LicVCFUh0/osyer0CfMw03mi8eysdpIB/jpDIxvpTTJsIpb3iQi4/0yolHO1ElzSPwqgNOoSrxVmn7hlKwFmXPKAPam/kZmJgB86zfhFqX6tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738902756; c=relaxed/simple;
	bh=l9FI7uIQ2erThvyAGsDRc2fUT5fYx9dugxiJun1NlYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QT9rSuQhnJnEK4BOkqQVctoTc5NPXtyJmnBpy1/MrZOGvADpDY7RscbXH/bjWbqksI5OrKvn6syutMgk5JDY04Y+8ZklteVnPk50RMDD9+sfudFvJZE6eB5/ry36QDdmQotu776IhRHRI0qKOBA0OxTCAZ50zydtNx6KPBdbw2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=icDHjSvW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="icDHjSvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598D7C4CED1;
	Fri,  7 Feb 2025 04:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738902755;
	bh=l9FI7uIQ2erThvyAGsDRc2fUT5fYx9dugxiJun1NlYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=icDHjSvWWr3INQGPZuWR1sz7NOOFZ38bjnvrqhJsbyYDgTswslMIzX9vcL1OoVd9T
	 DEuug+9RFFbBrTEkOq6fFrBsuzHk+w7cKQ+sq0ouSZDzvpwOdbt4T5szeajuwAizTB
	 DBk+Magsn5cX6wMx4jcvNDJ4jcagT69fvkkqG6Wk40DRpo/P5bVbtmJOKoUw2RXcir
	 itUupGCdZj2EhSaaB1x9fvIwgDMjX8D2MurqZL1JVVlCi0FWvDuRxGxR8CEQHq9H/G
	 Hr+isS1SV8ZG8VKOmfYd3qK2ZjFkubJXXjKcOzarfgWZoA3Lnc1DvSWEiPEwEEa+Oq
	 Cgf6CIqHzlpUg==
Date: Thu, 6 Feb 2025 20:32:34 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/43] xfs: hide reserved RT blocks from statfs
Message-ID: <20250207043234.GO21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-29-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206064511.2323878-29-hch@lst.de>

On Thu, Feb 06, 2025 at 07:44:44AM +0100, Christoph Hellwig wrote:
> File systems with a zoned RT device have a large number of reserved
> blocks that are required for garbage collection, and which can't be
> filled with user data.  Exclude them from the available blocks reported
> through stat(v)fs.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_super.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 5c1e01e92814..34b0f5a80412 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -869,7 +869,8 @@ xfs_statfs_rt(
>  {
>  	st->f_bfree = xfs_rtbxlen_to_blen(mp,
>  			xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS));
> -	st->f_blocks = mp->m_sb.sb_rblocks;
> +	st->f_blocks = mp->m_sb.sb_rblocks -
> +		xfs_rtbxlen_to_blen(mp, mp->m_resblks[XC_FREE_RTEXTENTS].total);

Makes sense,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  }
>  
>  static void
> -- 
> 2.45.2
> 
> 
