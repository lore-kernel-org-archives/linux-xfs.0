Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501D435DA40;
	Tue, 22 Sep 2026 05:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790054437; cv=none; b=KXCyWjr+KWJABzbbKd5ht4fMkMJ71Jkg1O6FXc4CyNA6h2kiUx6tasKBy78bovf8PcEAD6GmfQ9VTchsmIlxeHEcbB57bH1sCLFfqvhduyLu2R91t7Wm/MylJxE3si8NAsZURmilFJr3zeJBSndDO57ou5Xjws0LiKuu5gjETOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790054437; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bjUP2FwaB36H0DvUsddSHWzfwhU0df4u9qMt9+C9ez3K6BMwCsFwoxu9vX5MxUeL+wU0BnA1yFtQvbDD8xbCKKkAjNrNOnB+DIoaolC6HbEyaF42kNAVcO/PPTIRBy8kVlChi0rzod6yAK8P4x6na25BPc3PGjIRo6/nhnNpKXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Qohok8gJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Qohok8gJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Qohok8gJMchzvO96sUWTlOnKef
	ush67AMdaBwr0dIrrnvS7xFKruHXmKBKydaLjD8GCFc9rmy81ZN1O0lCmhM9DCAmqESdGUCTxNXPs
	6FWM9ow01BW70ZakE2imzJ+V6cwM1uA4aXaDS04ioq5yTDHbNc1MttGntzx1Fw+hZGFfqyDkeCF5w
	BY7d5M7em31kCbTXNk7Q6Zx5ulTL84NGmVTspSSkR8s94gNObMZBkTWstP6pzVgUvZdfgDyfPAquh
	NtKwtUp425clLUl6vPdQELWIVwD4gwVWHtbfZogYRuA+4qjioLPWttT6kh0xfnIfGJ4iINmbwuYI+
	o1XnyeCw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8svj-00000004ElY-3WNe;
	Tue, 22 Sep 2026 05:20:35 +0000
Date: Mon, 21 Sep 2026 22:20:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/14] xfs: fix ondisk symlink target validation in
 xrep_dinode_check_dfork
Message-ID: <arIQI_c8fdhoHRcN@infradead.org>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120700.181988.4590274849890145532.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178996120700.181988.4590274849890145532.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

