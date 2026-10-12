Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECAA31D362
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 02:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791773277; cv=none; b=fxTNSg5p2XcHpzd7IJch9+XAnf4gTxPJg45a5aiOFKJbHBq7LXHxGpfsRwHAcPId7/W6HoEsLqCLZi01tTLKfRMwo+WmEIsdsghQRe9N/rwE02hfvJWTPIXq0gdIlaxnNsXaUE0RzBwWTmKUSf22PoosfuV8TI6Y5TwAAEQml8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791773277; c=relaxed/simple;
	bh=WCphX4URgUH6Nmp4Rpz5K5t99v/wRhzMwEP/lZd5amc=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=BMX7lSu6yxiUKhqWDAtoY9etZEMUgzXjbLcx+frWhXl2cx5rub3w5kNSjumNjGphG3662E+fitlGCcN0GzUEGQ3gF4cMrpfuQqSFwJ3v+lxMelhAcB/OmMjiMcjoVQdcYvVpjT+Gj3EHQhAZXmcqoSGyVUiYA7NojaWNrxVPeZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=TT8ilfaZ; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="TT8ilfaZ"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261012024747epoutp03e54fab3356498c2a13e51664134365a6~dqEsiiD6_1228312283epoutp03h
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 02:47:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261012024747epoutp03e54fab3356498c2a13e51664134365a6~dqEsiiD6_1228312283epoutp03h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791773267;
	bh=WCphX4URgUH6Nmp4Rpz5K5t99v/wRhzMwEP/lZd5amc=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=TT8ilfaZdk98uAXq2mDogTumHPr9esemcPmc1WFgkdnqwK22+BDTVKN0mdOFq+8qu
	 ncFD4VivdgwIxyGzFH/nbJKKQSYszjP3ImAOCMkSsmuEeDZc96JMC84Qvj0adfpXrR
	 PkEivm1bT1syfQZf6+tSyHxBymE5+wXNXjUwMUAg=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261012024746epcas2p1b6c036d7b6eb460753e2a6c0928d5429~dqEr2hiFE0332403324epcas2p1A;
	Mon, 12 Oct 2026 02:47:46 +0000 (GMT)
Received: from epcas2p2.samsung.com (unknown [182.195.38.199]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4j322B2S5Lz3hhT7; Mon, 12 Oct
	2026 02:47:46 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE:(2) [PATCH 2/8] xfs: refuse a direct allocation whose block
 reservation would wrap
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai
	Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Christoph Hellwig
	<hch@lst.de>, Carlos Maiolino <cem@kernel.org>, Amir Goldstein
	<amir73il@gmail.com>, Dave Chinner <dgc@kernel.org>, Sergey Bashirov
	<sergeybashirov@gmail.com>, Christian Brauner <brauner@kernel.org>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>, Daejun Park
	<daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20261008154017.GO2705364@frogsfrogsfrogs>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261012024745epcms2p18c4fad2aa953cd80338e2e614198a6ea@epcms2p1>
Date: Mon, 12 Oct 2026 11:47:45 +0900
X-CMS-MailID: 20261012024745epcms2p18c4fad2aa953cd80338e2e614198a6ea
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261008154023epcas2p487b78abba35fdc6d75f9dd8d62a39837
References: <20261008154017.GO2705364@frogsfrogsfrogs>
	<20261008-xfs-nfsd-map-blocks-v1-0-560026cdccb6@samsung.com>
	<20261008-xfs-nfsd-map-blocks-v1-2-560026cdccb6@samsung.com>
	<CGME20261008154023epcas2p487b78abba35fdc6d75f9dd8d62a39837@epcms2p1>

On Thu, Oct 08, 2026 at 08:40:17AM -0700, Darrick J. Wong wrote:
> Uh... seeing as extent records can only map 2^21 blocks maximum and
> iomap/pnfs can handle xfs returning a mapping of whatever length we
> want, why don't we constrain count_fsb to XFS_BMBT_MAX_EXTLEN?

I tried that first. It stops the wrap, but it changes what an RW
LAYOUTGET for a range longer than the free space does. Today
xfs_iomap_write_direct() reserves the whole count, so such a request
fails with -ENOSPC before anything is allocated. With the count capped,
each ->map_blocks call allocates up to 2^21 blocks, and nfsd calls it
once per extent, so the request allocates until the filesystem is full
and then fails.

On a 32 GiB XFS with nfsd-testing at the time, an RW LAYOUTGET at offset
0 of an empty file for 16 TiB, or to the end of the file, got
NFS4ERR_NOSPC with the cap, and df showed 25 GiB in use afterwards
instead of 663 MiB. The blocks stay past EOF, as each call that
allocated marked the inode XFS_DIFLAG_PREALLOC. One for 100 GiB gets
NFS4ERR_NOSPC with nothing allocated, both without this patch and with
it.

The check in this patch only refuses a count whose reservation does not
fit in an unsigned int, so a count that fits is handled as before.
