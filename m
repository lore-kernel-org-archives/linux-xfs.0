Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A5C29A2;
	Thu, 10 Oct 2024 06:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728543086; cv=none; b=LUx3vuqLUHr7N9yoChquDxmOs0Iroh5vBAG7aJQFmv+8CLM8uxSyIibFsPPaYJc1YoSawN6p17UzkoNLn3lmDMgRrNO8078hjCr5UrkFFawrRyx/yNuwjlNnBNyd1Utv6joJpjub1/aTyRrucC24NfsHW/+piXBzbHRCmwO0SCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728543086; c=relaxed/simple;
	bh=vxcXM6MrcjPvzltaS1vI8dvQJasR9Og+judRH9r41PM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p1we2x05g7kz0VtJc+n2MfEyo1Ay5rqgIjAyxBTKscUQGrz8WADTJOwNkT5rpYEiB3jrqmq2HKPzqAj1712NJXZ2gR+KywNAtfh1buF7Zu3dsisuXRahkUlViszvu0h23loVM1q7546JLWEvUSZLK1lCNNlvqvy3KBmxQ03fBNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E92CB227A8E; Thu, 10 Oct 2024 08:51:21 +0200 (CEST)
Date: Thu, 10 Oct 2024 08:51:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org, djwong@kernel.org,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test log recovery for extent frees right after
 growfs
Message-ID: <20241010065121.GA6635@lst.de>
References: <20240910043127.3480554-1-hch@lst.de> <ZuBVhszqs-fKmc9X@bfoster> <20240910151053.GA22643@lst.de> <ZuBwKQBMsuV-dp18@bfoster> <ZwVdtXUSwEXRpcuQ@bfoster> <20241009080451.GA16822@lst.de> <ZwZ4oviaUHI4Ed6Z@bfoster> <20241009124316.GB21408@lst.de> <Zwad6T5Ip5kGtWDL@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zwad6T5Ip5kGtWDL@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 09, 2024 at 11:14:49AM -0400, Brian Foster wrote:
> Thanks. This seems to fix the unmountable fs problem, so I'd guess it's
> reproducing something related.

Heh.

> 
> The test still fails occasionally with a trans abort and I see some
> bnobt/cntbt corruption messages like the one appended below, but I'll
> leave to you to decide whether this is a regression or preexisting
> problem.
> 
> I probably won't get through it today, but I'll try to take a closer
> look at the patches soon..

My bet is on pre-existing, but either way we should use the chance
to fix this properly.  I'm a little busy right now, but I'll try to
get back to this soon and play with your test.

