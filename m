Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B0C2356C6;
	Mon, 11 Aug 2025 10:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754908615; cv=none; b=mzJ5UMzjCBhJMh3RwgbkT7IAu1siayoHxVK2hMEIUX7p1pVXRRA7D+OELJjcl17bWptqPJ59JZzfwBsDyiTJKC4DSvzBjdIocNNvw4TIBVFYZMQhcyFdi9yuZTJ51Lvl3YIvnG2ikgHsy0lusugTDjgzzSMwqtIHSERCcVT+TYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754908615; c=relaxed/simple;
	bh=MOTU4SAh2iThqIBHYr2IZ0EFKJOdfu2741cVqmAcITs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=brTUqstaFvkmF95NO8lUfDAmy3MnjdDpIP126BcNa//X+xInY7onAPAxw2KRgzkZpMDdq9UngJ/cPpUpm6CMgvNc+doiJnsGTtiMJvzTre1pUjuW9N5YVCJ8SXLBzqHs+E2EENeKC0fuOz4ozxt/MmyWaZxbYNWz2BhRBgEPsRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=isY9yo3f; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="isY9yo3f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=raBpgapriIGwO8dc00hxsXzZzPJFIxLadOxE+aqalcU=; b=isY9yo3f+0UWpg4lhYDAVRM/8M
	+bJYZVbjvaXQRf3tABzmgAVcaoXO4TsWiHAkuygpFJnGLTnhGbsVQKBDIpL9LC5PEp9uRJ61dbqeu
	LfF8+Lz2D4aVIDo36pZfP4397VU45ktQgbNl8GBCzvC0Ryhz3O+erEKCcp2PivuV/ruhXRyuJ1mxp
	eseRSz9cf6iB6Uzcny8EYJRnvbZso/gjZNrr7JVzyC7fcik2IbH1jRyUbepw0ULobkMdiryxICoD3
	ylTK+rmFWJxAHYFDU2Wth4MFDVy1BfiYnZ3JW301mU7lx4NTb0FcG2jzd/qJAzwEDtEtMqOOP8IqC
	fv0w2yZQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ulPtb-00000007LYh-3Ear;
	Mon, 11 Aug 2025 10:36:51 +0000
Date: Mon, 11 Aug 2025 03:36:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: liuhuan01@kylinos.cn
Cc: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] xfs: prevent readdir infinite loop with billions
 subdirs
Message-ID: <aJnHw78dwyEL4F7U@infradead.org>
References: <20250801084145.501276-1-liuhuan01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250801084145.501276-1-liuhuan01@kylinos.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Aug 01, 2025 at 04:41:46PM +0800, liuhuan01@kylinos.cn wrote:
> From: liuh <liuhuan01@kylinos.cn>
> 
> When a directory contains billions subdirs, readdir() repeatedly
> got same data and goes to infinate loop.
> The root cause is that the pos gets truncated during assignment.
> Fix it.

This got added in:

15440319767942a363f282d6585303d3d75088ba
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Jan 8 14:00:00 2009 -0500

    [XFS] truncate readdir offsets to signed 32 bit values

I promised to come up with something better back them, but I could for
the fear of my life not remember what that would be.

I guess the most compatible thing we could do would be to make the
truncation dependent on is_compat_task().  You'd still get the same
issue on 32-bit systems, but I don't really see what else we could
do for them.

