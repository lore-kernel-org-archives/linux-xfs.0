Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7656C3CDBD7;
	Fri, 24 Jul 2026 13:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784898874; cv=none; b=MjVq0zOUMtwY/ZHM4OfzBi5I0txzDWgaNTid7Hwhrsb72mBEb2ssALvzAsF/q5+juTlAZkvC6r2fLWy8FYvN8SEXvHzfFlDu5ON2M58IsMNNBLi0WhufRPpTJH7GnPJnM+Y0kGutOx9vzv69FI8gude318pIL3IIgN9AGdsR7Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784898874; c=relaxed/simple;
	bh=vp3uPHdG112SgKxd8a986oZMiBqWhSeCaU25fUr9XoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=btQ/sNHUM+DVkxrfBlpwluTPs48Jaqoop27ZaP3RgRHeIu7jak5wbOVviiDL4A6XcAcEkER5GnjB+PlXO0cVutU8Qk7MFezhGU53xzDMe7u0TnKFOwjIbGueNXAxA6HkEIbuNTDnV/wLymdGH47kgRrSGk7UQMRSP+dcbW++rCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BC81F68CFE; Fri, 24 Jul 2026 15:14:30 +0200 (CEST)
Date: Fri, 24 Jul 2026 15:14:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v13 07/23] fs,fsverity: remove check for fsverity being
 enabled in setattr_prepare()
Message-ID: <20260724131430.GC27878@lst.de>
References: <20260721184346.416657-1-aalbersh@kernel.org> <20260721184346.416657-8-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721184346.416657-8-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 21, 2026 at 08:40:44PM +0200, Andrey Albershteyn wrote:
> The check that fs-verity is available in the kernel is not necessary
> here. Filesystems could have fsverity files even without fs-verity
> module, then truncate will succeed. Previously, this would return
> EOPNOTSUPP if verity is missing, but if it's not EPERM was returned
> anyway.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
