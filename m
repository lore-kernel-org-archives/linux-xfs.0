Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB40C42B31A
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 13:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783948916; cv=none; b=jdqJa3x20v5r4+klNuHAZK9tddpK27vnHRdTvnpwLUAHN0i+mCsx1bONB5IWEsQGuyRcTytGRQZHn2kDHwgcdrbfzn7wpbFwTspuaW1xmUMY5/BAKBiMfjnRlSKk5DyMJmuFAvY/IskmGdAD/7w5ihNK5muqOXSk2KFL15SssDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783948916; c=relaxed/simple;
	bh=Y00l/aSmPOJBHXtT2VBY6pzYYLDYF4f40DvYsjUxc28=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H+phrbwKGWKSycpallFI964njT5ojCTrM99hNrbRjHnvQjc8s/deCK8QoUsgyEiJig0b7EAuA9FdWRABe685CWIc6MJ8lajTsSdsT/lpzkzwyD0EQtayc9hZ+PDkbgtRAwzlyjGrNaFGd1duoK2N1iLhrSZBwGiAE2L6CAhe0Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Cov13TH/; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Cov13TH/"
Message-ID: <db3ed600-8a4a-4932-9e4e-2f5a5d27cdd9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783948903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FbcdiqhBJyEUTJK4S+yiy3XNkF/rw3bRMaKqh1gl8bc=;
	b=Cov13TH/mP0LQyWsxmG9YTHikhR72V4sUNZvXvGhgKIareSiwn1d9oP2yjuoAqBEyrFOov
	ug9ZU7Bj99oKW48EXUC2NTAV/tnxonGMYfJf5NTl6Ppijqjecq62wFeDeQG8jKkRUWm7ZK
	Hu8aL9Vd8CapV94IgiiWvkDUX28Yg/Q=
Date: Mon, 13 Jul 2026 15:21:36 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2] generic/795: add unaligned boundary test cases for
 WRITE_ZEROES
To: Christoph Hellwig <hch@lst.de>, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>, zlang@kernel.org,
 linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org,
 yi.zhang@huawei.com, Ext4 Developers List <linux-ext4@vger.kernel.org>
References: <20260709083048.3849610-1-p.raghav@samsung.com>
 <1adabe60-17d5-49ff-a6e6-33f90debf6fe@huaweicloud.com>
 <20260713100414.GA11013@lst.de>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <20260713100414.GA11013@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


>> Unfortunately, I've found a bug in filefrag that causes delalloc extents
>> to be reported with a length of 0. This means this test case can miss
>> delalloc extents. The issue is in misc/filefrag.c's print_extent_info(),
>> where ext_len is incorrectly set to 0 for the FIEMAP_EXTENT_UNKNOWN or
>> EXT4_FIEMAP_EXTENT_HOLE cases. Could you please send a patch to fix this
>> as well?
> 
> We can't really rely on having a bleeding edge filefrag for xfstests
> (well, at least without a feature check for it, but even that
> would not a good usability story).  I guess at least for now
> we might have to add  a little tool that just calls FIEMAP for
> us to xfstests?
> 

What about adding an option to io/filemap.c to take a flag that allows calling
fiemap without FIEMAP_FLAG_SYNC? So this test could depend on xfs_io fiemap command
with the flag support enabled? I can revert this test to the previous version which uses
xfs io fiemap instead of filefrag.

--
Pankaj
