Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577A2233123
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738904857; cv=none; b=KbrfqBDCIwExUu95CVOeLug2yjRTlrWLRI/W7kuCKi8Dm2UNyH2LM8UbT0QDW3rqa2zWxCkgIUMKV/8++GjU8FZzJOveTUlQje2x9R57Wh3wQzg7kyXgUxfB5eeEfiC5XO3uyB8Tn7Qy6K1V/04eSCrLFFBLDU1ua2qEHup8Og8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738904857; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k0Lh9l5k1xS4ZZL2gVkZbM7pRYY1mZIMBTugQq3vizE76HSk1PbS1TEZ3EA1AnMQ9shatls3zDvMClElC8TLR83RurqZFKYgJLxEpnbkWDiX+/rPRJyD5IiL9uO7ANzBRmv3B428nuNUFAK8oHwmYMa8slnyZVhAdhhU7gaMao4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dJzZUECg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dJzZUECg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=dJzZUECgYKP3XtBsmJYrOKdx/E
	apWUKeADgovyPlKrPCAxXrGs13Pjjqnuoo8lpjp8imbD4HvvW5S1lJ+AURPR7+jLhVRi2eugJ/XpH
	+MptW/WeS0NB0YNbmYf5ihL9cGt6tyE0+TemSFmrkoCVGVyHDSXDlPV+k/GSnCOBdHJV28o+nD+9z
	o4GXpXQMBUyDH5anck1TwtxuhkUR7++jV0ArpleKMIBEOSXf40fWyN4BR3clS0ssfV73lS2KtPh1T
	Fo0DaXGrcg45ut8BkgTo3larQL+m2c7UKfFk8QAfNkECMCmp0nkmSycDVqQLUHNiK6+4l91+cW30K
	elh2JW7A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGaW-00000008LP6-0REE;
	Fri, 07 Feb 2025 05:07:36 +0000
Date: Thu, 6 Feb 2025 21:07:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/27] libxfs: compute the rt rmap btree maxlevels during
 initialization
Message-ID: <Z6WVGLygDEuxl6Ai@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088111.2741033.980299615772826570.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088111.2741033.980299615772826570.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

