Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5A45228
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tnEJu0CT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=tnEJu0CTzwy4Ex3Bqlb6fTqKIV
	AflTJ4lBi1IMdOHNHzhLATqV97LWh90RtO4XUO6Fthb9nDjUH8ImJfe/W6uLTzHTxeF1G2QwPXlzh
	Tfma0QEDMqeikojCHj6AEEDKTv1Aa/P2qo5/b5ITaNaGrOp1/RZLw609Ful5H2Oj2miof6It0ejEc
	TgW6mG+BhMcvtHS8EOuIxthl5khCGfp8nCxtDTHM/1rpHU+2YGgmmNNc1uz98d+NPAccOmWNQTHOu
	4LxxJ/84/hbvaAftOYbp2jbXfKWVLW7HmMMZd7G2w6xaHPx8OX/hbAwMzPqx9DZE9jjNoTdPI1phO
	9jTIJkxA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcMB-00Fwpu-1W;
	Fri, 05 Jan 2024 05:02:55 +0000
Date: Thu, 4 Jan 2024 21:02:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs_scrub: boost the repair priority of dependencies
 of damaged items
Message-ID: <ZZeNfw7DhsrNSCd3@infradead.org>
References: <170404999439.1797790.8016278650267736019.stgit@frogsfrogsfrogs>
 <170404999513.1797790.8882968878143930752.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404999513.1797790.8882968878143930752.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

