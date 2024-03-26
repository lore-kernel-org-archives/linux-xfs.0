Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDAE29B0
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711430157; cv=none; b=LNwuXGz9lpcfMu6vZ3t6jM/j4j0oZLikrRTVgqpJpEJ3VveEkm0TX0XrbiSKMFZs0wpiCaQyv+EShJ0J5we5i0cMHrpil9VGcKXihjU+dmNBv+FvAHNQpAczurUZ2bpKCmgXsrZPL75kE1aRN3PnpOCeM50A6sKjM3xG98ykUxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711430157; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AWenrZdSG1BRL4SfdLwA/2FgMtqmHV2UvlzYk/in05Z6uwGF8WabVSWM7W+UK5E0A5uxEaOtfHuK6El81Jx677S9kQhTtI8WYujtUccIwIpH36nRFZRqElblDbYy2wliCxK/DHtV9TxlsXLyfbRCpT+u/vn36pbvT8OXkxUuv3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=T4GepSVk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T4GepSVk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=T4GepSVkFU/OAAffiUJUE6ta0n
	L0gHVKRVXXynYztxAUpx0u3v2tCGoiQrAhYE9O+qn72xM+pgHEChSMWIoiO0nCvqokGitBfHYeJdv
	34C2uYY13lh9ZQ1/aQymtX3Vqp3WNbxZZD1o7wrBlSF0OxWvlMpUsLyEz0OfbqeBESLLczR8lMfT+
	qJKYvxA2PQ+EVzhqDHqVisP+yhJeC2xpwUP8a4l5j++2QTyROvWWpIGKhhKGv0iCDLXUUm8FcOvrN
	HcAwxjQ3FfNxVKnqM9pwe1CUms3BjkVZUHUmt6sb222cVcoWGBNs/Qc/pFCsxIMUKrdFjdisvM7r6
	fde5Fefw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rozAB-000000037P8-2IKU;
	Tue, 26 Mar 2024 05:15:55 +0000
Date: Mon, 25 Mar 2024 22:15:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs_io: add linux madvise advice codes
Message-ID: <ZgJaC3dd6ZSnwOKX@infradead.org>
References: <171142128559.2214086.13647333402538596.stgit@frogsfrogsfrogs>
 <171142128632.2214086.17684623757351495391.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142128632.2214086.17684623757351495391.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
