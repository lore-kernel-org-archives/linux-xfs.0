Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C971B7E4
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711432557; cv=none; b=am8lS0q7eWj9ErxgSadpojMZVb4XnoSffc83D0o241nhoO9lnLaeQzbpMO0e5+A0VA9JsHYmjCKkmawMRJ5neqSvcJUzunoPBCHm20Ar9NYrH5MBnoz1c5uUeqyKlZcdhMKzloe4cGTYUZTzKLYI1lkUT4XrDd8mbaJGXB66UvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711432557; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JgXlKC9b23jMs/2kUcsZUFivXS82RAQNcDkaX5QMwjS/7S0A3fVO39JTHWZO57qfxu2trsuQFVj+E1XaMNr9sL7hHzuy/wwvfYZsnXtLOBOg2m/Y7uvB8ZERh7oRC7nY+x8lkiF5ysFknFgauWaE7wPCn51VmZyxc3J3plqKWWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Io3MTL9Y; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Io3MTL9Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Io3MTL9Y703PO0+vOXtimuL6XT
	JHxkodFLRiUfBTA3UpOyXqPMV5npH14vg2efb7Km10XrXSxUS5Ya9b8NOOkm8K4u+wPHJg3/pe4Qp
	PjmmdzlMSC/XT41jDzF/tVdxVRjD5VD3J/jtIoXbVX74Doe6uF88aLITU79nirHw3LTm2n2mBg1zC
	qkOSFdw7Zll1uojK5ShvW1QYdGhS2KVXdbdF4wpkIC1sHusiOjObDxVJnUpfySJ01xKYjwKa5VKKb
	XL7RAJpayQzGMblWXCvcLtb/SbhiGdFhIb3nEare+sOdwXYOaja8JKcfZF3wRkt6KNEZ3ZViJy+iR
	A/AKCXLg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rozmu-00000003C1q-0U6F;
	Tue, 26 Mar 2024 05:55:56 +0000
Date: Mon, 25 Mar 2024 22:55:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs_repair: remove the old rmap collection slabs
Message-ID: <ZgJjbKH9d_TrxA3U@infradead.org>
References: <171142134672.2220026.18064456796378653896.stgit@frogsfrogsfrogs>
 <171142134751.2220026.10491142329168531362.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142134751.2220026.10491142329168531362.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

