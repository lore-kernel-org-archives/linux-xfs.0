Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190EB1EA7CE
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 03:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773372496; cv=none; b=IpotLeS+aG7MPV88PcoRBul6tKmNqKmIrfgskX2+UCG18vxEmn1abDfEIGNEloX5kgW5ij/QNBv4+RaDEp6+PlAWSl2OCIeQC0oAncEoWItDcL0LsZUa+FK+031d/FqSF+p0s6QxbCGhG4WNWKxcJ/ZWC5W8aZaVvgsJ0Fo7gL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773372496; c=relaxed/simple;
	bh=bBk6XEnTHc4W6aKuJsrYOAKw4q4YA/OVzWQqpso45h8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SgKPDQgqgJKA/lfraHBAlXzrxW4Fedj6m3+fLyohWoQGg/AhZDJNlep0/3EkgbXwwGuW7ecFB0mYcx39KCF9x+Yan27W/0+rWTSM+h6XGSxooqRNk3DgT1Mgdt3ct0sC9tKKmBj+nUrkrAnX6FDNAET9joaH0K9IKBOrD4F7OMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Je3arD3w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Je3arD3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB092C19421;
	Fri, 13 Mar 2026 03:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773372495;
	bh=bBk6XEnTHc4W6aKuJsrYOAKw4q4YA/OVzWQqpso45h8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Je3arD3wEHWKsCSXCKjec2mWo6aYmADypqysSzECCYoyL3ZRs4L2hUn3B/uSLKbbP
	 qE+eYjDMss34Fqv/N9KqXQIn3VmxA5Zkde7KJPe5lMZyy7y4nOERP2alwT0msyHayo
	 ssMBXEwLfkNKH3NQZZ8AuliEOOumguF9D7ACmbjCDSiJB+6PymnpQxS30ifzGoBlYW
	 +L5Ad7UQHsdd5tJO6XbEosKlGgaA1o5Q/81eawUg9144G1F68Yiz4ULQXexvhYq9GG
	 oIJmJthN9nvNrBeXJ1crs/93+Ky1TAzjBEUotLdOsqL03COYE9s1lsBwRchKh5NRc+
	 wiaMZVH3iJx6A==
Date: Thu, 12 Mar 2026 20:28:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wilfred Mallawa <wilfred.opensource@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Alistair Francis <alistair.francis@wdc.com>,
	Damien Le'Moal <dlemoal@kernel.org>, linux-xfs@vger.kernel.org,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: Re: [PATCH 3/3] xfs_io: report rg_writepointer in report rg_info()
Message-ID: <20260313032815.GL1770774@frogsfrogsfrogs>
References: <20260313002456.3823811-1-wilfred.opensource@gmail.com>
 <20260313002456.3823811-3-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313002456.3823811-3-wilfred.opensource@gmail.com>

On Fri, Mar 13, 2026 at 10:24:56AM +1000, Wilfred Mallawa wrote:
> From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> 
> If the XFS_RTGROUP_GEOM_WRITEPOINTER field is set, then print the
> writepointer in struct xfs_rtgroup_geometry.
> 
> Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> ---
>  io/aginfo.c | 3 +++

Looks good to me!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  1 file changed, 3 insertions(+)
> 
> diff --git a/io/aginfo.c b/io/aginfo.c
> index f81986f0d..978f0f3b8 100644
> --- a/io/aginfo.c
> +++ b/io/aginfo.c
> @@ -132,6 +132,9 @@ report_rginfo(
>  	printf(_("Checked: 0x%x\n"),	rgeo.rg_checked);
>  	printf(_("Flags: 0x%x\n"),	rgeo.rg_flags);
>  
> +	if (rgeo.rg_flags & XFS_RTGROUP_GEOM_WRITEPOINTER)
> +		printf(_("Writepointer: 0x%u\n"), rgeo.rg_writepointer);
> +
>  	return 0;
>  }
>  
> -- 
> 2.53.0
> 
> 
