Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4372818A92F
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734071049; cv=none; b=RewnSAInCINeoCLj//JoPlFFB2/wlJMWkONbjW/jBDgaCpl+cHD4as0Oea5+lUXhVx4/DpVvyHXmmdQLx7Ej7fsAGYF6M9goIX2e8ub832bKYWI0tBXPM4yJwu9KFfEuNPIHdkBV7inOGxaKUHLt7gV16SNoGmklTSS0slmNpNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734071049; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GAfOgsetUW3ou8T9jqa6ZeQaY5r3ZcaIlxf4ga5gV7C0rD8qEpZp0oUtnU7MJdQcsa8/Mm3GeHODZFuM8DMtiYZ6CFPDqG4EcmrvLhrYOmPu8O2JfLGixOGrXopAFgVhM4hvUt+Tb9ocT6xt59dRvBiQGyrlEiLaOsW+ft3EMUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UGav93ZP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UGav93ZP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UGav93ZPU+V8vKl1Efp3HT9YKz
	IkIlajRP7WTaJdy2cuvKm5PQzDLl52sKK5Sqs6jDD5Q4og/+6FrLM+OyqW5rMbIIAO7tcYyKxMTRf
	kq+MCEQxEMAonxrsiW87cFchEaz1mH5dR006Jl3etkJ3Xyi6elszhMOBMzjv53DeqVscR7W481quF
	a3FaDl81xyhU5QHz4EKDntCAEQKkkeadWrfTkkkzNdqMfkaS/jpL/WilZU1qDNR3KYXXa+V/N2seY
	6qU7FjkS6uEEmUhF3iaTQpPLgm/j6ucNUBNYiG0xEAWOCS7iN2XSYGMu9BVvgRKwXVlW397FwQlTj
	237+tg/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLz5r-00000002rPr-3FUs;
	Fri, 13 Dec 2024 06:24:07 +0000
Date: Thu, 12 Dec 2024 22:24:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/37] xfs: realtime rmap btree transaction reservations
Message-ID: <Z1vTB05kxusYsRwU@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123399.1181370.1254278860717277218.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123399.1181370.1254278860717277218.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

