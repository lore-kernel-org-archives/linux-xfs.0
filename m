Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tvMrXzbf"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D7210D5
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 21:17:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=tvMrXzbfxnGXTchgTeuv/78JW3
	YyWjGgtuSgKcSHUJus6Av6xpxgO+iyiTzNx4DSwcCmcG2dINmyZ80yZmKArrGlIJ338F9HSQg1mgD
	pMIGjKCerptqLb/PbbMThICWTn2u03+wk9T60TrIXpn7wkhwFJWKMjlDnTiTRSCpndA8hREKA3AmO
	d8H3w83hUUkXBoI4ndrKjRObeKDYX/pJ9BSh4qtPz6e0f8Mr7Ig1Yroov15DrlwmeS2sVJhg7UF2R
	TWQ7g8DdYVplA+zCPim+SwulKkpOP2nqXdaddxmQOl07nRRUc7M4+RxVrAbBatvI6dUKERl+ivyFc
	AY0TPILQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8ZQS-009xMj-08;
	Thu, 30 Nov 2023 05:17:24 +0000
Date: Wed, 29 Nov 2023 21:17:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: check the ondisk space mapping behind a dquot
Message-ID: <ZWga5GSicW70bDwZ@infradead.org>
References: <170086928781.2771741.1842650188784688715.stgit@frogsfrogsfrogs>
 <170086928807.2771741.8935602637361502223.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086928807.2771741.8935602637361502223.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
