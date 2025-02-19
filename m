Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CB615C15C;
	Wed, 19 Feb 2025 06:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739945031; cv=none; b=tebIMETBeTx1oPCupugiR/8G4nxFwSiw/IGxLQjqmzVNrYEx7uqJ3Kq27RMQqpPG13vXXVnPKP5asTpEwLWPkcoz3H7DLBcZ6QIJ7RAT8f0PGXT9fNsMu4GO4TDUE8NHmzK0f9saJh73GbxcfS28XxQn7cQ56q7GhO0VahLbsdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739945031; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ifj3NkXfqQlyENQXrKFpfi3yPldsDUDyYzh9sMfZbNzSflNNMX2gKm2PFj8Wapb3smzlI8vYTrSQDs3gutKbfjBjulnwrWaTSTx7fQnal46dGUbzruB3zGp4ikcaG8viOjHfDowZCIss/Qd/Qo4qEpvjhlJ+RDJw24hcXFUcrPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OaeTAGg6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OaeTAGg6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=OaeTAGg61E0dayxa3DSRu+VJxS
	KANlF2HGhT/+iKSgXJr5XrTh8bhnwOIL3dWH3xHhYlhYJxF1U7icrhjuUDP5Caa64aE53Ed0d1PV8
	DwuzWuA24i3c+QlOUj4cUjObv8g55KFhnRR4wSa6a7wmCtiaimbbU7KKovruRBUL0OqUftbMlmedZ
	SFG5pTSLIComDmJX+ZP3f1sdMvt7xBL1hCDpPcWVzkk2KA7azFbnsdJwYqxlbFMrQDQMOI3lBabLJ
	XPZJIPZBS56og/1urCAcW7Cp8T8TjfmS4K0vxexysrek1aRiuI0gD5Vg1z3s34PJ6ZmYsz2TX2FWr
	xysUFIRw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkdBV-0000000AzHA-3SNr;
	Wed, 19 Feb 2025 06:03:49 +0000
Date: Tue, 18 Feb 2025 22:03:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 03/12] common/repair: patch up repair sb inode value
 complaints
Message-ID: <Z7V0RZMqshIEvnyi@infradead.org>
References: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
 <173992588116.4078751.15663339276086108396.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992588116.4078751.15663339276086108396.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

