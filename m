Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D5410E3
	for <linux-xfs@vger.kernel.org>; Sat, 21 Dec 2024 08:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734768210; cv=none; b=nqgp+MHSuUea7NaOdKtQOhwioNZUZo4H6kXIdq5pib3XCrCYf1VKQA8NkVEV4QclTwEBV/XalYeIVerncMK2G7GcuAqGodXzvTk8U6HKvHMzzanTNmqoxQ6Ih/Cqfh7oNvSEP9sNdLSHejzpqIqwmzamuTHG9Nfa9TYRFdOr+dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734768210; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J68F+Agw+KllHAt6w+rBop2neM6MGhjEsPi+gLtYtSPyG9XIe0F+Br/8+HczYEvsLfSBEtnZSOZvYRT9z+dzqkCCJJ1hFYPs27FOdDyeSAp2P5cPVb4C/eBVVSusrkizdWfHmLT97uI2a8yBUrupoDbI1XRbP2ytFbHE8VrIHQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d26zRWmE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d26zRWmE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=d26zRWmEBM5/F6LMwOWo+p0csc
	ytK/eVee2p3hNPsmfQ7wWkMXQ/sS7eVb2P+Rj0YOQt9KpQKtbhDEdnQdzloK0CUNwz3IbFIXg1q09
	w3j7vDcwHdVpgq3oTtwjhqrHDEFxEESZORAYOkKQx2r9l2VX4LAl8Ltbgw/YXanzVvVARdRZxztDw
	V2vWOyzDtxBKsAaf5IwbxQmwJZLqwjCremgsffwa0kOZD+z59L7+iwyAZOT/9v7fy1VoKeHXYPapj
	rOd66tcJOUt80eXoffWYIPWfMxUllqsPuJHT9AUSQ/g7CcBv5diS4yS4eGhnI/qcWm9k1fM2xsWPt
	4x0xfINQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tOuSO-00000006i06-2Qk2;
	Sat, 21 Dec 2024 08:03:28 +0000
Date: Sat, 21 Dec 2024 00:03:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/3] xfs_mdrestore: restore rt group superblocks to
 realtime device
Message-ID: <Z2Z2UECRTTWc3fe3@infradead.org>
References: <173463582894.1574879.10113776916850781634.stgit@frogsfrogsfrogs>
 <173463582943.1574879.4367794239821092582.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173463582943.1574879.4367794239821092582.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

