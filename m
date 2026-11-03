Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793710189;
	b=SDJ9563E04lXc0RM7TEGQOG4k9bWjUxNqUF+bgjlFH7jJsHt/kUUI5T8A931dTDVmAJe
	 k0jYRWH4gvtpEcgwcxCkFFtzpwTpWirGcJTIMkpRRVYC0Dsh3X1h+/qmvhHprSvc7PlJh
	 c0V7hyMct3ueu/Y0T7+CFZ9ey857UXIhG7e41QCHrBhl+k33UEAFi8L0VbDvuzK7f7653
	 Z0A+2Cvot12iIKC6WzVhPhdjnkI0uG0YMky06yvIYGFo1Kz8Heo2Ln/0bnKq2HnhEzgP6
	 B3AuQ9FzoZRfIgtzPTXZ3VLax0UW5nBrX+d+8bC+esIz9z+W8392F85SsH/rJZBddnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793710189;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=3vAVNhvUyeYKpAU27GYNNvUdoFZg/CvbpdU6RE+GVF4=;
	b=QkZnSZUxUweqYuSuyWL/xMAjCkFw7JP25w5eCY/p04OzVlMdRErw8dNYE4OzIc/YwQKn
	 wf80FMttIE8MYq/HAFabW3uVi9Z2orsK54S+VpLK8ZBwznLXuf8al7MOh6+Yc79M6la50
	 Cqrj/YHd8hnNnwyvEZ1b7ulcni6rm3bQyp0UPlg3evOddjMBg4r18cdyKRkmAtegJtLHg
	 GFRw0J4K7pq7b6t3kOOtdhSUw3uCyHqLdVmKyu7BmCxUyZuV7+szRunWxZ5+TU35kisiT
	 sLI14B4lw4S9MTJfQcxMbBumozhzRN/4tLdQZ5aRy46KOohMGgwqPIOROfrkJRG+Oyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=W4E4X6pQ;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C91606A33B
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 12:49:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42C91606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=W4E4X6pQ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3vAVNhvUyeYKpAU27GYNNvUdoFZg/CvbpdU6RE+GVF4=; b=W4E4X6pQ3qXWjaIDkHXHD7FugM
	RrbWxtaZcCdjdaiOSc7A0ZB7lpGo+0J+KDHhg7qMcb+OzqKKuzDGamt4C80JHsuc7RNzwnd32t50m
	tjqTtHN0ty89AZ51VjGx1uZ375xCA0wiT0OxEtZthbH6uq9MleGcAD1aipS4SxEZwG/igBHpKAvex
	mAkFAVjG1dShVftRKKUXlMb1v+dUIkijAoVsUsmD1y1+HSGKP1VnS9NXGok1L1p8uGVWQPV7ePdjp
	7iMBQwoaKRIHh+tTzumAgPQC0G9QGTce/13TrxMluMhqL1hYlvA7AfGioJBMmOxk/ZhNR+Uo148iJ
	16pOUQmw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xODxT-00000002Pua-39cL;
	Tue, 03 Nov 2026 12:49:47 +0000
Date: Tue, 3 Nov 2026 04:49:47 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Subject: [ANNOUNCE] xfs-linux: for-next is now 9dde020e1968
Message-ID: <aunYa5PKsKxzvquz@infradead.org>
References: <aumw9Gazayh1SxZh@nidhogg.toxiclabs.cc>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aumw9Gazayh1SxZh@nidhogg.toxiclabs.cc>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 03, 2026 at 11:09:24AM +0100, Carlos Maiolino wrote:
> Daejun Park (9):
>       [77d5d75d727a] xfs: mark the inode preallocated for pNFS write layouts past EOF
>       [e0fbfbec7d5b] xfs: add a flag to convert unwritten extents without allocating blocks
>       [faf5f20d6c00] xfs: refuse a pNFS LAYOUTCOMMIT of a range without blocks
>       [351fccff2881] xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end
>       [cefa7c7b065d] xfs: cap the block count of xfs_iomap_write_direct() at one extent
>       [e4211f8034ce] xfs: clamp the pNFS layout range to the maximum file size
>       [d58a23e183d5] xfs: take the invalidate lock while mapping a pNFS layout
>       [c92cc6514b9c] xfs: add datasync and log_flushed arguments to xfs_log_force_inode()
>       [c3b00a553cbb] xfs: make pNFS LAYOUTCOMMIT stable the way fdatasync does

While relatively large, these are fixes for nasty holes in the pNFS block
export.  Given that we're only at -rc1 right now I'd love to see them go
into the current merge window.

