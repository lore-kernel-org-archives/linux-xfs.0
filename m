Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B79346AF0;
	Fri, 20 Mar 2026 07:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773991436; cv=none; b=rMVcjjHDwzGkCJWnPh9ulkaJbuuTPXij3ON9DmzNz+3/ZaREe0YbkUgjDDqGOAaF5Ou7DBvkge6/VxfmsYlmi5DIB54WmDbkSV6hThQTulindoKlBtVTZcW/Zjwp3e7jCrAHrONi9K8KVOPE5FNB774Sa++xRtZkloMMO3QExeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773991436; c=relaxed/simple;
	bh=TNupPXrhc2Vo6Vghx3RN9vRwertveSKcv0dCN3UqFGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A35M7i/OZXDUkqSXEt01hN2bjFagZ6XvXfBbKqUnYoEq3+OhpfHLsp4u+lVOCQFU8YMTYz2jct5U+BC1FS0G8olx5UvjzYhJUJnSfa5jHbTEmMvqYxM3Am2Pcj+hCevK+kF0klrJLTl7ltshZKxY86heGE2WgsPVOjViyJzqsRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EFo4ueI8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EFo4ueI8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9YLPTMoX/uHb+tyN+F9cjwTni7oJsEqco6ZCaFAuNKQ=; b=EFo4ueI862G97Ic0GIOL33bIEF
	c3cD9PmsZbPkpt0YX4wLBDv81g9bpZDulUxYQdHCebeOTRY1gHgkH/vAKTaB4cDOSJQY7FH6jqnpg
	MV7izBi5PkvO6TSW7/aN/TtPBCcREkmke/6QczzjQGywyoLIr4KH5R4C7Rpdo+lnZCvblThDsESua
	lH1jXSB/7bI6Ri3ggDkal0xSUC1eT5cdxhaCfc+H0JVfeRuBhZmRN5m2AWnwd8t7RxRHM8N945RMK
	3Q7zXI8qMa2gle3+Q29G5ySI/w8AVP4yjqtq8BpCil0HMLO4kBZ0ySqQkCQ7m67MwlmoespumLrbB
	OWzuGr2A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3UD5-0000000CFHr-3ATL;
	Fri, 20 Mar 2026 07:23:55 +0000
Date: Fri, 20 Mar 2026 00:23:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org, brauner@kernel.org, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [Bug][xfstests xfs/556] inconsistent {HARDIRQ-ON-W} ->
 {IN-HARDIRQ-W} usage
Message-ID: <abz2C1a-KIGMZCGe@infradead.org>
References: <20260319194303.efw4wcu7c4idhthz@doltdoltdolt>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319194303.efw4wcu7c4idhthz@doltdoltdolt>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 20, 2026 at 03:43:03AM +0800, Zorro Lang wrote:
> Hi,
> 
> While running fstests xfs/556 on kernel 7.0.0-rc4+ (HEAD=04a9f1766954), a
> lockdep warning was triggered indicating an inconsistent lock state for
> sb->s_type->i_lock_key.
> 
> The deadlock might occur because iomap_read_end_io (called from a hardware
> interrupt completion path) invokes fserror_report, which then calls igrab.
> igrab attempts to acquire the i_lock spinlock. However, the i_lock is frequently
> acquired in process context with interrupts enabled. If an interrupt occurs while
> a process holds the i_lock, and that interrupt handler calls fserror_report, the
> system deadlocks.
> 
> I hit this warning several times by running xfs/556 (mostly) or generic/648
> on xfs. More details refer to below console log.

I've seen the same.  AFAIK this is because the patch Darrick did to
offload all bio errors to a workque hasn't been merged upstream.
Unfortunately I don't remember the subject for that anymore.

