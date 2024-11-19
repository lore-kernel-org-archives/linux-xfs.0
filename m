Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CE11531DB
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 08:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732005426; cv=none; b=XriIRINykoQhb7FbS095zMkut/rUNjRKaJ7fkOpdM39iqHlkqpjC0ojDmb/4duLpPmIQO+D3z3tcOF4/x7Rk6M2Rse8uWDlsq8QXRBP5RPuf1hP5LP2BbvG3wY04oRUwkQry+VaCKNUwzqAuZ6Wr4X4MNtAVWkoEKwQIw6nTLCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732005426; c=relaxed/simple;
	bh=30Pk1noYoRWUgb7B23ae9iyWnXfqCV/9Eho3X4kAIO8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sxETGO+VRAYrmTL2ck5h9TqIPPJL4G6wlisIb+Ejv4yhGKtx746ZfezvS/7MY+ZP2DuO2DX5heP/imIzCU1OpOve6/dSuZXR8c3jV93IrotfJc2zNeB5OwHwdLiM3to6bAmO3h+ISgY3xGm4eiwC9N/OasXE+m9LFDQ1I0fMDwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XsyVt4HDcz21lLC;
	Tue, 19 Nov 2024 16:35:34 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 8A1B91401F0;
	Tue, 19 Nov 2024 16:36:55 +0800 (CST)
Received: from localhost (10.175.112.188) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 19 Nov
 2024 16:36:55 +0800
Date: Tue, 19 Nov 2024 16:35:22 +0800
From: Long Li <leo.lilong@huawei.com>
To: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>
CC: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>,
	<linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
	<yangerkun@huawei.com>
Subject: Re: [PATCH v2 1/2] iomap: fix zero padding data issue in concurrent
 append writes
Message-ID: <ZzxNygJUXTXd6H_w@localhost.localdomain>
References: <20241113091907.56937-1-leo.lilong@huawei.com>
 <ZzTQPdE5V155Soui@bfoster>
 <ZzrlO_jEz9WdBcAF@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <ZzrlO_jEz9WdBcAF@infradead.org>
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Sun, Nov 17, 2024 at 10:56:59PM -0800, Christoph Hellwig wrote:
> On Wed, Nov 13, 2024 at 11:13:49AM -0500, Brian Foster wrote:
> > >  static bool
> > >  iomap_ioend_can_merge(struct iomap_ioend *ioend, struct iomap_ioend *next)
> > >  {
> > > +	size_t size = iomap_ioend_extent_size(ioend);
> > > +
> > 
> > The function name is kind of misleading IMO because this may not
> > necessarily reflect "extent size." Maybe something like
> > _ioend_size_aligned() would be more accurate..?
> 
> Agreed.  What also would be useful is a comment describing the
> function and why io_size is not aligned.
> 

Ok, it will be changed in the next version.

> > 1. It kind of feels like a landmine in an area where block alignment is
> > typically expected. I wonder if a rename to something like io_bytes
> > would help at all with that.
> 
> Fine with me.
> 

While continuing to use io_size may introduce some ambiguity, this can
be adequately addressed through proper documentation. Furthermore,
retaining io_size would minimize code changes. I would like to
confirm whether renaming io_size to io_bytes is truly necessary in
this context.

Thanks,
Long Li
 
