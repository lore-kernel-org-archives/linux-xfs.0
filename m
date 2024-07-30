Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78358145FEF
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 21:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722375702; cv=none; b=ebyO7PMRnqxIX0+HyyHxwT0uImtuY660UIwJyUdZY8nh/ztXbBcMgpu6jiI6hYZir4zM5qFJ4FGpMte9XQa/Tj2jfhmmQU5OnESmjSyHR6YmGP89nK2pyX8PrSFP08GKt4CBXabdumUitwDoyRywrMau7CjGYOz6veealEq5I+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722375702; c=relaxed/simple;
	bh=ztEoMq0oLg0FF8E3vqjbOEcu+twryqw6us+dvsml4Bw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DwC6XmY8lHgrzNL833NetDbGSx2HfZyaS4Q1siFsrrdJJDkdHAwq82yFy6d+63or52tYSrn0EDVN9Uu4JDudW5HOwez64P8RFdWqdgBa5Rc7Md9hSUXPvgplNa8cCcUSezayT4YAGsh7XkbkrymC6P9YGp0SYAucQJL71Jm/px8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rTs2SweP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rTs2SweP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lfbgjmhUBwFztQ/uVCNxZbyi6f1Akxwflx0xQZO82As=; b=rTs2SwePYUTuK4hmjET+vB/Q0d
	5/THsnokCpTgaOO7KWo64PW4Eq1JkaVLP+HAzz9IIdkqiDrdpWEiVJungWXO1XBX2Ka/2La0MUKjr
	ybcYG2tXq5zTOZM9IJeWMCUXGSLVtO6aHFIGLcn4D1t8KIUyCaH9G7UWy856Fy+E7ZdWpJMJQYyso
	GzWelUJsGSvO4VXE832qfeReQAktVXRBknVIxXRo5dWsAmwB6a9nh+ku44UvbCHz0E84W9Pe9Eh3m
	mMqPLG24v0GSCKxGscHe1vO3UlBvZnbT69t0mtmm67vBke8Cin9QsB+jqraJBBOFklQ986aCWmcTH
	tOMQ4wgg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sYubF-0000000GZFB-0lZp;
	Tue, 30 Jul 2024 21:41:41 +0000
Date: Tue, 30 Jul 2024 14:41:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs_spaceman: edit filesystem properties
Message-ID: <ZqleFeJhCVee5ttL@infradead.org>
References: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
 <172230940600.1543753.11770032596501355577.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172230940600.1543753.11770032596501355577.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Is this really a xfs_spaceman thingy?  The code itself looks fine,
but the association with space management is kinda weird.

