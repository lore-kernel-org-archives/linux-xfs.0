Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69682F6918
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 01:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791942022; cv=none; b=n0+FPFLkPvwcfZ6MZTCac5qzQv05dWP7AZctszVHRVi1hJ+4AXxAB5J7vbUes7lGaD77IfNfdxjgIamotm+gHYGZ171pr+UCwByWyosegJ3xdS1L7JTqkfnevmcDID/NfGa+HoWHYzIevZMBGDZwyYkpmSl6tIYwQo7DG5YU71M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791942022; c=relaxed/simple;
	bh=YoN78TWBlmpx0A6DZIRcttrESlXSOSTvIOjKF9tTnoE=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=h2l2FMsWYv8U2EiYcE/b/RxkUQGs2Q3oOeeIohy3k6pSyjO5nNO0U16X+gr8r7Q7oCB6i5FPDdd/eNi+/a7mwBmbggfg93oJ4E/2RBebTgx/TdLXOaWdF6Mn8MDzYuFf8OemGAe/KGa0PHTZJwcMRaQi2DwKN6xWuCr2gqd9af4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=iBiXfFju; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="iBiXfFju"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261014014018epoutp0254d3770565d6164b007c25362e819e45~eQcWas2Br1347013470epoutp026
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 01:40:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261014014018epoutp0254d3770565d6164b007c25362e819e45~eQcWas2Br1347013470epoutp026
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791942018;
	bh=1d+d0jVHgB0EadQMkTGvrSCW+JV5YjB/dJMefH+YkxU=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=iBiXfFjuvp/91UceZp/C0Ow1sIBAEGzLqydF9emm/GvnYF2JeNMEywCjIomPbgqE8
	 kc3gZ8THLPH17D/01CW1kccTR5PFyF7pGBWSTdk88Uy8DzpxAyrGw7ncCXySaFKLK8
	 BCKlUdb4DUSqhknqrg5/2+GQ2hLKmHwA8AmiMIGQ=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20261014014017epcas2p24aaeaae47c415e988a530ec528956580~eQcVs79Zi3261832618epcas2p2D;
	Wed, 14 Oct 2026 01:40:17 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.211]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4j4DRP4mnxz3hhT4; Wed, 14 Oct
	2026 01:40:17 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE:(2) [PATCH] xfs: refuse a pNFS LAYOUTCOMMIT of a range without
 blocks
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: Christoph Hellwig <hch@lst.de>
CC: Carlos Maiolino <cem@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Dave
	Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>, Jeff Layton
	<jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>, Sergey Bashirov
	<sergeybashirov@gmail.com>, "linux-nfs@vger.kernel.org"
	<linux-nfs@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20261013120359.GB2944@lst.de>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261014014017epcms2p7ab0ff4f1356d695c55514bd7ccaebadf@epcms2p7>
Date: Wed, 14 Oct 2026 10:40:17 +0900
X-CMS-MailID: 20261014014017epcms2p7ab0ff4f1356d695c55514bd7ccaebadf
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261013120408epcas2p19974f8ffd4afa0b0cc5a4f19e9218004
References: <20261013120359.GB2944@lst.de>
	<20261013-xfs-pnfs-commit-hole-v1-1-740912db9102@samsung.com>
	<CGME20261013120408epcas2p19974f8ffd4afa0b0cc5a4f19e9218004@epcms2p7>

On Tue, Oct 13, 2026 at 02:03:59PM +0200, Christoph Hellwig wrote:
> blockgc really should not free them due to the prealloc inode flag.
> Do you still see that with your prefix flag setting fix?  If so we
> have a deeper problem.

I don't see it with "xfs: mark the inode preallocated for pNFS write
layouts past EOF" applied: in the same test, blockgc keeps the blocks
and the LAYOUTCOMMIT succeeds with the client's data in place. The
sentence was about trees without that patch, so I'll drop it in v2 and
keep the reclaim case and the range that was never laid out.

> It would be great to get these included in pynfs.
>
> Also a little doc on your setup to run pynfs in client mode against
> nfsd with block/scsilayout would probably useful.

Sure, I'll send them to pynfs with a short README section on the setup,
on top of the block layout test I posted earlier:
https://lore.kernel.org/r/20261006002622epcms2p38e492aef17fdf79e48b05c9aada2918d@epcms2p3

> As soon as we drop the lock, the result might be stale.  So I suspect
> we want a CONVERT_ONLY flag to xfs_bmapi_write that makes it refuse
> to allocate blocks instead in one atomic operation.

The IOLOCK held across both keeps truncate, fallocate and blockgc out
today, but the flag doesn't depend on that, so v2 does it that way:
xfs_bmapi_write() takes a new XFS_BMAPI_CONVERT_ONLY flag that fails for
a hole or a delalloc extent instead of allocating, and
xfs_fs_commit_blocks() passes it through xfs_iomap_write_unwritten().

One difference from v1: a LAYOUTCOMMIT with a laid-out range followed by
a hole now converts the laid-out range before it fails.
xfs_fs_commit_blocks() already left earlier extents converted when a
later one failed, and the Linux client resends all of its extents after
a failed LAYOUTCOMMIT, so I don't think that matters.
