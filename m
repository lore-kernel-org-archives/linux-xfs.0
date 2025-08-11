Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF012629D;
	Mon, 11 Aug 2025 10:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754909147; cv=none; b=OIjp9sbROvVrryNw0qvUX/mVe1R6NiBscvaFtrWfP13qmXJb/YLD5+o71dWftyIy1Ak+3dZv51tgvyNBMEtes4Hjwf/xM2cJ46LkNdgH/p7Y7RX9+4Stnbzw1NNRypJGOJAzeoCQhFQcDvC1bauswn4wG3S3bzpetFZmSac4utI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754909147; c=relaxed/simple;
	bh=4nHA3T9fvjVtq0dS64SVNrp9S2DvGOd2gUsj4jvqQRk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iRr8DEdw8c46I6F4Ka0RbGaDQPYMOLH43Mz3IgyM7fq6Xew0zQbXbOE5mwI08oMsqD+XhRYTsMb7TGvplJQC3kBkhKwqXtci0wVyYDLn/KUhmQ3FrUxeTBG3nlN6eRTjJIIZGzNOX3z3NAe8ZNO2u7QEbDgs8wMTwE3QlbBMTA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QgH17Knt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QgH17Knt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nFLH17RFn74iapUb2RPY44gZeWOKaqvuhhQ/tODaue0=; b=QgH17KntY5QfE7fzXJPvteJDh/
	y3EqZ2xTPiOc65bhO+b/+cApraqnNLO4tM6PvhX4tuIE0wec9av1M3zwFeH3pbsMz6WJ8dZT8RAef
	jmxTg0kQUyMzvTeqMM/VK25IKvtv3htg+p+PI3n8CdAPNYhDRiRSDpxqQ8ujVYEzkD34Je249WPO1
	c70jPgN9co4Iqsk3Xgw8s6eqLazhOszCNEOtQD++wgbc1yFHaiCL4v910s2va1vDaOnufHVRcdzPc
	pEoZYyuJKoYBG1Oo5afhOPBNE9XLe/o4mmruhqvRz5vzn0NF+8634J2pee1kPsxWbbp8iEKVlxe/U
	UaDhCs7g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ulQ2E-00000007NsL-0svf;
	Mon, 11 Aug 2025 10:45:46 +0000
Date: Mon, 11 Aug 2025 03:45:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: cen zhang <zzzccc427@gmail.com>
Cc: cem@kernel.org, linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
	zhenghaoran154@gmail.com, r33s3n6@gmail.com, gality365@gmail.com,
	linux-xfs@vger.kernel.org
Subject: Re: [BUG] xfs: Assertion failure in dio_write( flags &
 IOMAP_DIO_OVERWRITE_ONLY) with a UAF
Message-ID: <aJnJ2jnFdu9V-j1Z@infradead.org>
References: <CAFRLqsXrTagA7woSffBUUPUQ12VK1Ks292FT=miCv_NQktJY1A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFRLqsXrTagA7woSffBUUPUQ12VK1Ks292FT=miCv_NQktJY1A@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Aug 06, 2025 at 07:40:19PM +0800, cen zhang wrote:
> Hello maintainers,
> 
> I would like to report a kernel panic found using syzkaller on a 6.16.0-rc6.
> 
> The kernel log shows two distinct but closely timed crash reports,
> which I guess are related.
> 
> 1. An XFS assertion failure: Assertion failed: flags &
> IOMAP_DIO_OVERWRITE_ONLY, file: fs/xfs/xfs_file.c, line: 876 triggered
> by a write() system call in xfs_file_dio_write_unaligned.
> 
> 2. A KASAN use-after-free report on a task_struct object, triggered
> during an ioctl() call (likely FICLONE or FIDEDUPERANGE). The crash
> occurs in rwsem_down_write_slowpath when trying to lock an inode via
> xfs_reflink_remap_prep.
> 
> Unfortunately, I have not been able to create a standalone C
> reproducer, and attempts to use syzkaller's repro tool on the syz-prog
> have not reliably triggered the bug again.

Thanks for the report, but it will be really hard to do anything without
a reproducer.  I case you are still trying to create one it would be
great to hear if you have one!

