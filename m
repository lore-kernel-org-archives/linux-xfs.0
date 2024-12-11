Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E4E24632E
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 18:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733941136; cv=none; b=f7zgqalVKZlEgH9XBYqJ51iegApGaO/jYBfSCsRMput+fFmJ1XKetDQWNs2a7AK0Wkn8WyhaG0AgoTOOBr6GznvtHZbnZL/s5yy7oNLE4PqTKsP5PuBT3aKaNGnNnwlJeEQPKJT4IAEkfBUdok2hY5zVqHliebrIo62Rd5TVl+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733941136; c=relaxed/simple;
	bh=lAVFomGCUY+CKdUZbWTKmb0kI9bClVuqCgKW0DqAM/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n6+1ymJRCfVnOvjxV2ndUDopvMoEg9onxdRKep5Xg++JESplJvaRzi+Fzp7NJmyr1oNGAINBgGJmYhtPb6UzGuBDmrSH/5aWzy/dNx8CVNoYFy6w1Li7iYImsmzU6hX5tqHOGV6j7nJnwrpX0khzXdxTs/v2JsqXdKtEeyZ+txk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VNDLHoG/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VNDLHoG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF23C4CED2;
	Wed, 11 Dec 2024 18:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733941136;
	bh=lAVFomGCUY+CKdUZbWTKmb0kI9bClVuqCgKW0DqAM/A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VNDLHoG/HkAPiC0CVKDrnF75T2zeBabDypfQeAX8WVJhaNMmJL71jSK5b/vHyXfiU
	 ZDotBmjBWjSMokDlwO5s70MbrPqNOVZHROxne8KJcpm+Ex3C6ftWTxzmD/3Y9ECDpg
	 mRRlClWesz5ABj0jbsa6gN01PCI7HpmKdIdPZCtc3iynzm63yUovBSSMh2yvitC3u0
	 1MM6MkIoxBfEYM5iwSVoVUsw6fu/SzBQ0blb0SCfwuiok2u01QDnmRDLIGLFPxIUNA
	 fuo/gz7K/rq/4WY4MR6ImXMwc/bGpzh3N6j25m96YPHC6buYMyaUscC0vLR2WFXfLA
	 qYK96nQCi4RUw==
Date: Wed, 11 Dec 2024 10:18:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mkfs: small rgcount man page fixup
Message-ID: <20241211181855.GD6678@frogsfrogsfrogs>
References: <20241211180542.1411428-1-hch@lst.de>
 <20241211180542.1411428-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211180542.1411428-2-hch@lst.de>

On Wed, Dec 11, 2024 at 07:05:36PM +0100, Christoph Hellwig wrote:
> All the other options that require a value spell that out, do the same
> for the rgcount option.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Oops, yeah, I forgot that. :(
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  man/man8/mkfs.xfs.8.in | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> index 5a4d481061ff..32361cf973fc 100644
> --- a/man/man8/mkfs.xfs.8.in
> +++ b/man/man8/mkfs.xfs.8.in
> @@ -1190,7 +1190,7 @@ or logical volume containing the section.
>  This option disables stripe size detection, enforcing a realtime device with no
>  stripe geometry.
>  .TP
> -.BI rgcount=
> +.BI rgcount= value
>  This is used to specify the number of allocation groups in the realtime
>  section.
>  The realtime section of the filesystem can be divided into allocation groups to
> -- 
> 2.45.2
> 
> 
