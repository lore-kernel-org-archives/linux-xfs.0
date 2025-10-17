Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D5933468D;
	Fri, 17 Oct 2025 04:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760674985; cv=none; b=nris+0tMRp2Rdqxr2joelg10Wqtr+3ktREK6SNBOFNqXTvsm/hS43hSKxqKP2j1tAf3IxtvAPkN6lmte31rERynbnniO6ZVJf2NtrkZka3ykT6BOKDiEvYH4BKyfB+7D3FmAzWCb9LcyDELVo9W7Gtycqx02H2rPvv9Oe+ISeyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760674985; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GspVDQhdLSSgXavSmzC17uag3QDHHGR4ZkJm99zx03eSv089qrvS+PJMqQijX+J39ODMGYkHq6mYWfnsyivAjg3VeJM+xEMjCFPZExZoXKCsRDOG3lALtcSUEEN9+aDAWdVgoSyTe7QYMLUMuj9holAeRcMd5eeTD8X3pMTwUy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Q2vgDY3N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Q2vgDY3N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Q2vgDY3NpJqS30QHB4Z6d5MjwL
	t8ksV1jRN+1RGaj3oqJXmG8jzmAbKa8bwwrL7Sa66zUttM9hA6Vp6RWMZX541+9vXFPZKHW2tWjOk
	k7rQT8kkw0FFhHKn6VYHOBUcXMTFArxu2xtTvrdkS+5Enq87cCus8EL/bvxAHAUEUuBQKeP1qg7NN
	C7Mz2j5AwXUO9iwp0lBbhgPMXjs0XI04ZoENmktr+tYV0lL59FkPy4WOiwaxNgfjgw4hF8YTqEHqB
	GiHWZ8TytoU/8T0hV+YBsmEkgoFqdpWNS+xVflt4peXTR+otYVstcE7k5ALKpleVT4/lwCLqdwIGR
	6/UooNdA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9bzc-00000006W3r-1JIZ;
	Fri, 17 Oct 2025 04:23:04 +0000
Date: Thu, 16 Oct 2025 21:23:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] generic/772: actually check for file_getattr special
 file support
Message-ID: <aPHEqDI3DULoz8GA@infradead.org>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054617988.2391029.18130416327249525205.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176054617988.2391029.18130416327249525205.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

