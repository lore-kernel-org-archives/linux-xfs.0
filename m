Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE37524B
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 04:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Br9utN7y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rujeyz2Azd+wEbTAvfKu5rcCECur1ABXMFp2hLRvWqo=; b=Br9utN7yy/LX51qaal3qPZGx4X
	76JxyitcseuSynxG4VGsGOMkMfU21/S7kIgaTNplLwggpD6Zf+NXizwXWsMiaICqRuhgZZyrNcXnP
	YwzlxxghCXx4SXhmNONw+mIORf62Eo4NUAh6mnkSwMu5uIRqwbr/QvgB6/JrwFJRByhNmpuLEYTxv
	YXyVR9B+ReqQfLMxnDvJmSa+rep/L/jQPGhL9QYRIjr7cXuvMJOxXUXIUZukadoUQUS35C1qYrYkz
	S/Qh+0VcdlUkf5XQVZQ/HIYNZHMrS9IUpUGInLtnAc1O0qs62sczQDcw4R/IqV7oc/jwtS/3bX8qs
	qXxLfAkw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcFI-00FwVR-2l;
	Fri, 05 Jan 2024 04:55:48 +0000
Date: Thu, 4 Jan 2024 20:55:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs_scrub: flush stdout after printing to it
Message-ID: <ZZeL1COr3ZOLi8Ff@infradead.org>
References: <170404998642.1797322.3177048972598846181.stgit@frogsfrogsfrogs>
 <170404998660.1797322.4141893748731169587.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404998660.1797322.4141893748731169587.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 02:36:41PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure we flush stdout after printf'ing to it, especially before we
> start any operation that could take a while to complete.  Most of scrub
> already does this, but we missed a couple of spots.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
