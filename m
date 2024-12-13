Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6164A4A21
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734070109; cv=none; b=YqBquWeJzi7CwmpV8W43MetovjhHNpSVzH/9Dk/dowlt6N0h6lXhOiTfNVY8OxR7WVY/ayqoe1CKTbi0p7rtuZemSojykSJ1Myq1Y8JvsJIMA0OzXbTalKN7nyzoT8080vWLXwBNeQnbVhgc2+xelRUeGF3h1UmP8MfXrIDL9qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734070109; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=do5Khc5CvF2EaX8em5kbk13fH3PqpKEr9uIeUshIamP+FZi9zSG9OEnnAcTWFMfTx7eoLwVkR4XDXQYTUjCnriJILq0VGAfIFheYQXOW78Tqov7MxAFpribWqA97d2GGrO8AF1h9ctJvApU5eGgPsGNhwATVyE+j79VNM3x4BVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vd+N5723; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vd+N5723"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vd+N57235NLgCSsLQUbu5TNgRm
	9/Y9Qouy3DbebgUH1Dr433ohTpmvByqDhPtLL/92jjLOmF5oY3fujPB8WmsW3S8AMPoH/6uRQBCud
	RdHLlXQSSYuPtr8SLnI1T3LCq5NSaxu7leAMmu7Wg2CEeOc+CB/aYxZgC+1HgTz43vlaaiu5nrxAt
	gupbGOA1LAc01yewr2lUlRvYcfj8213XUtFrAnqQXJy2OYmy+frcAd+WV/zO/CB9nJfbj6vRf4ae+
	N8p/LkgwIuKKu5kN8J28RJgle23QTjDoImUgpilruKWs+XbCbNV87k9hWWSEu9RCWZfSOq3Ksrxe/
	norDR1Pg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLyqi-00000002puy-0E8P;
	Fri, 13 Dec 2024 06:08:28 +0000
Date: Thu, 12 Dec 2024 22:08:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: hoist the node iroot update code out of
 xfs_btree_new_iroot
Message-ID: <Z1vPXC5AaZJN0Kky@infradead.org>
References: <173405122140.1180922.1477850791026540480.stgit@frogsfrogsfrogs>
 <173405122263.1180922.7163747639662994394.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405122263.1180922.7163747639662994394.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

