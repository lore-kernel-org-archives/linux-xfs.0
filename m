Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BD0129A7A
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711432155; cv=none; b=HeuK3GVO6BO+FDZopdIhpFXIkJskmfNoUmHU26CKNkpJImSHqvAhwu8V2jC4zlSlMbbX+X2fi7sc1f+iEQvchfUzhMiOLSbSGzlzh9wgup8j03sQ8J3tkv6d4esa78PseSunp5vcDwWbmPkY3eNpjufMdc8mYpqxD71YjdRRONQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711432155; c=relaxed/simple;
	bh=ZmDDPbfC6r/x7vkNQ2YQT+Fat5VwqwroLy3oIZUIMnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tRON9w5UE8ThYCSCCIWULIcckatYO8MlnmqsTt7L/xKFokKNHSBkHKSxqAWNwFiqx1AeCM6gIPzHFJRXLhayR1Db6kTP7LS8f1bjYIHty9CSA1CcpujJLL3pHSUqXg8fBu7qOHd3O9DFYCMdMYN4QNaJYqXOH8DBrJ3u23Voby0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AhmNCeRJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AhmNCeRJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=ZmDDPbfC6r/x7vkNQ2YQT+Fat5VwqwroLy3oIZUIMnE=; b=AhmNCeRJKnlJ3mk1XK889lHSBD
	G+cNXDU8vgiBGg/NTwwoo3eCFvmCXGCBejVs+o78YfC7IjJDf6PcVkSWJ0Js9/GWNF0TkHXjDdHbH
	lq/cn/EJxTnflBdntXUw3yoWEFDMBiAFmbLfc09bYZtQRKGVwvMvb7oFaWSBojbb1sLoXuD0O6fxP
	Zxd4eET20IaVvbCkTEqjhRm0mLEj1x5KhJsm2p2+zLptCcY5pI/vY9/pY7ZVE+50DS+P8TC8HCU6y
	Alfn+rBT2g3uSnlA1zIQmz2X9KC20fA0oopw6H5LCmi6f1vIxYeUWw+I4pYbxm6zSGXMOqlUOSj7c
	QMwytEDA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rozgP-00000003B55-1yf4;
	Tue, 26 Mar 2024 05:49:13 +0000
Date: Mon, 25 Mar 2024 22:49:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs_repair: convert regular rmap repair to use
 in-memory btrees
Message-ID: <ZgJh2fqdEUu6r_o_@infradead.org>
References: <171142134672.2220026.18064456796378653896.stgit@frogsfrogsfrogs>
 <171142134693.2220026.17221087060563357898.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <171142134693.2220026.17221087060563357898.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 25, 2024 at 09:00:31PM -0700, Darrick J. Wong wrote:
> +char *kvasprintf(const char *fmt, va_list ap)

> +char *kasprintf(const char *fmt, ...)

Any reason these implementations don't simply use vasprinf/asprintf?
The calling conventions are a little differet, but the wrappers are
pretty trivial, e.g.:

http://git.infradead.org/?p=users/hch/xfsprogs.git;a=commitdiff;h=1f66530b2104b2f5e47aef76fce62df436a8f004

for asprintf.

Also in general іt's nice to split such infrastruture additions into
separate commits.

The rest looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
