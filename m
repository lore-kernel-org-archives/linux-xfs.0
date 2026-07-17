Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1F62641EE
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 08:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784278627; cv=none; b=K1RRSBl8JJ/lWb17/0Oc+Hp3V+uhl+NrgvYkIfPMdT812TC6d9GHkl7SzFfm1v1ao5/Hsi5Xq5DZ4KZ9p+RtMhEOlzbp4GHSoiLpVgPiDjn4CcDPtKiu1pXr1/ItrNdY3THP2hrbien/CUelyuR9EpNmOiV3IcWizMxUxYync/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784278627; c=relaxed/simple;
	bh=/a9khIJM2N6vOYxb8d2H23FClCu6+rnvOUpEuvUE9hA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cF+BuuJbnNB/7XTI5SKT433xHL4JJbAqUyOx4N77/fRGlsUucRqakIXpjPRBiDk2ZSS3Rv0kcqNaazd+eGE6tQsVwy7fsNW+y/WyW/YsGzv2Bj+K2VVO16xiOBE7CpOBODxZVXPmJCELRcTrGVDCE+3UAG+WYbx/zIvBqvxdArw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F382D68BFE; Fri, 17 Jul 2026 10:57:01 +0200 (CEST)
Date: Fri, 17 Jul 2026 10:57:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, hch@lst.de,
	p.raghav@samsung.com, rallenh@hotmail.com, yi.zhang@huawei.com
Subject: Re: [ANNOUNCE] xfsprogs: for-next updated to 2525ce2aa93b
Message-ID: <20260717085701.GB31819@lst.de>
References: <alnttbpthqqEdTJQ@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alnttbpthqqEdTJQ@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
User-Agent: Mutt/1.5.17 (2007-11-01)

Btw, do you plan for a 7.1.1 release with the installation issues?
That would probably safe us a lot of complains once users start
trying to build it.

