Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D372D6621;
	Tue, 24 Jun 2025 14:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750774475; cv=none; b=jeTeblcFLe759YEoJMfKqTUL3GVXRmuDUOeCfPBOwnF23uWq4YlhVrAANpxbdyCm41nUdqCNgqJBQ+oOsOMCjkHXf6V82Hi1rPCdEsrRctlOAGH0Bvx+fLnLBQtclXh2kqEwwvUOjCj/H04yRYTytHqDk8NXpA/arbF6O0r52pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750774475; c=relaxed/simple;
	bh=yDz3DHLKHRXAhmNcvV0b+qs17yAr+Jz0kVoG2giRtQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fHESjdVwv05sjUrfSkFkLXFxUUMeDHMdLK6WO70YqK4yzhEek/LvRQ7LQ5iXY64ywEitbdpSmIBEKYQknNsL7sFktVOypeNjFHBrYlys2hioSQP5i/8G8fujkvPNnqy8mBJo/N19R3Pqlq7SEBjWGQGFEvWfOUXZohRej48sdUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dI0WdYrP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dI0WdYrP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yDz3DHLKHRXAhmNcvV0b+qs17yAr+Jz0kVoG2giRtQM=; b=dI0WdYrPXGfSLDcYVAbgRhEEgX
	24b+hlvn4NdEb3G1ZY6fGm7kjvUCN9hJcv3u0jQ6UHiptaeqGA4gX2XzoxdcaVzkdRmzvjQi8fy8S
	ua9RAyDuf0nzP4DpiPLZSlEbb3Vows60HIkaiP367ROPSEE31TCrZvlKoA6Fne4skdLjPYR+0RjqI
	JBgdH6HdxrHnz62pF6rnziD02SCWktHvZ7M+k8I0HXymqJ9xoJAtfv4KUGNrZv88AsnuEeVkndxAv
	S8fa/62MUNYLFu1yDVZyU8ljDFefnYWYfR82WnfGumiW8VdW3yu13Ejr6QXmnUW5r/zZ+jZCVHtZK
	Pxwi0Sng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uU4Px-00000005rLr-1oAK;
	Tue, 24 Jun 2025 14:14:33 +0000
Date: Tue, 24 Jun 2025 07:14:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: ying chen <yc1082463@gmail.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH] xfs: report a writeback error on a read() call
Message-ID: <aFqyyUk9lO5mSguL@infradead.org>
References: <CAN2Y7hyi1HCrSiKsDT+KD8hBjQmsqzNp71Q9Z_RmBG0LLaZxCA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN2Y7hyi1HCrSiKsDT+KD8hBjQmsqzNp71Q9Z_RmBG0LLaZxCA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Jun 22, 2025 at 08:32:18PM +0800, ying chen wrote:
> Normally, user space returns immediately after writing data to the
> buffer cache. However, if an error occurs during the actual disk
> write operation, data loss may ensue, and there is no way to report
> this error back to user space immediately. Current kernels may report
> writeback errors when fsync() is called, but frequent invocations of
> fsync() can degrade performance. Therefore, a new sysctl
> fs.xfs.report_writeback_error_on_read is introduced, which, when set
> to 1, reports writeback errors when read() is called. This allows user
> space to be notified of writeback errors more promptly.

That's really kernel wide policy and not something magic done by a
single file system.

