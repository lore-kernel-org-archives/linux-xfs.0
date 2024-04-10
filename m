Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2D210A13
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712725523; cv=none; b=RHs/6i447E3z4NL2sec9pOetJOjHgsNlizvRKLxcvjPPH/pH0PfPuhvHLmAuPuipLKA/CMEeG0/tNA715kIBAOtNqkZn5sc542KJGErqLtPFLeRTPE4LnL6bpprq2m2Sp+77FOiJYsfvKFObIGL4OvUdgXTbJh3hAO9R37nIeoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712725523; c=relaxed/simple;
	bh=isEB41uNiRXIt6rnZHWOOc8apJZ2Lcntfp/MomMIiRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AstamqitNAM2sboeSy4kyILutvqTRmg+zRc5iH8lyFgHG7LLPtAuGgLSukTUPUA7l6HDP0Ja/XehiF7ok01NdEXz2l4w8+3TcdsA8JGPSkZuG7GC6aqbHLpxwPjefr8yh3S+f30LzLotEAF7so+LCSpR5VOBbh/SeIwiM4EgID4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pFJmJ0vG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pFJmJ0vG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6iD/ijE35kNyROXXt1zoXof+9lPYk4VK7owM7lDbhHU=; b=pFJmJ0vGzj7s2jWqJXBHnvlZOp
	4GMIFz/LQCUU2JnuJG+Ih9KOu/QZyCqSpDKWAOV3a9yBKuQUgrD1MHu6avcZxPLi9bgtsLV+28RCm
	+hspIepQtsyKDcno9HyLdiIBSW/FG8EaQHBIosEEqlZLPyfbtigCVHeRjnK+t7gyVavOq+05+Uth4
	dbay+omLD0bmrPVzzTDMtRbOePs6WO5DQFzDE3rPYGkk9Lx6DigCiKkSeRlaQyDRIUJmhYP3/po5e
	fuiYvE8NHU6j6P4Urh8BAXlee+hhqZxi31P8sTj4uK1rlqEvlQaXYR4ySoVoRwg16p8u14MRUu6jq
	vlNhrQOA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQ9B-000000057Jq-2r8n;
	Wed, 10 Apr 2024 05:05:21 +0000
Date: Tue, 9 Apr 2024 22:05:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/12] xfs: check opcode and iovec count match in
 xlog_recover_attri_commit_pass2
Message-ID: <ZhYeEZP1SJCNnn5X@infradead.org>
References: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
 <171270968918.3631545.8245038196869543271.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270968918.3631545.8245038196869543271.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 09, 2024 at 05:51:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Check that the number of recovered log iovecs is what is expected for
> the xattri opcode is expecting.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

