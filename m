Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A094D371D02
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 02:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791773337; cv=none; b=AegT2w/XW9RoDUAvwh0/IORpYERByXqb0I7BeVVtnkDdIbprOu9b0wYbfROC5xH2zMStHKZEdUclwkrY7K++5lNuyfmNq3006Po9fGeA+ndVmYq4hYAP2NwSWN51mnpqTwnGJH+nVhAGwni8JZvCIlRSB4Q51BJkRT5GxURjvHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791773337; c=relaxed/simple;
	bh=bOclPLGaOOy4NIFoGZ28vUWSYwjULpaTmSRmMTf+/6M=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=b1xyMYAv+UR61iGX6JuxTx0Q0CgSgGboSfZ8K+DyyrRr1WRbGuw4UWKj6wrjl2o3WM0oJ4j84Y3LYgmiCyLMV9LG+oD8348CocpGB4gTug1dWcsnM9wWZFyG0WyhHOdshxxTBvH6WYSDXItU8Y8XGfajlb62WBj4ZzyGHwt+0nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=nqL98ZJe; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="nqL98ZJe"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261012024847epoutp04a95154678cc67ad01dae887d029cc8ed~dqFkuTB8y0882908829epoutp04p
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 02:48:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261012024847epoutp04a95154678cc67ad01dae887d029cc8ed~dqFkuTB8y0882908829epoutp04p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791773327;
	bh=bOclPLGaOOy4NIFoGZ28vUWSYwjULpaTmSRmMTf+/6M=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=nqL98ZJeNpbmxd/FBzuI6UbBy+OsMN6v6YAGPEoJ2lE76kV5sGcbAR0rydsBgY83v
	 WblSVIFqPPRy66KWHlZLl4W7xDwdkOTGseG6Gpsq8bde67C0h1eADEPKt99+U2x6zG
	 YI/lKRWwHy4eDq0cVqGtVQhMrSdMfXvNDv4Cl5nY=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261012024847epcas2p1b8090a0d968e8a44b247403a68ede00a~dqFkNl7IY2927229272epcas2p1R;
	Mon, 12 Oct 2026 02:48:47 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.211]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4j323L6757z3hhT8; Mon, 12 Oct
	2026 02:48:46 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE:(2) [PATCH 7/8] xfs: map the whole range of a pNFS layout in one
 ->map_blocks call
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: Chuck Lever <cel@kernel.org>
CC: Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Olga
	Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey
	<tom@talpey.com>, Christoph Hellwig <hch@lst.de>, Carlos Maiolino
	<cem@kernel.org>, Amir Goldstein <amir73il@gmail.com>, "Darrick J. Wong"
	<djwong@kernel.org>, Dave Chinner <dgc@kernel.org>, Sergey Bashirov
	<sergeybashirov@gmail.com>, Christian Brauner <brauner@kernel.org>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Daejun Park
	<daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <4de5356f-bc4d-4f1a-9c81-fce09b1b46fd@slotpi15m67>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261012024846epcms2p7cccc5c988b2553b3f831070eb17e0455@epcms2p7>
Date: Mon, 12 Oct 2026 11:48:46 +0900
X-CMS-MailID: 20261012024846epcms2p7cccc5c988b2553b3f831070eb17e0455
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261008163812epcas2p120bb86754876aa75cd744bd63258c465
References: <4de5356f-bc4d-4f1a-9c81-fce09b1b46fd@slotpi15m67>
	<20261008-xfs-nfsd-map-blocks-v1-0-560026cdccb6@samsung.com>
	<20261008-xfs-nfsd-map-blocks-v1-7-560026cdccb6@samsung.com>
	<CGME20261008163812epcas2p120bb86754876aa75cd744bd63258c465@epcms2p7>

On Thu, Oct 08, 2026 at 12:37:46PM -0400, Chuck Lever wrote:
> The same freeing can happen to blocks a client holds a write layout
> for, AFAICS. But that is not new. Commit 527851124d10 handed out the
> same blocks.
>
> This is however the patch where a fix could go.

Yes. xfs_fs_map_blocks() marks the inode XFS_DIFLAG_PREALLOC only when
it allocates, so a write layout past EOF over blocks that buffered
writes preallocated leaves the inode unmarked, and blockgc frees those
blocks while the client holds them.

With pynfs as the client on nfsd-testing: a file grown to 1 MiB by two
buffered writes on the server had 960 KiB preallocated past EOF, and an
RW LAYOUTGET for that range got it as one INVALID_DATA extent, without
the inode being marked. About 300 seconds later, with the default
speculative_prealloc_lifetime, blockgc freed the 960 KiB while the
layout was still held. Small files written on the server after that, and
after a sync so that the freed extents were no longer busy, got those
blocks, and the client's write through the layout replaced 978944 bytes
of their data. The LAYOUTCOMMIT then got NFS4ERR_IO, as
xfs_iomap_write_unwritten() allocated for the hole with no blocks
reserved, and XFS shut down with "Corruption of in-memory data (0x8)
detected at xfs_trans_mod_sb", in six runs out of six. Committing 30
seconds after the LAYOUTGET, before blockgc, works.

I would rather fix it on its own, before the series, so that it can go
to stable: mark the inode as preallocated also when a write mapping
ends past EOF and nothing was allocated. With that, the same test keeps
the blocks and the LAYOUTCOMMIT succeeds. I will send it to the XFS
list, and patch 7 of v2 will keep the check for the mappings of the
whole call.
