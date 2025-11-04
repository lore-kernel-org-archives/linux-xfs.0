Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E52271479
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 10:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762253961; cv=none; b=LHVnP2I09U8hf/O4RmiSXgfZTnE73aUtkpNF8dwWE+gzaNxdB37Mh6UNgfHTDZf8JPJGAn2YXnUPz8JtdfObcdef/5ce2FY/kfPn+gT4YkxXdfsjZRzqpnkUsWQU0xz+LIz6SrZQEVjVLcEFhcvnK80IHkVeP6/8uJgZ6tocADE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762253961; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qdQ+FoK+yJ4tApthbD+Ffi0z0xmUdIDwzKZOow4uyrWtZuQwOagUo33H9eXbWv0yRqR+cm1HorSNB6AJE34ReKrAwbM/7gMRJDNYZUiLPc1apAy7xBDaEtAYCqK1o6ajqmGvsJe534Y7HbIXgcd1OYKQqdKbV9bS/uFsErxJrtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VF/sMmFT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VF/sMmFT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=VF/sMmFTrhBbONcEOOG7UW/Uqp
	d2MZhUp7AQKTuLxPlX6o9f4xav+Ywb+E38Bf1zHcrbxnjHG9t1ovojwpDJnI7gJxUDbBTi6RJH2is
	VgYi6gEY1WQ4+KpjtuYRQKiFr+zt8NkspZPF+AacQCF5dyqTqYeThy93Ym/Wv6XEUC5HTLsjgq998
	xUh5SNqMXUE04h4QjAHeX158byEpwijx9Hv9ertaR6x480MEk1qnoz6sj8op3XnfJ4yJM67NRL7nQ
	tuzQAGdUTWEpyIKnhE3A1NtA63UISa+w7TgkEpEXCgZqqxamNzjYISxj7kIqBEcLH1e1iL/o5VKMG
	B77+e/Nw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vGEkx-0000000Bg70-1Psz;
	Tue, 04 Nov 2025 10:59:19 +0000
Date: Tue, 4 Nov 2025 02:59:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, djwong@kernel.org
Subject: Re: [PATCH 2/2] repair/prefetch.c: Create one workqueue with
 multiple workers
Message-ID: <aQnch2-aW7z4a6nu@infradead.org>
References: <20251104091439.1276907-1-chandanbabu@kernel.org>
 <20251104091439.1276907-2-chandanbabu@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104091439.1276907-2-chandanbabu@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

