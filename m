Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FF0346E54;
	Tue, 10 Mar 2026 06:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773125409; cv=none; b=gnRk/ygj4idEbhwnd7MdkMDkwqTxchiTvHIblFkwUqAHiK4koKkFIQ5zZpGlGO2xutERIV8Hag6eBDHWdXFgBiM4Jr8oqw8Y6ac14bBsh1HbccQ+iwFf/uPV9F+S2N7wXLc01MABnt8tVqvbiUPmLZ25mypgKztrRusBhQRdZzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773125409; c=relaxed/simple;
	bh=07ySnRtHjKZo/ijFB5QL2C1BTIjcADoYzuGDF2u6lLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nl7ArX2Iv5ohis5qq3fIUJjiJdywq81vE9SYMeZXFubkzU7SvC/8eG0Qvv/3KXTu3LwvkCuXTviZMP1VjWstvyn/PgrDhC6HbK1rxFJiitvRNJHPCdlabJN/pBByx9RAxACfp2TtyMR4UGZzbxp+n/EdkC6FfYvSvBfOruj/z7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AqHF3k99; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AqHF3k99"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OdQVGF68+atewnIv7dxK8N9SMX5wqJ1KgxImsbcFnTY=; b=AqHF3k99FVv09ywrqnEVoKeCWm
	lsnH6TngkOUV+Y3tEEL1WnyTFAel7g87+9wjvhx4qMfCzGko75U63zjLZB5Pk7PAxMzkAxBeOF6AS
	pQvd6kvXLBHAKw666VzwL1NVvlPQ/ibRUY6uluhood9GgLSJfzBJRVHBGARo33DjvtEpRbclFUdFn
	m++nvNXCaFwUyWTgjccjg+f1KyUSbP3h/Z7T1RULq/JNlaZWu8vspTVI5EOIV8pN/mTMjl/WwnkSS
	cVOIs89WM61IOgfgW2qjNnRTdxaSxbLfk7SkQtRapSonavjtufkGwZ8FsfJVzjjHwazQ+CaK3yVPQ
	/u9gDYvA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vzquu-00000008oAo-2NO7;
	Tue, 10 Mar 2026 06:50:08 +0000
Date: Mon, 9 Mar 2026 23:50:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 8/8] xfs: report cow mappings with dirty pagecache for
 iomap zero range
Message-ID: <aa-_IM8JBdqnMKRw@infradead.org>
References: <20260309134506.167663-1-bfoster@redhat.com>
 <20260309134506.167663-9-bfoster@redhat.com>
 <20260309175602.GR6033@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309175602.GR6033@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 09, 2026 at 10:56:02AM -0700, Darrick J. Wong wrote:
> Hrmm.  I wonder if IOMAP_REPORT should grow this new "expose dirty
> unwritten cow fork mappings over a data fork hole" behavior too?  I
> guess the only user of IOMAP_REPORT that might care is swapfile
> activation, but that fsyncs the whole file to disk before starting the
> iteration so I think it won't matter?

swapfile really should not be using IOMAP_REPORT, as IOMAP_REPORT
implies just reporting what is there, while swapfile actually uses
this as an I/O mapping..

