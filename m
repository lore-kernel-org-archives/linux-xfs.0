Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8D41F1934;
	Tue,  7 Jan 2025 17:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736269948; cv=none; b=afmV6zRxmD6LXepk/zl7F2c0Uc6GOU/Ha2hKTM21bsL/gElXs18xvHp7DL6SFoE+OPTpw6yybfQZpD9AVVJxXY+av+HgFI00mZYLJNGvWETvST6ooTA1tRthn3dU60QxEaCOFfkUlTSUa7Si69louTnkhqSLgpMCN/Eru0micHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736269948; c=relaxed/simple;
	bh=zQGmR4m1juNmKAHzJCzaIF3vrl2AA/wDEkf4gcyIWpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HA2Cj+oj/QZ/cIzDXYEXY0buZoK8mm4EKMgokGG/BgVY5wAdvqk61Lg4aLI2w3MeO/GXrVlPE/YGqGimy4w3COLd4PGPMj9Y0RoMizGLfL8B3XoQYOf4T76v8Yu2cOs6f1Zrwma59ZcUj0iHShIvULgTg0mbDrFdUXepAgerzo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SOQQp8Fx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SOQQp8Fx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LIgnSGlWeykgfQyDfK6qq4VlOe3p8awfH28YrS9PAGs=; b=SOQQp8FxtNsyovWfmA9TGN1uAx
	ur4CX0j+1hVyLnVZ645oYBBmnRuh5/mgeUV5+VZZyGaCMv3YkQI5aQX7nw6XceKSLFXzCC/5oKvyl
	WTINeL3xfd3rNL46yWYluvcT+b08NPWwRVb22ij2eKArTZHhY9ksBiO2gOH2Rgzmn40F7lcd+cs3l
	UzuqR+CW/cn1JjT/+R2o+6FjhzhZpqE6OINn/jyi3RqbejVPDEabxBUl7CAqTfvYb0Doc69aWlPhw
	l2z3sroE0zMp/0EdEaSfk8do8e2c2A6vn9mQsh9XSQVO4YxW7FfjbIgHxijmnoJwqlAkpODIp4N2d
	BIeeCcmA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tVD7u-00000005mmk-2Cl3;
	Tue, 07 Jan 2025 17:12:22 +0000
Date: Tue, 7 Jan 2025 09:12:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Chi Zhiling <chizhiling@163.com>, Dave Chinner <david@fromorbit.com>,
	djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Chi Zhiling <chizhiling@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Message-ID: <Z31gdpNdwHYG2xY3@infradead.org>
References: <20241226061602.2222985-1-chizhiling@163.com>
 <Z23Ptl5cAnIiKx6W@dread.disaster.area>
 <2ab5f884-b157-477e-b495-16ad5925b1ec@163.com>
 <Z3B48799B604YiCF@dread.disaster.area>
 <24b1edfc-2b78-434d-825c-89708d9589b7@163.com>
 <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 07, 2025 at 01:13:17PM +0100, Amir Goldstein wrote:
> The issue with atomicity of buffered I/O is the xfs has traditionally
> provided atomicity of write vs. read (a.k.a no torn writes), which is
> not required by POSIX standard (because POSIX was not written with
> threads in mind) and is not respected by any other in-tree filesystem.

That is true for original Posix, but once Posix Threads joined the game
the behavior was and still is required.  See "2.9.7 Thread Interactions
with Regular File Operations" here:

https://pubs.opengroup.org/onlinepubs/9699919799/functions/V2_chap02.html

Now most Linux filesystems ignored that and got away with ignoring
the requirement, but it still exists.
