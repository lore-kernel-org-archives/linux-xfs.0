Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB594DD3C1
	for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2026 11:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730698; cv=none; b=kbUhhFXigWdqhltAE5UNEdQf7z7hJBrV5+5gcLRdWfYAf81qykXal+I/eSCDzIqdVGIM3HXktxt9jx6AOuGJQp9tlRU7jE5AQJSIfgvybjKinzH9rdTOqWhJdctvtCmCgkbUGdClb1bPj29+fct+TL5afCNYR9b7//CqudHDpwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730698; c=relaxed/simple;
	bh=tqBv72iAG2xK+QAqfeBqMf2tsiYqHPWU/djeFeuzytY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qv68suc7FD1P9+s0PdirbBBM+qQ3WFuizjAnyJ2qcx1AZHRCV/UQnIvZ4XL2UOywwGdxT6IwZDB1SYFx4apvFaSslf4yRjsXqVaoyougJASUflhJbKVUD7nvrQYfiDrEYy0gqupYYekehTpc1hAp6hJKATCPe0bjJJpjqbvBzk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1DFEE68CFE; Fri, 18 Sep 2026 13:24:51 +0200 (CEST)
Date: Fri, 18 Sep 2026 13:24:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Lai, Yi" <yi1.lai@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 1/3] xfs: also flush the RT device cache in
 xlog_write_iclog
Message-ID: <20260918112450.GA15716@lst.de>
References: <20260907073427.719935-1-hch@lst.de> <20260907073427.719935-2-hch@lst.de> <aquGEi4DdTPqdQEh@ly-workstation>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aquGEi4DdTPqdQEh@ly-workstation>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 17, 2026 at 02:17:54PM +0800, Lai, Yi wrote:
> 
> I used Syzkaller and found that there is INFO: task hung in xfs_buf_item_unpin in v7.3-rc3 kernel.

Looks like it is temporary and then your test continues after this?
Could it be that the RT device is backed by something very slow
and you're just seeing that delay?

> 
> After bisection and the first bad commit is:
> "
> ad0033e2dbd3 xfs: also flush the RT device cache in xlog_write_iclog
> "
> 
> All detailed into can be found at:
> https://github.com/laifryiee/syzkaller_logs/tree/main/260916_125217_xfs_buf_item_unpin
> Syzkaller repro code:
> https://github.com/laifryiee/syzkaller_logs/tree/main/260916_125217_xfs_buf_item_unpin/repro.c

That looks like mostly binary code, really hard to make any sense of
that.
