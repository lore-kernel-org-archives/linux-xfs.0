Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766FC5220
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 04:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BqMnIv/a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WTYuFePsoOjXg/mEYHgXQM0jO6F8SAZPC7HwuyIrJ/4=; b=BqMnIv/aysFfozNZJmqJGGRTEW
	MpYOiZcxUfzH/wcpegZzKM2sBOXjIsgX4HWMY7cwdl7gFZNtlybXHKDmxV7zAWIkU9GmhxbkfWmoK
	Ym9wc7tryrRSY4ff0sHZLS7C2fL4OxHSxIDWhgglULpFmb0wvS6s+0hJ/BmN6QObhDRGbs/CnVzkQ
	vGrpl1wbFzuTd8BC+IL8WY0+Y90/1XxMyY1sZn0aSp9WHaqg3/C3P5h8pCWC0zpsf59lt880t/gEu
	LH4RPPywhvc3gLNJ+Q8+Zj4eDJ/ehX4E8rJB8xCL89DxegdFQCfQCKK5DZL1oC58s7qnL4THg2IoB
	HZC7i7vg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcCD-00FwEU-0H;
	Fri, 05 Jan 2024 04:52:37 +0000
Date: Thu, 4 Jan 2024 20:52:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] mkfs: allow sizing internal logs for concurrency
Message-ID: <ZZeLFQvLwrR/ed4v@infradead.org>
References: <170404989423.1791433.6933477036695309956.stgit@frogsfrogsfrogs>
 <170404989451.1791433.2745783356762992258.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404989451.1791433.2745783356762992258.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 02:05:09PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a -l option to mkfs so that sysadmins can configure the filesystem
> so that the log can handle a certain number of transactions (front and
> backend) without any threads contending for log grant space.

Looks good in general, although without support for > 2GB logs we're
going to hit the ceiling pretty much all the time :)


Reviewed-by: Christoph Hellwig <hch@lst.de>
