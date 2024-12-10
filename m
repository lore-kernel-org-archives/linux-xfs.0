Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2241079FD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808834; cv=none; b=k7Jj+WoUBwSYCS+6G4oPW+oIxydkqgBDWDbX/ykpjzdL48yQnBDed37dnKbH0too+zLgOdpqhS0svB3z4Vic23OZ5/vFr53p8uht5DteklHkRRhtqufbhk7riyZYib1W7wL5goeSBnoT8Qh5u47kaeIeQu/f3/kUe/QXZ7OBfDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808834; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QpkBezHVPwBvlRaHhD9QJYxxvb9XlUH/7s0wyDVr8fJ5nq7hakmJqqgKMIjJsTs32aZ5riv9o4Q0z7LqY+KOx41Ov3O7ci4hUN1GFCGqE/jLRPsnrX5o6JqzISihC/kgmtgQFbd315DG+pm5SZ8TZ4Qs0sZGRd6uMIqs/uY32vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Id7YUPec; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Id7YUPec"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Id7YUPecVQ7CMaViZpAJ69j+JD
	yhqVVe9/44CkJIWePUxPbHQUKDSjohRTxK212VD2l+66mv050D3KVaDsdXSIOP9dqnEBThp0VLH0b
	HSPeA0/hPDpzFrdqVGV/Bbt2ZZ6g0OcCq1KnWby7Hw2rRz5QTLtehekP53pPGyG5kWIgXUP79yvaH
	8W9Ju4KY017ys5B5xO/6RLW1T25K0hua35c/5Yj5hgp0sp+iR2QZh0Bc+hV0eJ7aGZZ2VJAremBDV
	zUo2if8es5HsHHsBCyfH7IKFctKPVT1IE9gOOsW6qJOEqzA+tK1dZjnB2dh8ChlXooAHXS0BoCZga
	7dMv/Hyg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKssa-0000000AI0q-2m7U;
	Tue, 10 Dec 2024 05:33:52 +0000
Date: Mon, 9 Dec 2024 21:33:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/50] libxfs: implement some sanity checking for
 enormous rgcount
Message-ID: <Z1fSwF55tYtSece5@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752068.126362.5584212124575478710.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752068.126362.5584212124575478710.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

