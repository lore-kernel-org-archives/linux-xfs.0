Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75561A7264;
	Wed, 12 Mar 2025 05:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741757722; cv=none; b=YCKOMe1dZL+uQjKtu3ppKeL3ITaXXm5TfoYYhRua6GEdJ1dpGHn0NQ/EX3vJ5sjK9kCf3x4tcQJTJeE5IBWpliPgNqNuDScdUVJjqfMi3+3Cy9PaUXn1hxV43ChvruDhxbwF+KOdWsjral6/pISrwhu0mstjAefzSrIfBeoJqQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741757722; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FfFdKmp7ot4TdnTVfLd8HNDbSiosydIZE9jYQE0obVmK/lx27RRBTIJ8t216DJwBdPi0SYxnXkDdCKozWCINGzovIX4h1+CpnEmAzUIf5/Y0O/mSVESCoFFUjBinKhmKthRCOqIwlgE95+gYPujd+CMWCPyzWhHMMrl+/atkosE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ymbWZHD2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ymbWZHD2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ymbWZHD22U8+AgJaZ2zYJpHVvl
	l0TCXoM0p6BOFT1srPegUSvMD9wAIG+ilEx2THMghyudV1/aLfs0k8E4aH/j/A2SzOVahXtOKLKLD
	c7PMfb9HTENu02gUM/uBHxYIyMuevOXRKmgCiJecoc4Hhbh/Fg2Q+tnp2qJhJgOV1Qwxz7aOFTcD/
	NT9H/RB+a+jMlvPVTR1BKjLAQaKlPT8EOrfPbb3IepJLn5dy0sOd4f73SOWB/P6ftSdjHXdhZzDUh
	eI4QVeOOcCI9dfl5ydXgWXDmYEL59jYTHF6N5LPYtihDOayAY/QjzJ9ccnoPzZvyWBcswgQjPxvAc
	ZSicmVfw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tsEkR-00000007X3l-2PqL;
	Wed, 12 Mar 2025 05:35:19 +0000
Date: Tue, 11 Mar 2025 22:35:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] xfs: Remove duplicate xfs_rtbitmap.h header
Message-ID: <Z9EdF3P61uyVYX6Y@infradead.org>
References: <20250312014451.101719-1-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312014451.101719-1-jiapeng.chong@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
