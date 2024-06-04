Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A0B1C294;
	Tue,  4 Jun 2024 05:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717477612; cv=none; b=h8BHWdQJpvWiFBCqYfppIKSYEg8XgAk/Pe/M9YnoMtxtLgIBOtRfKsD0suRraejnQKNoK/o9+BN+6AVkGXTuKkSquJ0ea6+AnAVskUY25ZUQETvszMR7OHriIk1SSpeJXSIpz5eDa0ISYKqKXSQlynbII/4wvXYOV0d+HEBFW/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717477612; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=byxDPppk3gXlMHNFd3yHFau8/Ranlcpzg1IZyctsnCfefItCtmNbqrJ309i/+JLrBfiAKUSel7fCOyqBcAsOKgb1mc9Jf2464ulppQY5D7NDOOQcnacP3Mnhj8XdRFkapTcEpRwWpL/vLAjUjyRNS/58jW7ycVT36WBV839HwWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GX/T/iE/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GX/T/iE/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=GX/T/iE/Io/hsN7qIFSHSz4ioU
	jGOoUgCwiVlS9cn5nclALcAH0jTHQ5QBYOqyHnsW2Dz0BulLNoLduWPUPgtiqLbefqVNlusIRMMul
	kcrnqFHL8TRjfkjAhYI7ywuNbh4h2a1RuLGvixn1wulcL3DD5gXaW8I6EVlKFmVjoqhgbq3CrqdwO
	7AxfyZbBbv8iFKuxF1FUKE64mhTTRUKhDBKcx7mb8CK9+Jlw2TS4eIV3KECXB0I1P/xiddgBHcZS8
	LD6MRDPQIZjdwB+AxYv7VJEPNh3TvBf8sBnHH/3rCZL+CHJ/XuWlk4IWMgZt+0I2vxZxPAUQGsHzO
	J12MCdQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sEMNn-00000001Dbc-0yKf;
	Tue, 04 Jun 2024 05:06:51 +0000
Date: Mon, 3 Jun 2024 22:06:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	guan@eryu.me
Subject: Re: [PATCH 3/3] fuzzy: test other dquot ids
Message-ID: <Zl6g6xKDDs4gTtG3@infradead.org>
References: <171744525419.1532034.11916603461335062550.stgit@frogsfrogsfrogs>
 <171744525469.1532034.305765196235167428.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171744525469.1532034.305765196235167428.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

