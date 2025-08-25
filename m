Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CFE2E92DF
	for <linux-xfs@vger.kernel.org>; Mon, 25 Aug 2025 11:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756121631; cv=none; b=GHZnnWmNVAv0YkGNPPCy/t/KUx6JkjwIubQRLF5us848iRMIm5FYHLJdk2WscvHKzciBLLeCl5DCz5hIwTlSO3FhIq9bkPath9Lgwwn3u14dGIqsj08yBOF2JRWSjbVS5s7mnldLz9eFxuMNQNOvq3lPIRjBVoXTcx5DuQl9nW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756121631; c=relaxed/simple;
	bh=/d+swR/dxd3DyI9A2LxayRowhDBduVB7AvKFvmekUMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cifs3bCPor5NLmc13V8kyXz54FL38xIV+0htq0lyAbUgv2hYfwLHo+G9SrasAnjx0W4ubxOJ+jcD06OHSXtQJ9VeusOsuNxRq9Xg2RMTP8bKwU3nSCpScnmScQsIScNcROdh5Gc+OoqPnCjD3FNqM+VL41P8XAOvqRv2UEymjSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6BB8868AFE; Mon, 25 Aug 2025 13:33:45 +0200 (CEST)
Date: Mon, 25 Aug 2025 13:33:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: implement XFS_IOC_DIOINFO in terms of
 vfs_getattr
Message-ID: <20250825113345.GA5897@lst.de>
References: <cG84V92R_rvXt_xDUKDRAZU_E6E69atqXw04uiv_deBLGkFtMFj_XYvumw4sZh6EOFZpn33yItQ55aPJs5hNNw==@protonmail.internalid> <20250825111510.457731-1-hch@lst.de> <fhpfunzcfllg2k7qslumh3n3vsac3h3aaq7k4l6vxcxhdqmeqv@3rb266uid7bx>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fhpfunzcfllg2k7qslumh3n3vsac3h3aaq7k4l6vxcxhdqmeqv@3rb266uid7bx>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 25, 2025 at 01:32:23PM +0200, Carlos Maiolino wrote:
> >  		/*
> > -		 * See xfs_report_dioalign() for an explanation about why this
> > -		 * reports a value larger than the sector size for COW inodes.
> > +		 * Some userspace directly feeds the return value to
> 
> 		Some userspace /tools/ directly... ?

Tools, programs.  Or just userspace :)

I don't really care which way.

