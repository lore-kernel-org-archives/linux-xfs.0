Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5472054F2
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420713; cv=none; b=bGXGGw1R9GsCT3jbVBm5TnfnlbYF043439N09GbGtj6npAVVWIaoStLSPUVDjM8KC3c/b/h2efAbDlFNESR57AfkQooa1yJpWJGEy0Q2xFyQ3CMf3yuApoHXuf4zWbOLv/BCVE5TfiK9whRcL/JXiC2weL4scPrThKhxYjUaq2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420713; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I/sKy2yfxMsC16gYeNMWZc67bBPknPNyxeemYyA9aBzvRi7tFmdmCtnzvnmBvBsTUwvTs/4d3zdzEwVSE+0eJhmccXLlyzgZUYewKC4QA8HMvOK5gOkDvnrhOJOsLgZ3+4ySXoFJGLQfsflN3J6/glm3dYhOkh0MTAsvxK2a3uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yUT3yp9p; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yUT3yp9p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=yUT3yp9p8ZhYWKQAsQ2HQtPtTJ
	8Jz1BNCYJVYHhJBVYxDNf0U50cubZKQ/Z3V1prlbDQmpcwrvNMFORfzyFRtP9GaR9t5uDdAV2BopD
	Fsy3qin6O+1AJZP+vz2tJMQWw7Rq/P/cHbpI6IoZHwFgG6vpS9exjgNbBW8k0apz6VXeoLFRbLeYE
	fsjLmtiBJiy+ydqmx01I/n+4xmF1zWpx00KOqrik7q2bkNFIIMU6/C7NjAjijIs3gcDwjdFP72H1z
	/7i+1XwkhvfwvGdlpzHskvZPICK45e4YexMl6mJ5qGDxv57rWGeGYc9fYjidI5duYDh1RLz4K3uSS
	RDVHEQrQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQml-00000009iBM-3HiT;
	Thu, 13 Feb 2025 04:25:11 +0000
Date: Wed, 12 Feb 2025 20:25:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/22] xfs_repair: find and mark the rtrefcountbt inode
Message-ID: <Z610J5nG6xUWGRAJ@infradead.org>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
 <173888089131.2741962.15415300047895957138.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089131.2741962.15415300047895957138.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

