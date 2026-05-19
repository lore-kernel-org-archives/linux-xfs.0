Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E5B39D6C9
	for <linux-xfs@vger.kernel.org>; Tue, 19 May 2026 08:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779179255; cv=none; b=pube/h7cX69QCJbyHpLTHbZchOkni0fRRPQSKcWJOYPJRacGXeNoXijg/56bgLvRFLGf19glJarl+bBeLqpWoDvL5jbhtqOFnNjjZuDAFC7aPCxPs7VWHsD3Jhww9dS4JZSNaTRD7MZjs3ciST/ASRfnXQWtsRc4r7/pmy2nHSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779179255; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dmYCGcRhhynNJohqyokNw7PbdebVL/jjxYw1WMgcpIndD5SMHDr/hiHH7qYanws/azD5RwsAAAu+9N8II0yS+JBcpxgUUun2yoEYuf6Y+TdnBzyyqMyfLLMZ9Kx1XLpesZM4E9ie5JDJ9lJorVHl9tJ9Mdp07cux6z1cTP+umxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MT5LOxGO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MT5LOxGO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=MT5LOxGOhvgsasIdQM7YYhXDZc
	l/Hn3k1HvlF5Qg/vvYk/POscKcbdlUTTiNB6PBm57Yx13XqXE/eCcHlw1B++bxtEE6iqMGmHDwB1Z
	Do9iamDVrJ57Zm+3MWFBtdh7lb2K6wP8dNIq2d19wg2GpQXTpAyoCJsU/nVR3ciDTXuLvT+njEkqX
	ASRc/hC6N454T5bb4YCUqhB2unv/DcDQri/BaInHOZljSjRz+BfUg/OCoCO+bL33MkXV2f1L9nNJQ
	3yTzvvN0DNhstT52k2OC3/uUKY4LJFHPPk2t7LVShcSZnbeFoEVv7XW8zEqh1N3ZGySOb3fOXlsJn
	l6RqadFA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wPFnY-00000000foF-0oh1;
	Tue, 19 May 2026 08:27:32 +0000
Date: Tue, 19 May 2026 01:27:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>, ailiop@suse.com
Subject: Re: [PATCH] xfs_healer: fix missing HAVE_LISTMOUNT flag and stubs
Message-ID: <agwe9Nr1mb6VA0Ya@infradead.org>
References: <20260519041805.GF9555@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519041805.GF9555@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

