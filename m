Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D24F7481
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2024 04:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705551690; cv=none; b=peiYmgzOzsfvi6Gkj5b3eILfkXeWRQKekPHWxaVbOBLmVw+7dMd/0Lm7sy4Nn+IoPrTCijp6TgFtt03Zd1EpW+XE/Q6ZFHYJtU8cbs51rezMVXVnoN/urgA9az1FhNZlw8G8YGD1FEUxxj51NnaEUtf4vJmrju3x9Bkf/CPsAnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705551690; c=relaxed/simple;
	bh=0DfdJFyi2aAUKaGwxqYAqttWoNton8+WjAigRxMGsy8=;
	h=DKIM-Signature:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite; b=XA2DF0vmT9lA/TUhEj81tpPSHFZft5O0tJz9Ljdg0P5vj97mxEim17AKxjQu83sAGlYe0Ftw89btfetxi71Xo8qbHBhaxBp4W9Lp0INHWVvKCFIqMineUQfYZhBkCPXdlrmv7MJFU3++Ce5Wy8cjLuQsHjz6rvkXWmqrkIskIgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KNh0x7hy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KNh0x7hy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uZSWYSc5oh+OuAIaUH1jK/i2mb10O+kU7A6psS3B9XU=; b=KNh0x7hyN+fu/eCIy+HiwozabW
	zAQmztYWkohGnn2nmcaKiMdsEC8YXhmpqJHnZHUMqrPqn/h9/9Th77a2y02VcRa+vAbOj+Z57KsU5
	KD7XZLaam45AdIpHe50PTd5yJcjHEEq1WU/GogFf0Dcifudq0YKNaez93mRkk4Rck8P738s4OoQmD
	rTxZFz3nJoxnVKhYeoxwu6fipVEZkeLMMlnVYesXcQ039SeApkQK/CRYgmLsYU9zRPyn9bddzIdfq
	/Y2GZDz1egaA64uvRWA2ucz9/18RajTrHZVKUJmKffDIRRN9dWIi47f6bjL6SDDQX3przdNggcrAM
	TBrX6Vzg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rQJu9-001bu2-2Y;
	Thu, 18 Jan 2024 04:21:25 +0000
Date: Wed, 17 Jan 2024 20:21:25 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_db: use directio for device access
Message-ID: <ZainRaV+P0qr1o6g@infradead.org>
References: <169567914468.2320255.9161174588218371786.stgit@frogsfrogsfrogs>
 <169567915609.2320255.8945830759168479067.stgit@frogsfrogsfrogs>
 <Zagcv3rWRQMeTujZ@infradead.org>
 <20240118013250.GC674499@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240118013250.GC674499@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 17, 2024 at 05:32:50PM -0800, Darrick J. Wong wrote:
> > 
> > For xfs/002 that is the libxfs_buf_read in __set_cur, when setting the
> > type to data, but I haven't looked at the other test in detail.
> 
> Hmm.  Perhaps the userspace buftarg setup should go find the physical
> sector size of the device?  That "bb_count = 1" in set_iocur_type looks
> a bit smelly.

Yes, that should fix this particular issue.

> > Should I look into finding all these assumptions in xfs_db, or
> > just make the direct I/O enablement conditional n a 612 byte sector
> > size?
> 
> Let me go run a lbasize=4k fstests run overnight and see what happens.
> IIRC zorro told me last year that it wasn't pretty.

There's a few failures, but I've been slowly trying to fix this.  The
libxfs/mkfs log sector size detection series in one part of that,
and this:

https://lore.kernel.org/linux-block/20240117175901.871796-1-hch@lst.de/T/#u

is another

