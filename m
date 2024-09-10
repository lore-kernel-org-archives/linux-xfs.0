Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D385F33985
	for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 08:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725955567; cv=none; b=Nehv/N5mJrRAKGzPJRtMFPoVgBaarSYbeb99adMj9uFjttrTLjSrdRLsBEMJGNbCTK6HGgS5feXO9F/MqfU3OQhaQ7syhiwZFZcDwVD5I1Fupx2cZy9LsEq5C2nVFr6eTBVK00l87RRdh8xR71B/BA58i2R8HprKsfQmGNn17NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725955567; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cTafYADOSScJOk7R19VDdhlCIMpUWtHYhRqHRFEpKRUssu5NIDVXjgdyM5qqXZUU5bQ1vbJFZ5vsHURO1K434Gnu2tLAycWficgp9dMoUmL7NSUwHWhyvK9pcCF1p3JV7//ySz0edIVioPklfRvtmQaXreAYNSFH5KtpNmeGU+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WoiXp2Jb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WoiXp2Jb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=WoiXp2Jb3vxZA3mtwkABQHCcN3
	0ru9eISdQGEohQnK++HaLe+aHzctNIZGiR/zbIRLDDarFk1aLMGyjLDd/uu/bhFfLI8byhisHYFi3
	w7/uvcjCGQNIRGKOt9YHEh4ntSOdsYqW6vUN1qAMrTgjVMGzOOnGORcSWSUcIDQKiE3IUCGslkCZK
	7pGRgSauGtuzP+J1+C3jfuWJcrjktp6xWfDZ2kwwKWpCQlPp5Jlb74yk5aSshVmfj1s+JiyRVdGNS
	aEveNV0PSSCH9utsBpBe7VFQg2wJfMVEtrIixtWQQyEnOcJ176ZOV2zVutVMB31oN4iS21tXHbvyJ
	qGNcksbA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1snvsz-00000004jTU-0gOS;
	Tue, 10 Sep 2024 08:06:05 +0000
Date: Tue, 10 Sep 2024 01:06:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, djwong@kernel.org,
	sandeen@sandeen.net
Subject: Re: [PATCH] xfsdump: Remove dead code from restore_extent().
Message-ID: <Zt_97UxXnBeqlKC8@infradead.org>
References: <20240903174140.268614-2-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240903174140.268614-2-bodonnel@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

