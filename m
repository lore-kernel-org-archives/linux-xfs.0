Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54230538B
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d12nEWIT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ut07xhfUcGZXP4lUVLrKOFKbkRxQSWe+N8WQMUhQQgQ=; b=d12nEWITlqOxFM3Qhox0tMWWJy
	Ydp4PVpKVuWgefnGj6WxO1kYaMAZn5ZBOzPHXyzhZCpb2YYQ99aFgotu9ovuyYtQ96k3qdmz7I2jC
	qeJnijgZMbsxpwPDVDFG16n4n/rYsifRqQoXxYA44C0t8uPlQmtxX88eJ0UWT0hfDIvPpxlWM89RB
	BH0l1okKjAPe6Ivpu9Az8STopC+r1q+LyaKnqDlY34CHInBrkuQYmX3mR4sQp2vgJu3G59jMf1nyW
	WocalIRC9bY119MAraect4TWCFvbk5VNDLmA2e1EhrxQzcTUitj2gywmPMmWPNAmDqbkHTpBdmCGq
	vnIQcBHw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcUG-00Fxf5-2d;
	Fri, 05 Jan 2024 05:11:16 +0000
Date: Thu, 4 Jan 2024 21:11:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs_scrub_all.cron: move to package data directory
Message-ID: <ZZePdC9VWHOgqmnL@infradead.org>
References: <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
 <170405001964.1800712.10514067731814883862.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170405001964.1800712.10514067731814883862.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 02:54:41PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> cron jobs don't belong in /usr/lib.  Since the cron job is also
> secondary to the systemd timer, it's really only provided as a courtesy
> for distributions that don't use systemd.  Move it to @datadir@, aka
> /usr/share/xfsprogs.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
