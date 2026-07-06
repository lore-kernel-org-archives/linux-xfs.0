Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B3A3BFAF0;
	Mon,  6 Jul 2026 06:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783317939; cv=none; b=cURsKFJ7BIxrfWKr9dRorv7ImFykMvAWBQ+aPsHaoXkT8n/8EFrMlhbf1Qo9H51cdmDgSXEkGG+YTKGhcsUvYge35LJ0JMQHhjtuMvZ2LHWG0DHgJrwhBPm+U+/TncBl5WgjTsZu3IoR9LqfTJU1P/K9bWbcn33A1wwBlHDLC8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783317939; c=relaxed/simple;
	bh=ubpJKApIjhjp0mXa6rqsqPgypfBwtwPp/A1AdEKDpEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wk/nM3qRIPk1jtlEwEl0eOzIXLyXQbHmRZZP0AGlbzffFYv/1WsmWFQJZygwaE+HfcotVIVFXiNybho8O1xzoivNRFNFKvA9PdMy0TM0OFL78+vIqTKtahrdgGAViA/sKCE4Cs7PxMHc6O8UR2uTlrZ96N9dhQ9Jxw2I21qV3qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jrpHtgJw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jrpHtgJw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZiQ+TL0M3qbfJjcOyPlVX0/yhoEdZeej2dS1Gd2++HQ=; b=jrpHtgJwtNrIXrBYxd/7+Z+8JL
	v8b2BBhr9l4fiY86PEi7/vOT9hjrb6TcBz3ovfVxX/GOl45SPhFO7VxC7nRZTsknJxeBa7UtC0jRw
	7gdddR3a0M25cIr8IDau2i7jsW/rs5VoxWzcRag3lD2Nrc8R5SEnkCwr9lyKqFvTgoATxEL4uOAWx
	KLwKkekbdr2e6XPcG+xfruattY22okeeNZxZjkoJ1d/41uyR1jcXA5Af0UVZJXgDI3ZYoLDV6GlZg
	mgkLTKmOc8WTzNexfvs2o+T/dH/I4rL8JPqVg4dWIpvtgEy/Dej+jI+IOVDAclmaeT66iAsCEzBcq
	Sej+q4JQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wgcSW-0000000BZO9-47N1;
	Mon, 06 Jul 2026 06:05:36 +0000
Date: Sun, 5 Jul 2026 23:05:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Cen Zhang <zzzccc427@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com
Subject: Re: [PATCH v3] xfs: tie zoned sysfs lifetime to zone info
Message-ID: <aktFsGJSNWFoZbE0@infradead.org>
References: <20260705042358.3667466-1-zzzccc427@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260705042358.3667466-1-zzzccc427@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Although at this point I wonder if we should also just move the
code out xfs_sysfs.c as a follow on.  I can look into that.

