Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900F779FD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808656; cv=none; b=Rb73uMxGc6y5/AIUIf2gU3tdvLM19fO0dDSw/Ldnp8uLdjhj05exw+cCl9Q7gvpzVpFS06XxczH//FPlkAMxKKkh3/UetR5q2hERdOKG2fVYMuTeS6q11n7T9+ecOWV+9EvhX3J15H/+SfTwFy8HxbD8kQIjacn0lXfsx+P8kPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808656; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SJUGUE+6p58pu9BGtOjRPFZI3TqGFZLVYnCVCV0pYjjSXbvVdAc9xr2zffTfHmshLS+BPua4bRJSdUEx31t4XY5TlZe4kxSfHzZHGrMLtg3GNdRbTv6wn0ZFiQdTlkD5Dz7P4MD/zMjbXY6NJqEEFglxmLJOUUYv+MNaZss2hyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iBHa5HO1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iBHa5HO1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=iBHa5HO1ruZ9Sp4GIIrRkO5DbA
	hSEkWiAO8SoLPjzv8MDr9UmzqLOUxD96RJZ1zeWvT0+csz2xGyYX5bl5rCqt5TcvGpWLS/s4ryFuu
	wPatsgIEO7JijzbUMWpWwb3RqUpv35mj0JM0rokZvS8hQl2qf6AIvNjekBxUmlsTdIVy11OnsKuGI
	1Tou1NGSLCBYNbjpApQ9sVz3d8DNuc6/UR/1JiSQ1gQSlX01cajjT0+dLwnHahwKNZ6JfcTPz2XZN
	p6cSsinH7GI05xDL2N39w/IE8Tp8B7y9V4TKjBmP/y0EGVdGC7S0ogiUPCy/oNL+IR5UVasRIbJ2h
	ZZ1TJBkw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKspi-0000000AHq8-0uVo;
	Tue, 10 Dec 2024 05:30:54 +0000
Date: Mon, 9 Dec 2024 21:30:54 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/50] libxfs: adjust xfs_fsb_to_db to handle segmented
 rtblocks
Message-ID: <Z1fSDkQHWET6oQU8@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352751977.126362.6614323652955366394.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352751977.126362.6614323652955366394.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

