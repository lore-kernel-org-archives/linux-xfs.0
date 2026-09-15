Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F1B43F4B7
	for <linux-xfs@vger.kernel.org>; Tue, 15 Sep 2026 06:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789454061; cv=none; b=OeTlxfy/QnRxfod4RmkpO6y6k+BxwlUlSW6/f7c/kk1CYToiruFa3RHPBuWhWf3S9p4RUGguxGJA+WnwN4dMZLBPXaYcGlZGOb8gK8cKKpBku6EAAdqX9K5B/zU2zSY+xQlnSktoI60vBXW6UTIWNZoQM7e6Go6PesGsuSU/KhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789454061; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PDs37e3ge9yY1fHXB94y5zhVrsWawclh+JwMC6liu8EVzhxIY9WhfNIAYmOQAOurfusKLn+COTM6fri+N8ROYIeHfgZThV4NKjlRSQMRGOXaO856Cq73lW6mYmyMaWhD6KXkxHBcVD+iABtU9v08hDOhkXhq/X0RoRwTJR11SNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uZKz5Ui4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uZKz5Ui4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uZKz5Ui4fgO2+wncTjH/JwrAve
	dyD4nrrAKaCAm5P7k3PvUWfylj6+rFloRJSewU/AJ82m37TQoMe7/HDywwHlO8hJWSjFwG3n7xXkj
	KlaU814PzXnFE61fixRayHvvsnJo5HfQYzUt4zKBz+QbSdQprcGhMHG2BViOaQnkZtnqWiaAu+tRc
	yaGdHJtPFcsuU3PVtmKv0xTTfQRdcvzxRctgLn/K+CoKPnP5QfVnpjEXni74aW/tCMrFeRB/QV9o9
	45V28CMxZiIlTAlUXDogCPf3NNzPRN/A49eA52KyLuEHTiwtV9e9dBrtkq9Hu5+A3h+jGHs39zDL1
	tUdVehhQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6MkF-00000005MFy-2crE;
	Tue, 15 Sep 2026 06:34:19 +0000
Date: Mon, 14 Sep 2026 23:34:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 0/14] xfs: remove unused arguments from many functions
Message-ID: <aqjm63KSSWPLfzFx@infradead.org>
References: <20260914223007.1587017-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914223007.1587017-1-sandeen@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

