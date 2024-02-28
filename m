Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DF615B0FD
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 15:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709135373; cv=none; b=HFc0RmoHL3aiKrdQPF5YtVgKjYhI4aaqLdtbWzKfGeySow+h1iZ2oT2q351q0e7zzV+Nr9PKdwJk0VXuZheksNB67xUeeDcFElQ1nzyp9nbyX7v8fyxxzNkEKx4aaYRrtls0d7QY7lutmHoiUBnVGS3nAUfbSJZD2Il3a7wWeSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709135373; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KhsSfAMl7BQMa551aju0h2PtH10PgoxNB8ss4KrDTuR3cx1y+SKBQfYwjw0lqaRjtPjcckkSlBGlmT2r/cGNPXBCqIBmjEcHgm/BS54JrUNNYFfx2ef+FutFC1ppgLoPdLI0ppuqau3wHwTCKT3kU4ffbG316a5PrMkRes6tpwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=afU/jiWE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="afU/jiWE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=afU/jiWEqTLzuM2jT/wBf4vWqA
	fUOlZegXugWdYiiICVKEskxAukVBrnux213yFD2rfblaHtbR6hsQovJrnYhGMTEXSqqP3P7Uu+z2t
	zQchaROuWmLe8WrjN1ZStXtGen8awBM1jTRafGYfFH2mMxRKu2KT9RFK9nvoF+/V2KapNYTC7UWe5
	DRUbTldnKTMcRIYT1bh0CIwp+DVjWnKnn7b6TlC8lxAGbFbZA1liBUx1AEg4nnC/HAbam5RGcGusb
	x7eWk9p3OrOLYjuWc9XtdYqIMMH0LhP3y3WVwoPQWUBDKvXTPjspdov7qp0trYUZw08oUimEzFwYH
	eVTZsdTg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfMBY-00000009yUG-02fk;
	Wed, 28 Feb 2024 15:49:32 +0000
Date: Wed, 28 Feb 2024 07:49:31 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 06/14] xfs: bind together the front and back ends of the
 file range exchange code
Message-ID: <Zd9WC7_gtJf3Hq8a@infradead.org>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
 <170900011741.938268.17978239071578352808.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900011741.938268.17978239071578352808.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
