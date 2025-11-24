Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AE128682;
	Mon, 24 Nov 2025 14:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763993109; cv=none; b=alIzPb/b3p7wM/22EMkqehDmtaXdFL2OL99a5ZlwCTX1rQknVImQeLkXOdE8B3LHkmzOgBOk+jh4HofR4TN3iW3wmXoQEoK2HlJNn8EES2v2HZwjSKVt310dNSVIbHRv+3yCeJ9qApPGSQaFBUhZ2oBbNbulADNdxXgr24AzFPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763993109; c=relaxed/simple;
	bh=c/yeVeluRCOuAAwjEW6b0/UEluofsBIVUpmHNNKM7xI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sGaGTr6LGNSuJgFNv+GdKvAiAWKCpCYA3KLkKhSh1F7NiTanV1gjqiA6ksvq5oklAtZ1IokDqLo8M1ONzCiAOpdyNyOjzNukGNnHYdR7HvIxwOC+qcXDc+/xYkxlByuDBCN3J8fCAPpgcXAf6rGoEwvHt6v64W6G5kHuh6vJZZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HXWDl35D; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HXWDl35D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pPZa5Co5BqnSNguKZuAVzLvvOYYE+GcjQf3hfE5GegY=; b=HXWDl35DnkdPi9Np4m67vAe297
	CpyUcnOr9qe7DRGbqRrwDP2E7pZqMBmmbDNrSh0WPgwhMWcXUWNzFbnoM97agWH9/5RMzx2Xx3vAl
	vmbjp1fuaq8SG09kzVTjGyI5QKPbn9hHZCvCTf0flQbagCKUZJOC5NJXJgE43oWsDfbXgqOeloLwX
	3r0X3UuGY8os0Dyru7kjrWPBZ85Odwvks5LAePfsxeqgd+FSYhxBQoG8BQdLnlPbTvxLCM2a4I9B7
	QUPu91Qz5GV/sRFcXl40A788SoIcsKWF91QLSo/SAHmEnekqzF90KUdMmAHmjyUPrL8d28/qCRUS/
	fAeH40VA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNXBY-0000000BoD4-16eO;
	Mon, 24 Nov 2025 14:04:56 +0000
Date: Mon, 24 Nov 2025 06:04:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, alexjlzheng@gmail.com,
	cem@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fix confused tracepoints in
 xfs_reflink_end_atomic_cow()
Message-ID: <aSRmCPKBOpSaAYYN@infradead.org>
References: <20251121115656.8796-1-alexjlzheng@tencent.com>
 <aSQmomhODBHTip8j@infradead.org>
 <93b2420b-0bd8-4591-83eb-8976afec4550@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93b2420b-0bd8-4591-83eb-8976afec4550@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 24, 2025 at 10:57:24AM +0000, John Garry wrote:
> Commit d6f215f35963 might be able to explain that.

I don't think so.  That commit splits up the operation so to avoid
doing the entire operation in a single transaction, and the rationale
for this is sound.  But the atomic work showed that it went to far,
because we can still batch up a fair amount of conversions.  I think
the argument of allowing to batch up as many transactions as we allow
in an atomic write still makes perfect sense.

