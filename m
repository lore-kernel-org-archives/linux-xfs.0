Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED0C3563FB
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 15:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789139543; cv=none; b=K0STQG3cH3q8Vl2lJBocRDn9VY0NgLlJm82beJx4Y0SwDbERa/fGZpfU18Fx4mP9Ot/rqVX8FBTodQIfUUp6MRwHMUSs6XVzGUL79fa4sHBt1o3421MauzN7V724d+c9N2RBIDLUg3efcDYVapSVY+PzN6+PPnXKl5bWDI0Ah34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789139543; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IQh9+G2IPbamUoecl00IWJTILAgcSgdCt//9vx/8wTM/zN7J4UeNgLgZZ9tqRkY2B+mXgAkNBX7qwEqgQ7g47u1XviS+RXYo5HoutZ9Ngqpms5GaDh+AH8MkQk/5jMcdKaOa0TL7jHSIRJZ8gNO0KmTgfNIYYFx/mPNssvesyjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sKIooBAE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sKIooBAE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=sKIooBAE3OCkBlPfGK5v3gWrpq
	GNIhUdsE+aHFcH3wNrGl4l2Tf3IgpfitpniilWCE72ycbts1x5JV3jvI8DtYgrSR7+4NQKhXFRXfK
	12GQaIw5WZTnNBKbRTzub0O/EwPRyDYbGV48QVSk+nwpxmRnCQBB/crMXBDWeTbue9KboQU6ygI3y
	NxRTSplfg2KSzXJtfwC7Jr4RewL6vNsnhI/zMH7BGVjOlgpno8sE2LsXWM9A1LFmj46giczP9aCf6
	tfVvZ0p4VlpcJWf+SjIfoKfv0FXQHYbD+zudErSersUNtj/nXh/8Dsfx+vg6/DU9PqqndsCrj+sUg
	gw3sQFUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x52vM-0000000H0sp-1evY;
	Fri, 11 Sep 2026 15:12:20 +0000
Date: Fri, 11 Sep 2026 08:12:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] mkfs: automatically upgrade autofsck earlier
Message-ID: <aqQaVNZbsniCFePB@infradead.org>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
 <178892910547.4047311.12714199545208525271.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178892910547.4047311.12714199545208525271.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

