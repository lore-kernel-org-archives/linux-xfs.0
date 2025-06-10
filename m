Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22ED823ABAD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 13:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749562428; cv=none; b=Be6/QE0OCDuHPfOHLZvzUd3UzzNkHqSurSXZraIQhaEd5fMQScvBv58BPBgHxUic/3kPXSt5wpLkOk9lrEdndnoMkTFbkzLjT0WmmHwxh9nmQmQTPDqGlq30PZchMZmSbAOK9SNHctU9uuM00wYKsnTz8/KODE2q0u6UJrb1YNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749562428; c=relaxed/simple;
	bh=+XIxlcCqK44j7Im/z6f+6EEkqnoTt+HrqgX3JHXnxoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BltPEY1/dwYRRcB8OQvErqOlx20abhP3YdFKHMaYgz9XCdEg2oSjaLn3mRauz7/kpKUjejlUH8JpU/UxpmEMspkLaxuOt3uScn7X67QbT8jAAPCeOigPg/64oSTqfxaNPy0j1SuPCEogcrlf/+Sk4zSI2ZcOCJCggqC+YTA0rOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 836FE68CFE; Tue, 10 Jun 2025 15:33:42 +0200 (CEST)
Date: Tue, 10 Jun 2025 15:33:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/17] xfs: don't use a xfs_log_iovec for attr_item
 names and values
Message-ID: <20250610133342.GB28445@lst.de>
References: <20250610051644.2052814-1-hch@lst.de> <87zh7iMN3YQbqk4Sqd5jZSbgu2shMtWSZ6TxTx26lY6GhKClJ7tOdXNIBsmmu1VMu9bslTEhSPdgplacw1n0bw==@protonmail.internalid> <20250610051644.2052814-5-hch@lst.de> <yxm7xmw4oyfk3udwnyvutvsbsbtmctmxxywiyb5xjfowuawqxa@gfxtmvfzpebv>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yxm7xmw4oyfk3udwnyvutvsbsbtmctmxxywiyb5xjfowuawqxa@gfxtmvfzpebv>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 10, 2025 at 11:17:40AM +0200, Carlos Maiolino wrote:
> On Tue, Jun 10, 2025 at 07:15:01AM +0200, Christoph Hellwig wrote:
> > These buffers are not directly logged, just use a kvec and remove the
> > xlog_copy_from_iovec helper only used here.
> 
> This looks correct, I'm not much sure if using a kvec here is ok, so I'll rely
> on other reviewers regarding this. So take my review more related to code
> correctness.

The kvec is just the non-__user pointer of the iovec and can be used
everywhere.  For userspace we'll need to add a trivial stub definition.

