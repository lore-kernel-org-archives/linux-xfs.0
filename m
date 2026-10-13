Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648AE4F30F8;
	Tue, 13 Oct 2026 11:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892112; cv=none; b=otg0mrKqUZ2a61RVzNV7gZVeSDVf1k+wpPsBg6Odf0ljG8Ft4qakQH40Isj/BGHW4U3O10p2gxl3ySm+TocksrK/il34Le5Wc//R/U626M2orHaOieB352KaRDoQvjgDfr4jgABRYXIcfu/58U/xKZmHHlSA9O69zraxdeoZSyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892112; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pG+VkTFcNBbEgdjjQc7oNxqrjCKfmertsKfRrO9xsvr9311XXkLcPqzNRZ0ocqUZVZYjkVzPT4xk0Bn3YieEYZHru8ce5r3V7mfKjkn/O9WBnCwV/iK7w2ktU8ImzAd0m9v00fphoEvs/CVMGS3RYo8JtMYIm4tR8SdQ143kGMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uUfg8LJ3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uUfg8LJ3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uUfg8LJ31uXmA2uPbIKhAJVOG9
	2iRe3H/GTtwVq7LB7bbGdaVnXt+xslizclbhG/ExlMIgyC/LKtcfUir3rxWEVoDi8X/ld3jrNcGFQ
	RRqWps2s7X9sdNOGxoysmoWgHuIT7+XvRnV2LnU7oSHOZiBzUPNP218luyUUKrCyUkkhPYTMh8Eyt
	Jk5Im9IWZJzB9cJi9+Arg31IKKMRX8hh7Sw3SESWOVqsV6puOpejE8Ilhr9RJiXgP25oCaLuVJ3r1
	Cz5QrwPEscQWapusUV/W4eH40PCChfa2mcNbxR7IujsWQsCvmEUIvLtZGIFC5h6YiVWaih067JNdm
	uQW2W9NA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGaza-0000000CkDn-2xah;
	Tue, 13 Oct 2026 11:48:28 +0000
Date: Tue, 13 Oct 2026 04:48:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] xfs: rescan the AGs if incore delalloc counter is
 negative
Message-ID: <as4aiufz-VRuones@infradead.org>
References: <179186107760.1898896.12318125940367230627.stgit@frogsfrogsfrogs>
 <179186107906.1898896.10797643225456623847.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179186107906.1898896.10797643225456623847.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

