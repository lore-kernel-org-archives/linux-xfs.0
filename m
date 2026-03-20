Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FBF274670
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 07:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773990961; cv=none; b=qSVBJ7cXB6lRecSyT7ILuQ18YRj58KoY1SRtNTQB/IwNKRRPPmbZVRxpSc56eWbixIKimkUjZJU2kiufdTAOOhCbdcY58krhw+uB6qoA+WWiSEphchCKnl2tWVoECyiafjSUZd9f4A2iS9LCtkvWliDQZcqmAlccIjrhWi1ksMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773990961; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kGnSoRQzBZy8JfgjPLk7gNT0oi0thjrCf08LkhlpCoC76uJf4qF+JR3TXqzZWmavsKiZZwzH1hzHdLA0an2U6hKTNs+vxOyQ9NquR0hBSMqh0DGmCZjd2FMQoiJpVa23Rxs26rnIHK0s9mqGr/PceHcMl+oZknIZTRgyz90/PGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BP3HOQQa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BP3HOQQa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=BP3HOQQaL5MN/Y5b4OBlpkJSFL
	6eYfMTxHEAgPeR1JIBFFkFPkoAggEbhoNNzz4sFW8hFGix1vrMV85ViXDEencqcGjgoCWM5iO8yEB
	jpqq6VxjV5s7bUQ8UKv8abH+srOl4bYr+or1rzVCfMnwtxoW64yTUxtYDVt8SIdmR5tn30hqYN9L0
	SBAobdYeLdlV5ulz1hOyCwspTAnw3evuOc7iuA3uAm8OAebELk0hga6nEeHG0CMBtXMzAURe36xHH
	/MHiWEpMblz00jbprMT3ViuvGXR6sn1Cfe1/zV8tE0DQZEh3Rn9olOWe1w6OvdIl9rMOXRGKf4QbR
	x1udtBhA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3U5P-0000000CDhs-2hcG;
	Fri, 20 Mar 2026 07:15:59 +0000
Date: Fri, 20 Mar 2026 00:15:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/22] xfs_scrub: clean up device-related error messages
Message-ID: <abz0L8QMpI9KiK-y@infradead.org>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
 <177389507289.3681140.5395854061770102183.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177389507289.3681140.5395854061770102183.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

