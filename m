Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627AE1A38F8
	for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 02:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710382099; cv=none; b=GGCpP1pGxabpqi5oTE+5iMXeismMmRN1QSDDn8Bfvr5OGJkArSsoSoM+EqhngV1AKmQmEmz69dyKU/c5SmRqclk8A8wSoEmJHUSrwELo79Pkfe+86vbsmn7rFiJOKNa3omIJjgwEnfGIoDLM8IvzwGCTqpyn7z2v9zFIj2bbW4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710382099; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=amgpIKuDf4vZ0Mv/nJqZ6SfPUVDFoVXhLlRJ73wsUVaQdENd2SB72q1oK/oGelSA6r/NTJnMvI0XGZBA70bDox/EAMTNkHmT2icmsnLUlVdOH8JfYKa2zam9fKXudPpAyKMJSunPbOhCjrxeVlytayIIxnWzMJcS0uq0DdwwmfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=h/SwctB/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="h/SwctB/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=h/SwctB/OeTVaByjVf5l3hGn6u
	JF/dXAq6MSNQNARO5EZ4w3tA0j16llN6/vO6NN/vocPk9GtsHlb/GGJVeHy7XxRJL9GAXRN7dkQlt
	P5G8FRJpczaIufNMNyzh38iJQkfq6f1pT5sJz82pOnBjC9tpO7zQJCdlpWVk8gch+3vCEF9SkRaZz
	Lko2xCeS0m/tLt07PpvYSXZwiWXYnPsEmcYwggGeHYG0UFbZlm0C6a0H3tjGpt+CPAhmUj5sC2Y3X
	aslMViuUIPByTSDUgkqg6aoyszH/hzbaJ+50JrA/x5bJnGML8Q5Jcbjra8u42Br6x4J2rhDMisdvH
	/LxPjVAQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkaW2-0000000Ce8r-0TTm;
	Thu, 14 Mar 2024 02:08:18 +0000
Date: Wed, 13 Mar 2024 19:08:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] libxfs: clean up xfs_da_unmount usage
Message-ID: <ZfJcEozfX6yKcbzK@infradead.org>
References: <171029435171.2066071.3261378354922412284.stgit@frogsfrogsfrogs>
 <171029435204.2066071.12077621897985625395.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029435204.2066071.12077621897985625395.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
