Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C1DEBE
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718944663; cv=none; b=kJh2f4zwysYBltllMfOpCunfCFpB55ZrwZGWd//xiufQMHsmp61rLf0e7hyUuGJkfcAnekD8Y0T1KUeY2n/l5j8OD1vtopzWiRJI66wZwaIlr7KJ73jCm04BnWz1dLGO0ZLFxPEoGg2kr/uQIVJhmtOiqM3Z29oLuv3mnjZn1K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718944663; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ndn3PsLGZGmW/cI6iZnlXIllhQgF8lopkJQ8NKlsIEPHHVNChyAL+2kFXLSvs8BkmsRX+mF4wUsqzXLRVW8yiAYJ7d6/yV3ByT/ENeRYNPBU0ruq3vJeH4YfN5xKyemhy3QUDTjBsZlupL1gwCYbEcMIL3H8GQS443DOEs0qLcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eHn/P5Rg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eHn/P5Rg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=eHn/P5RgG6rGBGxjewMZcI1lYD
	LI6ImEX3igzqegLLqVjNIuCh6XYixSZ7UzYnPe1LMH5XfSG+dQ7RC2eDKkvqCjiL13AV3fj1XritU
	LZHSANJfQJpOLR1DcTllGJByy/brSCUea0vClt6/XmFAR1xGsjCXjqINXcqN671Cmp4DKJYXF6mK6
	/EZ+G74RgEpTJnkZ3kFAqe5N6z/lyun49SOU0EV9q9DrIx/QPpQriZBJ80a5jakbUIIGNy5WU6Mdo
	rHn87b3wRdsFJtTtd1KxVkpq7WdzTaepXj4q4PfgSZoqYH8ZPTrXJYZmY/20QA9jm9okvZdlBTF1X
	JpLi2F/Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW1u-00000007f9a-0kuU;
	Fri, 21 Jun 2024 04:37:42 +0000
Date: Thu, 20 Jun 2024 21:37:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 02/24] xfs: move inode copy-on-write predicates to
 xfs_inode.[ch]
Message-ID: <ZnUDlpzIAidT9WLw@infradead.org>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
 <171892417927.3183075.160380352995983091.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892417927.3183075.160380352995983091.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
