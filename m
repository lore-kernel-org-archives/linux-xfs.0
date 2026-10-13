Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6C5390613
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 01:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791855125; cv=none; b=jXtFPXe6P9lTlEV065pcK6myKWrxVcotxHtYF1XK/QriGJisgkQX0b3btdIamEIh2YhFGFh1vHZ1zDaRSBGIx3uYOmIpfisjLY9o0bLdS779UKSDc+amxhlO2evG2kYcu9XRvMMk9eDSIDdDf0yII0uGv6bPt6eM8W6pi4ZEWVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791855125; c=relaxed/simple;
	bh=idMX5yjXEYO7wOauDUhlwU9op3jmAaxp8ofbmmlqgfc=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=P4JCpihTBz6kpnlRo4EoTkxMtl4KjOrM+/lrJKuiHbxF1llNGL1Wj8B/4Qx8YAUC450nxjazDAwdaxmuMZq7e6/zcB385jQoaFT0wpLRNOdwm3kHyJzaqxZ3i/QUJODHJPZrAdyclNL5TpHirwR9YFq2LXfltfl4du573N4KVhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=FdihwLgr; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FdihwLgr"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261013013200epoutp013cd6d9ff3c4ba0f791de77cfa867898f~d8r0QhviE2892228922epoutp01R
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 01:32:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261013013200epoutp013cd6d9ff3c4ba0f791de77cfa867898f~d8r0QhviE2892228922epoutp01R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791855120;
	bh=b2wRoMcomqylst5Dp7BtwRuc75Xrdr2sGwl1cj2yqaI=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=FdihwLgrg5HH5PrTrTbPhFaUDaUYiuZKGgp2i2BAiHrPAtBXaeq5Ar7hVKbFQbqIF
	 IzIcIklHCCRVmsgB1CARzdxvjRgY4EDxFCWfaiMJ5T4h2ZFmrCunCNyWsITlQKmh1b
	 /JZ1EWYA5Y1xAtT0YQA0lO8+kTDPxWSXTCLDh3Rg=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261013013200epcas2p35f3cd7367bed795a25beeb1b587b3527~d8rzyKzwX1789417894epcas2p3D;
	Tue, 13 Oct 2026 01:32:00 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.211]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4j3cJH5n0tz6B9m9; Tue, 13 Oct
	2026 01:31:59 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE:(2) [PATCH] xfs: mark the inode preallocated for pNFS write
 layouts past EOF
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
In-Reply-To: <20261012124118.GB32488@lst.de>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261013013159epcms2p3fea98953ac15bf1c1505057e5cd2c5ba@epcms2p3>
Date: Tue, 13 Oct 2026 10:31:59 +0900
X-CMS-MailID: 20261013013159epcms2p3fea98953ac15bf1c1505057e5cd2c5ba
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261012124126epcas2p136e362cfd7a8ec3b16cca7d192565650
References: <20261012124118.GB32488@lst.de>
	<20261012-xfs-pnfs-eof-prealloc-v1-1-e4864d917a00@samsung.com>
	<CGME20261012124126epcas2p136e362cfd7a8ec3b16cca7d192565650@epcms2p3>

On Mon, Oct 12, 2026 at 02:41:18PM +0200, Christoph Hellwig wrote:
> > +		if (write && !(ip->i_diflags & XFS_DIFLAG_PREALLOC) &&
> > +		    imap.br_startoff + imap.br_blockcount >
> > +		    XFS_B_TO_FSB(mp, XFS_ISIZE(ip))) {
> > +			error = xfs_fs_map_update_inode(ip);
> > +			if (!error)
> > +				error = xfs_log_force_inode(ip);
> > +			if (error)
> > +				goto out_unlock;
> > +		}
>
> Let's avoid the code duplication here.  Add a boolean flag that
> we need the update, set it both for the new allocation in the if
> le, and based on the condition here, and then do the update
> in a separate conditional below.
>
> And mayne the xfs_log_force_inode should move into
> xfs_fs_map_update_inode while we're at it.

Will do both in v2. xfs_fs_map_blocks() sets a flag for the allocation
and for a write mapping that ends past EOF over blocks that are already
there, and calls xfs_fs_map_update_inode() once after the if/else.
xfs_fs_map_update_inode() forces the log after committing the
transaction, so the separate xfs_log_force_inode() calls go away.

The behaviour does not change: the update still happens under the
IOLOCK, before the blocks are handed out. On nfsd-testing with the same
reproducer, the inode is marked at LAYOUTGET, blockgc keeps the blocks,
and the LAYOUTCOMMIT after 360 seconds succeeds with the data in place,
as with v1.

I will wait a few days for other comments on v1 and then send v2.
