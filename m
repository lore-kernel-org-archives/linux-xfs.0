Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9E947F4A
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738903324; cv=none; b=TimlnMkl+JuaXyMTovpV4Ddwdj/PT/j5eTJNeWDhZ5GZ1fV7Zr6BNUILhgc0cEWM9EMakLdTyUUN7lW0rc0+ei2OZeKAgjlVx5gNrV6JTmTgS//HJF8/u44ZjwiEM7GhyO4MOHH18f/iSYFvuRX0i0JoBvM3Eox9IwL8k3qpWUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738903324; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=paa4vS6QRFBBjdWU0fdXnANUzCAZGk78aCcoJiF0zD8KD1AqGa89ibcYTIxI/J56SKiPHkpCjCmW54nywZQE66kI2Y/sIVPuiWBifVGM++VkkdO3Upy87MdhfMtwwUaS69afJvnXx0LP0HKx7ugFZAY1vtJVrJyI9PSXixrxFok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CydJN0+g; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CydJN0+g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CydJN0+g4l2kVj7G1xONxZGc8K
	+me0CFSXGLzznZvhJt8BNgugfyn1sx7ckrJq1aAhQEfl0drU81PGVdW6BSeRzwY7RQ71ZKiGhSL4o
	RbuBt8Wh3acsmrow5DDwOXQ+WgQkl9QPXt2E5WmNzj848UULag3DgBdJH4NUlh64IK5astkdZ5IHe
	iSjZIRRoJTeV1ALnC0Y68z4jCxEBiAEiVectdAV46MUUghGyrAsOYHJF2TxRT9t6R3+P6Q3h9pyL5
	aJ7jJmLClooGFlS9E1ylCmYICMPiKh15GG00JGEAqmu3VngcuAxUJECEUsnjoMvleaUe/Wf4NuYg6
	MBehjoaA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGBm-00000008JG4-3c4O;
	Fri, 07 Feb 2025 04:42:02 +0000
Date: Thu, 6 Feb 2025 20:42:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/17] xfs_scrub: don't (re)set the bulkstat request
 icount incorrectly
Message-ID: <Z6WPGpUlbxaOEbiH@infradead.org>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
 <173888086229.2738568.17046030028284704437.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888086229.2738568.17046030028284704437.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
