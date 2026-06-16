Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E973644A2;
	Tue, 16 Jun 2026 13:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781615095; cv=none; b=Sw1Q7Dn4ug1CoMetVnR9ViCKSaFmjgk3ATiEj1INFYhXhGQUXgqG42l16HZjujHp/kQyuL/z/M+PSGthg5I7l8T4tqVjm5q5ApGzMesUPpcA9hiJFko+A8DwMfam9WqagrKFQBlSCLLfDBblTC2gVAt+nh9Q/6jx7cwUOVW0+lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781615095; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r/jlAHbUIbFgvpNLLBsDOzA60e3cBQ4f4FceLzAC4I25Z/FvBA/OcTKKWV2ajaYyLJMKj0o3ywAye4gsOBTWh8OVXAcg4YuER3cRy2U7dnkngZ86/MB6VArsWVAHCgRUB/Z6akbYlVVXLp2v+9c9a81I+RFVchPgW0NyHLl0eto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hZ4gqzPE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hZ4gqzPE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=hZ4gqzPEOD8h2n4iFdFpnwrpAQ
	okxuKD0jMO/ghIyYsu2l986IkHoSuRr1xn/K/fF9ICeQI+saeQd75j+k5cnXM60SRQduglbY5UqFd
	Tqam54k8Hd366RTBcYEzzU+PUvRGeT0sGHjDjXRSvOJbSsdd88JtxmNShY4f3u04zN4E1jxPLU7yu
	gy0EUzStIbhJa53SIxjaes+SFKfDlTRR+r7szaa8rLMXPUFkEq6JTe0X7wRa+sQoMe/xGVAsTdNLP
	Unsl/1NAZVMA8g8HiJbmK3NrB7lUC+DUFWsEbxfC2mabiVTiiMU9UIg0SfBKOCtjYmQRG4abwK9za
	z5hTXo9w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZTTK-0000000FoLn-1d8S;
	Tue, 16 Jun 2026 13:04:54 +0000
Date: Tue, 16 Jun 2026 06:04:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Aditya Srivastava <aditya.ansh182@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] xfs: prevent close() from hanging on frozen
 filesystems
Message-ID: <ajFJ9nj5Urduibrd@infradead.org>
References: <20260616053850.2188-1-aditya.ansh182@gmail.com>
 <20260616053850.2188-3-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616053850.2188-3-aditya.ansh182@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

