Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8302A1D554
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 04:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739939774; cv=none; b=r2WVbFvSgVBf+I8KEpLusDBPGqd4HAIL8/wzoZzw4s6Q/DEabiOYJbKr9wFGLyJcC3GdMeC5ozLZt+zEO0qamjwWR4yrYuQcx+XHj88jIdQTxHbcinno4mskconqvC+rPncPE3gWI1SPvs58j59r+BilM2ukN12Izs1UpWVskjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739939774; c=relaxed/simple;
	bh=b+qpZYKd6iUGRNN7JIIoK405hi8/R4Gb9e2MC3311ys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qlOWuLzkMiTdTJMoyVnKRmEba0D83WnFXRuyoJfF7TedK5GJh2h09em/y39f99IhEOnvToEfJvdjMkDkD5ZBfXHsV8qt1keNXBe5KEvFXHV1WWGJKr7HjT2rL8YS9YgKNYR6evB3Y/8rlJtKpx/FhWKz5m6hNB6+3SKEG9M+0cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rdyoDLW0; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rdyoDLW0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UbjWkmt0FFVR7P6EiEo1AB3s6500rT69kKcSfmbPypc=; b=rdyoDLW0qjEFf5JHvCqwo1z8cw
	VyLeqBLuhEexnbg1gZBm+rxyfgmTJQ1ci/8ukTwRKJ7GSrfMVl9ttAaB7p8FgWtQ5kr5BNkxjVToH
	54mPI/sU8GKl0wk1Vcil1uNxxL+jP1coJQLe+yZ5vBmqKtZpnYraYpYYryhNF+DtINtHo5ne4REyW
	60eqmu7V2TSTaDGx7pKgje4ichCA/G1/8cr74Hk8GJyKWYj+kgv7HczwJcVWl/BMYse3kGKaqzc3b
	s3/k/NWKToCrq7Q7D/KvW0rZ74iSav6tD5JGggmiHYV97DY7C3i/9LDynxqmAIcYAcKAHuFtxti0y
	UaWCuMgg==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkboa-00000004oNI-394l;
	Wed, 19 Feb 2025 04:36:04 +0000
Date: Wed, 19 Feb 2025 04:36:04 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [regression 6.14-rc2 + xfs-for-next] Bad page state at unmount
Message-ID: <Z7VftAeqEgTwUyx_@casper.infradead.org>
References: <Z7VU9QX8MrmZVSrU@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7VU9QX8MrmZVSrU@dread.disaster.area>

On Wed, Feb 19, 2025 at 02:50:13PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> I hit this running check-parallel a moment ago:
> 
> [80180.074658] BUG: Bad page cache in process umount  pfn:7655f4
> [80180.077259] page: refcount:9 mapcount:1 mapping:00000000ecd1b54a index:0x0 pfn:0x7655f4
> [80180.080573] head: order:2 mapcount:4 entire_mapcount:0 nr_pages_mapped:4 pincount:0
> [80180.083615] memcg:ffff888104f36000
> [80180.084977] aops:xfs_address_space_operations ino:84
> [80180.087175] flags: 0x17ffffc000016d(locked|referenced|uptodate|lru|active|head|node=0|zone=2|lastcpupid=0x1fffff)
> [80180.091380] raw: 0017ffffc000016d ffffea001745c648 ffffea0012b1da08 ffff8891726dae98
> [80180.094469] raw: 0000000000000000 0000000000000000 0000000900000000 ffff888104f36000
> [80180.097740] head: 0017ffffc000016d ffffea001745c648 ffffea0012b1da08 ffff8891726dae98
> [80180.100988] head: 0000000000000000 0000000000000000 0000000900000000 ffff888104f36000
> [80180.104129] head: 0017ffffc0000202 ffffea001d957d01 ffffffff00000003 0000000000000004
> [80180.107232] head: 0000000000000004 0000000000000000 0000000000000000 0000000000000000
> [80180.110338] page dumped because: still mapped when deleted

Do you have CONFIG_PT_RECLAIM enabled?  If so, it's buggy (see linux-mm
for a fix if you don't want to disable it).
