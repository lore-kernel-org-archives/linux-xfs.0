Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8A154BCF
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 22:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710367318; cv=none; b=UWJdk287ZIulGNvKM4riu3JM+yg4xpZ5xt4T0x0pdFfOkmSdfAzm59EEVFd8dMkndIcmj17FeoEMW0OjcaYHbmbyMmlN8jA0Dau/HJIn2QSzE9s1tknjgLXuMT5UZYIi07uBiDZwvIxg19cr8o1MmhORy7SaZ+ot5C7erS2cNxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710367318; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=su67OZCnOdmwcUoMxp45lzlIsgqwu2JK7/mDWitKFsFN45w+RpRoQ5pYfllCmrPegYiOt+QK3VTrowB0OPqCKsSafiR/RW1vOgp81F9IhXgG+NWRqLtiE8cElNZGYt/AKBrz3gGQxoOhGhRsy8VpoKs3w/tNJQOpmXnw2cUbl/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R7wXdqXX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R7wXdqXX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=R7wXdqXX7btb1hTf0pFt0iQiAQ
	PJOdXvvIQ93xUGNPXFF9kmDejCHMxKQA/tNIVwoGQ/G1q5Trf3k5ql+A6gag6CLoZGIr0jZcbACM+
	95eeZFRHqPm460N3lh9Vn3iW47krqPXWN3ia2Wx8bv2QxfV27IBnlbWzXvjUcFfdJinc9YM8RBroY
	wD3d12VEG7m8U25ddZDotBlWmigQLspdIweTYRMd60VcIwApF6qyMitMLZWLZ7klZRph4gtAKEuHp
	v/9Vwy/nCXxq1XMUypawk6+j/x6RfBUQj3vqUHh4fxQlkIwgFbPpE8JIBCLrCZ3LaB7/7aPBdR3HI
	C8y4l68A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkWfd-0000000C3xb-1igG;
	Wed, 13 Mar 2024 22:01:57 +0000
Date: Wed, 13 Mar 2024 15:01:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/13] xfs_repair: convert helpers for rtbitmap
 block/wordcount computations
Message-ID: <ZfIiVQkDPVN-7WjG@infradead.org>
References: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
 <171029430686.2061422.7471647213070466430.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029430686.2061422.7471647213070466430.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
