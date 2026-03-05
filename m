Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F81D3822AE
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 14:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772719609; cv=none; b=s3mDPnn5RuRCIbe7pbRpfThFNd6O0eCqGkrPiiWaA2F+SRSqEfXDedwVjUCCyHwqb14IqWX5RqWLg6SY7sE9bPHMcosTHoGAJA7CceFMa5dUKfdomw8grjqa1xqBoc0uGwhvH+rUgTa0PBhD7bm8gkcP4fAF9P/+spHWDYc86aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772719609; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uewEDPZhbjN0Ge0zswqWWNzcEa1jP59rTStIWXe8Zzl3epUXkoQB4/KQZF4E2GapbZTxbS7jEQMpdmW1TLpEJt9RuXqe+SFHqyepQGCikH+JLj2P04NNvEUBja03tOcIIQZQOjPJYIfNzlUpF9Eq5L3qaaUJxT7NMIgY298xSV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RuwBeyCZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RuwBeyCZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=RuwBeyCZaFWzHCnG2FNIHd7Gc2
	LNcID3tW7YoRJkCv7FJqoZiNIKbD23SY3sE58kx37qg9t5KP0gHRR+4I+YOZj8UisM6m2DZ82rPRa
	6zMUxMxlALf4ri6KAqh8l1eGWGHQFWbi/grbvrpgkuXkV7eUzfLvQH06JLrW7wg2NqT1zv3zCrvn+
	8+JjhBsph6Q+vbDoKr6mkxaAyQoutBQjVll6OxIeUnaRREVG9YBxVrH07MBpzhl/DoZ0eS+R5E+jd
	PjufNnPfgXOmQ5x5PkoqLKxxHooA/kYb+8DP/0IJrIOyrFoo0AquSb/7Mwdcga+EgqbzRiB/hiC2v
	qp6ZwUCg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vy9Lj-00000001vKz-2X18;
	Thu, 05 Mar 2026 14:06:47 +0000
Date: Thu, 5 Mar 2026 06:06:47 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	david@fromorbit.com, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com, lonuxli.64@gmail.com
Subject: Re: [PATCH 2/2] xfs: ensure dquot item is deleted from AIL only
 after log shutdown
Message-ID: <aamN95NjI2L7VBzi@infradead.org>
References: <20260305084922.800699-1-leo.lilong@huawei.com>
 <20260305084922.800699-3-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305084922.800699-3-leo.lilong@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

