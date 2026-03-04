Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9602C26E71F
	for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2026 13:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772629325; cv=none; b=KsaJkPudyr5+FKV+9e3P0aId4GVQHFpQNieqtJnf3ZxDu69tAINjV+KQkXeVXmbrv9AKaUzHakJ/wWFoV21AdU8izeOrH44qXVHfEXHK6jE3GZdukZVtHn5KnVl8B0mwCPDtooZxTO4uKGOivq/pFBt5Th7XX5ZKaMPvygBAzoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772629325; c=relaxed/simple;
	bh=tuF9fSA8eU+YKx2EyjmbpvRxn8Vs3Upda4cIdHCItoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sh9WPtlPg/3jjha1agf79ozXFkODRZHRLzOoxCJwPSYGVHbacG5bMYmMqNuod0BCXn5oz+9lQ4hgcNTFY6R4+QzJFJ6ZwUqOp2QyvaUTLb7P07n9OqvK85/GdSJ1L+ZOSyE5mGUXJQNmo2houtwo7Rzyx7JjL3IDbNp9N8CSPfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Jo01Zwic; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Jo01Zwic"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=irNiMnjvxN6ZEzmdkWeBKRlNQi/d23kfafBSx/p1yNM=; b=Jo01Zwic8/cb8hPXa+n4Xl9Lui
	A8K2wLCVV1WECSLP3Fw87ckFHgGAAPOeaW/szG0VtZ/xQG2olnVM+iOeAYpgUqCGDYxdl11iH29bV
	KbxZ9UnSGdisYeALmeD34XVeX63Y4/l6eLxf3W9Ria4z1tiIuGML48l4kn9P4rpnvcSNpdnWVBNV1
	3jTFxPBV3+ZUgbVufGwvss2svCMkIzkJuPWLI6VRk9O/kZ0EanfDd1TaoykwkHwtsUlNz4eYwVXCw
	rVLekg2TZx1nF1xh2G4tpZiTGNMXxlEcdFhorPPlDGe2lRXJZZzsFNVs8RQ8/sxYTo8RchaeT3nI9
	oQ9AxS7g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxlrT-0000000HDSQ-0brO;
	Wed, 04 Mar 2026 13:01:59 +0000
Date: Wed, 4 Mar 2026 05:01:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, aalbersh@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/26] debian: enable xfs_healer on the root filesystem
 by default
Message-ID: <aagtR_YU0gOwAZCs@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783748.482027.8553755838914398859.stgit@frogsfrogsfrogs>
 <aacFKgnRvvhSVsH_@infradead.org>
 <20260303171400.GP57948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303171400.GP57948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 03, 2026 at 09:14:00AM -0800, Darrick J. Wong wrote:
> A lot depends on the distro -- RHEL and SUSE require the sysadmin to
> activate services.  Debian turns on any service shipping in a package by
> default, which is sort of funny since they don't enable online fsck in
> their kernel at all, so all the healer services fail the --supported
> checks and deactivate immediately.

So this patch doesn't make much sense right now?

Either way it really should have these details in the commit log.

