Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFDC1AF0DC;
	Wed, 19 Feb 2025 05:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739944560; cv=none; b=AX8MnDu/wMYNDdFVXL2/FCMeCUH2OkX21paL5zplwLyZ4ngT3zeiOIii4jJP4VMSGjX/vOvtPM3vlj2MPTCAGoN+TmMnezcZfx9OkPyxiyGNP2AULU6k3lEHTI0+/Jbtd6cVbk4/4HvvxGAjcfYYrzAKLD6hoqy4cDHAgCLK+Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739944560; c=relaxed/simple;
	bh=ru0yzCk4QYeQ9wqfdVjZK04zJdfKzf4cTtg4GuBATVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rzjfX0uYyaCgFptwQUhIjYPrzbl48ep7IxEt8f8IUadqbGv9lnlOugwvdH7/RogMkzgee5iGCF1dyOTYGlGR3zUjMFbaTwg5ghfK+rNs1J14nkWfTHyI9acMJTld71B2KdSDeMu/5O52r5ROrQp/wFIUdS5B2I9gLMT+eZLur8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b1ASisgo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b1ASisgo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8457BC4CED1;
	Wed, 19 Feb 2025 05:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739944559;
	bh=ru0yzCk4QYeQ9wqfdVjZK04zJdfKzf4cTtg4GuBATVk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b1ASisgojaW8T0ATtZs9QExkUq6Q0n0b9fgi945gPdFa0fmtjraTQC3yrjyKSn5al
	 kxE1f8GLX/g7Boq7KyX6t6EuT7LyB3wgOS6TKRP9szESx/R+PH41atR5xGvfIV3p2h
	 wTaVkZph2i5eNLcrQTRFxVRXapFdS17yeccwArhed86TpdB8sCtj8IvVn2Zv1IAyjG
	 rdCQAs0vY1cdMzAqQBo0Xw4rirSWmKkd9BH7oMnQhHRVJMXlloSn+bpuTQ8uQ08Nyb
	 YUfxJj123HtRBRxNwM38O7TT4xvw49bGxh0+nGaVaanLmelGImhbquACvUDDb+nmM0
	 +MbsfQbd2CPFw==
Date: Tue, 18 Feb 2025 21:55:59 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] dio_writeback_race: align the directio buffer to
 base page size
Message-ID: <20250219055559.GV3028674@frogsfrogsfrogs>
References: <173992586604.4077946.15594107181131531344.stgit@frogsfrogsfrogs>
 <173992586646.4077946.4152131666050168978.stgit@frogsfrogsfrogs>
 <Z7VxSgR8mOUMcQGd@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7VxSgR8mOUMcQGd@infradead.org>

On Tue, Feb 18, 2025 at 09:51:06PM -0800, Christoph Hellwig wrote:
> On Tue, Feb 18, 2025 at 04:49:31PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > There's no need to align the memory buffer for the direcio write to the
> > file allocation unit size; base page size will do.  This fixes the
> > following error when generic/761 is run against an XFS rt filesystem
> > with a 28k rtextsize:
> 
> Note that in theory even just the memory alignment reported by
> statx / XFS_IOC_DIOINFO is enough, but I don't see how reducing the
> alignment futher would benefit us much here.

<nod> I guess its a bit fragile if there's hardware out there that
can't handle 4k alignment, but those probably don't live long on the
market.

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
