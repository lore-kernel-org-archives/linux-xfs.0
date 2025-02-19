Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C24C1BBBDC;
	Wed, 19 Feb 2025 07:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949872; cv=none; b=C0Y1AxcHJ6d9OQZFbfWnUEyP/P0W+zQQ/93cwa9YpdyPUQEmvuW5lkKl6nnxJLUr83fe8gVywjN0z59siqX9l3rSqAyTKFcLxxwdv3J67GcssomhXnLruY+geEderUeT+/b0oC+cFX6FCXX1Fe+rjxfw1p8XKmeUVS+c9ep+mEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949872; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tdG56lQcpJnsokLUIob3lpS45xTzzWkeZs2sfqfo4GO8qNbLvxlk+vzOhB41fUGdcTrUe3xEi8rIiLZYVLFxrxDJVZECLnQoZr2fWG/OxHTNkH5NWDYm+cQ+LKDRL8GjEEI8dNG9iZzJ0tSC29zklHritoc7lSoCuMH/xRff0RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=no4cmmdE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="no4cmmdE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=no4cmmdExGszETWo0pGsz1JNSq
	ALrkeOJunxeYOP7KKx5tmBSbhUecmErVuEXQcaj5dqArZMmOTldp/uGOAPVn727nxmH3KP3/Bll70
	MKWmtXaG643IvxEqzQNg72hpCdSagyMZOQw31eSaJOtQHRMr3vrBWCKwCyYJkTY/YAaO6LmedP/yy
	kGRQrvbFjuIlXqS3rgK1xdIXRZs510qRatw2xkOpVtN+KVXcT6fGWdJbMCAzGn5R5bJJRmrIgwSAz
	O9AwgshwWYqqQMQVXdJoWD81TS3EiI8its2rmdzOi4tLaS0RxhaYik6mCVHNaCrQEgkLuxyQKPDEi
	MXYTWJeQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeRa-0000000BDwE-3r3h;
	Wed, 19 Feb 2025 07:24:30 +0000
Date: Tue, 18 Feb 2025 23:24:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 01/13] xfs: fix tests that try to access the realtime
 rmap inode
Message-ID: <Z7WHLqZaYvPCplgR@infradead.org>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
 <173992591131.4080556.9851417940463513539.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992591131.4080556.9851417940463513539.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

