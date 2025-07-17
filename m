Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EB34C9D
	for <linux-xfs@vger.kernel.org>; Thu, 17 Jul 2025 04:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752728381; cv=none; b=LMgA/3q4fAR6TL1AzbQMtXbj7KG6QSu7BTn7ewL/7+qFZaxmArkafNdzcxWCL5t189AzYeD/kUNkCcaGvKXoGTcZCdwLC+0tHAivmN0FKVcDUe229lzZvbaVzM3kvHhhJbxPBS89U2zzGFhd8rq+/qjHjDuK4wdUd4Vi2rNL/Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752728381; c=relaxed/simple;
	bh=udygk/hQ3y8yhW+25cpJOZPbRHW6ZiwQyjNrBQ7q28M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lZ+psN53ckJ4SFd2zE4MAb0q+JxN2uyuWPv/dEg4bMrILYRLQ2t8rrKHHd7LZBP9GhJj+b49F+2ZeKZNuUTusgE4HVuLGVH7AEHFb8gL/sIlTkLVRHMLPHIibRc3XHxq7LiR022xUItx5P6D5gZWq9Jli6GsEIsRR8PQpuUAkjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xR1qP0nr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xR1qP0nr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=R7fNpAFHv8/oXQR/FTKKibKwuvbI5hAJ5FpEHHwtYRA=; b=xR1qP0nrgpqaCOlFTIi6vU5riC
	NZak4cUWf4bFViRZm1TVmKAMiSXpA+QYkHgPg0GR7P9V5c3COIHOc4CH1sGJO5r88ZWtJjVlgqTX6
	7RZ84goBFW5LuWflh1ZcLE8aCLIYz2byL0bHzopxKrZgHIqeAr+hPQDwMcQ6hL0ogm2zQLTylxuVM
	sN3FV57nOW+kB8tf24BwSES2O2B0Osnet4qpZmJLxE19nsQoklinC1eDV7aGmKKSnVLbA/te7RMqF
	RZs62TC/Gmkt/wqKOmkIy6cA7kWk9jfZZEmwMOGDwdsXbzsXDeyhOJg564ByVf9efKvmUYidYNbl/
	VF9yis7Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ucGiX-00000009Cn3-1j1o;
	Thu, 17 Jul 2025 04:59:37 +0000
Date: Wed, 16 Jul 2025 21:59:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Wang Yugui <wangyugui@e16-tech.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: a deadloop(?) when mkfs.xfs -o rtdev
Message-ID: <aHiDOTwl8lV1g0s1@infradead.org>
References: <20250717081332.E87F.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717081332.E87F.409509F4@e16-tech.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jul 17, 2025 at 08:13:33AM +0800, Wang Yugui wrote:
> 
> # pstack 5785
> #0  0x00007f8df5efc01a in pread64 () from /lib64/libc.so.6
> #1  0x0000557b7bbfe9c3 in __read_buf.constprop.0 ()
> #2  0x0000557b7bbc3030 in libxfs_buf_read_map ()
> #3  0x0000557b7bbfe1ae in libxfs_trans_read_buf_map.constprop ()
> #4  0x0000557b7bbee7ef in xfs_rtbuf_get ()
> #5  0x0000557b7bbf03d8 in libxfs_rtfree_extent ()
> #6  0x0000557b7bbbb322 in parseproto.lto_priv ()
> #7  0x0000557b7bbb7643 in main ()

This is reading the data from the main device for updating the bits on
the rt bitmap.

If you have a very larger rt device this can take a long time and might
not be stuck.  And easy way to test that hypothesis would be to try
formatting with a very large RT exent size.

