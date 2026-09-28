Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A44337C11F;
	Mon, 28 Sep 2026 08:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790582869; cv=none; b=TLQgoEohJsmuF4g5OkV9GnABIfY1XX/AsSHyBc/gMRy1Wo1n9ZBEVjP27roS6Cnb6Z+nFUKVoZNur35Wj9FBpzI7FSZoqh8ohClYCJ7iWZTulshjfGeqGLF7CPdVfzjxR88rRgKks5WEpNJEs34BGRrDnQVWLDIen1qs4oRsxl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790582869; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YDMqQ364EPzWsihV6sPxz9fEGUjAu5ecTe1UW/BiX4F/uPNo9gn4H2vc1xxiLAqeb0N/ZsjoZ0zguQl2k7K2vTSIILWEx48q/VAFmqONj3r0wclHRnYqGCclwpmPD/UDg5nOaXOFM43HCewD8V6/bhkriCOQmDCIOZjacC5myyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BJz6S1vj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BJz6S1vj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=BJz6S1vjsw3lSiNIsha02FM0MP
	V9C8QQBiVMeHAa9Zv4cpQHnOmhoP4uyBazOJ8UiMmqggRiKKwLmzLb01BK02A3DJMoynCC8mZk4xO
	JKT6nj7LwetCQLCTl0yvgCtZb/b6OkzEtQsu/g/yeRCUaambs16jRpmunWzXiZ80z3NX+2Csi5ZYl
	GVSJXzko3izacwUzCukNHgZ40A2UJRpEWHeNIUvpBdBEGNpLt+fh1vpClGJSmjXRzuP0m9FyucZWQ
	nMuwjwqM8YhZDMBT1V05/zmDLB82h0gzehPFKp4cbjZAbTfy5Qvtml8zuLaXhrsLfAMMOCMt22m1T
	O8O1zegw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB6Om-000000001Mr-1Uth;
	Mon, 28 Sep 2026 08:07:44 +0000
Date: Mon, 28 Sep 2026 01:07:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/12] xfs: bail out of directory tree repairs on error
Message-ID: <arogUJXARZ10gYPj@infradead.org>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
 <179057612682.479634.10962408939364769676.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179057612682.479634.10962408939364769676.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

