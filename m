Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6862E822
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 04:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733546296; cv=none; b=BUuvRzBeeSmcss9So+S7GFm5sTViOs0DLAZetR9QSehYF9kO95vMW4sM7qtoyyqzub7y5L6ngYym1XLnrUMOoBviTW+OEF+A71N7teoSuysEB0BJe6g2Dr0+Y1Y70AUdIaKGdh1/uyNJLgcrhnVlI01Nb/X2XPi8yF5Jq516KI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733546296; c=relaxed/simple;
	bh=p5ELYR/4tCek+7cbfUba5cnSQ9qSXnB+Rs+pkRk7gqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UoOc6wu/FWNTfhoCRKBMlhhy78YzAT17eOX3m11n2SRwqjkbptVdtCfiHzsfWp+XYDtvqwgt2CGj3fTTs622gJleM6FRDPUKOUVfpdd7jjDTxrhyE8l8AV125Hdtu7H10vXnaFn0z+s/G4+py5tDqJEcKm7i+gW113OTqmZodx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gGtOYXyp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gGtOYXyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49608C4CECD;
	Sat,  7 Dec 2024 04:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733546296;
	bh=p5ELYR/4tCek+7cbfUba5cnSQ9qSXnB+Rs+pkRk7gqw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gGtOYXypNehVLAIgj6Kau/0Sg9p7uYPhTD97aX0mAvMp8/jwR6pFuD3cPhjRHIH4g
	 ZWTuRePrxhusGm72lMlczBQWJ+ecJji1Qtmm0odmtO75Sed91s2bWEJ7IwP0qLQE60
	 jPYOME6kXB2Sz99Nr2TXPRB9ofym1rXVpRy+GKr8N9l4LcEaAut4nX8prdMVSQlG2A
	 nNqycKR5Cnr8lH9hm/s8GrF8s+m585x9AANSeX7QtmmqmydI0sIzitzxfqW4S+dGa8
	 buTQMeaK/NrPNH4So5skK9bXfXF1u/nt3lrRUJFJu8WDmkjLVJ3XIY+O4O4+CwF0iT
	 cmnLcnoAY5bjw==
Date: Fri, 6 Dec 2024 20:38:15 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] man: document the -n parent mkfs option
Message-ID: <20241207043815.GR7837@frogsfrogsfrogs>
References: <173352746299.121646.10555086770297720030.stgit@frogsfrogsfrogs>
 <173352746331.121646.4339047798362935705.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352746331.121646.4339047798362935705.stgit@frogsfrogsfrogs>

On Fri, Dec 06, 2024 at 03:30:16PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Document the -n parent option to mkfs.xfs so that users will actually
> know how to turn on directory parent pointers.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Ooooops.  I forgot that hch already RVB'd this:
https://lore.kernel.org/linux-xfs/Z0fkd5si2ibRhehu@infradead.org/

--D

> ---
>  man/man8/mkfs.xfs.8.in |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> 
> diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> index a854b0e87cb1a2..e56c8f31a52c78 100644
> --- a/man/man8/mkfs.xfs.8.in
> +++ b/man/man8/mkfs.xfs.8.in
> @@ -902,6 +902,18 @@ .SH OPTIONS
>  enabled, and cannot be turned off.
>  .IP
>  In other words, this option is only tunable on the deprecated V4 format.
> +.TP
> +.BI parent= value
> +This feature creates back references from child files to parent directories
> +so that online repair can reconstruct broken directory files.
> +The value is either 0 to disable the feature, or 1 to create parent pointers.
> +
> +By default,
> +.B mkfs.xfs
> +will not create parent pointers.
> +This feature is only available for filesystems created with the (default)
> +.B \-m crc=1
> +option set.
>  .RE
>  .PP
>  .PD 0
> 
> 
