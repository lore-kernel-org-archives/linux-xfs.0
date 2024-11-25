Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731602AE8B;
	Mon, 25 Nov 2024 05:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732511577; cv=none; b=GQoV79hera4rwQxu/dzVzeAnZiMhko3iF7ngkrzSuN4ls21tj1ghZEQv1L/nDUFKasCgynPVuz8XrLQEp/fAJr9PckzZmAd4n9cXfZiZYpGKTKUXmicZDT9hlgZAte+7lZk8Su5192tI8g4NSzPueSsDo3LIcF/u8f6WVJIazy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732511577; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ik07oEedVbu7YwcJgz8ZqXzAtOipsvI++yHaBHzVJpdLBS/r2LYBgKaak54YqUji2fKzftsn431cB+6Lec1ziuiFhyAf/iLCA1LiCF2tJNdCbkgkhWdA4k0/g33bm9D/uqEF9gDXvrA+/TCQgqbrxAEzXdY6KIFpuF9INZDowcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AFC4PI9l; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AFC4PI9l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=AFC4PI9l59C6Wjl5Dy25gaWtW6
	UD90gTEm9bE4p0a2b8pqV6w72LVDz6q/PgDlQqgdCkPnfzG/F5KtY9utVebmKp3/Xw/HVbluix+nD
	The1M8mKyXV8QR2zYpjaQ2DhFvBo8+sZ8WRS5+euuPfQnzhMjeWtvpTWAizNm3jEKZIHBPMW6T4yl
	UByr1cuoyGwakowRzIxiEDdrR6l6OuDDO0zQTPIY7aF+R4yO0VrfB6MVRM00LDMd8NAwyAX2jJ0pM
	YZS3LzETtAawda/lvPQyFr3sLyj4s4Esz5OyE8d3yYlYyMt+IXVRnHpdTc1Q9VALv2fsZ+WV1tyu0
	tE81kPHA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFRP6-000000074d2-0xZS;
	Mon, 25 Nov 2024 05:12:56 +0000
Date: Sun, 24 Nov 2024 21:12:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/17] xfs/113: fix failure to corrupt the entire
 directory
Message-ID: <Z0QHWKTbF35-4IuR@infradead.org>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
 <173229420102.358248.14679957569173990136.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173229420102.358248.14679957569173990136.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

