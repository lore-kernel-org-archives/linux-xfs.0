Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130E225FA29;
	Fri, 24 Jul 2026 06:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784874828; cv=none; b=dpZ6RAWfDwZXgY+8mtEkvBMcWP1vOUcqk45uv8gKTiLWZo3WMgDQtmAVHrvTL0fUMGWtfLZ2XWglH4kCnM9hoWcYu0PXTZfz2+TpmN6Z89AqJazO+PjM35356oLvGlJnh1oJCaeXPzqGWGpAF4gVQEsWtmjO+gfQFSAeQE1IRMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784874828; c=relaxed/simple;
	bh=SiyHAQhM8dmCfvRb20M+fB3NFNIf4cWorvNhUkLYlws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sHJXpErSqcUtBUHiiiW78+oEdwRZH/mjP0GTnOZFUPING6dUMl70sKimB03G11OfDmH9N2WCjwhbvQok+dgsTl5G+CNy5XxNSiD9Fwy2lZ1I2J584SUXkBYoFufSd7zyqVMra7YZIyWLxqwQQS/l4L4ZKl8Y/fXy8mRgX3kjBck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BFF1A68BFE; Fri, 24 Jul 2026 08:33:42 +0200 (CEST)
Date: Fri, 24 Jul 2026 08:33:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 20/22] xfs: add support for lazy direct read bounce
 buffering
Message-ID: <20260724063342.GA5328@lst.de>
References: <20260723145000.116419-1-hch@lst.de> <20260723145000.116419-21-hch@lst.de> <20260723210550.GJ2901224@frogsfrogsfrogs> <20260724062443.GE4953@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724062443.GE4953@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 24, 2026 at 08:24:43AM +0200, Christoph Hellwig wrote:
> > > +	/* .../xfs/<dev>/csum/ */
> > > +	error = xfs_sysfs_init(&mp->m_csum_kobj, &xfs_csum_ktype,
> > > +			       &mp->m_kobj, "csum");
> > > +	if (error)
> > > +		goto out_remove_error_dir;
> > 
> > /me wonders if this is a debugging knob and therefore should go in
> > debugfs?  Or is there a solid usecase for normal sysadmins to be able to
> > control this?
> 
> I consider it an insurance again mispredicting user workloads.  debugfs
> also is really painful in general, and especially for trivial files
> likes this where it requires tons of boilerplate for no reason.

Also: I'm not particular happy about the placement of this file
in sysfs.  Do we want a misc group, or rw?  The current one feels
a bit too specific, which means we'd keep on growing way too many
groups in the future.
