Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA6438DEC
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719896964; cv=none; b=YsQakrj92NJQUBPOWPWaxq05A7l2S8wvsku2XNBQSkXWxvS5kUOxiXOPiXXZbedztcbCXN2OXrAaJkgzxU7DSYd/Lvr7LQ5ABAWyksSZiMX4NO9z+CaBlruPzgeqyjx1SHMvh0QvQXCm6VaN/oB9NtNtZ58bI2ilzYfbBbhPzLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719896964; c=relaxed/simple;
	bh=7abLl42vfm9OfmE6F9wQiCsRVUH0ulJoMdDju1ogJXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S0z1zBBZ8Z8+gD/NlQwL1ilAJ4zlgpucIsPi6lsSd/9gwGiFscaUUZr0r83ahYKO6dieM1LN3ll9ro8E1gHU76xTaR/Cslj0KzpNFMj47usXnQ332jVlcMKqe4Fkz+2na1m2fo3LKNCYK149NjTWR5jJLB4IgtShMcPaflXtMdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 53F2668B05; Tue,  2 Jul 2024 07:09:20 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:09:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 03/12] libhandle: add support for bulkstat v5
Message-ID: <20240702050920.GC22284@lst.de>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs> <171988116756.2006519.10115349070206614078.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988116756.2006519.10115349070206614078.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +extern void jdm_new_filehandle_v5(jdm_filehandle_t **handlep, size_t *hlen,
> +		jdm_fshandle_t *fshandlep, struct xfs_bulkstat *sp);

No need for the extern here.  Same for the others below.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
