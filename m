Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA7040DFD3
	for <linux-xfs@vger.kernel.org>; Tue,  7 Apr 2026 05:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775540496; cv=none; b=OmbjsFHkVmBv+26P+e77Nj24A40HXHVKyyIUM3WPzHzEGIZXXRJVyAKvLUISm1xkgOqfGIfWrU7++DSHJKThSGOlO7vZdR8/Rqj82nfWv61jwPcl4swRlhtUanxBVLfW3TD/orB6O/kKD2I7YoqP3Eo9sHYCb5J9z6rvdMu70/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775540496; c=relaxed/simple;
	bh=jzdcCY0dJOV/2s5JXa275CWO388zz4xIHwQSiRhEtMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DdwItSSnZAZT1wOGLZEVivLb5AYzlQz7LFuNiNTcBm8gIqdjiC3AjRKKEd39mHZTPqJ6Q3nUUuIAgyiGJ4UZewuGc6Ghz9mxozwPsJY6i/nk/K4T53hZRnHw1YnXrfZyxtZ9Q2VSMWxe0qjs6X0AA6kP+FMpVXOdtYPmfVM1Qi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1m30wnnl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1m30wnnl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zVFG75AuhLmUo7CKi0rvRylPFaHiXEnlBIMkL8v0mjM=; b=1m30wnnlWcYLIUPCT70hsxlQdy
	K5CmM6vLtwvtGKZRopipt6/cK4frMNIMF7b38+EqCaCnt8CGNgW8ZV/ahiKlukJOQGx36rWz+0TgU
	fnwBQa5eOz1mRdYkQNWRoUjbKfxnl7epCJpyGOFRS4baR6KingVT3J6A3AhWdlsrifXlEumqw8CBX
	zBQTYx4rUSi+Q5zeEW0eWWJaC+EtttgflUJYsHq1lgy6+DV4I3HHlHl1aQ4BghEdydAL+1B/zrBbC
	qRoyBeGDcPSuecu7N9Lze67FPCLOnSRCjXJvu/eo/qXinl8nIUEwO4PyHRJgY6XByIwqo7C62pDDi
	+GHx3hog==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w9zBu-00000005wDv-2KCo;
	Tue, 07 Apr 2026 05:41:34 +0000
Date: Mon, 6 Apr 2026 22:41:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Hang with xfs/285 on 2026-03-02 kernel
Message-ID: <adSZDr6uAe_aQtuy@infradead.org>
References: <ac_eUsuxqf6IYN7F@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac_eUsuxqf6IYN7F@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

I tried to reproduce it, but failed.  Can you share more context?
mkfs/mount options, kernel .config, system information?

