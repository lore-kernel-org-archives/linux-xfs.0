Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A2879FD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808865; cv=none; b=FN75RZxvpGPqFLKtJl7yUTSt9uCC9nWtuXsaOxaBE0rvShkJ3/rwlQXmmhGXS7hMorPXLZQHNM0G0djKJrasFPXewVvhsAnPtAaW3JrFw7VyP1zuGd/7r/X4css/EN36gu1spkXMkk0F2b+n4gBbxIofpQoCQr33kTPEzAdmtMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808865; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZJBAhPX3nVdW5ms7hTPAzP/3S4zRKOpxkEXFyJEyt17KFbr+FcOVlhn0RPIjzVzEfZhTSA3IMNZuspwIw30V4SPdGMdC0fpkPsSODtiaY6lYHAiWIJ/cUyMSssP6yAB7sZnri+rZm2aPWN8Hsw5qmcxrQ678ETf0X1Md0S+80uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mp0Whay4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mp0Whay4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=mp0Whay4nHLQ7gMetjGYG6GxCY
	5AIKvuZphs8dm3OYXDK9Ux728sr+K2Jl6JyBacmNhkS1yNICNrs9xtBOHQCsuXPr7bsTmxdIe8pEy
	Y04MrIJUSLMnjgImIw9pwQLs1eCzr0L6lQNQsYagMlf8UOX4McWBsJW3/Ej3Ff/5tcmPUDYzo4nAS
	lf3hGH1fa3LtjUVkZUsxkVBPuBHr2kDSQgxMlZLBN8h2KI7kNqNwKJFNbrGWMJe0GqdnZtMd5YfwB
	rcdEAmT7EWLoppWNYF/aQPwnWqTEV3YoVN/3OGaSnhkGfPXk1MsLuGkE/Y/eN0qHoPRxa9j2LILRm
	N6Kod5CQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKst6-0000000AI2l-2BXs;
	Tue, 10 Dec 2024 05:34:24 +0000
Date: Mon, 9 Dec 2024 21:34:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/50] libfrog: report rt groups in output
Message-ID: <Z1fS4DSOrM5mGHMY@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752098.126362.1262402405604422083.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752098.126362.1262402405604422083.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

