Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313CB469D
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 04:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733805807; cv=none; b=HLMy5M1EO+VUUe+y4bVMg4sIe5BR4duL6Nl9zn5UvhG3wuKOHIdl/A6GTbNZBQihUdSftCr0QY8tTiJx6Dgb1RI67qV74vshgC//vubemeqt2VKyS6ApRj4tRH67FkU7hZ2KuEWwRyZbKMP9Qom/94fykVZM1IwJvbO2d4NZGag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733805807; c=relaxed/simple;
	bh=3ooisLDJyVVOQur0VWbUwI1EdlX+c8iGCkPcqvsljPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ITNTh42NLjm7asGF1nK5ZSfiQPqMdViZm0+c+AMQ6kex8JqUup1Q5rOqPWv3G7lFS9O16PtoF3rxRtdNYppddeYZaDM8sTr+PqhK4saNRqdSZ6qn42YrvwasHdXa83PFpYLK6dgM9KFK+zzNlZ+utc87THK2YV8kcup/ik+LiTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ciz290Vn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ciz290Vn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=pDG7Aocl0r1ShD8N6x4btrMLqIp9v6KUrP8PK7Z6GaA=; b=ciz290VnQSeN1DZHiwf0NwJyZk
	X3Ldh3pAgHJE5oExWtRwyW3rvI9jRXIB+o79Cac2LnYH8RyZbDTl6QKY6q0jqFll9yrZuP2so8TF/
	7PqC+YjomOEMhtt7iu3vsFfymE5qfjG7GNTsvvlT3hfHyU89mjXeFrU47P/JB5wOT3f01j/XOtFoi
	Jq3JTk8aY5tXlGt7dp+raU1XMakWVE7AQctpOREqcvTNM5lUS428C0o5DdFK6wQwOytADkBhm34oK
	KKOrSITI2nYysns8DhwMrx2kk3bPsfWOjrC3mAm4ATtWIJ31BVFwagBg7Z3xfN6qPL0U5pTUVZc3h
	E1abVghg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKs5k-0000000ADDD-2Lrt;
	Tue, 10 Dec 2024 04:43:24 +0000
Date: Mon, 9 Dec 2024 20:43:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Mitta Sai Chaithanya <mittas@microsoft.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: XFS: Approach to persist data & metadata changes on original
 file before IO acknowledgment when file is reflinked
Message-ID: <Z1fG7DSi4SaqYYf6@infradead.org>
References: <PUZP153MB07280F8AE7FA1BB00946E25CD7352@PUZP153MB0728.APCP153.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PUZP153MB07280F8AE7FA1BB00946E25CD7352@PUZP153MB0728.APCP153.PROD.OUTLOOK.COM>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Dec 02, 2024 at 10:41:02AM +0000, Mitta Sai Chaithanya wrote:
> Hi Team,
>       We are using XFS reflink feature to create snapshot of an origin
> file (a thick file, created through fallocate) and exposing origin file
> as a block device to the users.

How do you expose it as a block device?  As a loop device?  And what is
a "thick" file?

> XFS file was opened with O_DIRECT option to avoid buffers at lower
> layer while performing writes,

Note that O_DIRECT can still create page cache, e.g. when writing less
than the block size to a reflinked file.  Note that it should matter
as the caching is transparent to the user.

> even though a thick file is created, when user performs writes then
> there are metadata changes associated to writes (mostly xfs marks
> extents to know whether the data is written to physical blocks or not).

Any write can create metadata changes, and you must always call
fdatasync to persist them.  There are a few corner cases where we try
to optimize some of them away, but that's an internal implementation
detail.  In that case fdatasync will do nothing, but you still need to
call it.

> To avoid metadata changes during user writes we are explicitly zeroing
> entire file range post creation of file, so that there won't be any
> metadata changes in future for writes that happen on zeroed blocks.

Why do you care about avoiding metadata changes?

>       Now, if reflink copy of origin file is created then there will
> be metadata changes which need to be persisted if data is overwritten
> on the reflinked blocks of original file. Even though the file is opened
> in O_DIRECT mode changes to metadata do not persist before write is
> acknowledged back to user, if system crashes when changes are in buffer
> then post recovery writes which were acknowledged are not available to
> read.

Of course.  O_DIRECT is completely unrelated to using O_(D)SYNC or
f(data)sync to persist data.

