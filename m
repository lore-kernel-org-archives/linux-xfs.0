Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52AA22DFBA;
	Wed, 15 Jan 2025 06:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736921182; cv=none; b=mpHcVXVdVfDZ6xaG+0aNibxVDRtRKSao9WYsEjPCut9DCLqqiv8m1SpC9f2hZwKleweZ3mR610DFuC5/2bbYNWUbly9IKty+Pk8ZeLm9flwhBX1FaO9sxDX1QZO2hX57M1W7AXS/EiHjQ1wcURejUoSbHbnCbkIFJrJ9nk1KFu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736921182; c=relaxed/simple;
	bh=7bl7ngTc2MzHAI5STZOlAAow1isPWYdrcCsLLwMG3PE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Apu+P7XMBV7UPj7tJPM+ECGQp0DYWVaO3cx9q9jK5Pju1eSzRay2ZEwXSQLviRnjjU0Cs6kEu8nxOXNw114DERUuUWJpxzn0FPck8e0ZWZf3uF0KbF/+W6nrJ6Da1nUb9pLHLWPN2oTpWLeERWmMdLSEZqZ8lZEY6vjQIW2727I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D18E868B05; Wed, 15 Jan 2025 07:06:15 +0100 (CET)
Date: Wed, 15 Jan 2025 07:06:15 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, hch@lst.de,
	xfs-stable <xfs-stable@lists.linux.dev>, stable@vger.kernel.org,
	david.flynn@oracle.com
Subject: Re: [PATCH] xfs: fix online repair probing when
 CONFIG_XFS_ONLINE_REPAIR=n
Message-ID: <20250115060615.GA29387@lst.de>
References: <20250114224819.GD2103004@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250114224819.GD2103004@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 14, 2025 at 02:48:19PM -0800, Darrick J. Wong wrote:
> index 950f5a58dcd967..09468f50781b24 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -149,6 +149,15 @@ xchk_probe(
>  	if (xchk_should_terminate(sc, &error))
>  		return error;
>  
> +	/*
> +	 * If the caller is probing to see if repair works, set the CORRUPT
> +	 * flag (without any of the usual tracing/logging) to force us into
> +	 * the repair codepaths.  If repair is compiled into the kernel, we'll
> +	 * call xrep_probe and simulate a repair; otherwise, the repair
> +	 * codepaths return EOPNOTSUPP.
> +	 */
> +	if (xchk_could_repair(sc))
> +		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;

Stupid question: what is the point in not just directly returning
-EOPNOTSUPP here when online repair is not supported?

