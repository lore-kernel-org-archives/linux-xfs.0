Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D000C79FD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808930; cv=none; b=qfYmPfiv3nTVeC1ZKfzSZ96rz2JcSn0Ui1wMpfDB1SLmyWSvpVL9oGgGxRXh3vThxeT6OMmu7dMCx+TdUscHUecS6alT/peD8TcuhZfAV8RiPilFu5fPUjJ3wHaw4NY9PthH+MH6cpSkXw5c/I8ubNbzqODK6o4KXvR1OX79ido=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808930; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DH5cSFgcVxbnB9egnEYkLcdQLUS7I3OFqCpMO7a/Jj6kqPRYtkIX4r9KJkG8mwrK1eeTH4pI3Fok+1vq0pi2HtKG7o87m7+/ZFuAfqSWfL31vrMQc/6KstLDdqzMJUKQaDHVtXH/BsO+9svvQLuQMR4CRJuMgHtBligD9p4jKps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dK8Y1hqU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dK8Y1hqU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=dK8Y1hqUmHFgfxWa/X7aLAA66x
	fGrnV9PA/JhMUHbTquY5q6rA5FYRLCWRsiqHDI1Pg6pXlZpQyLVIP95RsomzUaZ251PYzFajpeLpA
	L8KJNXeQ42MV+SdQEnhH5Mif0S9Yw7lftczs2QiN85tHzgjgF94ye9vCP0QHuWKjK5jBB0c3wk6dN
	7F6yqiTikAKbS+MkQpndZXv+clDZ/pLyy/sQXzO8WS+8BqWDjjSMLRRhMTDh4GvLa4B7xfI3eVZh7
	C9pL4His06g3tQMdNeMgd0VJDB5SZmGzR7FooPYaaFR1SZ0+k1Ng0807LQudTNGhJx1FzPO4j6NUK
	MA5WCdGA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsu8-0000000AI71-1zPT;
	Tue, 10 Dec 2024 05:35:28 +0000
Date: Mon, 9 Dec 2024 21:35:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/50] xfs_repair: adjust rtbitmap/rtsummary word updates
 to handle big endian values
Message-ID: <Z1fTILzWL6XJKK7N@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752144.126362.17082355862911716811.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752144.126362.17082355862911716811.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

