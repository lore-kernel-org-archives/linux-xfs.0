Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF3938389
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724388892; cv=none; b=rStSC3d50jY3xRGvU0hKD43MIFNoQqxG3qNd+bMp3rXVz5LwtehiE0Gm2tWQJ+rT1brzmlA4TVmTSpWIVfIEIZrWCxjDMMDPdArBM9/AgjIGn55crRtV+i62bf28k1zWUC/7rYTh8PAOnzWbFSwt3gSx7AErV9VUBXN8veH1qJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724388892; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KryI48knfJSuD69QaUj3qZ/SJJcd6soBSr9raY8pc10e44HCVlFOrt/Y6LS13EqyXDZwmloaPIwqxXRu49EEYA3MZt02nOCD9a3BqAYnL872jkRY4BSYfxQ3rd9nf/zfH4p0RRcETcLzieoDpL23w++Te6lnVJruvu7NbvrXQMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mZ1a03jT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mZ1a03jT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=mZ1a03jTbkklGKNDTD1u9re2qW
	GZACEfEEOCTVGtcDggiBByaxJ+Hjkj06snNcAPYAaFtVouEzxHGhqJ8VNoJM4TebGsFlQjvwENHcn
	AL8euwR0mQ6gnAbu5OUdMy+gUG9Wr2wKy0YIqgnD973hv9UiPgMLNB3SW1G/Fs5+JAEyHXz507pxq
	XHEXw5FwQCWrixWRdOa4DBQjh2QlcZighafhBAtP+WsoRo9ZUv5Hn9SFbUW70YYIjqBNLRlexWQeL
	/ezVxYSTQXELVEbe4ZqtJNe4ZfLl05//zS0VTuRR2ira3p3t7etLd/kmprAyopMoukALybeRfWlcB
	FrXkXcnQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMK2-0000000FElD-3O5T;
	Fri, 23 Aug 2024 04:54:50 +0000
Date: Thu, 22 Aug 2024 21:54:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/26] xfs: move repair temporary files to the metadata
 directory tree
Message-ID: <ZsgWGkWg-oHohRy7@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085570.57482.16581918870184455200.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085570.57482.16581918870184455200.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

