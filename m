Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88C24718C0;
	Mon, 28 Sep 2026 08:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790582921; cv=none; b=CVWzNL2wxPmSzFTvIfPX01T2nDrJqs0TaZxErgfFpsalWv6c62knU83EWaVGweHwZXqT3ny5t/Oh5AenoHCJ1LXM3pwcCMaF+rdkgmKW95rn43nFoxwM2zj5EB1R3EVBzmfUytr4kO+RB5vlpOrlmXZ8QpHaJELFvrslzR08TrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790582921; c=relaxed/simple;
	bh=3dVnxs6JbI2bn5I+yOYXcr8h9inTs9XBVFsS4GOwUAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CnB9ou0hBecVMFYGEFR7E2qIHaegt9znopzvRFM8+1SLx9kZG/JZWHUPpiL8ekkJVunJU6ikyAMEasNsGyDraYqmsph9HmZxuJzxXs0fRwscO77Py4mlEYD3RC8HXzjR5WluMpJQqCi5pbr8sw1U1bUAPsVMstGQLoF9LvuQr50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=s5btMnrd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="s5btMnrd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FZO4EZmKDP7sSInyub/MRE8unLA7aembsG6FpM7G2X0=; b=s5btMnrdtsWkkMCqM/Qtlxl6qC
	l7YCY7xiygTk4/vRJMqCPCYlwj7KZNgxZ8cBor2Uj7pWDExTdMCWdS8NmIRXSbN1hKf6jb0g1XtQP
	JWiUjz17ck7k2CFFQaqrQLeSKyemjBbJN2/cG20r2+XONNbKM41QrmkhJ9hp+O3gN3D5KR+yrlrR7
	JlB6JvYzm7jySv0wWgIYYoXnSBLUz1S/GYJp1q5Kc8ediYm0oGf3h78n+F9NGL2f82gCA5p4Yqf5n
	UTnygTJ7Z7gQu4UtRxdajeZmvBoCrlYmcL3E6TRnjRooX249UKUOKFKOT1OCrgzQDEFHTTU2ReHXg
	IUs2pE7g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB6Pe-000000001Tp-1MDd;
	Mon, 28 Sep 2026 08:08:38 +0000
Date: Mon, 28 Sep 2026 01:08:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: don't repair fs summary counters with garbage
Message-ID: <aroghgv7vDhe2qvp@infradead.org>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
 <179057612724.479634.10486546764392701308.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179057612724.479634.10486546764392701308.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Sep 27, 2026 at 11:17:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that if we scan the filesystem and come up with totally
> garbage numbers for the summary counters, we don't actually mark the
> scan incomplete.  Because we don't do this, repair can install the
> garbage values into the filesystem, making things worse.  Don't do that.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

