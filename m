Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C7418032
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 08:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3kYsDGN3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Lta7+I2Pry75cMwy5X7nTYpcg+CRE7L2TmU0L0kKAW8=; b=3kYsDGN31Dham1ujzym9Znio71
	bQHkQ9CBTn5ZJHN6NRZCyjUklzyJ0ducpwJRNDYyyfrab5e+tSf7v8UZF9jcVmgTxld9nmMwmwLcy
	pOAgKZUjfYfRfIV+dsIAslgter+UvSSTvKphZG8zf2ARPQkaZpiopEiHzK4tHIMIKKThXDC+KXhC4
	gKc9BYvNhnc1YXq1vyFe/iGgpgdqslCxRz12jzqehRohXucml1DwVMPPwtBNO1qe8M5tz550gfUQG
	bUTJEy5/vXBmjJErvRuFTqKWaHmsac8v9W6DQHdmt93a8f4ykWacLs/Lum9/UecY6sYvEy2Or8WhM
	gOQpvAvA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKwwC-00A7mP-2X;
	Wed, 03 Jan 2024 08:49:20 +0000
Date: Wed, 3 Jan 2024 00:49:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH 1/9] xfs: dump xfiles for debugging purposes
Message-ID: <ZZUfkFWWl3k/uHu2@infradead.org>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
 <170404829594.1748854.13298793357113477286.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404829594.1748854.13298793357113477286.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 12:13:49PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a debug function to dump an xfile's contents for debug purposes.

This doesn't actually seem to ever get used in the entire patch bomb.
