Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A497714A617
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 15:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178139; cv=none; b=SChzLjq19hP1Kkv5QIAFYKHR1WW5Nyn+v0CSgzj5CF6/jeN7RT4m5TgxnuAuRMfsre8RuB8XTCom/VT422RJWg34FXoCzEB0OiwNAoL1Wsm1zSZEAcklypwFJ4+AVaF1RW3+qozhokVELZoEURZS1BlpdkIFBXqIf+tHhZV07U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178139; c=relaxed/simple;
	bh=kNXBobGTpXHf9IjYkhSud4m4HZK9Lj39krGbJtUEk1g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j+5fer/WRtfV2szhyhS7dc+Sh+roX797L5p7g7fPFO9iR+eME5/zT7KEy0bzjfVBV6Rw2TH9KcZAOpXqOxUF1Rh1vajwGqJ7eliZbReS+OK5B5sabV11BMKbjU9+ixMBLONerdAL6vqjmKNiCiCiz0pa0DJ7d0nq3P1J21KGBEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CD94768C7B; Mon,  6 Jan 2025 16:42:12 +0100 (CET)
Date: Mon, 6 Jan 2025 16:42:12 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, david@fromorbit.com,
	hch@lst.de, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [RFC] Directly mapped xattr data & fs-verity
Message-ID: <20250106154212.GA27933@lst.de>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241229133350.1192387-1-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

I've not looked in details through the entire series, but I still find
all the churn for trying to force fsverity into xattrs very counter
productive, or in fact wrong.

xattrs are for relatively small variable sized items where each item
has it's own name.  fsverity has been designed to be stored beyond
i_size inside the file.  We're creating a lot of overhead for trying
to map fsverity to an underlying storage concept that does not fit it
will.  As fsverity protected files can't be written to there is no
chance of confusing fsverity blocks with post-EOF preallocation.

So please try to implement it just using the normal post-i_size blocks
and everything will become a lot simpler and cleaner even if the concept
of metadata beyond EOF might sound revolting (it still does to me to
some extent)
