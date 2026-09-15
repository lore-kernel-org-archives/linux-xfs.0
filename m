Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E46A33A03A;
	Tue, 15 Sep 2026 06:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789453614; cv=none; b=eitVCKz39HGjNHtWH+M4yv7Ne7FCA8dbqPfbfwA8CDlZ1qHWkkcZZLimaAchPx0wuxGBhr8AkYGs5ifsyzKquZa6r9Ink6eTjWha9dbqd8jUDddcgbGq1EO3ol3Ou7eaRDggKkZ4I1JF4PM1Aak7aTAPnazsaaX+s46LX/wVJWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789453614; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FS0AhezKzNJu9n8ZtIwNDnpnoEkdNNcaVgRJ6RDmdglqx79YQgCCoWYBg7V72AVRVa9vM8GiC98GvbDhpKILeL025EJ6xDTYWDNSGE3+cYEh/Sfnz5dr7io0KhP4lEhvEXPAU1pQZvF2yIgbkQaI+rlyLg2TV8rpuvHunhkQ/eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=f71DhybP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="f71DhybP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=f71DhybPWKZsqDQvYL39MQIsfu
	Is87hNjl3qXm6Be6ecUjhZHczEC0fTISiqkeDIBAJ78gbwcDXRRBTJ05JMgyOLVxV91jrZ6k974AW
	9SX1R/iKz0hr+qAS1EZAVkeayyZD7zbD+eWj7zAOV/i4zHJIhVuTrKvfS/ZlRiqJwzSUQyP0BnQO1
	KiBUWgkSmNlKo79QYei7Ce4xP7UPippI0ZMpefeXmjDJzDhRF66pe8WZLqAhpbI+fty17DWNYf3Mh
	WmgNPq56oSe7hZ0uQRBKw5qLf8TV6rzxBi/FhdwuVP2TtpP5MnDvAOi6LVxsL3ZWhs92PBrg0YCZz
	TruA/FwA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6Md1-00000005LM8-24SM;
	Tue, 15 Sep 2026 06:26:51 +0000
Date: Mon, 14 Sep 2026 23:26:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/11] xfs: fix rtgroup repair estimations
Message-ID: <aqjlKxUP5IWG_mw5@infradead.org>
References: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
 <178945048564.3061055.17283791204360805735.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178945048564.3061055.17283791204360805735.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
