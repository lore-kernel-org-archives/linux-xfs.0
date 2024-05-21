Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0CD770E3
	for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 13:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716299965; cv=none; b=jaFKuqcBlugY1zplEIt8qMbgZkECxhWl/NTmEBMxLfmDSRDflkfBTFkV4BGYWXwEI9fYnPSQqN9pKFhrpNNyrgqsbXEDqN9tajf0iRRKPmuXBkJUcxvmvy7CLnsK3H2h6AhM4bWhtxBQrxHF6ufXK4it0XuCLo0VLvemM4297oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716299965; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SKwC+XTkxdjrydvDhSUeRfltHCaMVMR5wl7LjoOG5Aq1VmhAHl1+YVb4T/r4vaGWgf4rmumu0DDc3XImyvDr79h6iNsrWvrFM8WU60MwP5OBwz/+YJk2XQi7+zh7SPmPyzlVPL4aWsSGRAQvtQK2hUyE/SycCn9SkV4RFBaPVu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=shwgaTsL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="shwgaTsL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=shwgaTsLbtQ1vvC4N7OOWsu1pg
	ExHhtVC9RxjBfyC7wILdsLnF46E3ggeYYRvCezMrmA8Sjg1J1OaA6UXfDs5aHoBvEY+vveX+arEi8
	auYXvIiRb4w9FAMQSzHK1jqR1inQPhHsukeV2JXbvoC0KYbq2lLwsUjyuhE4bWpWoSd8vNbViG596
	vtPVGAFEx67u+eviy3Szdas889MCw90SiCIJ3XHzkmKIcadMhazvq9cxEXLRjcapb4tPN8lVzih4w
	8qeRUKpxoGvEWA3X1jD6aKrzNLGWCOzlgI3zBkRQfPNigBKXGA6mjlCD37hcVlyniTHlVTgO+YBH+
	JbRtk+Jw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9Q1T-000000004zU-23Xs;
	Tue, 21 May 2024 13:59:23 +0000
Date: Tue, 21 May 2024 06:59:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] generic: test creating and removing symlink xattrs
Message-ID: <Zkyou1YxhCMDSfjH@infradead.org>
References: <20240521010447.GM25518@frogsfrogsfrogs>
 <20240521010603.GN25518@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521010603.GN25518@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
