Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01795200BBB
	for <linux-xfs@vger.kernel.org>; Sun, 23 Mar 2025 06:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742711368; cv=none; b=NkOOR0uaQh67ksGsQi2DpyR1wzX/cFX1pk3cW6s4HsWlkH2FsxIEJBNK76ZgAq40Ln3ug1g7rimp1gsWW1XTOP439oB51mdPgmLV9n2SAROUXKwl9g+7U3yRQyMdL4O2lJRzTZgn+at+OXQAUGKKFtLsph4iwe7S4lgTU9lqAS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742711368; c=relaxed/simple;
	bh=+qruxh0MrqBxAEjADb3TUIg2JRhT+YtYs3XcqsE2AaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UVhAL23BgewVzlqoIjyeBpRq/xkZVDfA3yvX+NyU2DbiMlkrjnIjOeXJiaYhHEJOMUjUrItWtyFFPn29Oj0yZ+I763zqLawMV1zOTjMfkpS6hto1m4DRBr4FMMpF4ezAcvuZBr56ckC3x0/tacYjISXKtk832P4e+km+9nt03sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A19BD67373; Sun, 23 Mar 2025 07:29:21 +0100 (CET)
Date: Sun, 23 Mar 2025 07:29:21 +0100
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Dan Carpenter <dan.carpenter@linaro.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: mark xfs_buf_free as might_sleep()
Message-ID: <20250323062921.GB30617@lst.de>
References: <20250320075221.1505190-1-hch@lst.de> <iehRDkchwLyn5czaoM6iHGrNaM7A235ISuVTw_D6fpn8zuuiMCqofPep2K2Xn0Pgo__30TcjbKGoIBCld0AM1Q==@protonmail.internalid> <20250320075221.1505190-3-hch@lst.de> <dswaua7ynkossegyqw25x3ghilbjsxalatbto2xrbek74j7u5o@mxhq3mhukk3j>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dswaua7ynkossegyqw25x3ghilbjsxalatbto2xrbek74j7u5o@mxhq3mhukk3j>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Mar 21, 2025 at 10:21:35AM +0100, Carlos Maiolino wrote:
> If I followed it correct, vunmap can be caught via
> xfs_buf_free_pages(). If that's the case, wouldn't make
> more sense to put might_sleep() inside xfs_buf_free_pages()
> giving it is not called only from xfs_buf_free()?

xfs_buf_free_pages has been folded into xfs_buf_free in for-next.

