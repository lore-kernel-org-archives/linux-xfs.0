Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3C282492
	for <linux-xfs@vger.kernel.org>; Sat, 22 Jun 2024 16:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719072007; cv=none; b=rvQr/gG0EmtYkQsM2IQ4g6q1q0ECLqzbG7AANGyWjVlTwQTTcFqf+fcq7+3958QV360Fa6BM7zVaVf2IOkbP0rX45VU+TxXg8gco1HWVXjAfnLNun2QeaCMMjjqqqn0ob1bJESl+DrOlBFxjpGq8/IBlmvENjIt0vtRTcXHQcW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719072007; c=relaxed/simple;
	bh=Rcd943jQWfhldyBHF2IKHqqZejJwDi8fgk5+RKEXEbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FyySv7fKbovfVnyesMUdWzFMfgK5pKoqns+zuThmNESPu4kWf5Ibs9SPF0h603fwoZR1kYJgCVcv5Kqz+CB0QZKM/jgdW7EgQc1vhy635P+5VMYMpduqaXR3VhNxpTG8mcoOWHQHFVhoLjE+o5jvmIoq+xNiiG3zgkTYghShCHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BCOxuQ6a; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BCOxuQ6a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=u65w0IseHkZmk+iFs3YjReGZ0cwituZadHQSjMLXuNA=; b=BCOxuQ6au+aY4x380evK9QQv2N
	vUfUPBcqsqtXx05MZ5AYy79edjzxk+PUSZLSftRzQr5tP1hvdfkfDE5AetDN0fjQuWb1OIAfxpIhC
	6BzABsWhw+LOnWLLf3a/aY/XFV+NMpIoVTvsHXoW8xwnND+ukc4OkjFp+5afhlQAp5dYuEEpOWjKr
	BYMHf/doStAwjIt01S4IxVWnMi9cUukTz/PmeYFXy1B9TsbK8tdjueUgPu8yRdNKIk8vXXqcJl9QF
	q+1uvrjFWMaWWyMXpaINCc6zzdbcvv6XpngUW8bbFjCHd73C2tmn13jiQSZiyFJ+1Xhf6MA+JJXzM
	A1PnZOpQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sL39n-0000000CNjq-2D1G;
	Sat, 22 Jun 2024 16:00:03 +0000
Date: Sat, 22 Jun 2024 09:00:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] xfs: random fixes for 6.10
Message-ID: <Znb1A0ZWI7Hw3X9f@infradead.org>
References: <None>
 <171907190998.4005061.17863344358205284728.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171907190998.4005061.17863344358205284728.stg-ugh@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Jun 22, 2024 at 08:59:00AM -0700, Darrick J. Wong wrote:
> Here are some bugfixes for 6.10.  The first two patches are from hch,

There's actually just one left now :)

