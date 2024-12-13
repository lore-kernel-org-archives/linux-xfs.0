Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043E81ADFF1
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081023; cv=none; b=uHp/860teQ4i+tenQFxxB7O4DhjNVWOuNijV1L/bO4Na9XHv3lIZBpLQ1moM3ceX/sdsmW7YHn+JvIo8U/1ilWwAkAOlqNjLyvfEKwMuHmsTFWfoYyKY+6xGLZPe32B/B1BYlenTxAkGZ6kG+8t4ZobS1TwK6TgW+iAEOgtyxvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081023; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cxui4rhCxD49Z3iPby07N7rY4GIzIEeMbuxzp/8rNuZbg/f3+3bLiD1HgD6yu22PipVaclUGaMyem4rlrMVakB7cN+e5pk5FFQ49kbCqXtzu0RDDEpswJwsBIFVUL2pOemmRwUd8myPZF378urk4UNGt6PDJFjEXRPtAuEytEBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=L6nD3aIQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L6nD3aIQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=L6nD3aIQrALdK6l16tmv3MUqjl
	gqoN31E/MNs25PvzmzKRNqypVVXJoC10qtqQLpp2G9Qnxv/a+PLFpQJla89sfoDgu1WpnFQuX2kic
	MqJ1mzTjj+1TKsHJA8C6jP2y6n9ZK6GrHqX4UyDtmqAZMZLgN9tsjC53idO+2phOQW0O48HvBBNK2
	6HbXUHYIth8aTC9v5YV2WwNTUR7N7PKeBmFDlKkCel9pPVa00/X7w6Z2lIELlw7MbAND7SodN6pti
	dI+aZrBdGjBRN7y6j1QknmJd3HMwV3G+sVTcRBIhwX/sehpNW6IPI8AdexCcVRbXrQckH3Lb+z3eK
	HF5jh1pA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1gj-00000003C20-2nEm;
	Fri, 13 Dec 2024 09:10:21 +0000
Date: Fri, 13 Dec 2024 01:10:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/43] xfs: support recovering refcount intent items
 targetting realtime extents
Message-ID: <Z1v5_f0L8jSEilxa@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124705.1182620.9898053925515649452.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124705.1182620.9898053925515649452.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

