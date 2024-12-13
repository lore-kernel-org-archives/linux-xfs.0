Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90094157A6C
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081002; cv=none; b=smUxxJN/4lhTm9T+nZumNndWVjdOxTKJbFP2ZgPs1YJTD8olZ8jVCa7aywIRgLWTJjnI+1xbhbSiXxhxCmknVyDQIhhCloM7juVj8lWwQvdW6DmOsiXQ0aHXIuOYvXoUHj2V5e2XcyE2nnZ1oP4TPJL9N/sl/NQ52B6hvhuYNY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081002; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EA7VNAXJH00OsDeiKtHpH0ELBfO96hRo3Oo2vdATGSxtERceljfHgYVl3ktBs9uuFycxoxSAzE23dppZUHPAgkogOhA+DpO7J6CPSWCvCKZ0CawLbPDbmvOFledDSQUpQCMiBCn4k/TS8QkeprYiP4ulEKjU3Wt4xMWvW6tXQS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FL0De8ya; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FL0De8ya"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=FL0De8yapswEb+yf9+bOy89a5d
	GKi1I9k67lALPyZVl0DoQDWdAmyf/5lngNlHbjBvNb1ouLpKsR0gwrOpODmtUNOC8fLaZRPo9Fn0E
	NkE073prAAhlXHBB37ZzmLcYkxD7K09WBKMhQ+v37lR6OWw9njQgFLyJnH/tokD+1BIP4/775QSm9
	Kuf/q8lQM4skMU8jg2ScDvf3V50UpsjZ7SLbM1H3kYvMVaFflfDanb9Xz/bUEPGRFBHdsXXgh34cg
	adwUoM4SmGc8M+3Zl7myljqWBlwn2QssuJG1Zq4n88QYr0RXfT8hKWbb7NSX5jlA9Nph49TFu41BZ
	tZk2OX4g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1gP-00000003Bx0-1SyD;
	Fri, 13 Dec 2024 09:10:01 +0000
Date: Fri, 13 Dec 2024 01:10:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/43] xfs: add a realtime flag to the refcount update
 log redo items
Message-ID: <Z1v56TEwagbHd6_c@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124687.1182620.16319663799309491735.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124687.1182620.16319663799309491735.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

