Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3925674D
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 05:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724304677; cv=none; b=iSJdFOnwiM5Au9RdNmCLrO+Eoqk3nEHGyb57c66SdPiJ1Axpsk3CJfwI6iWAT+BWcC9Y560a+w6Vmqx7YkZMeHf3vwvIvUE+D8rWaWPvTme4pEzg/gyodqwpB6axmySD0yh6pF62d9XJYJ+qR2Y4mIq22N4sMIC6sgY0Hj3xD6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724304677; c=relaxed/simple;
	bh=4TYK7ECFaJsaTEfKGT23hP/CRmLzwX2eYGtsmzPDdOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uesxaxNMOVDkaLfboZBtXq7GYLqGU7LJ7I9zUhstUVnWxsFPlEKH7vF3tHqi8xL+WAtdtVe0RK4WA0SiHRmAOmLphsD4/y0beVUKZ2uy73LWHbOMIEZIwhorTb9bnlOaW/DA6rKbOvvrgHL3NhcbqXXjONMxXRPiY0mNKP0aWnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1uQTAQ3/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1uQTAQ3/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gdADQaGUXrMrSDVxjv5eFNXOBQtxNQ2gC7XWWapdpJ8=; b=1uQTAQ3/lhMtyL95FG+JZ4LZkx
	lmdSNCk97/XcqsyddxSoBhty9rkZDXCjjLd4IZ4KCtsWc0YMYjLxL7M0C55z69owhdusJ648vo0Tx
	P2pIXtTKiadmcPJsBvMLOEqYnMJ+cbfyuUh20TmYdLlrJwvSiD0CVQamHYzg8e1TyGnOvBiLD5N8H
	+Ut9WHQghiPkTO9O3qwhgshKNc/HHlMnQUhK6YKH1mm7wxLUUWThxhU92uzYrJR9Cbh4d4LiiEMwB
	R3WJNkWsO7kcY3Kvu2E6yYvhKYlbnqYn1bnsrkwLm0bQYBNfeOQn1jTPx9vLFAqoK9ynApkG3XReY
	xlbXKgBA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sh0Pj-0000000BTmJ-3fAr;
	Thu, 22 Aug 2024 05:31:15 +0000
Date: Wed, 21 Aug 2024 22:31:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, kjell.m.randa@gmail.com,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix di_onlink checking for V1/V2 inodes
Message-ID: <ZsbNIxrlympxO8hn@infradead.org>
References: <20240812224009.GD6051@frogsfrogsfrogs>
 <ZrrzUw55-UQZ649j@infradead.org>
 <20240822050442.GO865349@frogsfrogsfrogs>
 <87r0ah6saj.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r0ah6saj.fsf@debian-BULLSEYE-live-builder-AMD64>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 22, 2024 at 10:55:05AM +0530, Chandan Babu R wrote:
> On Wed, Aug 21, 2024 at 10:04:42 PM -0700, Darrick J. Wong wrote:
> > On Mon, Aug 12, 2024 at 10:46:59PM -0700, Christoph Hellwig wrote:
> >> Looks good:
> >> 
> >> Reviewed-by: Christoph Hellwig <hch@lst.de>
> >
> > Hey Chandan, I just realized this didn't get merged yet, even though
> > there's a user complaint about this.  Can we get this staged for 6.11,
> > please?
> 
> Sorry, I missed this patch. I have started running tests on "v6.11-rc4 +
> <this patch>".  However, the earliest I could send the pull request is
> sometime next week.

FYI, we'll also need to to fix the new RT discard support as it
currently is broken when the RT device does not support discard.
Either my series or (maybe?) the patch Darrick just sent, I'm
going to give it a spin now.

