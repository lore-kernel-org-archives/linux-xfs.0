Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E06F188018;
	Wed,  9 Oct 2024 08:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728461096; cv=none; b=j9+uV/EtudbN9PgpVw+JDF9rqtluUexxaghQAxm3qlWN7Y2TZr9Y6woqiYaDeo7S2UVww7mnlv2pjGkKfWh4g6X+9AC0+dJx0rZ3u+CdOIohrsfgEn8VwUjhxbPFAwBt8wvi2QkvD28KAo7vH0cZmlVL6tMCaGJdxqdUpwNsRwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728461096; c=relaxed/simple;
	bh=DpEYPqZ/j2zayeJPeum8SmrpmqB2hzC45m9t62tD+VY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ApfnWnpvbXqxgrAQqKgrpoQhVvR2jX/zqRi5y94yC4ln+mE7+CAobIGdOpb5fonRFhlq4ALaZ23xAisrEpOA1ISXRK0fFrjBYv2jBWIfgw3+k7bUo2j27lp/6FVxY2gK6FqYEepO9LKjVpeUemfKUax4HPASM6PaUnVhZgy3ZHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BDBEE227A8E; Wed,  9 Oct 2024 10:04:51 +0200 (CEST)
Date: Wed, 9 Oct 2024 10:04:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org, djwong@kernel.org,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test log recovery for extent frees right after
 growfs
Message-ID: <20241009080451.GA16822@lst.de>
References: <20240910043127.3480554-1-hch@lst.de> <ZuBVhszqs-fKmc9X@bfoster> <20240910151053.GA22643@lst.de> <ZuBwKQBMsuV-dp18@bfoster> <ZwVdtXUSwEXRpcuQ@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwVdtXUSwEXRpcuQ@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 08, 2024 at 12:28:37PM -0400, Brian Foster wrote:
> FWIW, here's a quick hack at such a test. This is essentially a copy of
> xfs/104, tweaked to remove some of the output noise and whatnot, and
> hacked in some bits from generic/388 to do a shutdown and mount cycle
> per iteration.
> 
> I'm not sure if this reproduces your original problem, but this blows up
> pretty quickly on 6.12.0-rc2. I see a stream of warnings that start like
> this (buffer readahead path via log recovery):
> 
> [ 2807.764283] XFS (vdb2): xfs_buf_map_verify: daddr 0x3e803 out of range, EOFS 0x3e800
> [ 2807.768094] ------------[ cut here ]------------
> [ 2807.770629] WARNING: CPU: 0 PID: 28386 at fs/xfs/xfs_buf.c:553 xfs_buf_get_map+0x184e/0x2670 [xfs]
> 
> ... and then end up with an unrecoverable/unmountable fs. From the title
> it sounds like this may be a different issue though.. hm?

That's at least the same initial message I hit.

