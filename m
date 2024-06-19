Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0794A1D;
	Wed, 19 Jun 2024 06:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777577; cv=none; b=nE/oAjmui6b1ue31MeZA++uxG7H4xzRpuF8k1AGHUrZtHibhoF2LonMLBldswidFlLq9u6eR75pd9R7fauKG8euCenOioBxsVw/M7q34V0AXnKmfg5nHo6fbtPIbciKiWW4UW4KSQ0BWGzFuEMwahCFWSeqF1Im7zElnzRlfpQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777577; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SOINIchQftQYYSpMpAO235IRfc1SuckcdCr0oBqxSbS+gr2LeRuQeRVQdaOA4boMn79D5Evw0+kdyrTHKkLdFjnfNablxidsaQeMlMetjEjiOgcKOvasbQ3mt0V87b0di7uY2NfZ3bn7m+aoY49n1MLFtn0ojOwJNGDx3e7sH10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TIyBe5KW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TIyBe5KW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=TIyBe5KWh9MGeqnWJAoSdNOpwx
	ww0lw1LiRoXh3wSpnW2CHqm8az7CCBKByjpEERGb127KWHfO4Ic7k0mep5pItCv9+KnOMbNb8ph2d
	O2FpgyLQTeawKt2gDIsTCjebR2P7EbLwqwWBSXFjdsH1FUrCeHJzPSKIZaGRum7q+Y3rySEnYVulB
	8PW0xexK+zAKJXu/71lFBlc/toY2ncR9jnKnXYVXep95CwJAfH4kPjayJYfc/adyTa1Q5a6avF5Cd
	xuCGmLxeAjRWlcZkm0U8oLBFjBsYv9iJpOs/JiSzk/m8QRTIwunkrxqMaPKMBoBM4rGenE8LyYgSc
	0JqXklpA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJoYx-000000001RJ-0Meo;
	Wed, 19 Jun 2024 06:12:55 +0000
Date: Tue, 18 Jun 2024 23:12:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
	catherine.hoang@oracle.com
Subject: Re: [PATCH 03/11] xfs/122: update for parent pointers
Message-ID: <ZnJ254bx9IVHnL8j@infradead.org>
References: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
 <171867145853.793846.10098023133879667583.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867145853.793846.10098023133879667583.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
