Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF1A17E00F
	for <linux-xfs@vger.kernel.org>; Mon, 28 Oct 2024 08:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730104501; cv=none; b=CuM0t3waKH7TDv+MfVVCQ5HiuF6WzdKCFqrCtHhRdOABnEu5o6Uuv49FkX9lpGk5Sg4ZK1Gyv4RmrK/mAJvj00Tfszmkg9GUsQgScx5OsFsCM9zu/pw2Xn1CY/oO14klj/ECFe8DoNfZ5VjTy2sAjPRdA9ngnu97945tgvYtUJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730104501; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ThmocQRWCS3RGvMxjzIbOqfc19s/jZI+QirbHGjmyfylmnPgUDxnUwmhW3bdhVwNT3kYGowXQcFv0+5/Um7RT0m022crqSGBTNQtOmLrun7ARcMqpP4xaRJrDs9lQMTAm709RadHg9Ciqb34CsoeBdiAkIeVUug1OLd/pfSyvvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k7oLTOyo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k7oLTOyo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=k7oLTOyoG+CF49nek1tklViuSg
	30XhRLf4c5hIQ112lZFZFFMOrnqPOOuRIrkVhnYoFYweKohu68BOO1KTdnLHSiuYBcFhAQBex4xKx
	oTfPdua98YfA5AGLMoH9BEZf2iFs61uy2feUURzjXfgaj6/hpJ99PBP579vIm3JPJndWUedwI/Rrg
	v1O0M6vn9jGW9iNo/6bJBTT6hVX0jFtuvAlqngvJiH45enTg+mGYKsySmPay2jA8Z+W1Ew43Ag2JD
	C9pLRsWXllzOclWUW+3R2t99BzFJOMUhobtXAhbo35KykZo2lm9S2Vx+uC629BWn/6g44XFUrlbU4
	mbNkQ8kw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t5LDH-0000000A73t-1l1j;
	Mon, 28 Oct 2024 08:34:59 +0000
Date: Mon, 28 Oct 2024 01:34:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 2/8] xfs_db: report the realtime device when associated
 with each io cursor
Message-ID: <Zx9Ms7GRunyAONnC@infradead.org>
References: <172983773721.3041229.1240437778522879907.stgit@frogsfrogsfrogs>
 <172983773759.3041229.6653374398230478526.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172983773759.3041229.6653374398230478526.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

