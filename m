Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054EF48E0F0;
	Mon, 12 Oct 2026 12:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791809129; cv=none; b=BUzJZQdtYcq9Jmj9hXk1n5v5AhV5D9xH66qJfzh3Z4qqg2l0wf4upzJAeLH93laaGx/r+dMOaK8uLnXNlRBKtaBRke/bmrBJ+clDTOukWluLJ8MyYbMI/0NpOHSRbdBbbiANkzPGMDiAAFG3lTUwbYPujkQHnaGF/oIQqbbNyoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791809129; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LdwKgY6qMylKMKEoeM1bMj3hluuUNxsBzDM1JAPamLeSpG6Mh7AgQHVMfhpicqMn7lvUK2TFl0lZZbP1reRRLlSxqOFcr5iixPxl3eFcSw51tUOtwdC+UTnq1PdCNDhGMn5S6dY9OrcLXNZhXm7PbomaHMoyReAj+lhcZsZxz1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=skZ9V3/s; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="skZ9V3/s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=skZ9V3/sOCVQwIFFxU1c5Acf86
	CZnsxitQ7siKETUdxYeq5Pprc3bc2kWXIMWMsEcuWF/9GE9K4AcrGWXwUwu/RmTM+ztfSecmwckAf
	60X5urCFsMJlboZFv+0fi0sM5LeeWll7faXdG1fBhrxS1BTRMooRikCMLthty4Q2hExsAqfEox0qq
	2Fc6wqUYfAv+Mju0b1CVz6+Qj34GH+0wMQ3eMMt0ZpwbB9Vn20BFBqlrxfN16IB9qh1y76udi/AFF
	M/CByf0dqTSE/Zr7+r9ZZfR3YeIrVAE5DUbwAz+LztEBmQd+Q9iBPDy0FbBnRExVIiFmHLaiRQQtx
	PiPbIreA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFP9-0000000AUj0-0Tfo;
	Mon, 12 Oct 2026 12:45:24 +0000
Date: Mon, 12 Oct 2026 05:45:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/13] xfs: check for buffer overruns when examining
 local/remote xattr entries
Message-ID: <aszWY3XwSNkh3Hc7@infradead.org>
References: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
 <179151614859.3163896.2791616340863381551.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179151614859.3163896.2791616340863381551.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

