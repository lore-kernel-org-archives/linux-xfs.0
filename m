Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5C43515CB;
	Fri, 24 Jul 2026 06:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784874288; cv=none; b=GTxAxuBQA3o9Y/gZn5chffd19FWWRlbrGlav3Ot6s/bIE6BhWbb05OKNvmqgCArf6kqpWgf5DkJCPMuR8CKpKgPVZNv2DVyFdyPlLlBIfs6nchYHQsp/sGD17j9C96Pg/KhF+qMMz4MNoNn2wi4T6f3Z2pt0TRA2AinSubTLh1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784874288; c=relaxed/simple;
	bh=8mHBJ9nNFfD+SGoaOZmrvVAOB7mwn9CU733yVXjsxzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vEQ8TSqX17MCdr6xjI1xMk/HBws8AJgyd39zFY0Y4t90790TkIeVUOKJPTJaxIjLweR+1hugUfW1NnEOfcxYRHAV2w5SFQUnpYl9sVg2V8Z/Zld+IJ+0TfRCtqsWfp+wHQsKVj66dKEkFeiD3b5FEOSDSbhA3OQ86uJz8eEgDBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0E79068BEB; Fri, 24 Jul 2026 08:24:44 +0200 (CEST)
Date: Fri, 24 Jul 2026 08:24:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 20/22] xfs: add support for lazy direct read bounce
 buffering
Message-ID: <20260724062443.GE4953@lst.de>
References: <20260723145000.116419-1-hch@lst.de> <20260723145000.116419-21-hch@lst.de> <20260723210550.GJ2901224@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723210550.GJ2901224@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 23, 2026 at 02:05:50PM -0700, Darrick J. Wong wrote:
> > +			 * We only really need to retry for guard tag errors,
> > +			 * but right now we can't distinguish them from other
> > +			 * (i.e, reftag) errors.
> > +			 */
> > +			if (error) {
> > +				xfs_read_bounce_and_resubmit(ioend);
> 
> Ahah, yes we are being mean and making userspace wait for a slow bounce
> buffer workaround if they mess with us.

Yes.

> > +	/* .../xfs/<dev>/csum/ */
> > +	error = xfs_sysfs_init(&mp->m_csum_kobj, &xfs_csum_ktype,
> > +			       &mp->m_kobj, "csum");
> > +	if (error)
> > +		goto out_remove_error_dir;
> 
> /me wonders if this is a debugging knob and therefore should go in
> debugfs?  Or is there a solid usecase for normal sysadmins to be able to
> control this?

I consider it an insurance again mispredicting user workloads.  debugfs
also is really painful in general, and especially for trivial files
likes this where it requires tons of boilerplate for no reason.

