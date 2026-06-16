Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3091FFC59;
	Tue, 16 Jun 2026 12:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781613875; cv=none; b=EUASMd+Hud+QORa2AoEX4SyVc4qDg28c4rIqvdeMmEYWqM8TROja7EZwqKnfuLGn+CePqwNMEByjNYNZseeVJFze7GWRPKh5dYTKnd6TWaSPij8s4JtL6F6/yn5KeHUZP852D/euw2GbPG16gAGoMZh8pGtagrhNp/hYLzA7Gxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781613875; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rMAe2zQmE5/7LVaIQOkJHqcxjgjq/3qeXgiyocGvgplo2aV3wKJrjYB5LuFRC/8eTMs9GNAO5A3uDpD/0JjiglxB/IAENidANmLVY01OvD+DqmXK3An0XpwdRD0RNEkO0w55/TY0JEbI2eXjDcZfnGl1G+iAczJBmwDQw/LsP+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2I4L4J0K; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2I4L4J0K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=2I4L4J0K10tONahdRECFHVSdN9
	bwux4Q6TTC6v7BTC9AVU+Du2dAbVGeYG1qHtLfgOwCNWZ0QsXiUraP1GDp4qq8wi4hzZ5RPkf0ZGO
	xbQhhEseGKx6LswL6+OlUfSgzxirQVzLjoPaVi8BPzgMiRXGrOTixDEyQyAGG7Dw92Kaj/ntR56eh
	O6sWDx5aqdzg2HOUZ9vIv8A6lSkmCfuViSW0kzkYBYJfD57Vo6EgwYIMFMR9U5e3IJMNwBUMhfjL6
	IcoZ2cc7K6u+sVaQmKg15YjYTMqJwX52q5/JspDHsMMLv8KiUrNfhW7QWwxHsUs3smS1OCV9QGRPv
	dgSSio4A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZT9e-0000000FmjW-0LFt;
	Tue, 16 Jun 2026 12:44:34 +0000
Date: Tue, 16 Jun 2026 05:44:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 2/3] block: respect iov_iter::nofault flag in
 bio_iov_iter_bounce_write()
Message-ID: <ajFFMvy0yrRdZ9Gr@infradead.org>
References: <cover.1781597506.git.wqu@suse.com>
 <9c165a314022b61566eb247852eb773ca6c70889.1781597506.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c165a314022b61566eb247852eb773ca6c70889.1781597506.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

