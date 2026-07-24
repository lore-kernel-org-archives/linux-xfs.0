Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAC42DAFAA;
	Fri, 24 Jul 2026 14:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784902900; cv=none; b=heZdWY20DhPyUYsv/IVhFNCI/nvbp8bV5lAJp7ueI/aFgncziFxnWAY3vGI4E4Ew+3/t4E/1MHOfYbWmNAnYoWjFLKtZu9+YOioJJkxD6oZaiZjO+srQE+2HpFJdvdVNzUVXj2d3bFtNKpkSY49dMEza9sJOjasGHt3Fax4Z/dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784902900; c=relaxed/simple;
	bh=x5tMXceGbZLsUZ2frSrMikaarDSc2u604KCox/otmiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GEEB99BVlwIYDRaQDCadoaYuDwo/eNRfMGbKc1AztnNKq8evEE+RD8QWYSEzQPOzyovxzMwRp50Rdyg4rTaN18dcB4vS98w7Qkr2G2yMnqBINP31RzJ8SAUbR8Rflm4pcaArjpY6YcEy8NWyncB4yKMXJ2QI000lz1xN1sDj/l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bfqTKrQZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bfqTKrQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47191F000E9;
	Fri, 24 Jul 2026 14:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784902899;
	bh=yo68qjongadB1GZqXZprYtsFAZFHbGPoQ+5S7vlZ7+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bfqTKrQZoghsWVyi+N3a1tMHl+uOYqNHFzxanWJM5XT8Mq2ua1dbXs6VjffBJc6e3
	 2Y7FwpnYv0gSI+QpfA+4acSlm/1QRI7FGdDk6a5rxjF8/XLwwhSeuWc9fPOOOdVtFe
	 gZZQDpxnXCzr9T4B3SYJVw/5u+3ZMaNuBqx3Tc/PhS2+aKgh+2/7wx4Lu6bnQRTyXn
	 IGRh1YpWIYvZZEaZWi7IYYopm8m98ahUlSEuubXPt4gn9xl5I1AbSCVZRXc9E7hqCO
	 KeTAaDc8Mf+HRtHgNnIYv/+HDtzAr8N+bAbN3sMBDGLyKAoNheQebkE8aJT5SSv15S
	 XlX7BYRPjj5Ow==
Date: Fri, 24 Jul 2026 07:19:47 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v13 06/23] fsverity: don't allow setting DAX file
 attribute on fsverity files
Message-ID: <20260724141947.GC1876@sol>
References: <20260721184346.416657-1-aalbersh@kernel.org>
 <20260721184346.416657-7-aalbersh@kernel.org>
 <20260724131353.GB27878@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724131353.GB27878@lst.de>

On Fri, Jul 24, 2026 at 03:13:53PM +0200, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Shouldn't this have a fixes tag and go into -stable as well as it already
> affects ext4?
> 

ext4 already checks this, as I pointed out before
(https://lore.kernel.org/linux-fsdevel/20260710234643.GF1911@quark/).
It would be good to note this in the commit message...

- Eric
