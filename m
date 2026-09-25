Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA3C501F4E
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 22:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790376460; cv=none; b=DBcuuB/HKgAAG5C4SMRRNq5/hUX7VLL6vOmBYjswFBgfTUGmZba52/ALc8S2zNmgwdLK198JewkG+TxViNagfoyifrQvuZfZE8FpDNTi3kt0IH1N8/RowLUQvsum/SIu7WBa1RhH2Zrf+RH/Fjf/rMlFc0EmgPrb1auCENktqCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790376460; c=relaxed/simple;
	bh=zF25L0LniUr8bxC3cZ5dr0k83CIyziLwG0WpsoW9SIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u9qzCf8EYObyj/dd0PPu8Z4+k4eeMHCoXKNhyj7QF+YsLSMz4FrzRf3sF4CeWQVJ22RVHYppG74YOHgxlAZnS13Uw21GHh9tB8xgvHLu0kLYtdMrO2CnHd1Clw2aWWysdREJqaMRQ9h8kxs8ofC+FKZU1aK+c7F5gDKJNVKSDgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E0FR/IT6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E0FR/IT6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 282F01F000FF;
	Fri, 25 Sep 2026 22:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790376459;
	bh=136WpbZRcBydJzEpquEh8GbEdf67Y5DQxBDzY5JqmS4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E0FR/IT6RvfeQruGo5pGbeagqe7EvZGwk7d479trUh3DR4TtQtb8/71Po+6zFHAAe
	 YvMK4S4EQJBNM4MoN6oZrAU2eenoM9KS3/npctiX8TSNZdIMbWe6aWDRSgGAdEQycb
	 uBSKzGD38y0FM32Sl1IEaIpYx5bY085W7x2AlZ9vmdj3NsSSnicngeufAgNALyAt8A
	 /MmG4Ezn9KLehwBUwNN4dZTQnPYHNiNVMhqTRGpCX7RwIQdeF50dX+/Lk4qxX+IaJh
	 87cgmgKFqHfQEOs/FqytJ12FF0bs7xvOgdBrh8dggqun9/FJcsVZQoGBrBPFF1lO0G
	 7DucGinzXuGng==
Date: Fri, 25 Sep 2026 15:47:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs_db: remove a double-whitespace in
 rdump_regfile_data
Message-ID: <20260925224738.GY2705364@frogsfrogsfrogs>
References: <20260925051336.2997014-1-hch@lst.de>
 <20260925051336.2997014-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925051336.2997014-11-hch@lst.de>

On Fri, Sep 25, 2026 at 07:12:56AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  db/rdump.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/db/rdump.c b/db/rdump.c
> index 7fd171a9d53f..a0177e5bd007 100644
> --- a/db/rdump.c
> +++ b/db/rdump.c
> @@ -643,7 +643,7 @@ rdump_regfile_data(
>  
>  		fd_pos = XFS_FSB_TO_B(mp, irec.br_startoff);
>  		if (XFS_IS_REALTIME_INODE(ip))
> -			daddr =  xfs_rtb_to_daddr(mp, irec.br_startblock);
> +			daddr = xfs_rtb_to_daddr(mp, irec.br_startblock);
>  		else
>  			daddr = XFS_FSB_TO_DADDR(mp, irec.br_startblock);
>  
> -- 
> 2.53.0
> 
> 
