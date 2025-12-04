Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8CA1DD9AC
	for <linux-xfs@vger.kernel.org>; Thu,  4 Dec 2025 17:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764868918; cv=none; b=V+NZfHT/EzGDvIkPbBLs6u+vkxJquIt8u7bTWavtl88LsR0MPVCv+DYZXbW5Pjk2LUfrdiNUaLq4473n6lWvkPwC3Kg5X+VIqSx4/BGDI757PtircKCx4Cl7G3LXD/n4zco8PSQDrsxOSqMbqZeRv7w+tZCdfH73UVmO63S0SVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764868918; c=relaxed/simple;
	bh=TjiVKYpt3D6KeQB+RPpB4oez2TsbPB7zzzrC7tSuC40=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BYOtD6nMc500GLhcCRYbr3IM6tI2XEBANRyES1LhOCmFDpr7o9z4YU6438RSiG1QtWHvWqcrcg7Xt68+0sqmaackhRRSlxdAzAfsTEiMqELdvIxRvOrCJ4scocGXv/x4SYhq1LOwsqthXA0gqIIwWlJQ+R3Og0ACOBu/GsX/wzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c2SjoPlF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c2SjoPlF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9376CC4CEFB;
	Thu,  4 Dec 2025 17:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764868918;
	bh=TjiVKYpt3D6KeQB+RPpB4oez2TsbPB7zzzrC7tSuC40=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c2SjoPlFZbvXJ+IwgxWUIbSVqQH8jHRBPCFfkmDTDxxqrJT9WXMeGmvcE7IGcS6HY
	 sWJD8uioVQm9OiP/MnxuOrLCglOtKqp5BF5yyu90H4jca5UbK7GPmnQt7EJilNzVOs
	 QKneoV3BHfYyatgSj2QTJaWjYhd8e48iGKh60m+O9uxpfHuONJ+4axaDvVGApELs0X
	 a/JOS+o2pEvPH+HP/kg/JzyS5yELuiqiUdnkZIANVsOklzC97gEMScyE3v3DAmWSSD
	 UEIKAKIF+oKpTGHPdoFYmHyIWRfjESMF7CHVYO8WVEkTArWutK3Lfq2qwMUAUSgq6g
	 mtFsjfRFktShg==
Date: Thu, 4 Dec 2025 09:21:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH, RFC] rename xfs.h
Message-ID: <20251204172158.GJ89472@frogsfrogsfrogs>
References: <20251202133723.1928059-1-hch@lst.de>
 <aTFOsmgaPOhtaDeL@dread.disaster.area>
 <20251204092340.GA19866@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204092340.GA19866@lst.de>

On Thu, Dec 04, 2025 at 10:23:41AM +0100, Christoph Hellwig wrote:
> On Thu, Dec 04, 2025 at 08:04:50PM +1100, Dave Chinner wrote:
> > fs/xfs/xfs.h is just a thin shim around fs/xfs/xfs_linux.h. Rather
> > than rename it, why not get rid of it and include xfs_linux.h
> > directly instead?  I don't think userspace has a xfs_linux.h header
> > file anywhere...
> 
> Fine with me if that name is ok for shared code.

Why not merge the xfs_linux.h stuff into xfs_priv.h?  It's not like xfs
supports any other operating systems now.

--D
