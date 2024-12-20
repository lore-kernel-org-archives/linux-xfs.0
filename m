Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7E417B50A
	for <linux-xfs@vger.kernel.org>; Fri, 20 Dec 2024 06:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734676982; cv=none; b=Fr85pkEdH4lINkLlHJ9b5/C6L9KSS7BMeNBdIMdhlRckEagZn5H8vUlBhDl4S2rd/q4jAC6lkkI8p/oueNXfP16fimf6V8skIXBAk5bTVWAShxdPz06Uu4nNE2Hdc3QhP2lMY4kds/E+8qeQ+3OxwY+Z4uafH7jMpjATH4WjS7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734676982; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X/evgER5Z4tIhr0dlehNJxAR0cCjBxwNI59tBXRkcFCvVFcSA6VPNti3l68YrYo6dwgBMuUWz/HqihUYqA1sVoZZtvCyd9D6X6ScbSetcsuepaqvl7BqvjJqWTv+LvR+UhBO+3bXKx4m7a37cvplZW27CFQ4NcxbgefXeP4ypMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZmxF0RtR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZmxF0RtR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ZmxF0RtR4Jef7odIfF6RtAfT25
	aBMRacOBTrih0cXm7bo515JVS1OSjXU5to1sIyXfzBKcXgdqvSXeIwDSqx86H+t1btBQgn7lc48Iz
	eSeBLmt9K43ic71qm0JHpYRwbWJje4TymqpINIbqVBuQOtAaDm5dbY6q1rqCOAIkMpcrME491Wu+j
	AW+1zbBw55E+tIDxGHWaKpklQVnZcqsjmjvMo/67V/GV8YCeEd8Q1gIyCo8uEV/W/U6fO1qSU+BJ4
	G0scx8CUjLxysAZcxkARFJRoBzNddRNlmBfeBKuuWLsQqhw0Gldx7bNvIakboh4WiCBMQZc0VNKx5
	1/VQrpRQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tOWiz-0000000478d-0KJW;
	Fri, 20 Dec 2024 06:43:01 +0000
Date: Thu, 19 Dec 2024 22:43:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 28/43] xfs: scrub the realtime refcount btree
Message-ID: <Z2UR9SEvQpbFs0P8@infradead.org>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
 <173463581458.1572761.9841543400134933628.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173463581458.1572761.9841543400134933628.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
