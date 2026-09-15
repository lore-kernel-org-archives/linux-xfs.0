Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4D5351C20;
	Tue, 15 Sep 2026 06:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789455463; cv=none; b=RLtTUQHtXTTSMopMS3VX4tIXJkclbBkQJj8vExbwJy26+e7rhdtAThDhV0y/pV9URIUe0lcBl8e2J19RxRkRDF+bYbvL8lyP7/0owyELh/UFgNmeqQRMk+E2BwG6TWnWMX3ReH4p2hBOA1syYhh7XIs/1ftgtzKLHQus5b1C92I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789455463; c=relaxed/simple;
	bh=m6xj8Pr4mqKCXxM1P9wXz8hfwdBNQzgafzdueLH6emM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L63ztFQB6JqFHcRjuhhdFWVLWbE2OlmPNuL/OpGka5zdUj71zdCPoWzG7mLCLJvgfpOA9BTglfsSAkKSGcmk52rMOuJmeNNHJgAlh6Y/tREb9jIoSxQjGKkOLKnSwF/OpE3wT0TuUfXKmmyRgwShKMxGThQ8SV3WhjWMGrecEp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ilH9uawj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ilH9uawj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bj03I4DngqDwJ2JtivJIliz06M6zwlsmrZ2i+eO1/M0=; b=ilH9uawjuBgV/Su8mpmzhM+rtw
	iBtliSCOzedhruUC5EXwFwqXdrrGgIpKovZ4ACS9yXjGnRVZ0f0UcAAEZzazj5Jbj8nZ63boqxHFp
	i3BGYe69abmzYUrASTLLPW9AJ+uY/TgFLICpgDYjocjowDa9ccoLj+wrFe96vbXQztueVXStBtVhi
	/EHyb50/7dqAoDRqwpSoqgxxgqm9UJWjT1vut1fIj0Hesi5hzwHyeR8Ds2W+q/WKfSPuAUcv/PWEG
	veNL1Sp8PJwb7OO+ZrkckhsGju845N6VCGbVf/aDPUDzlFgaihf6/CRLpBU/JBu10iJO3cHpZUWnC
	lv3wtZjA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6N6r-00000005P28-2tJb;
	Tue, 15 Sep 2026 06:57:41 +0000
Date: Mon, 14 Sep 2026 23:57:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org, Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>
Subject: Re: [PATCH 2/5] common/sysfs: adjust function naming
Message-ID: <aqjsZZD4RPVK-uBn@infradead.org>
References: <20260914172509.3799016-1-zlang@kernel.org>
 <20260914172509.3799016-3-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914172509.3799016-3-zlang@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 15, 2026 at 01:25:06AM +0800, Zorro Lang wrote:
> Add the _dev_ infix to helper functions associated with
> /sys/fs/$FSTYP/<devices> to distinguish them from upcoming
> /sys/fs/$FSTYP/features/ related helpers.

Should these even exist as separate helper?  And if so they probably
should have btrfs in the names?

