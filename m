Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8C92F2C;
	Fri, 30 Aug 2024 05:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724997377; cv=none; b=iNaGo8vfLlw55gN6RR5QxBYz4SFOQtDoosV6EDLKzpQlFRGjJ4TpzPfQW9ZYga5puWb8iT2mg9XPRHhAyCgyw04c6xWviFIDKRMhYsKF5UrPT0c6Q/oisoJL53uet4kQcjMtXMAxoGoi+SBnhSTftGph/blPYgwg83y9GnOqSpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724997377; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=daW6bVngFFxIv+FzuJPO5W2PHeim+43l0lcNeuNiG2PUWhAu1YWBoHID9RKYhej+E56bB7W5IC8NDiW0SvZ95t2OUrrolIvzzAyphXZtw5g2gJnztF9lR78iblC3VVRuQTSIBMx7wTaXtBCWx2EPq4QxYdOn9N7MaOJ3rVATM0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0O1vZFih; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0O1vZFih"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0O1vZFih80lfVJQaKui3FIely5
	COxhhedHxZ2TXBOfzVRYQdutQsPU7MYLMVBh+otbJoMDJ0ML6ZoB6RDCRaJuQkJvZBFUSHkbJodmp
	Tvmmw7RaMzAR6IVqTo2/bP4eLDg3ZV0q2k66bWYcnXJcWH/TlqyhcNSH93eZtgwPN/8PhTHrPYxY0
	2UxNTp8yLU320G387eV0cEvh+n6thaEwI4D1S+65mXd5lSN+SjlJIC89Ti2taYubTt1DWxW541XLL
	rcsROc0mDwE05CV0vAbfIm2gNvTFqoFJj/YHV5NfBgkPYfgdVEh+R7xK/KfOZi5wyphtuANiD65Wn
	BjBGbiDA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sjucH-00000004sDW-0oex;
	Fri, 30 Aug 2024 05:56:13 +0000
Date: Thu, 29 Aug 2024 22:56:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: test xfs_scrub services
Message-ID: <ZtFe_Y-UiXLepGsH@infradead.org>
References: <172478422640.2039472.46168148654222028.stgit@frogsfrogsfrogs>
 <172478422655.2039472.662383375138981747.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172478422655.2039472.662383375138981747.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

