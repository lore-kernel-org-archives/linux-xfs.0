Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A2047F4A
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738902626; cv=none; b=DtDZuzkdv4aXGZ8Niu+rbZyuIjqekCRoqZPkpJoufhIiYvWznMAhK4bZVRdh6Q8tpb+NZmOM0476XeheJRFvadq26u73NWALq7lqfgUxvIIDsHtRx+v23zAHMqS7votRgy/edBQgs+IYZKmQTLHMRs8WsXUdBJ2TEfE3PnmL1RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738902626; c=relaxed/simple;
	bh=1dHIQSdf2dafjDAsf0r990j74YeEgKRpZlqCLMN3lzM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=akPsKRq0a0D9doOu9T8gdodxo4m2jwiZy/HeobK/Pmhb6FMvCrHxOF2jCbClzbOVJ70sVpdgIY9HVGL1sn79VOTq2PkVn+h+EnDbVrMeeRoQDE+9jAyzzJn+NnM4oTVpb/9VJUOErw4Zf9VxOLazYZgXWeEuye/dM5dvUS4wJIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0kUT5vPV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0kUT5vPV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=y5MLrVe33SvOTzJor9/tZkRyQL9arGsYOkQhpMgLIUw=; b=0kUT5vPVQiyIpw93JZAGTjPD8X
	zigXe0EJtCKZh4Y0ZmTOOJv6l4em8a7gxkzpPpkIJa9vbpiAhWWfjCSIx/h7mMsoDC+2qfOi//uzj
	08rcLXga8oJUo1yytLYRPDx1wOb+ShWQ99c5uuLZsg4yTeSu52eQXE1kqS7ruVV1Un0Dnsxdj6X1R
	8EBu7qaUGUnLedjyA1ibNMwFBv36io+maa76A7YIPWGobYhr18TBXSvgV+hYDWlwUGyx4UHiFiFcG
	BUFpkCEj5EAfdqfguVSWF6mxnPugIHMl+NxvFXPFRKniDuAHqyVxtVH7v9BdR46FPjC3JSkDsttCr
	MyT485nA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgG0U-00000008IUp-3Jp1;
	Fri, 07 Feb 2025 04:30:22 +0000
Date: Thu, 6 Feb 2025 20:30:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: da.gomez@kernel.org
Cc: linux-xfs@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>, gost.dev@samsung.com
Subject: Re: [PATCH] mkfs: use stx_blksize for dev block size by default
Message-ID: <Z6WMXlJrgIIbgNV7@infradead.org>
References: <20250206-min-io-default-blocksize-v1-1-2312e0bb8809@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206-min-io-default-blocksize-v1-1-2312e0bb8809@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 06, 2025 at 07:00:55PM +0000, da.gomez@kernel.org wrote:
> From: Daniel Gomez <da.gomez@samsung.com>
> 
> In patch [1] ("bdev: use bdev_io_min() for statx block size"), block
> devices will now report their preferred minimum I/O size for optimal
> performance in the stx_blksize field of the statx data structure. This
> change updates the current default 4 KiB block size for all devices
> reporting a minimum I/O larger than 4 KiB, opting instead to query for
> its advertised minimum I/O value in the statx data struct.

UUuh, no.  Larger block sizes have their use cases, but this will
regress performance for a lot (most?) common setups.  A lot of
device report fairly high values there, but say increasing the
directory and bmap btree block size unconditionally using the current
algorithms will dramatically increase write amplification.  Similarly
for small buffered writes.

