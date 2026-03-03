Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A858A3644CB
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772553140; cv=none; b=ShIJPfo5T9orrQTmY6zxMcH3cSa60Zim9cri/yd+a6rouJDUo9OapNJ00xywZJJAz4iCy4ZBnX/TRFNoE6egvcxYWB+1J8Igb3R3CV8V0SKHHzWI8k5YAbVRRsEiA4A2eNmccrJms4ipKyFD432UwXvphWEOT60NkP+U7gfXk0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772553140; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ANWfGraEIsv67w33JLH/Ioza7kpuXICiGfvtWiC/crg3X5KzkYUgNhL0ZcPIW65y68bqtFfSrW7Dnq4XHq+aL1eLqCXvVDl5T1GXSSA799oHbnfVJqC6rUxu+j6pLe7g8ooy9rljOvzKd9cUEOnljY68B/7fU6eghUSN2d4kxRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QGT3VT24; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QGT3VT24"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=QGT3VT24nJu0O8BaYyZHrqazkm
	Mjle85FOdCoewoDXoW4lOV6LkCKFJR31rsS3g8j2oJX0iff+r20g/IGp5NvFCnPZn9Y53nzXi02oy
	Don9xZYC8f4PxYnvZPKrPk4HOEP7127LDvj7PSeKy9Xkb7yey9CsxUXStEX2+HQpnHKtOQ6GjfeUT
	8fhSC8wgRnn2iAVIM8S0PsViDNCYY4IQlILaFs6y1Nk8jO2ujmBJ3zG2LezrqvaRERi6nttrzaJJj
	5qJ+rDFqcwhpGXUhRM8Q+VgIBhcaZ4IzWXQjjasxyfpOM2Y5tTW+ESpwcgm6h/7Wu991DjDWBwYnt
	4mJ/5+Tg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxS2l-0000000FTHx-0sEn;
	Tue, 03 Mar 2026 15:52:19 +0000
Date: Tue, 3 Mar 2026 07:52:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/26] xfs_healer: add a manual page
Message-ID: <aacDs6EozDRtjkuA@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783637.482027.8151365663209599394.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783637.482027.8151365663209599394.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

