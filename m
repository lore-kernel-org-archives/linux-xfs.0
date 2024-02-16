Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0E014A90
	for <linux-xfs@vger.kernel.org>; Fri, 16 Feb 2024 07:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708067518; cv=none; b=bQ3NceYsi1sb/4qqby3AXIWPO7TRZ8iDgMsjc1hQcANu5v7X3SU64Z0nKlOWwcfE4+/kjKg2mqi6z2U4sTtFVS7gsQyhwjbbUzH+DseMtx3mPiHDvSCz96wsPRtHceQuyl6fnw1EL4wWduOtT1ecBXCaR0r1Obh/UPxSXSJ1ejY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708067518; c=relaxed/simple;
	bh=4Z1qzr7PzsNOZgX5sgSKVFa7H/ER90pwq2agbrSHThY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U4mVi7dEyKMdaY/TC7GKRTABKMZ8lEVNgFSCimbngP0q/F0lPGS4cTcQn6qRV8i+jXk23MHgrpHZzpGfl9KGcfX+ceDfayDzjdw+kc0RDeGtuXvV8kR3d1RiA8hODboBjwUTdNOckrKs0lekAoSfjtSeMgBZf9NKr6c14fm7STI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=e0BI3lrZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e0BI3lrZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OiH4oGJUNgxzoCDGkRQgM21iQSlnWYdqKOqgW3HY0BI=; b=e0BI3lrZ3YsPhO/JGVaMvSCsrL
	vluuXdpF2/ge6zTYvseBQ365/AKdKv+tY24KFVQT9GLmP6a9YJEEZZS7DosxbbKL9F1Nya2K0DZ/d
	CQUIbpA1yUI46MdpODhGhx9XkIyIDQtBwNrzT5aOQ392bI/YF99nH5vetbubcHpUfwedg/zQtsdx8
	oZ4cJ4RBXUZzoHk7N97YqK5IrQ+BrZoa/JUS+24v1SoP0IkEtQldWlBunBNio15qGjaaQeUBHYvPQ
	D+4lSMBgF2BvYAzEmWLmeVKHO1VDJsshAcI9lSWSUQDK54AaXx3o0UtioOQOtiw8sTcAkqMiaWx22
	DjacjJCw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rasO1-00000001LCe-1i5f;
	Fri, 16 Feb 2024 07:11:53 +0000
Date: Thu, 15 Feb 2024 23:11:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/35] xfsprogs: libxfs-sync for 6.7
Message-ID: <Zc8KuRnFmm6xTQOn@infradead.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 15, 2024 at 01:08:12PM +0100, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Hello folks,
> 
> this is the libxfs-sync for 6.7. I know we don't use to publish the results on
> the list, but this release's sync was a bit more complicated, so, if you can
> spare a few minutes, I'd appreciate an extra pair of eyes on top of it.
> Also I thinkg it's a good idea to publish the patches here before pushing them
> to for-next.

I've looked over them and done some testing and the changes looks good
to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

