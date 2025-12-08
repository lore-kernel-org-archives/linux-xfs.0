Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0677155326
	for <linux-xfs@vger.kernel.org>; Mon,  8 Dec 2025 06:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765176222; cv=none; b=cmTirI72war73V1iFj/fbQesC4YOqP7d9Fzw4FiS67ColMY5+yNszpV75HMNX0vvnJFTax2aYzB79x6p+UPbcSTosg2R0okTuX7Khb0w1x7hhy+VU49X5LWINwfd1n+O35jKbaXqsYeeyfdMrwBnIuvilNAPEspZsxXG5lK2MVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765176222; c=relaxed/simple;
	bh=2/Px50wuebIB4XGhh5tXJk9aNCzSmtaaPPHvgJW/27o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oky6kXYIFJhrkKvmSbfexSRF88QpMrIHbJhzSG0fNzFLKfIFAkbF8X40p54w2goT0gybn3QN7TAfJJf49YxHkF8i8iJAzS1Qrp76yIQdGUpnArE33Jj2w/yM0I73IoiGCtT15hxOpprPuqix5C48Gz68a/X4DqJtZDugDdBRG5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3S5akQMC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3S5akQMC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7KiJ0SleYr1KUdtASkzitgBUP81yNKqLc8etgcPyJaA=; b=3S5akQMCL3bpHkTlpIXjKp2gcb
	xYuoaNDjuSuX4XwpI84WiwFBka0Ff6lHC8QsE3xAzU9PLb8qnRn+2NZ0VLhMo3ELvYWFe3R8Gn4zE
	RpwbZxddoAEo4g+NzzStf1HRF32LNfPwUMYurv/8V9d4ymc4RYZm6keRAOUMvhZ71DSpMQhG0mRBB
	Y6AHbpmjKIrKJKGSIZCr4rExp49prAeYnksWBiF7Wo+kKER2RojmnlfnZLROsGQXz3+027ctA3N44
	5Di3AcpGnDDC5GTcgT8uXKbm2+D/tQfeksOquWzJHub1p8h9zhujFz0sOTJHism7d5/cbt3bCFn2w
	8KRZFckA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vSUyA-0000000CiEz-03Eb;
	Mon, 08 Dec 2025 06:43:38 +0000
Date: Sun, 7 Dec 2025 22:43:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, arekm@maven.pl
Subject: Re: [PATCH] libfrog: fix incorrect FS_IOC_FSSETXATTR argument to
 ioctl()
Message-ID: <aTZzmatuLCSx2ATh@infradead.org>
References: <20251205143154.366055-2-aalbersh@kernel.org>
 <5i6vygbgclhg2u25yjmfzl6oac3l6mohvjqwszosj3s7av23pi@gjylrkdzcevs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5i6vygbgclhg2u25yjmfzl6oac3l6mohvjqwszosj3s7av23pi@gjylrkdzcevs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Dec 05, 2025 at 04:06:51PM +0100, Andrey Albershteyn wrote:
> ops, git didn't use From:
> 
> adding arekm@maven.pl

Kinda useful as this really needs Arkadiusz's signoff.

With that:

Reviewed-by: Christoph Hellwig <hch@lst.de>

