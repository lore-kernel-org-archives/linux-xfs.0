Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F85A26ED39;
	Wed, 10 Dec 2025 11:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765365695; cv=none; b=BqyiHXfeq3XHkHPyFk0FeKb3EJH2RKuQjdU6FTHMo7eP3o+XUQRA5izkUfHFjyArDTFETI1r6f6SZNdt0HjgCl7FTCPmplG/+ffDrktyp+8FZKc9J/lNu1UlGpXhQBjIFZbjo5KTt687qdw0ATXFdoTzPdB5Pn75sM9PkIBCCAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765365695; c=relaxed/simple;
	bh=02TJf16fnJk3ighp6vgdi/0FMeoZ8SlIQNCacUajNgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=INJwcAiREKlH5qQ2+rJwp9RIZ2zujPz57T8p27Zl1JuL3oGIg0JCNmxpYAXywci9pQcm1nF9+bytgxz0A9V4YNahaQmIkj2jnvlg6KO7IijoyRPvfCL1H/ZQuGj2nN8DjeeTQnumisuSp8pJ3LkwJKYRRYFg5y0Lsg9statIm4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qVwGVVZp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qVwGVVZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538DBC4CEF1;
	Wed, 10 Dec 2025 11:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765365695;
	bh=02TJf16fnJk3ighp6vgdi/0FMeoZ8SlIQNCacUajNgU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qVwGVVZpPeY58SfN5rAE+y4vep7KmrLCjyhECcDA/28CraNn3LqLDFaAtH5r2cPhV
	 VY8i0KcS02ZfXJGzmXCxFKclwNhiZbedhrtb7GeLcF8KmNAbbIL7Z+tsTfNs2xF/hm
	 gcTOb4e85Q7y6gl7wJjXOrd2QLggNdZ670UirSSgeBNfkMfbYWmkxTJV4/BuP4upOp
	 drToIyNGT4CAiuR3mGqXiSsvqESoeHtNNeTD8DiuTUEwJgBGfKfuKiOAqxwE7wK9Q/
	 nzNrN9kg2CoFgi4OFX5nwkkyJwdVd3CxxC66L9dxKsDKAPuialzI83fK7Lkh8M8L3d
	 xgGkj+6BO8qWQ==
Date: Wed, 10 Dec 2025 20:21:30 +0900
From: Keith Busch <kbusch@kernel.org>
To: Sebastian Ott <sebott@redhat.com>
Cc: linux-nvme@lists.infradead.org, iommu@lists.linux.dev,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Jens Axboe <axboe@fb.com>,
	Christoph Hellwig <hch@lst.de>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: WARNING: drivers/iommu/io-pgtable-arm.c:639
Message-ID: <aTlXuhmsil7YFKTR@kbusch-mbp>
References: <170120f7-dd2c-4d2a-d6fc-ac4c82afefd7@redhat.com>
 <aTj-8-_tHHY7q5C0@kbusch-mbp>
 <acb053b0-fc08-91c6-c166-eebf26b5987e@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acb053b0-fc08-91c6-c166-eebf26b5987e@redhat.com>

On Wed, Dec 10, 2025 at 12:08:36PM +0100, Sebastian Ott wrote:
> On Wed, 10 Dec 2025, Keith Busch wrote:
> > On Tue, Dec 09, 2025 at 12:43:31PM +0100, Sebastian Ott wrote:
> > > got the following warning after a kernel update on Thurstday, leading to a
> > > panic and fs corruption. I didn't capture the first warning but I'm pretty
> > > sure it was the same. It's reproducible but I didn't bisect since it
> > > borked my fs. The only hint I can give is that v6.18 worked. Is this a
> > > known issue? Anything I should try?
> > 
> > Could you check if your nvme device supports SGLs? There are some new
> > features in 6.19 that would allow merging IO that wouldn't have happened
> > before. You can check from command line:
> > 
> >  # nvme id-ctrl /dev/nvme0 | grep sgl
> 
> # nvme id-ctrl /dev/nvme0n1 | grep sgl
> sgls      : 0xf0002

Oh neat, so you *do* support SGL. Not that it was required as arm64
can support iommu granularities larger than the NVMe PRP unit, so the
bug was possible to hit in either case for you (assuming the smmu was
configured with 64k io page size).

Anyway, thanks for the report, and sorry for the fs trouble the bug
caused you. I'm working on a blktest to specifically target this
condition so we don't regress again. I just need to make sure to run it
on a system with iommu enabled (usually it's off on my test machine).
