Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4561128370
	for <linux-xfs@vger.kernel.org>; Tue, 22 Oct 2024 05:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729576677; cv=none; b=PPm73PSs04FK7NAJkgBTvPwKNrl60iEsdQLlwDx9C2vYaP/mlIHB0s+TGIHqYiyhCLURRJyCvmqNXrmF7O+HMsmLAFIFW784DlJ4Ic/Rr3o9U47dPm1d6uTDkhCtkqvqK/D+m7s4gpLuo3vUXXev26sQGKkHuHgDRC+BHyoK6KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729576677; c=relaxed/simple;
	bh=Zas8expJkue8W+r44Dqkv090hKaW6kV3voLpzlxCweE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bivcT+qmmBNh7jQsiAAGzbRkMxRY69xbJDKSztrf7nIx1ef6Zhy9lw6ZFX+YxE+XpVnN4CuTmY8jqtaS405eY7mtXCHtTZKgN3BuusK9RUqOy6YJ1Q2CiuYFA4G5D8csc8uACsK7rNxxxUJl3xQxtg4GsGLOTdTYk+D+qqXWdR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fhwHI5V/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fhwHI5V/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=f5Rp0ijUKrn+XR1xpX6MswOiVJqEDmk4iAqqJnIkYYs=; b=fhwHI5V/7T86u0VKBEKsIN2I5B
	bedaNlltOdVTdQ6O8QztmYe6M8j4rF8qIQRLIB342BKgh/Vb7yR6IlSWqN6s9vfmD5/+8F3LLq0cS
	oAxS+GkOjhV7ojIY8pDm+8MUPONpwg4tALh2MksJs53SWkhxnWN8p0M7n8O/nqwGoNKn+/e7Ja+M5
	biOKSCaFlr4ruzfoOvXoC432xuyoQBekP60qXaBoglwGpIOzR2GS6+f1l0Zq0TeMob0kRv7NMOjv9
	FMzaJPcFBM/TRBxPqLBXojS9suqBF08BoFUXKHUJEz/ylgqqXt3k9o6WahmKnTlEyN8KNSqT3N7kM
	aXPYSeCg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t37tz-00000009jJo-3oYN;
	Tue, 22 Oct 2024 05:57:55 +0000
Date: Mon, 21 Oct 2024 22:57:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/37] libxfs: compile with a C++ compiler
Message-ID: <Zxc-4zDL1wzyU23H@infradead.org>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
 <172954783502.34558.4926204658396667428.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172954783502.34558.4926204658396667428.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 21, 2024 at 02:59:27PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Apparently C++ compilers don't like the implicit void* casts that go on
> in the system headers.  Compile a dummy program with the C++ compiler to
> make sure this works.

The subject line looks weird.  This is test compiling the public headers
with a C++ compiler, not libxfs itself.  Maybe make this a bit more
clear?

The change itself looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
