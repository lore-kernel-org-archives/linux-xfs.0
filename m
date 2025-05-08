Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC1F146D6A
	for <linux-xfs@vger.kernel.org>; Thu,  8 May 2025 04:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746678014; cv=none; b=jsiKBJdciAxY57hzbrfblJwpTwjgVbHQ1DusctRrlY1I9Slp+BFZIQ9R0ORxu7HRp9zbsQrCtp6xMfe8zEu8uR4IT1SasJW3dhjc+sKEM7YWYzULRYTaWBljUc4/+jY3xyi5mEN9FRPnEVKhwVWsH9x8k1Q4RA0axj5X0PFQLxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746678014; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cbB2ri4R98HerX8FBfqrsf0bSqXkfQO9OA2dwf/JLj0nIbkgy/2kFa0RyPw1Kj+JgV9R9IMi4xTVDKPaoBaqLSJvlqxSUAddxJJwbxnAtsq9crnD7XbLZjRXEewB/fjGeIdJZHzJcmSgleh0JXVGGq/y5R2iqytW9k37kTugcAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3jRtwxZl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3jRtwxZl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3jRtwxZl160OeH6akmqXbFXjXo
	61O9blmCOtbMESWO1ZBhLcxleUKnYAB6wB3Tf0vy16thTOBCKlwAAIOq5aeKLaylri97+uzrxqJbU
	yXtTAouCNB2WfVRu4gQkJJG1Nz4iid3dwJz3yZApXRhcyBHOQo5Ejg7uSBnW7RFQqWH3K8EBUcoJ2
	Ijv+q7YfT+aOCj1GBzCh+2KhW6TI2zqfKzsy/onJN7AjyaZXbCdxyihi/+JvXjKljDa7+RPP0pLmE
	cVdPNHi+75w6vImmXoOxj+F5TfLWG7PAoDDwl3yq+G1/3hNz2vJoRnHFe2EXBeff84oU7PDqG/Hrg
	A4Eg/T+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCsk1-0000000HHGT-0F60;
	Thu, 08 May 2025 04:20:13 +0000
Date: Wed, 7 May 2025 21:20:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] man: adjust description of the statx manpage
Message-ID: <aBww_ZotC4J1pPW9@infradead.org>
References: <174665514924.2713379.3228083459035002170.stgit@frogsfrogsfrogs>
 <174665514991.2713379.10219378506495036051.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174665514991.2713379.10219378506495036051.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

