Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC182C21DF;
	Tue, 28 Jul 2026 03:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785208764; cv=none; b=oh2+zQUODF23FixfQIrdFa/9TIwnVJlKWxM2qyrV1YZG0xD4d/ZHL6SIfh6BdEW64qGr2g6WKFKbkXTd4tc9/yYsMyuTWMniiehVtT6DO993i+ITXLfsSSghnuulByE0WcUxr/3mNFozj4gNGzVFzIw2BXJ3VZBPiHDdsSDZsTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785208764; c=relaxed/simple;
	bh=xSdhEtN2PiUGg1VMGAg7W4TmVSqAh9ZHoSwcvtwCMTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k8xWAxJB/HSrZ+P5qyPBPQU2+rNc5mYZrd8y4MQx+tYCmzsIlk0RFGEtkyoi1zl9uW57s18IsXKEEqv4zdZkk2Znr7C/lGVxJR/5W+KSwMwys2rHvSjIRrX7/szH9lNEIyBBn/ez/SKmuuk6UpDh57mazBk5b8bVUrLFIHqBT94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0mXvgFf/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0mXvgFf/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xSdhEtN2PiUGg1VMGAg7W4TmVSqAh9ZHoSwcvtwCMTk=; b=0mXvgFf/6FbI/Zy5fdrPBTq2n0
	MSsJdKT01Tp8F4Sd+8R0GAIB0XBX6aXiEjhov1lj0t4IcbE/Wov09YjFcFEIzR+7JW+JeDaYrZwCt
	vMzAW7Z8bXlQnpPg4RxW34Rs1x4683CADzdcAbkl/Up2ziDgWg1ADpB9m9uS9Od2Oy2VBb46U2kpU
	vgsMCcn3NJ9o/kPdgfTVGw3TwGsOJL0nvkQN5yaKP0jdioSUxMN5I1CWZPgaLkw6uvQNlM3sPkvBu
	dgBBJZMJPwYDC8ezwZy39y8rvjrmbXEGojzkWgJITIPUvL/AuHPmPutufSkqbNXQaK2Qnwr88183+
	XWhV9r3g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woYLi-00000004Jxz-0oFO;
	Tue, 28 Jul 2026 03:19:22 +0000
Date: Mon, 27 Jul 2026 20:19:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Vacek <neelx@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com,
	hch@infradead.org, djwong@kernel.org,
	David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 00/12] fstests: introduce fscrypt support for btrfs
Message-ID: <amgfuk12imPN2XJe@infradead.org>
References: <20260724133328.1837318-1-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724133328.1837318-1-neelx@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jul 24, 2026 at 03:33:16PM +0200, Daniel Vacek wrote:
> This is a rebase and cleanup of older patches [0] from Sweet Tea and Josef
> fixed to work with the recent kernel and btrfs-progs changes.

I'm not sure if you post this just for reference or what the intent here
is, especially with a cover letter like this that doesn't have much
information.

Before we doing anything for the btrfs-specific fscrypt changes in
xfstests, those changes should be accepted upstream first.

Maybe some thing like splitting tests might make sense without that,
but then it should be posted separately.

