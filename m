Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E1D1EB39
	for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 10:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708943208; cv=none; b=kQtW7zbjwaD1HfeSV7smoybcKH7XFdahNjFMZyRBgL5bU2+fdbsnNxrOSqr0mqYoH+wJUlEoRPbOCM9+k4hcM05111AqxieuSYkBR+N0jPzvjIq/x42FeO5sfJp0kLggrKLvYcyEXx+qrYvhKZQJ82qsdfDABpbckWIlGM5trmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708943208; c=relaxed/simple;
	bh=LvWU4p1Gi9kIt+kwuNelSp1E/D3OjFEo6ZJSMOkOCDM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WWWGhu2n9lbQprllbPxX3cHNxOteGl1rV+9UKd40Q4kcZpiKPUR30s3HiGSPle58p2FyL/3AEXPWbe28MzUSO23Qfw9IC7ab4shbE1uooXBUOE56B/dzmCqKvtA+l5caOWzqexESfTlGmuZqlrm7vKBzNBMK98k6hftzV6+EWkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KjklQ6q+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KjklQ6q+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EUZYRWEfng4NFxyu4uVIxRE642k06y+zWO5BZCEiXEA=; b=KjklQ6q+3rGM98dYkL6R8q9E8I
	nFZ9rEcYgLN61YznNLe1jkzStjZ6+NX5QHNTDuIVGbjM3QkHVAlRIVIH/XG11N/jSkK9VZlRZsoCG
	LDIXj1P5sWlLGBa3MtNjTg5ke3grIeEjiMrEtjh81F1FZDPvTthU+MAdtF50Pn+7JIL58ozQntAc9
	r+XPkzpbf9Vuili1aCUPkO7BjmLRK33YtUCu9SUwgGdG4nM4/+4OXrV9XODxKcCaWXrDsdR63cXPO
	yQPiiWMdeuDbuckXdwX6dPv1Z1bVylmLHQjXYmSoRYHxwI4nn4PxzTSxbkeEvLo4P1x0C18fhCBOU
	iF6EtCXA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reYC6-00000000387-1Sa2;
	Mon, 26 Feb 2024 10:26:46 +0000
Date: Mon, 26 Feb 2024 02:26:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandanrlinux@gmail.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PRBOMB] xfs: online repair patches for 6.9
Message-ID: <ZdxnZnmNvdyy_Xil@infradead.org>
References: <20240224010220.GN6226@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240224010220.GN6226@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Feb 23, 2024 at 05:02:20PM -0800, Darrick J. Wong wrote:
> pc : kfree+0x54/0x2d8
> lr : xlog_cil_committed+0x11c/0x1d8 [xfs]

This looks a lot like the bug I found in getbmap.  Maybe try changing
that kfree to a kvfree?

