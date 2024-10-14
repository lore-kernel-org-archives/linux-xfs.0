Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD4414F12D
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 08:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728894533; cv=none; b=e3McfY41bfZGbozds5yMPDs6f5I9RzEPWdT91LLWVFTNd23uC/Zmr7OghTp0XECnXqS7cY7Hjm9T4bY16B4FAMMACZgEs8zWtDdjsXJnno/jqTyV+JImqPq++FvgIS4/giSb0DNe2vYGW/BdRAW2S6gADtk+ynH5W/ZL/DuZonU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728894533; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kXAtaEQ42UHUQ2P7EK5sgTMXBW7VR9GE4qF5HcjAWGSX9f+qAa6bmP8tA0y5q1e+FdADQ0MhHOmV6gKyf60IrHUjExJl7XzSznNcLRbHJh8JmWVwCMtgWLeW223bdyDDP4vpxAN0kRGL/RzV8h9TGALeOQogHCir8JtAZLIxfCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3oXOxL9C; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3oXOxL9C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3oXOxL9C4WfIXQ6ta/aGQ+JlPI
	0lIN2aJu3v5ttrR+E47VwFXlzyJbZbVT4bMKOWobiMg67OPjvWl6GKoLrExIFpoj9Ic6zwTBhUPND
	4eAfNzhHmcWcFpxUfva0m6RZAGnlI40dYF5MJg2OgI8Adx546I4jMFUv/aesc1EEms4+MFbdXiqDE
	N0IAV73dzI1F8AlzuVx2SyCwDQXdrgsZAX5JqaXs4TWCe9ftkRDrpkTUu3ft2COiBlhCLLoRcv6w8
	FYprcfhcWgyHW/JdoIGKuue10/fcALZi3yJNo769irkYgH0f2CUwRaFJ6mrcx+y8B7N9UjHTixX/O
	zld6ZL8w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0GRf-00000004HkB-1bYj;
	Mon, 14 Oct 2024 08:28:51 +0000
Date: Mon, 14 Oct 2024 01:28:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: enable realtime quota again
Message-ID: <ZwzWQ-xN-X7tCk_K@infradead.org>
References: <172860645659.4180109.14821543026500028245.stgit@frogsfrogsfrogs>
 <172860645780.4180109.10859688721403091860.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860645780.4180109.10859688721403091860.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

