Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CE01F602
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 13:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732024101; cv=none; b=cuO06VZc67/tgnfD9OHCkeDzqrEtsDeb8nkk+UFJdkACMXjef2y7SYVaRX9D3yRg0UQEerbHzdDP+G+xdu4qQ1ICmrVAUhjQQJMfBv9QKeY90AD4YAhyaAKudb5qbZ4xwpSormOylfN8Sf6RlWxSDKd8NIbAszCeoCUsWd7Q0Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732024101; c=relaxed/simple;
	bh=lOSNZf203EB615E0NbWb5NJAIfZnHGKBa9bUjy2KXYI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OrbW6/YgvrLVN7VbXRovm7/0vKFH9Mr74zcVTPcLNZYT7l98t4zPzMqL5R+cJmubUH2n/vIjQ4SSnW/3bx/R5Qx4gV1CNJBAJV7LrgSrgMVt2YcEp+QJ2zLrldS6lduJgtEvNT1AxrZeZnUbhQcG0o+8Mf9DknuQrItyH22vGa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Xt5NX5YTkz92D6;
	Tue, 19 Nov 2024 21:45:32 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id BD65B1400DC;
	Tue, 19 Nov 2024 21:48:15 +0800 (CST)
Received: from localhost (10.175.112.188) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 19 Nov
 2024 21:48:15 +0800
Date: Tue, 19 Nov 2024 21:46:41 +0800
From: Long Li <leo.lilong@huawei.com>
To: Brian Foster <bfoster@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>, <brauner@kernel.org>,
	<djwong@kernel.org>, <cem@kernel.org>, <linux-xfs@vger.kernel.org>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>
Subject: Re: [PATCH v2 1/2] iomap: fix zero padding data issue in concurrent
 append writes
Message-ID: <ZzyWwczHS-57q_w2@localhost.localdomain>
References: <20241113091907.56937-1-leo.lilong@huawei.com>
 <ZzTQPdE5V155Soui@bfoster>
 <ZzrlO_jEz9WdBcAF@infradead.org>
 <ZzxNygJUXTXd6H_w@localhost.localdomain>
 <ZzyBB3gKU3kBkZdQ@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <ZzyBB3gKU3kBkZdQ@bfoster>
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Tue, Nov 19, 2024 at 07:13:59AM -0500, Brian Foster wrote:
> On Tue, Nov 19, 2024 at 04:35:22PM +0800, Long Li wrote:
> > On Sun, Nov 17, 2024 at 10:56:59PM -0800, Christoph Hellwig wrote:
> > > On Wed, Nov 13, 2024 at 11:13:49AM -0500, Brian Foster wrote:
> > > > >  static bool
> > > > >  iomap_ioend_can_merge(struct iomap_ioend *ioend, struct iomap_ioend *next)
> > > > >  {
> > > > > +	size_t size = iomap_ioend_extent_size(ioend);
> > > > > +
> > > > 
> > > > The function name is kind of misleading IMO because this may not
> > > > necessarily reflect "extent size." Maybe something like
> > > > _ioend_size_aligned() would be more accurate..?
> > > 
> > > Agreed.  What also would be useful is a comment describing the
> > > function and why io_size is not aligned.
> > > 
> > 
> > Ok, it will be changed in the next version.
> > 
> > > > 1. It kind of feels like a landmine in an area where block alignment is
> > > > typically expected. I wonder if a rename to something like io_bytes
> > > > would help at all with that.
> > > 
> > > Fine with me.
> > > 
> > 
> > While continuing to use io_size may introduce some ambiguity, this can
> > be adequately addressed through proper documentation. Furthermore,
> > retaining io_size would minimize code changes. I would like to
> > confirm whether renaming io_size to io_bytes is truly necessary in
> > this context.
> > 
> 
> I don't think a rename is a requirement. It was just an idea to
> consider.
> 

ok.

> The whole rounding thing is the one lingering thing for me. In my mind
> it's not worth the complexity of having a special wrapper like this if
> we don't have at least one example where it provides tangible
> performance benefit. It kind of sounds like we're fishing around for
> examples where it would allow an ioend to merge, but so far don't have
> anything that reproduces perf. value. Do you agree with that assessment?
> 

Yes, I agree with your assessment. The merging through size rounding
actually occurs in only a small number of cases.

> That said, I agree we have a couple examples where it is technically
> functional, it does preserve existing logic, and it's not the biggest
> deal in general. So if we really want to keep it, perhaps a reasonable
> compromise might be to lift it as a static into buffered-io.c (so it's
> not exposed to new users via the header, at least for now) and add a
> nice comment above it to explain when/why the io_size is inferred via
> rounding and that it's specifically for ioend grow/merge management. Hm?
> 

I agree with you, this approach sounds reasonable to me.

Thanks,
Long Li

