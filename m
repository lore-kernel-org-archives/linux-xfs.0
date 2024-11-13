Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7DD18B467;
	Wed, 13 Nov 2024 08:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731487660; cv=none; b=qFjzh/OUgJxTIiSDZ9RGFu1DeJuOMapaod+PPwDyOrLcsVdVrttgk0S3g5Jfjv+PPf0xq/kw8VuvWo+k/L/97M+4hkN5pd7S6dwCCMPsSymeZTrX/EJRj9cOMIfGcRVtQgihcIoNpQ8CRbe6R4gHDATXhkvxRb/4JCP9x5KMQQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731487660; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bNFnOZCdMkcKOKvfLBW7pQ5jW+tYzKSGKOWc3crB+5yfk8gnxXF7m5EBSQag6mGevIj0kJi2wod2bvWA8fHbFXXToeK9KpScj5EbKvqdiYlCzX4CLjy0EeFnk4yPzxQvuCsvhTr7h6cimzI0G4U9GB7LsNmmvuDRpi3ITNp3Soc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DetDrrGE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DetDrrGE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=DetDrrGEx2XOoUCh7ST3rs+Yjf
	5hE6Qe+GUWaS9Z7JWYf+8U8XLEsfRLYGOhcNqfPNUoHV8FIcRDb/vLKhvQsj4CMAJOk9L7ocgGjBz
	zblW8D8Ie2zd9gsotmjX9k5Pw/hkHznRcSKjJKRkLTqg5EchrOyCsLFoBCMFq7r87LKX+VAILxZ6J
	B190YuOKgb7qKNZZDFdJk8pksdpCI32It7kij4anIiQkGFiZ70l60MlkDXk5iw/hfCD77jJuycsL7
	T49p3+P+V5mAhf0KaByOWunbd4ZjjFPJ+/o28erYSuK/63zfTuNWpz2SlTzxN7aDQI+K2gP/itExP
	i+k8iv5A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tB92H-000000068vZ-3X63;
	Wed, 13 Nov 2024 08:47:37 +0000
Date: Wed, 13 Nov 2024 00:47:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs/185: don't fail when rtfile is larger than
 rblocks
Message-ID: <ZzRnqfFCiZN-3NWE@infradead.org>
References: <173146178810.156441.10482148782980062018.stgit@frogsfrogsfrogs>
 <173146178844.156441.16410068994780353980.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173146178844.156441.16410068994780353980.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

