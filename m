Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8E628FF;
	Tue, 26 Nov 2024 05:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732599763; cv=none; b=Cm6qfuMMYB2zzfNB8tZ+xRojikZZy7iGMvhvzwivnG1AgL6cCEFl5a7Z2Mll6cevfjMyn8W3fpKaU6z32djETI+xbae3GKAoH0vOn41CaZO/3h3/AKAW8ca/HJw0ulVca6Dq1S8hYmBi07XTpAkkXrq8qQdQlmvJN/+2tYwiJOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732599763; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bvQUqIfmqiw99iYirlGwGxSy7R1j1HqN1pzJH0EzJFGJBPRhYr48ZaGQuNiIq2sNCoTtqBF7dAfMLLkmwKEQD7hUoC40FRExvbMIzDnWexfkQskAf3+z7yFtbdluQW6CmYv8RjWmsMC72NbpP/h3BN4zea+wNAOCzrY3ifuDI7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gPpsgGQe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gPpsgGQe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=gPpsgGQeBltihpfuqeSRPOZPN3
	l4HD/IBQigDdBHNXHEu7X4qxCzIp+9+BQKI8Y9D5CgeN2S99G4b8rSt4zb/HphroHHGx9BtzSvHTY
	KDDoVqfkuXC314Ke0E0PtbrhO/xY2QBQM/+WKNNSWwx6SN9q0T8d7y5jl8kL+pJLG4WQ+DEgPOLPR
	P8mOr1Ph14ofcg5391gb8s9PcalP/FxCgWxq5Ry70nYwIS3fBF64vs+CsElvpEYioQ8ojUPEctvRd
	nOfaxed4pq1PTG228jCmhS6tVrkyJFP4u6+0tv07+haX2gfwDPG6R25NcUh/2zkiI6Ko4bpIS+Vc7
	/ft+fiAQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFoLS-00000009gmw-0y3y;
	Tue, 26 Nov 2024 05:42:42 +0000
Date: Mon, 25 Nov 2024 21:42:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/21] xfs: convert quotacheck to attach dquot buffers
Message-ID: <Z0Vf0j38FOC6RRHo@infradead.org>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
 <173258398160.4032920.3728172117282478382.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173258398160.4032920.3728172117282478382.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

