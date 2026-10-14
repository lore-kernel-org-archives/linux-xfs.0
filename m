Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843EF2D8379
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 01:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791942061; cv=none; b=fQOvVlGAgyBml9ku/UB3Kf7Pf3IBy8v1j0KXHc8z3dlL09q0JGO4BxoP98BBgHgx+cdKE7z6CBURBGWtbxBIsbZfbfpoXU/wR8Z5Cir4aHwvRL3pPc+TKg9yMOsJzlA3E3vev5cDYpZcCYmsnOTNmAilaVmhBweyhyVU/UX24O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791942061; c=relaxed/simple;
	bh=+Gi6pkET5TN4Ax+sd3JWepZ5KzFh0sJWwvfq5VRU6TE=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=KcDxo80K3L0n+W39h2O0jTsA0ZYgov/Ti6ZYfj+Q0wZIhJW32colHUWlPCjzQS2vjxN4zgpZBhFS9GApLyZ7NL4qUiwUBHcYzxdBomxmT/O++KtUp7peP832q8PPXIjq0BoKuRTNODVDuHsSDyfyAl+obDCcSibV44jOO6S1NWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=JGhZ0fPz; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="JGhZ0fPz"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261014014057epoutp0462c9affb056fedc2994a68bc81109237~eQc6b5FO_2455424554epoutp04P
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 01:40:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261014014057epoutp0462c9affb056fedc2994a68bc81109237~eQc6b5FO_2455424554epoutp04P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791942057;
	bh=+Gi6pkET5TN4Ax+sd3JWepZ5KzFh0sJWwvfq5VRU6TE=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=JGhZ0fPzFPuvi3lkcBF/SrxySc35XZKXXRZWrK8drWUSio0EK95dFK2n8ihm62o+t
	 DBmD6Somd/ABemD/wSkFDgcma1fLhlm/oqn4w00TWs57S+qBmMrHBODJiA6Yow8eRO
	 CDHxi9+sXx0gb5P6RyCwng6uTaav6dehbOXDmmCY=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261014014056epcas2p1f5cf8e8a20853fe5b65850f64d83bca3~eQc6FQ9OY0786907869epcas2p1Y;
	Wed, 14 Oct 2026 01:40:56 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.207]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4j4DS84P5Qz6B9mT; Wed, 14 Oct
	2026 01:40:56 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE:(2) [PATCH] xfs: make pNFS LAYOUTCOMMIT stable the way fdatasync
 does
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
	<linux-kernel@vger.kernel.org>, Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20261013120846.GA4040@lst.de>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261014014056epcms2p5df940cfbe097b8cccce16080e482e422@epcms2p5>
Date: Wed, 14 Oct 2026 10:40:56 +0900
X-CMS-MailID: 20261014014056epcms2p5df940cfbe097b8cccce16080e482e422
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261013120853epcas2p4eaaf03a8d782645c9d336cc4a5300f3c
References: <20261013120846.GA4040@lst.de>
	<20261013-xfs-pnfs-commit-datasync-v1-1-2a12ef89ecd9@samsung.com>
	<CGME20261013120853epcas2p4eaaf03a8d782645c9d336cc4a5300f3c@epcms2p5>

On Tue, Oct 13, 2026 at 02:08:46PM +0200, Christoph Hellwig wrote:
> That feels like a bit of overkill, given that the shared code is
> just two function calls.

OK, no helper then.

> ... but maybe this helper should move to xfs_log.c and renamed to
> something like xfs_log_force_inode?

Makes sense now that it is used outside xfs_file.c. There already is an
xfs_log_force_inode() in xfs_inode.c, which is the !datasync case of
this one, so in v2 I'll move xfs_fsync_flush_log() next to it and make
xfs_log_force_inode() a wrapper around it.
