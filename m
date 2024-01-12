Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C750276915
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2024 16:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n4of3+cE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45AAAC433F1;
	Fri, 12 Jan 2024 16:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705077891;
	bh=eL3Nofrhn4Kzwlpr7JZXJng1kgsc/C8hbnQGR4SUDlk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n4of3+cEp1iFD977oxeAG/vmgPBJirLTrqKSMCGZ26eDm23thFTo+bWJnNc2CKqTo
	 S5chtvlWGlwdoK6Nu6RTZiV3gLEAmArD6x4Q4yBs892YTRrjkrddJGHNDIgwME6a+F
	 FOelA/UPHUMu9ZzXNUjr0CZ2dOoRfepcf16J96PGNXbTA4dTILEjeuLfHWCaXlz/Gs
	 kN6h9Tr5ccIfbAdzdxbxY3WQbgVoYOWMIunnVQX2DAI/FMgqUPp+VY4teUrqu3XOW1
	 VgIu9fOXEiR31xPk88Uei+rdcZeoC+7Hgl5gVg8snFVV/WkgvEYNpt6ixmK2Y4PGKK
	 PD8uDC2iO5AHw==
Date: Fri, 12 Jan 2024 08:44:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] libxfs: remove the unused fs_topology_t typedef
Message-ID: <20240112164450.GU722975@frogsfrogsfrogs>
References: <20240112044743.2254211-1-hch@lst.de>
 <20240112044743.2254211-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240112044743.2254211-2-hch@lst.de>

On Fri, Jan 12, 2024 at 05:47:40AM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  libxfs/topology.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/libxfs/topology.h b/libxfs/topology.h
> index 1af5b0549..3a309a4da 100644
> --- a/libxfs/topology.h
> +++ b/libxfs/topology.h
> @@ -10,13 +10,13 @@
>  /*
>   * Device topology information.
>   */
> -typedef struct fs_topology {
> +struct fs_topology {
>  	int	dsunit;		/* stripe unit - data subvolume */
>  	int	dswidth;	/* stripe width - data subvolume */
>  	int	rtswidth;	/* stripe width - rt subvolume */
>  	int	lsectorsize;	/* logical sector size &*/

Dumb nit: the ampersand in the comment can go away too ^

Don't much care either way though.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  	int	psectorsize;	/* physical sector size */
> -} fs_topology_t;
> +};
>  
>  void
>  get_topology(
> -- 
> 2.39.2
> 
> 
