Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E393C149DF3
	for <linux-xfs@vger.kernel.org>; Wed,  7 Feb 2024 22:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707344815; cv=none; b=Z0mZOh7qRvmycVmVilqTN8i5sCja0KSZ7g/I1GX70S+TRjoYWj70wfKpD+CAtGhMZiCO7Us9qRz2PSLJmtjYsWHwAY83kemnRoKcWzh5rucsSh7ir0NsfMTgao+rkOoGh6QMvj/lBtFgPhsZRZGjstq6c4bNBOkyZlnMH7fltcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707344815; c=relaxed/simple;
	bh=DJfMYmk4RCee/atIZdEaDRA90qmWWLLIBBagTwi3uFI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Tqwei6HKspAohqHIVU0xFhPOgJ1AmlK+LipcGYnNMDYX+XfJa3uMv0G9mqYxdQ3QDJPvKwQEuBKJF7wcvBUUhruQCBfeVc2JRM2WzU9DapJ7oJ32lXWowsbR1DJkOTw5RRLXzt9wMEYTWn12sCel/DoIpqIyt2d1WHsWeQbbQ+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LUWNYCpu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LUWNYCpu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=f7dHylytnSa+g7wMWpB0zRBZqa/4rr5lWYmQKUgKkQA=; b=LUWNYCpuOk8/RgBck4IiUcH0NM
	1QYQcIDVl49rWucDSIyspyerkE8DYhCjy7D8Gi6cbzZHYvHf/Em3N3bJv6fSrDK4UWcsEhcjqLGgl
	ZnAoBkwpfzRPiRNDND0Mqwbq+veEElq/SBcQxvX1klbbRVT8sIKc8s9UZGp5QLSkB5dyRZT3O24xa
	U02nA/2hsa/3qJSJu/Vn55orvBn7yFh/56dzqAA6YFNcgm4cHQsqLhcj6E1s7eaH/xSHjjKlvknG3
	g7uWZh1Xaen5zm9c30Xgbuwh0p4F6hBxx7yqp/SzIhlCs3RsykyxmLTX+ZDgttz/v3RSX9PSqurQe
	fGanxdfA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rXqNZ-0000000C6ft-0Bkj;
	Wed, 07 Feb 2024 22:26:53 +0000
Date: Wed, 7 Feb 2024 14:26:53 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Luis Chamberlain <mcgrof@kernel.org>, ritesh.list@gmail.com,
	Pankaj Raghav <p.raghav@samsung.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: Max theoretical XFS filesystem size in review
Message-ID: <ZcQDrXwyKxfTYpfL@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Luis Chamberlain <mcgrof@infradead.org>

I'd like to review the max theoretical XFS filesystem size and
if block size used may affect this. At first I thought that the limit which
seems to be documented on a few pages online of 16 EiB might reflect the
current limitations [0], however I suspect its an artifact of both
BLKGETSIZE64 limitation. There might be others so I welcome your feedback
on other things as well.

As I see it the max filesystem size should be an artifact of:

max_num_ags * max_ag_blocks * block_size

Does that seem right?

This is because the allocation group stores max number of addressable
blocks in an allocation group, and this is in block of block size.  If
we consider the max possible value for max_num_ags in light of the max
number of addressable blocks which Linux can support, this is capped at
the limit of blkdev_ioctl() BLKGETSIZE64, which gives us a 64-bit
integer, so (2^64)-1, we do -1 as we start counting the first block at
block 0.  That's 16 EiB (Exbibytes) and so we're capped at that in Linux
regardless of filesystem.

Is that right?

If we didn't have that limitation though, let's consider what else would
be our cap.

max_num_ags depends on the actual max value possibly reported by the
device divided by the maximum size of an AG in bytes. We have
XFS_AG_MAX_BYTES which represents the maximum size of an AG in bytes.
This is defined statically always as (longlong)BBSIZE << 31 and since
BBSIZE is 9 this is about 1 TiB. So we cap one AG to have max 1 TiB.
To get max_num_ags we divide the total capacity of the drive by
this 1 TiB, so in Linux effectively today that max value should be
18,874,368.

Is that right?

Although we're probably far from needing a single storage addressable
array needing more than 16 EiB for a single XFS filesystem, if the above was
correct I was curious if anyone has more details about the caked in limit
of 1 TiB limit per AG.

Datatype wise though max_num_ags is the agcount in the superblock, we have
xfs_agnumber_t sb_agcount and the xfs_agnumber_t is a uint32_t, so in theory
we should be able to get this to 2^32 if we were OK to squeeze more data into
one AG. And then the number of blocks in the ag is agf_length, another
32-bit value. With 4 KiB block size that's 65536 EiB, and on 16 KiB
block size that's 262,144 Exbibytes (EiB) and so on.

[0] https://access.redhat.com/solutions/1532

  Luis

