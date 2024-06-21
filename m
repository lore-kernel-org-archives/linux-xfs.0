Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E34D12D745
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945235; cv=none; b=eILhX7DReuNVB93Hbaq789ycBjZm0s8c/cIMV71l/0rMxWSUz0OiJMoMSLfHugNbdBcKDPsuCppBRSTiN5LqFMebftHYhcMtuMmcsRb5xTY3Vcjfhq/qi1Z4V0Bu9mJsiO/uh2/mx4IF0/pRoIuvKgr7TdppdZXyWPtuktCyvWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945235; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YC7F2LFNeouyFsQm5McQTXBhvnO6cwMZ9dJcKH+rITm7lHAb3AIKQ7Y9HmUKa382hKsNMCOEQ0WPGbpug2yj9FMZewGbRgeLqmumUTKjUF5AWn2Awshew54qRh+f935LLUpi6KnMn+zD1NF3674yI7dnMo/4Sj/iZN/LwmRwaaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LkfB14Bb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LkfB14Bb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=LkfB14BbRGhcvtSjPnAIzzThPn
	J3ouMSkiRdDmC9N94UVbM+5qo4kCqAPHWpNU3y2f89B9KAs6sbozhfLiwd5nIZamg0zDPHzxBGoTu
	RusuM5yi9MrP5RlWN3q3NNFlmWiATJzpz2NGhi5chmHLn7iOXPjwxbAxDKpWMhPpxHY2z4xl60aqg
	/S2CJ1MvNj3EmvMWywncmiDnuCBAHWjG6ncF4mh0YNJDw+k0Q8Hs1qyswa/5piYfnf1E8btY9q/Vx
	oeBL2xGGhxOMxtg1kFK0YE0VL5tNRLeYUkRuBaGphkjcwQi6SbG1ghJCky9RlJkaRdw++JdOrLwAV
	SUUxzKZA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKWB8-00000007gBW-1Dpp;
	Fri, 21 Jun 2024 04:47:14 +0000
Date: Thu, 20 Jun 2024 21:47:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: convert "skip_discard" to a proper flags bitset
Message-ID: <ZnUF0nRQjaQqhHwm@infradead.org>
References: <171892418670.3183906.4770669498640039656.stgit@frogsfrogsfrogs>
 <171892418730.3183906.8429370486663214449.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892418730.3183906.8429370486663214449.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
