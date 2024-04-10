Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695431CD22
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712729596; cv=none; b=qQkAfu4t8XtrYcSpfjEkcMuYjbA99zuyBCgZFQ6cyd/8UyRVe0Dk1FmFJVdwnKK1EoHdI+E07VBQlCWaG5m9crFYxAJivYcxpzEqQ4CzXIIqtUzYX/CrYMQ1lq59Or8q/Px3i5NlVqwnir9Dbo5y0X3gyI4r4ra5mBsDx/sau1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712729596; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FuEuP7Z+Vh882ixmOn95bYvLk3o1wiTAkTIMFG++cukH8ZnAprrbwQO9LI4e23FNI+CgNk9ObmkdYKh1ok1DCzc2KV+filtCWV6eNol2HLNsiUR9LH1CKtkrBb9YaXT8aNPLqX6/9iaQqCcH+hUrsKDfqKZ5MPbsOfs97xUJNhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=e3cIi31N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e3cIi31N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=e3cIi31NKUHi9N7pChGWv6q5E3
	2Kp5+DAeSrF27fy5b0c98Exc8m5SBGoBHb+MI5AldKh6bprVoY4F4BwBMes72j1IbxMQ7Z3gMAgSm
	F3skCSUL7WV3SEchnJruL3rIfAE4oKU9HvL+hpWXy/29fRu2XPef43lrl7AyecZRg6J4RRJw6klh7
	sFnnBdTinkqpeUusCDQSkO+Dfsv0ewoF7zy7SCK2lE91kdLnUaAef/MSPCSfV/MciMBsATS2V5Va+
	pTPAZ8MgkW1FDQeQl4smBQ5NCClh+5UDlqPugymY3lN4K4WrFwudv45gnWCcsayixh75RktLSCYH5
	qSG9YW6A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruRCt-00000005KYS-08k8;
	Wed, 10 Apr 2024 06:13:15 +0000
Date: Tue, 9 Apr 2024 23:13:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: deferred scrub of dirents
Message-ID: <ZhYt-6nRhDVjtyPI@infradead.org>
References: <171270970449.3632713.16827511408040390390.stgit@frogsfrogsfrogs>
 <171270970500.3632713.13655651505954944042.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270970500.3632713.13655651505954944042.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

