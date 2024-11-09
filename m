Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDA73B192
	for <linux-xfs@vger.kernel.org>; Sat,  9 Nov 2024 07:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731136498; cv=none; b=anTliM4QedhpynT6txX+ZN3epFqYN28Q6RZZOzf2oC/5ytuyBF+GEyfZsrlDMCOaGt3JDuV6wEgU8ZELBqJvJfULR/Mtl31eAIfhWQ99HyR0au160GLv67LCQaZJ5mhQMMwXbEDoNeWExnQoG7jLc/CtPCeh51sP1/yeywmsT3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731136498; c=relaxed/simple;
	bh=5pSJi/m32ee47RxnG/QbaP/XI/gjf9dsCj57K52Yr3A=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BMufR9NdEfqxv27E+uQYUoU3FKaCPFYY9OyjRhrGWFmb1Xe414DfWf4aS1c2LZZ1u384Mz2AKEw4k4tMq6YEVIG0laxvAAv405YHAS/Q+sPEZfiQNf2yOyoYhX/ZJJLXVURjPoQlnr5b6XxuP82tni/xtor9gYA2GvwbZAMxSg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Xln8N3bmLz2Fb42;
	Sat,  9 Nov 2024 15:13:08 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 3B47A1A016C;
	Sat,  9 Nov 2024 15:14:53 +0800 (CST)
Received: from localhost (10.175.112.188) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 9 Nov
 2024 15:14:52 +0800
Date: Sat, 9 Nov 2024 15:13:53 +0800
From: Long Li <leo.lilong@huawei.com>
To: Christoph Hellwig <hch@infradead.org>
CC: <djwong@kernel.org>, <cem@kernel.org>, <brauner@kernel.org>,
	<linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <yangerkun@huawei.com>, <lonuxli.64@gmail.com>
Subject: Re: [PATCH] iomap: fix zero padding data issue in concurrent append
 writes
Message-ID: <Zy8Lsee7EDodz5Xk@localhost.localdomain>
References: <20241108122738.2617669-1-leo.lilong@huawei.com>
 <Zy4mW6r3rjMEsNir@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Zy4mW6r3rjMEsNir@infradead.org>
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Fri, Nov 08, 2024 at 06:55:23AM -0800, Christoph Hellwig wrote:
> On Fri, Nov 08, 2024 at 08:27:38PM +0800, Long Li wrote:
> > After reboot, file has zero padding in range [A+B, A+B+C]:
> > 
> >   |<         Block Size (BS)      >|
> >   |DDDDDDDDDDDDDDDD0000000000000000|
> >   ^               ^        ^
> >   A              A+B      A+B+C (EOF)
> > 
> >   D = Valid Data
> >   0 = Zero Padding
> > 
> > The issue stems from disk size being set to min(io_offset + io_size,
> > inode->i_size) at I/O completion. Since io_offset+io_size is block
> > size granularity, it may exceed the actual valid file data size. In
> > the case of concurrent append writes, inode->i_size may be larger
> > than the actual range of valid file data written to disk, leading to
> > inaccurate disk size updates.
> 
> Oh, interesting one.  Do you have a reproducer we could wire up
> to xfstests?
> 

Yes, I have a simple reproducer, but it would require significant
work to incorporate it into xfstestis.

> > This patch introduce ioend->io_end to trace the end position of the
> > valid data in ioend, rather than solely relying on ioend->io_size.
> > It ensures more precise disk size updates and avoids the zero padding
> > issue. Another benefit is that it makes the xfs_ioend_is_append()
> > check more accurate, which can reduce unnecessary end bio callbacks
> > of xfs_end_bio() in certain scenarios, such as repeated writes at the
> > file tail without extending the file size.
> 
> Hmm.  Can we do away with two members for the size by just rounding
> up the block size for the block based operations?
> 

If we only use one size record, we can remove io_size and keep only
io_end to record the tail end of valid file data in ioend. Meanwhile,
we can add a wrapper function iomep_ioend_iosize() to get the extent
size of ioend, replacing the existing ioend->io_size. Would this work?

Thanks,
Long Li
