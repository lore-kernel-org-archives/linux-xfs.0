Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E0435949
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420454; cv=none; b=jHcu5JntmPZA4VLHZEsnQpT9VBENVoQLinvb+RQDmIEY0Hh2FRS2cvViapLImHtu73TkpFXXVj2jdMxym1AgkxPVoU0vLuNGNf9K9jMA7KGj7KsPiE2ldpTuXAwec/z0X2RCmXNHV+Apd4kqbolbyBV2g8OoiHv4WMafh8D9zTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420454; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X/0vLsVGFuU6nSzw/2bD9gKHjnqCgbXOCx6LHr3mjoiFm3hPu9zytEXm7RUhrnt9Qro6K48jY9U3eXybinD4c4UCQTsLDjK6ZKe9/YroerBX2FMsx4XFoPFEAHXsjvY/eF9czmbR01URXA1EuhKU3ecGUTKGXdN58iYIrB9aGjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0tWBYkl3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0tWBYkl3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0tWBYkl3vmJoSCeIHF6IBpYPUW
	47xCib8BTsjyegPFyCqcccqayx4CjEEmTBrHcK7uNU+sRVA/oHjuetJGfoTsqMEFbS8I5CqJqkDRh
	Uujz27HBYM5e9qIaFgkAZyyBalDbm2oCiDqAq/Y6fHlpjYNOD9jXhqQ6SwGcdI+nqXaxrY8gp6mX1
	z09jq2eWu3nTfoXZaCO9WhkGgtZItksAS9glejDlIMIpMDr0jmkghPNtibkXlZbYsM9FNJdtaqVYN
	7xjqOXHTY5gN/XUgjcj4eYF3zltCuAnpIz6tEKAF0+zT/kY/FaWQPUlofJyMBvyraQE6407e+AjTe
	5+OxbHJA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQia-00000009hsK-1fEu;
	Thu, 13 Feb 2025 04:20:52 +0000
Date: Wed, 12 Feb 2025 20:20:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/22] libxfs: add a realtime flag to the refcount update
 log redo items
Message-ID: <Z61zJAPO-8zbjSd7@infradead.org>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
 <173888088965.2741962.5146151692664108906.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088965.2741962.5146151692664108906.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

