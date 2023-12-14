Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z+sLilzO"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865F2106
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 21:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VkVK/knJW8uFArFE1mhGqtRnvskiU55p7FJn9zZ/N+4=; b=Z+sLilzOa8hNIQxc6Ft6bEW/q4
	x1mDQvzWwF9PvCKwbitq+ieXvQ6Sf03uTP5w61sVVrAJ2BOqtCpYPHOYRZ97dQA9gAYlW0y7YnCC3
	wU5Uc6YeaPFfItugmtn05lgz197+2sFUtsIJjRJ6YFrGw8t1frTDRJqTruH+3CaONqqCK+Bo4U9gg
	2tbVONXXy38vBwQ/ZrPgEPuObhZtTQ3NUpWFOWPsU7dyntcBB6uffjmw1DGm+D2QbjF1Tc+wglNYq
	HWGgQKlLi2pc7bnU+3EZNRZapvYPdvmM+rA3h5FQzsTC2G125bVqyCO6EbLDYb+GIqaE8JtsJGFkW
	m7bTplIA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rDdpv-00GlDj-2N;
	Thu, 14 Dec 2023 05:00:39 +0000
Date: Wed, 13 Dec 2023 21:00:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "wuyifeng (C)" <wuyifeng10@huawei.com>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org, louhongxiang@huawei.com
Subject: Re: [PATCH] xfs_grow: Remove xflag and iflag to reduce redundant
 temporary variables.
Message-ID: <ZXqL94xSn/bG6vgj@infradead.org>
References: <b2d069d4-b96a-443c-ad7e-5761b8f10f88@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2d069d4-b96a-443c-ad7e-5761b8f10f88@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 14, 2023 at 10:41:34AM +0800, wuyifeng (C) wrote:
> Both xflag and iflag are log flags. We can use the bits of lflag to
> indicate all log flags, which is a small code reconstruction.

I don't really see much of an upside here.  This now requires me to
go out of the function to figure out what the flags means, and it adds
overly long lines making reading the code harder.

