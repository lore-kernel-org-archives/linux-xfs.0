Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941143A4F2E
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 09:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773134658; cv=none; b=jxsddztZ1vo/5ft5A30T1Sg6MJS7TleERV4188egVytyl6pEe2hdq4K2dYqZNbpkfjOEhKOjpHW3amlPD62KuSgrZ6e4381ORAxKTLFF076b/X0jyVDjn6TFMdJ8O6C2rDXArUjuzfEg51Zsw5LHHMZLO6L7n/XVH16Yld7iXxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773134658; c=relaxed/simple;
	bh=FcFucGiq/hVKNmD57hoHfqkB+RR6L4RW/aktEhc/gso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ie6ahLHyuSSLnYt+uGbxlaltI1WLR/ML4Lpipv2IffqIdbV1JydF93L6RmTVmwZ+UVbVwSFRWo3esVON7ffR+gn8ZAnuaore87q/zOKWY9ajFK9JD/tJpChHvJoPGsSaVhdm62AyZ/5ilu0yaBFDtKbHEV8zSUKuu/ib3rkcDvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RtIjcba7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RtIjcba7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=I6otsbb7ZFLq5ti5w5cWUr5usjt/97WxSyFx7wpXOBA=; b=RtIjcba799mSQlA7vHEpVbAJCQ
	lq5l+wkldwvjmVA13Uyz4iQHn0JNdqp2IfokHOLsDW+yN5ZdF484f6zVbr6mhTFdQ8u9ZT0a8UTmu
	LrPUe9nKwvLS7PiuqE+0bUXWVJiS9YVqR9tqxViEwaJw2dexrdrrk6Asmy6fyEmZdCTpUW0JEH5jC
	Cvm8B6Exsq6KB7kfzW5O7F8bAy4bsOWQ+PEqjliSbLEqaqpjd85IUuGpTIbDy1ifQHIomCUrMJ8KK
	G0NecU6PLi6S0eVMySN9VFhkZISG84VSmRQUtp6f/wo+PamalR9UcWeH70C4uhqauyJJHU/8no7xz
	NbxsxOVw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vztK0-0000000951A-2D9t;
	Tue, 10 Mar 2026 09:24:12 +0000
Date: Tue, 10 Mar 2026 02:24:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/28] libfrog: add support code for starting systemd
 services programmatically
Message-ID: <aa_jPHPfYM1wQwvW@infradead.org>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
 <177311401522.1183235.13255430360161493359.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311401522.1183235.13255430360161493359.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +static void
> +close_fds(void)
> +{
> +	int max_fd = sysconf(_SC_OPEN_MAX);
> +	int fd;
> +#ifdef HAVE_CLOSE_RANGE
> +	int ret;
> +#endif
> +
> +	if (max_fd < 1)
> +		max_fd = 1024;
> +
> +#ifdef HAVE_CLOSE_RANGE
> +	ret = close_range(STDERR_FILENO + 1, max_fd, 0);
> +	if (!ret)
> +		return;
> +#endif

ret is only used to check that it is zero here, so maybe do away with
it and avoid the extra ifdef?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
