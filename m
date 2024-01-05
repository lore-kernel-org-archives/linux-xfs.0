Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC498524B
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 04:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JHxiqAIM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=JHxiqAIMqPfmSYX+4T0fq+eX7k
	oFcx+gZKba3BAhFQW3Oxr2RLfoEcJ1cfeOdx2CeRdeD/dLcjCp4mYYi04v0LzYvNtUKfF0t9SA3u9
	06TKzsRzUKyTTaDLjJhcu5DKPkjqwW27pPRKEJLbCdPAvuBQrS6MxFkEhPMGNLpAFkGK4tkbnnvl9
	UIkcDcGEb4MH3pmXoTVGQG5O0rOkLRTeIfJ1NsIhOIWXWh4ugnFTE+4zvJIb7VNfAJXvQ+l5VDtgM
	ZxiSpz5XqrjJbT9Q5QEyGbj3JJEwnFVlrwWpSzltgSiwDpmhvQv3SYqTt4W0+qlkPuGcnYmIoIBry
	DKCl7gpA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcGI-00FwZ4-1X;
	Fri, 05 Jan 2024 04:56:50 +0000
Date: Thu, 4 Jan 2024 20:56:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs_scrub: move repair functions to repair.c
Message-ID: <ZZeMEi0DwAh92S4L@infradead.org>
References: <170404998642.1797322.3177048972598846181.stgit@frogsfrogsfrogs>
 <170404998699.1797322.6425738245640649842.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404998699.1797322.6425738245640649842.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
