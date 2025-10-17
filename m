Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E9B33468D;
	Fri, 17 Oct 2025 04:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760674756; cv=none; b=alPPkGuNl0WJJHT6e8T4k77Nxg+FgxL+tBwrmyYLyBv1VXW2uwEY6aSl1fM5l+a9PhT6d65p34kRkvMNlOEgQ5EeqxtlJTLRnAKD5kn+P1f1f+sKn8Sa5p/eckhlkqBTifpihUIBOqM5wPv5SNt9PojiTdCoBUu4JPjxiwfrWZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760674756; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ECL09VsP6p/SJzk2MDCK4c7FmubI3Od1lUNMsdKSqzPDp6XOJsVdQySCouyXDkRpSgroZzEi8PvjWYZ/vsGpnLTnyep5m82oQhCcZt48bKrjhc03HLQGrnoOdNenal46KfFA+BMUEcbJMrTf6pEVGIhkPoYwbkeDczHTtH00cxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TE+pf2vQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TE+pf2vQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=TE+pf2vQ1pGPubz9jQ1F4EBhJx
	MKCdxX9Fiwo8C9HNSRCc2mNk+z7fbeU7GvElkdIZoy+++zxiTMXCnhLl9r4VO3QO4fiv2WlhmRj64
	MMlFgxjIbNW8BvOL7/xxK6Vgh6gtFzj3gHmzLNPx8QwRDymRLHCJqGhEq1x0KPviMvwWHVSzZ41Fo
	QJ8wGLU9jPdTXxRPk09DzKjCaplJbYen5KzmTmfzPfQ8QqD28/q4tCsQiXN88i+5kIJ1hlg9IFHpK
	psHTixo/8yaOvTXL/x0e/3l3Uag1+7MqyLX6og7JtcP9sPrkfXoG6+dQqYQSV+ZM39qZ0B16wSrva
	8y1CGmDg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9bvu-00000006VwF-3kNp;
	Fri, 17 Oct 2025 04:19:14 +0000
Date: Thu, 16 Oct 2025 21:19:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] generic/742: avoid infinite loop if no fiemap results
Message-ID: <aPHDwuYODLatJEya@infradead.org>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054617951.2391029.15086649161940357832.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176054617951.2391029.15086649161940357832.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

