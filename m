Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232B533ADAE
	for <linux-xfs@vger.kernel.org>; Tue, 15 Sep 2026 12:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789475251; cv=none; b=rmxX0tWkby18ceWmChW9ain4+brTmODirwrR8Lh9WDE9PGU+6onZL5z0C0YuTioQUeLkfaqNCB+hBfkqeOlBRxXgTUzBDVLqvuAwxLfC/Ul/gdTvzJfUlvx+XVDvQ8HcgQ+srcJyLCKrSbQXX6qEYzxpkWCvNfuexO7qrg/EyCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789475251; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zba4sY1eorALM3CDlsApX9hNG8x3kgwbuoG21kpQs6lgFdK6W1ITRC9TLSCF2eKng5O4wcwt7LwG39cFgdd4FLRfA6tqs477Kqgrz45OUbr5Ip3T4zwvUvEgrCM/zVtg5GgwJ95V7ADPcbIGMA5LGEulAl6sqRqCmbbwX4TzeRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DpXQsk40; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DpXQsk40"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=DpXQsk40T6mrw057JxITCUMJAN
	YL8NucMlpMQOWsNKd6+jXUnziSbkPdmRYWH5gc8180vzQ0xSGH0MkjzJxXQ7z7CzEHvwRnbtowJwF
	Ew7sHD3Fe3ReZpxMMDxP6c8mMWMZeS/hhjIJrzvYcNw4o7XW9saYVmz/6ow4dIwErTq2tvqdA6uEy
	GJPe9F7JbWo1ME8W6ZCVGIgoNL6CdOyQJQg13FXjaKHAlueF/vsCln01rTUwz65egXmvXA5izS2gS
	8IKTp1M4xCHKJnxGFKpmtg+8VcKt2cWcyTGHMzWF9tTVenGSVeUPWNm3GO+Q+DJzrKcoMyL87eU83
	QQIzoLJA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6SG0-00000006UcP-3q5x;
	Tue, 15 Sep 2026 12:27:28 +0000
Date: Tue, 15 Sep 2026 05:27:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs_quota: open the filesystem mountpoint for quota
 operations
Message-ID: <aqk5sD8U58o_unsy@infradead.org>
References: <178936484773.2108717.13238892511050788442.stgit@frogsfrogsfrogs>
 <178936484918.2108717.4779652680175945955.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178936484918.2108717.4779652680175945955.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

