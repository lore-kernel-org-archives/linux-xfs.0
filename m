Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A3A2054F2
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420845; cv=none; b=Q3TfHl6wQM6qpdOrawlm+tpG8YwJwBQGEKqQH/HnyNUBqW45p8tTntlumhj640NvlyZ0bSJMkxc+xC2daGPpHKKdUpRo/wiaNjQLbOfnbjhrkDRffHtZYblUFrAbpOprNVT1megVD4R5wqhto9IKJdgfvnzX09BkmXpBkfFiUiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420845; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rWxEHDpjhIenewbn+xZXP7pIx0bDA+AJtLdkiAzmq0C3bKcnrABItinicJNAGDzkGT1VfVYrmeE4gNKUdr49bhDKa+0QWobBG53q1qFKYx56bwQRvbaJ5bQyIXnFoO8i+07moxTClFRjC4DJ0CIbKhvXCcaDE7er+XbKjaNHe5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3yom8Wih; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3yom8Wih"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3yom8WihNY4ebV3moCs4a6hFbY
	QbC4eN3Vegwsj90BnQAtpa0t4PI21T9CGvNeHjkcGqZaANUKL9JdSgpbdkd498JjUpRluA9y0SnF+
	PvbRPepRYnfuzG4iwEMrkmY/+f9Mrdd6S9SFNHjSqRfZa7/jjG3ZAoS7K0LuOpFtt9i7MSfkCnOCa
	I6/+EvmdlXwxYrnECmbYGqBYI/fbUcyn67OtEzSK3c73JoWbgNMhb6xbtpk8VvKR6ojwjgop/84SA
	Ks6QQL44T7RsXfdKyXhHA46e9kAB6gmDZDKFQ4v/56tR4lEFxWzlUwMsE6vTUjcnt2z8h/EuxGak3
	uubwNlHA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQot-00000009iLJ-1yAz;
	Thu, 13 Feb 2025 04:27:23 +0000
Date: Wed, 12 Feb 2025 20:27:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/22] xfs_repair: allow realtime files to have the
 reflink flag set
Message-ID: <Z610q_9lRe3pMu_Z@infradead.org>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
 <173888089207.2741962.17336773299406608051.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089207.2741962.17336773299406608051.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
