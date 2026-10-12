Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4E231D72E;
	Mon, 12 Oct 2026 13:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810648; cv=none; b=ncuFnTnm4Mx1MUSBO0GAHcek96VfFS8shiFbC5mY/1onQFro3dYTPV526eh9SCuWTnWvBGqK3DJSOiVyFNDcElJZDo/GW1NuCjOvrl7EXOwX0OLNHCmXA1qAVnj2AP2U+cfQ4iF36bgwBmtIHMpsanbGXneE9Z8HhXUEo5ZcbYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810648; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FBcLDzefRfZXpQhnzQLQdM+u+5lFO4thSFNpe2rWk7jHMeQ08RsqV1DaArpG5BOw8TxFs5MNFQbhOq975LUqHajYM2EhFNUMVaqK2+cO78y0uN1bqRkX+ZT/nrzX1UN1BCK0+lvEU/ft6XscgJU22NO/5GTcJJtnykkR08I0w2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KEBPUfoj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KEBPUfoj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=KEBPUfojWq5+dx+vAcItpmrZdn
	kNZ9LLGtbKA0NBYHowncnINwwR0T0ZgAXCox2hugZ4eF2UUq6T88MPMQzqPf/CM4ZQc3oJP/35dY2
	5vVdDyq4t6HR72+f1FzQu5AzNjipeiEPZQ05jiNF8nqLEgFOoX5w84KHA9MY400H+BdVZUGxfMXYT
	iBOmOJFVOG5jC12LrPoAjoSnncSSXrSH5O2ug3CHYcFpPWCreHUJFOVuZI/X1pW64XaqQKEr2c8qr
	FF7MzElPzP3VK/6OAYInPvg374IGB8FkXscGjHxI3OGIjKiekNHY4Gj0T9RNA3CEz9klxfeWaesot
	vFFJ5ysQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFni-0000000AXHi-2xcV;
	Mon, 12 Oct 2026 13:10:46 +0000
Date: Mon, 12 Oct 2026 06:10:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs: clear set[ug]id mode bits when zapping attr
 fork
Message-ID: <aszcVt2XxQhf2F1h@infradead.org>
References: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
 <179178065389.1058326.15301245615537747127.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179178065389.1058326.15301245615537747127.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

