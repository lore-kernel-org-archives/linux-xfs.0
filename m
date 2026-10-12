Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A157938F92D
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 02:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791773382; cv=none; b=kHTcXZO0JVQiaO8ccxpJYGmotwT3seFZUZ31w8Ek4Jg1GYq+70/0bthwc5Q/WNe/nmBjA+v8E1M7kLw63sCiUtT58om/DzCRR8XawvoRefyOZaOu66K3zdgSJHD344mzo8oVYukCoF0+CV7geJgWWbc/OPOD3Zv7uLKaT0psKyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791773382; c=relaxed/simple;
	bh=8qIQmo2moCtbsf4JcTMPVVM9X8Oig9a3PSVBu/cxhlw=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=EX6U1+WHFP4u73ebXGcebQYmQPo/Mjm1+UopW8fiJuSzhSDiC6GsF3Q8f3G3lrd8a71GoE5XgNaZzwvTI1jWZDjDlIA4WLBrKNwVqGenKX5xTKRkkp4/YZD76zsQXzzLgLbAycG+EB9/QKQrTrHo8s5UGJJhsYpkIF2x/Qpd39c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=OMeJnrko; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="OMeJnrko"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261012024938epoutp01113f24971588706f3de0d3514e7d8164~dqGT97I7x2856328563epoutp01U
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 02:49:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261012024938epoutp01113f24971588706f3de0d3514e7d8164~dqGT97I7x2856328563epoutp01U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791773378;
	bh=8qIQmo2moCtbsf4JcTMPVVM9X8Oig9a3PSVBu/cxhlw=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=OMeJnrkoTqWN/b4/4ogi2FWIyZWzBFURYUSFr36sDstQnqjXOAMzBP9QRbhjRsCXs
	 HjfH4fFtNnpQJ/PudQ09Wd36qrBwUl/dY5uWX5yYJtFuFDO5WkzILoLIuJm00TdePl
	 WuQarO1UKDbggfFYkwQ3amZT6YE1kajyXBUErLZY=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20261012024937epcas2p4844d696dd609c08ea09700314f6e8868~dqGTTPZw51129011290epcas2p41;
	Mon, 12 Oct 2026 02:49:37 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.199]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4j324K33LRz6B9mC; Mon, 12 Oct
	2026 02:49:37 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE:(2) [PATCH 8/8] nfsd: get all extents of a block layout in one
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
In-Reply-To: <235ae19b-fd63-4d01-9fe0-d047a33b55ed@slotpi15m67>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261012024936epcms2p167798df55a23e5505a4c2f9d8b71f452@epcms2p1>
Date: Mon, 12 Oct 2026 11:49:36 +0900
X-CMS-MailID: 20261012024936epcms2p167798df55a23e5505a4c2f9d8b71f452
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261008164459epcas2p313b027cb2807a94a05edb388633152ed
References: <235ae19b-fd63-4d01-9fe0-d047a33b55ed@slotpi15m67>
	<20261008-xfs-nfsd-map-blocks-v1-0-560026cdccb6@samsung.com>
	<20261008-xfs-nfsd-map-blocks-v1-8-560026cdccb6@samsung.com>
	<CGME20261008164459epcas2p313b027cb2807a94a05edb388633152ed@epcms2p1>

On Thu, Oct 08, 2026 at 12:44:33PM -0400, Chuck Lever wrote:
> nr_extents_max is bounded by PAGE_SIZE so that the per-request buffer
> stays small. But a struct iomap is nearly twice the size of an encoded
> extent, so this array is nearly twice the layout buffer it sits next
> to. On 64 KiB pages that is well over 100 KiB of physically contiguous
> memory per LAYOUTGET. A failure here turns into NFS4ERR_DELAY for
> every request under fragmentation.
>
> Using kvmalloc_array() would cover the large case, or you could cap
> nr_extents_max independently of PAGE_SIZE.

I will use kvmalloc_array() in v2.

> Passing write only when loga_minlength is non-zero, and having
> nfsd4_block_iomap_to_extent() refuse IOMAP_HOLE for IOMODE_RW the way
> it already refuses IOMAP_UNWRITTEN, gives the client the same answer
> without allocating anything. Admittedly this is a pre-existing
> issue -- perhaps a pre-requisite fix for this series is best, so
> that the fix can be backported to LTS.

Agreed, I will post it against nfsd-testing as a separate patch. It goes
back to commit 8c3ad9cb7343 ("nfsd/blocklayout: accept any minlength"),
which removed the check that refused a minlength below the block size.
With pynfs as the client on nfsd-testing, an RW LAYOUTGET for 0+1 MiB
with a minlength of zero on an empty file got NFS4ERR_LAYOUTUNAVAILABLE
and left 1 MiB allocated. With the change you describe it gets the same
error and nothing is allocated, and one for 64 KiB of written data is
still granted as READ_WRITE_DATA. v2 of this patch will take the same
change.

> A note about process: the series touches XFS and exportfs. It will
> need to go through the VFS tree, I think, and might conflict with
> what's already in nfsd-testing.

Patch 1 is now in xfs for-next (e3c682dd1130), and patch 8 builds on
170b788af22d in nfsd-testing, so patches 4 to 8 depend on both trees.
I will post them again after the merge window, rebased on -rc1, for the
VFS tree. Patches 2 and 3 are XFS fixes on their own and apply to xfs
for-next as they are, so they can go through the XFS tree before that
if Carlos wants them.
