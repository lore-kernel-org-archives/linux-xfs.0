Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HLTE36Ww"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D087D7F
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 21:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=HLTE36WwaZlat5JS8aucUli0vO
	54rkiLvIqozQPUcR0pmO0HL2vKu5O9CHTR0u2SdjByVjd7GaaVfxVRZ/44YaGvU8+2AYJoB/85gcF
	yc5ij4x8ibeG0LIgb/VC5H1ZyknExAYC+pLfoPzKoNmNCMDxyMEt2PCOn+IGPPF+s04GbXL9nUU3Q
	5gOf6hbb3hibjOyFm+4cyqHJz5qTF8rJS9ILFYClhi1UztZQaeLQ0ReUGeTozwkngh2NpzyMqlgiO
	wT5gi7YpiXLRMk0/08f7AAAXIsPnN7cVb0jr+UWNnWLijq+EoJd5yXEq5WxXZ03gN1+1F9NgrxKvs
	uTRijiJw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8ZQp-009xNU-30;
	Thu, 30 Nov 2023 05:17:47 +0000
Date: Wed, 29 Nov 2023 21:17:47 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: check dquot resource timers
Message-ID: <ZWga+9htXcHAHc3o@infradead.org>
References: <170086928781.2771741.1842650188784688715.stgit@frogsfrogsfrogs>
 <170086928823.2771741.7062657907919448653.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086928823.2771741.7062657907919448653.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
