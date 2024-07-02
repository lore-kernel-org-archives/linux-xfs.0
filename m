Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14DB12EBE1
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 19:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719949701; cv=none; b=gpf46ns1UjkitS1WCbPUPrTbSklv4ERMwWyLH06QrHjHRfr///IZuk9ZpqKkVeC3kl4NnUyBEpy/B+wz5YgO/7o38dN11zQTtSu6eIvhQQ9NpQveiFb/h2R6rybOjafwvowJciiF5vvniMUsyARngpS0JnEm1qVP/A7IiFxRK5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719949701; c=relaxed/simple;
	bh=QzdqltlcEBbQp3TrOhPFPZrrFV0ZFnQFW1Cl0zEh4Tc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HR3vLTQmNLfhGgerDkfi1wyLlL3CcSK4IBucgZH4D2MjlPIJUgflUV3bo/Xglg+ozZK317GhxlUfIdpLPCbEA3JmCFA6E9cQlc9gfajGaNLJg1Wkw7tqtVXTCcLVIxBYzRnmCHca9x7Bc37PQj+BD1lpQzfDgjr47g5Lp8H5ipY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QpNKmRwd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QpNKmRwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3452DC32781;
	Tue,  2 Jul 2024 19:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719949701;
	bh=QzdqltlcEBbQp3TrOhPFPZrrFV0ZFnQFW1Cl0zEh4Tc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QpNKmRwdmxSCZIQibPfBiGGj7kfh8JL5rgd2nbcBssUhEeEyq9yHq2/z5PX3h5Xyk
	 saqzEGsDIkR7xGI4WyUx5DuhaJvwOos221IhTOlFGh/DduuF34AK+MBn9c4uH8swcK
	 n6BQtr2yl8nbcEgxswqd63LQcHWsSHAoav5yOQgDm2Lu27AIX/HfyF1p3eOiW6Tofq
	 H9EyFK4u6P5AkCOWGDsqlvlSC7OEO9cVOEZJDLH6tbrSV3t9IQw4iZINCHk9srG0Tj
	 ZLAjE0Mtj0eLuRenV/UVzlrLga8o0QJ4dTRqdwFponM0+3PXP2QGUd7KDUbemYucoB
	 kGIiZNS/IHQoQ==
Date: Tue, 2 Jul 2024 12:48:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] libhandle: add support for bulkstat v5
Message-ID: <20240702194820.GN612460@frogsfrogsfrogs>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs>
 <171988116756.2006519.10115349070206614078.stgit@frogsfrogsfrogs>
 <20240702050920.GC22284@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702050920.GC22284@lst.de>

On Tue, Jul 02, 2024 at 07:09:20AM +0200, Christoph Hellwig wrote:
> > +extern void jdm_new_filehandle_v5(jdm_filehandle_t **handlep, size_t *hlen,
> > +		jdm_fshandle_t *fshandlep, struct xfs_bulkstat *sp);
> 
> No need for the extern here.  Same for the others below.

Ok, will remove.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
