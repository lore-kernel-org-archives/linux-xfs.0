Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85260C8E0
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712727901; cv=none; b=WzqFOK6GKI67qvtTKse8zV4pU7mBSVpAjMpG+2dFw1WXpekajFM2kLTgG1HoOqO9L8jffUN3zLy+MlqGWqt5gq1dsK42FOej+q9zV430oyQaxsAgUDF0maDbKMa8wg0vNgvwXcva0Vu+i+lvV9B7gk5ZufCasJDbQ5KaQxKcqNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712727901; c=relaxed/simple;
	bh=PI1hmQ5gsWxFO9bMLfvChhs0W7tb23ghRdGELKMiENQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lDpu3ktu04SNEUq9G9+j06jbWuFQ4HLWwBd9vhTkTpNWWy2i0zRc1EHRAfQpQ+hExy+OkZCWPr051pBDXEfdsPA1HfKCK/Fcrf1Kns8yk+tPKD9IKTFcgHGMV6p+5LWy8KX3IlkiH0IJjEXzC+xZpy6nHdXqBdMjcsN5X266Hzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sCG9LMcT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sCG9LMcT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OOEvQsZhzjBFIq14L0RvD4v9UbN8VHt/tBUWTjcqtg8=; b=sCG9LMcTw/Xlzbxwam8nXj6mPR
	QDdJ9GGjYr3lBbhuYg/fUbocGfFpG2lWaOSNj95Osk9gsWPtfqul6j9f7x14UQUUqDAyfEnBA41Qx
	Dkra3w6HBcMq6OokUguse0aWzjpvbMh/HEj8bJq1s/aCQMDXeXhxWRYrsk9aLfmHxdVgMgoyA1J17
	ZZkEid1Y3j+n7bsPAbncvvuQRnx3JwkxGBkIAFSHVHm6cyS4d7Xf0QDIXwDq0xhfk/ZQuRUSPKLMh
	yaF9AqNqn5PbUj+5qfk01kgRDg8uzH3hqnDsY5LsiZosI6ZakFMybhIsFl/KMcINakSVkK4PmENhL
	3hXMTtAw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQlU-00000005F5d-2ElJ;
	Wed, 10 Apr 2024 05:44:56 +0000
Date: Tue, 9 Apr 2024 22:44:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/32] xfs: parent pointer attribute creation
Message-ID: <ZhYnWEiQuxzONreJ@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969840.3631889.8747832684298773440.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969840.3631889.8747832684298773440.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html


One thing that might be worth documenting in a comment or at least
the commit log is why we have this three phase split between
allocating the daargs, doing all the work and freeing it.

As far as I can tell that is because the da_args need to be around
until transaction commit because xfs_attr_intent has a pointer to
the da_args and not a full copy.  So unless the attrs are on stack
they need to be free after transaction commit, and as the normal
dir operation args are not on the stack we don't want to add the
attr one to the stack here.  We could probably allocate the da_args
in the main parent pointer helpers, but that would require a NOFAIL
allocation and maybe lead to odd calling conventions, but maybe
someone directly involved can further refine that reasoning.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

