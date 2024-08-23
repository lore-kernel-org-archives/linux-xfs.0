Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5211B5A4
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724387751; cv=none; b=QkIAvrfJaBcfJi4Torz7Qyq3KCwAGNOZ1ERsjO2KNOfGYnVu0hKmnugXXzYrdTXARCZkjKOIOgXse8R7JPEzpqHubCslt3ENf5ZxzuzHOOSMaL7supXK9PjMzJTA/6lYFFBsPtaAAW8ClB/ZVjiAGPW9+F01IICgoVHJRB1mU6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724387751; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q7eL9JVNSkeHPh6ECPes5nRwx8GrG40vxoqWVJl46EUxY6/qGFgDW6W76bGWd93NIWi8NAvpOF3xTqJBDJfkyiXIlkjo4EraeUCrjT0Un6MQd6wx5Q1xD/q+qjMy4zpERjEWz0O22VH5XAGfEZOE+vVxW/2xLcOBDSrWlj90/P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lDH1UXav; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lDH1UXav"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lDH1UXavVW7bkIusP+QjY/m1KW
	3Cqk6ZgLYMhhOFOhBckXZDMnbj1MVaO8zcNIXvuwlWUMJnlLiEGEmwnolb966j/S3ps1j07df1jH4
	07mlRDTeK1ojAwng8PYWz4owxA3vq5ZgnzNy9FjkBbwLppLZLc1jYnFfb8eXItLPLhpcjgPchWwX4
	RJzvJyK8wrTkODouQqU7IAPfIlTL/MUGPwBnaX8xz+MsMNfj4pimtLFNk1qIp1CN3Tpo3fWkLrgoD
	Ha08XR5WkySDFDiwEXKA3YKTiAy+eSgJNmgJPxA12Aswy4+yNv7FTN2KKm43X3+2kSoeg076PIfx0
	a8qBJS5g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shM1d-0000000FCxt-3QvP;
	Fri, 23 Aug 2024 04:35:49 +0000
Date: Thu, 22 Aug 2024 21:35:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/26] xfs: load metadata directory root at mount time
Message-ID: <ZsgRpdQ6lYPfI_tb@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085241.57482.14718872314000238810.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085241.57482.14718872314000238810.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

