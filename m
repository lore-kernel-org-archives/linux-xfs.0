Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666DE534451
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 13:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183911; cv=none; b=on3+zQsnNVYNA52OiTeaBkNDEg4CnGOTeRk8Gq7DYmHF4o4DVuwkWmTXXUMfq9FQlXWY4d3d/qGbK2pgYUpgpIzeZPVN0z/ij8ofRuBwmuRu5drcm7xaQRor37KFKZ9HXdGevr9frrLs8NGdMpj8nbdKW9FBuMZbjAH1hCH+TgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183911; c=relaxed/simple;
	bh=TiVDxLF/1vKc8rKmiCauYkJnNa3VaCoN8iP+r4d83lw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kEyJRZpNbr4j+uphq7r7yoHvOuYXFEGlOZhez1R1xQWxMKFFVgpoNscKNeTtnBCGJ6e/m7e8G3y66ObtDjGVnLFPxQPMEUSi3W68cTFLTNCQ6dJ5rino2qo6zjKPPiRWHXU31woMuSzwgRC5SAYPB8EyeKazBIUCWjf7jH5Rtko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=x4a2Oaks; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="x4a2Oaks"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hBH8jfsrM4h/MPfzKM0pPCYCs/uwVlBXmxQHTXhB6oY=; b=x4a2OaksMjUnhpoUvTgrfXPMkB
	qUB61FmlnH42sSr6yzgCuqhMyfA93M8I3rn9s42DqLwqIN9v7J9XP6GBjOIthnUUrsZOThIh7bcvn
	Yv2Cd/26rwHrmes8pD6zcJnuln87c95S4osEAQSBG/5sCUE04epRDFvpL5GZOiKsjWNBrPX0Q5pvO
	4fo7IYtq2MKZ+ETqvq80p0fVMZ6fox/Cu6HPYr7R20KI0u7R/d3r9L3otGu+Rj314Fx8mxq6t+CO5
	BE6zNV1PdFQxRRUuRidOhGoH/aPi9NJW4QZzU3uCFFCTcVxbWQUq8cGl6pbwb4Dacj0tiJ5VwBCNb
	Nq0+01pw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x12Jw-00000009V6f-3kvc;
	Mon, 31 Aug 2026 13:45:08 +0000
Date: Mon, 31 Aug 2026 06:45:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Chris Wedgwood <cw@f00f.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] libxlog: import the kernel's log recovery, log items
 and AIL
Message-ID: <apWFZAYCqGb5QRjy@infradead.org>
References: <cover.1788110147.git.cw@f00f.org>
 <49d9d6c177ed570d0ee5668df8a6d65ac3a27c6b.1788110147.git.cw@f00f.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49d9d6c177ed570d0ee5668df8a6d65ac3a27c6b.1788110147.git.cw@f00f.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Aug 26, 2026 at 10:09:03PM -0700, Chris Wedgwood wrote:
> xfs_repair cannot replay a dirty log.  The code that can is in the
> kernel, and xfsprogs already carries kernel code rather than
> reimplementing it, so import it.
> 
> libxfs/ mirrors the kernel's fs/xfs/libxfs/ and these files are not from
> there; they are from the top level of fs/xfs.  They go in libxlog/,
> which is where this tree keeps log code, so that each directory has one
> kernel counterpart and tools/libxfs-diff can check both.
> 
> The files are copied from Linux v7.1 and are byte-identical to their
> kernel counterparts apart from their #include lists, which is the
> adaptation libxfs has always used.  v7.1 is the kernel this tree's
> libxfs/ is currently in sync with: comparing xfsprogs libxfs/ against
> v7.1 reports no difference in any of 102 files, while against v7.2 it

As in changes except for the include file mess ignored by libxfs-diff?
Because otherwise we should have a lot more..

> reports 33.  Importing from a newer kernel than libxfs/ is synced to
> would mix two kernel versions in one tree.

We're about to merge the 7.2 merge.  Either way we'll need to coordinate
them.

> diff --git a/include/kernel_compat.h b/include/kernel_compat.h
> new file mode 100644
> index 00000000..0dbb2800
> --- /dev/null
> +++ b/include/kernel_compat.h
> @@ -0,0 +1,231 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Kernel infrastructure that xfs kernel sources refer to but which has no
> + * userspace equivalent.
> + *
> + * libxfs adapts kernel sources by rewriting their include list and nothing
> + * else, so the annotations, types and helpers those sources use have to be
> + * supplied from outside them.  Concurrency primitives collapse to no-ops
> + * because libxfs is single-threaded with respect to the log, and the
> + * deferred-work and I/O types only ever appear as struct members that
> + * userspace never schedules or submits.
> + *
> + * This header is included both by libxfs internals (via xfs_platform.h) and
> + * by the tools (via libxfs.h), because struct xlog embeds several of these
> + * types and the tools inspect struct xlog directly.

Please split this out into a separate patch, and make sure all the
other kernel compat bits are consistent with this.

Also usually kernel files need some amount of changes 

