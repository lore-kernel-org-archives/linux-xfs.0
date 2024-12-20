Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE61913D8B1;
	Fri, 20 Dec 2024 06:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734676168; cv=none; b=NP9yE3M6W5JXGlCsrZf6Qd34jvZpqTJ0112rTVzHxynzVkcFqOSFecivWp8RawnK4v7fEbIYl+/x/BWj4Bj9mTGp9rJno88aWt52ykG46/0pG3FvHS5Q03bUU6wcf8L3IrrmUXuMCfUgAcYEQI9KszH4Voxr5Zi4HT/iyiF0IsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734676168; c=relaxed/simple;
	bh=nGE6MrPRUx1SEpmJCA5V5FhODuf/GgyrcEX66YOygLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Edl6uM3yBPAxHO8xmepO+XCdndfWU/MgsjkPTU1M1SH6aHDwlbYAyV9XbglhB1clQyt3sGbyhPv4bojwFly52/A3GFkk95/ARiSLrwCDmqzLlGCH/xLZR7wWVO5z+O/kxpbYr/W1vL2vz8RMask1rLrMBXUN76BnibYUc8HqyEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Or02LW65; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Or02LW65"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nGE6MrPRUx1SEpmJCA5V5FhODuf/GgyrcEX66YOygLQ=; b=Or02LW65nKnUedWktJgFJg00QE
	VMy63QOGZgnLi6l+xGx0D7f3kgHMW9L4Qz6Rc5vbh30KixoJ1GKz/waSkHqVq5Jx050ScheIOl7UI
	7GjqHeKLu3Wf1+ZqTy4mxqymHiLWFqq9gqcCgoI/y/wQJB0X3a0GHjJlOJJLSPLPY92XbFGjIUxzM
	hgWD7ZKTQsIP69AzFdQC3p+M/vEbLhxNA7dKcSgXGR3a/BDIxPgKphD7sRpDf3pz2xCd0ViH7HnNF
	XaGZUB/+5ze0h724jzuZjrY5dWF1J6veFYJYgg5gSrijf33jbmcvnqIooW6E3JXB+R98ILxKd3A5V
	xlZGdwzg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tOWVo-000000045lT-3LP8;
	Fri, 20 Dec 2024 06:29:24 +0000
Date: Thu, 19 Dec 2024 22:29:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com,
	stable@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/2] xfs: release the dquot buf outside of qli_lock
Message-ID: <Z2UOxEL7exbK6E_o@infradead.org>
References: <173463578212.1570935.4004660775026906039.stgit@frogsfrogsfrogs>
 <173463578249.1570935.14851151691186464527.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173463578249.1570935.14851151691186464527.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Yes, doing a xfs_buf_rele under any kind of low-level lock is probably
a bad idea:

Reviewed-by: Christoph Hellwig <hch@lst.de>

