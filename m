Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C413FA5F5
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 18:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786385388; cv=none; b=fCCpmG1DsYACDH1jihwkVjNjF+OCnPZMLoTBGIWgoImxoiy5M6UXSFVSb9lR0jA81/x+nYWmGYt9dIeTtxbo4NWxKHvH8b+kUqoUWkJ4LQ5CCnx4jLK+8IhhTYXi6N3mL2qfdST7vNHUaL2RC2pUwh2HCQ6zoPBZE8Wl7Tn0cag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786385388; c=relaxed/simple;
	bh=vypkzyk1P5vZ+s1Xi4ynpObJLqwGVlbYRwwGtncqLuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EKtxnnDqVRCjYU4BlSxeTUXyBvuXIO3eY2R3yKw6LgM70ndOR3SU3QM4ca+KWpTHBFxX4OPdO27JwRcXe4AbeZv+JyT49RWO+UL+JESMp5q3ar+lEo3VE5NplBzwNZ2H76+SrVsMQsDlMU1W/fp7YB5MneRsuuAwBVP8zmkU9p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gXGmkjYN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gXGmkjYN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BC4231F000E9;
	Mon, 10 Aug 2026 18:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786385386;
	bh=p+smqmcAdmNRNZCENP9EPXPQIVf+GgNp1KLrs1eaUoE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gXGmkjYNxSJq1SMq5Rmsbm51WmAolgQSwjQTN/jUE6PMA8+UsCpSc9bZghoWgT0PM
	 rcTValhoqsJ+8mxdoipvaKsqh6RH0gSVY/TkWUspVDP/OY6pCGAQA8tNR4xZMok0T0
	 NKeQIIlARftzKRx/sJINZuFoen5camgmDRefpe8D9QDs4+kFQ5gc4zU9+pkf/RF5EI
	 zjnPA3oso9sBfArMyIASoINq99cgwAkK/TaPmJxRKoXE1dyeW/FIJvoBiAp2uxj/Rz
	 dkBPOvuiruzH+HOPH0WKIhvAHMESg78UT8LEGoAz2YMwQRiHff0ur40CJeO0SPgqfo
	 iVsPtz3wZL3RA==
Date: Mon, 10 Aug 2026 11:09:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: handle NULL open_zone for merged ioends in
 xfs_ioend_put_open_zones
Message-ID: <20260810180946.GT3556460@frogsfrogsfrogs>
References: <20260810153759.466417-1-hch@lst.de>
 <20260810153759.466417-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810153759.466417-2-hch@lst.de>

On Mon, Aug 10, 2026 at 08:37:42AM -0700, Christoph Hellwig wrote:
> In theory we could fail multiple ioends before an open zoned was assigned

...an open zone...

> to them, and the iomap code could merge them.  Check for NULL not only
> for the main ioend but also all merged ones on ->io_list to handle this
> case.
> 
> Fixes: 058dd70c65ab ("xfs: implement buffered writes to zoned RT devices")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems reasonable to me.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_aops.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 2a0c54256e93..c80f05507373 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -89,8 +89,10 @@ xfs_ioend_put_open_zones(
>  	/*
>  	 * Put the open zone for all ioends merged into this one (if any).
>  	 */
> -	list_for_each_entry(tmp, &ioend->io_list, io_list)
> -		xfs_open_zone_put(tmp->io_private);
> +	list_for_each_entry(tmp, &ioend->io_list, io_list) {
> +		if (tmp->io_private)
> +			xfs_open_zone_put(tmp->io_private);
> +	}
>  
>  	/*
>  	 * The main ioend might not have an open zone if the submission failed
> -- 
> 2.53.0
> 
> 
