Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FB771B48
	for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 13:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716298778; cv=none; b=kLmVEqMTI/CRiwHHo2Mr4RvJUD0rBmQ5N1RKQ8/R4JWWCrEOZwPsRlCP1x2pzqH8+LR3CjeaSMHO6XQzYYmiUx7EV4Ww0SS/x+91YMk9LnOmf3rkQGOUd7yvOJhhGxaqAxuZSan6eDnp3K9SjlGJGhe2kcjazcNXzjiLc8IomlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716298778; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ol1IF+m9ijaSR9E7gnPwlw7ijCkZ/iz3ZHEB40QhvqzeCYEqBCGPu7vNQUGH7Szdn7uWCLoIciE0YlgnpxbpMHVZ+wPSvrLviqL1EKYi2zIQvBkNLywswyqbEnomgDHrNifT/mZUkoqbdtxEDJNSe79nO4al8Nu7pGE7Md4ZVGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MdY6Sucg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MdY6Sucg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=MdY6SucgOm0yGQ7fAcuZdvhN7a
	zeUui6qcRQZFx/kAXtyxWa1FIb2W5O6DEW6YjUhy9FDEAFzVgREsT94s4SxaIF3Ahojldup2Rdt3i
	FiW3R3f1gRUdIQdnEA1Upmt9pvo9D8VroMxnQu2Dt42BKRMt8lopxQKBgDavYOvyPvlPlhHBrK+kw
	3nYvGCj8It8oWnhFRLrTSFxF5YHeZZ/zCckxRQ6i3tdGOrfqgJZDDkMxR1bBoNRE3vASSj9x0qVqU
	uLbyqqlhlOyB2ei3vOdBchZK14D2L275GOs/xWa89SWriih/sVAbndm1NZARNMAEhGAw/9BNOx1JL
	ozdiNo5g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9PiI-000000001fE-24nc;
	Tue, 21 May 2024 13:39:34 +0000
Date: Tue, 21 May 2024 06:39:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: drop xfarray sortinfo folio on error
Message-ID: <ZkykFjn5eO9gIyoP@infradead.org>
References: <20240521010247.GK25518@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521010247.GK25518@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
