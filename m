Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055BB3C4B8E;
	Fri, 25 Sep 2026 04:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790311612; cv=none; b=cnhQoi0Hx6coGjvEGxjx/1WkS7TO9hNefy8gehun1eZC9QXpcVhOBASocgLSB/H7uqutuL/mOTUS1RagG5ulO26RzSv0p5Xcc63LfVs99mpKGGDBCChDv0kJbdJaV9KdOvjXK5f1QQHK1FGiFDNPpvFx3oEbl/yQo5yfF9bYpNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790311612; c=relaxed/simple;
	bh=dFj4PXIWzhbmUJOFmzQNt1qgtQ8syeC3KliuYY5z/vY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s6hL3ol8FQn3q8DD8gD0qS30nROLTzpCqanN2a+bo71VFSB/oDi1HKgxAIh2kdWFSe00kTOSuEdUxbT1toLfQfCikjhkhao4vngMEs+EQusWd0+NolTazcvRBP8dSC59eliSLxdoK6FE6LfC5FFrupcuWjl83xgWIzlMkwayo5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cqKhqk4H; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cqKhqk4H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dFj4PXIWzhbmUJOFmzQNt1qgtQ8syeC3KliuYY5z/vY=; b=cqKhqk4H69qbZwfRljaTzjyLOS
	ILHS3dPauGeP8NbD2kQFfuYUVRIEEEAHDFkZFmI2Zm16vOCNY233Nmcvdy1fCIpJzJG3wOPVPxz0o
	up75a7Mb7btCHxifB6lJ05GS/q7qdWVQxviBi9aD3OZICMsEh31Q1vnU050R7HyrKZNJDrGFhvyuM
	AGOIFzcfYP3uXWtg3dBzB0+7MLg5FuUafeNwEPjukYare/0P6FEDKV69/bsCo+pBw/ioEd/Koa/P7
	rTuGpBgb01e9jbBHJMtevht1OgeN6tt8xJ1XwmXljGz+AM5SyJcJCyjUzWa7omgxVKJDbA89LXKec
	+tKaAR9Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9xpg-0000000Ccum-0dFo;
	Fri, 25 Sep 2026 04:46:48 +0000
Date: Thu, 24 Sep 2026 21:46:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] xfs: add an error tag to inject a
 ->writeback_submit() failure
Message-ID: <arX8uEDejQaewKqV@infradead.org>
References: <20260924091203.198225-1-parri.andrea@gmail.com>
 <20260924091203.198225-3-parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924091203.198225-3-parri.andrea@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html


Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
