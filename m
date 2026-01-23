Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E663524E4A1
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 12:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769170493; cv=none; b=e0b3YZyZUcNk0dxA9YLKs3d/xyN4wP34FG1FpRKAmA+t5mBMuboDgsb38cJhsEwWkQds/nmQBlobumPY/zPoaaacubhf5mG0C1nQQywWnzkczcHd94ayA0LMhu7i5yhCcwdNQIlHcWfXsFqe4sMWazSOPMlSNgXN0c/MVYon5tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769170493; c=relaxed/simple;
	bh=7Fge6Fmkgld7YLUrywNY+EJQXw+yVu+zB01EPx2KCOE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=eqlEoKuaALuU31q7d9uALqXHuF+Fm5gWRxsNdndUs/1f+04ZB6UtmGnk/o9ZLZA/DGNFzA+eAqzTefj03Vb3xOsD1yI6exgqwlEnvRSNSVZ7VoCfb1k2SUY4u6h3Hyu2SMwte7Y+a5E7nSabhz4vCrG3GeAWQ1o3+bm3A7pPu1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=DWqqPd2z; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="DWqqPd2z"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260123121448epoutp0215d1811929cdd3530b56c2a8d80aaa00~NWy90ZYpy0302003020epoutp02S
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 12:14:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260123121448epoutp0215d1811929cdd3530b56c2a8d80aaa00~NWy90ZYpy0302003020epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769170488;
	bh=WjQNuY/LaNwimN1LsMDCa88dG7mBi2PdVExVV3Yfqn0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DWqqPd2z7EUAQMCM5Hs8H0gWCd+Gl4LMbQzF+RABtsbmBSLFlSAmcS3FVwLoL18Dh
	 tkJW+NhBdXdaEmhQiYM41CceLySsACw7ZPIbAP+mDI0eSO3v2ybVxTPVG4xjLnKE8d
	 gJrXcGEd6pbBbEOeWG6Ki+RHkvMwPPQ6jABfxyOI=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260123121446epcas5p38aff88f320af62074288f7e4ac6f9f13~NWy8i-g8u1610816108epcas5p3f;
	Fri, 23 Jan 2026 12:14:46 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.93]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dyH1K4xfKz3hhT7; Fri, 23 Jan
	2026 12:14:45 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260123121444epcas5p4e729259011e031a28be8379ea3b9b749~NWy6fJ6rc1107511075epcas5p4I;
	Fri, 23 Jan 2026 12:14:44 +0000 (GMT)
Received: from green245.gost (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260123121441epsmtip193ddadcef38cfbeda2b4fb04a9163535~NWy4CX07A0851408514epsmtip1x;
	Fri, 23 Jan 2026 12:14:41 +0000 (GMT)
Date: Fri, 23 Jan 2026 17:40:26 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, Qu
	Wenruo <wqu@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
	linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: bounce buffer direct I/O when stable pages are required v2
Message-ID: <20260123121026.tujkvhxixr6pgz7c@green245.gost>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260119074425.4005867-1-hch@lst.de>
X-CMS-MailID: 20260123121444epcas5p4e729259011e031a28be8379ea3b9b749
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_11f367_"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260123121444epcas5p4e729259011e031a28be8379ea3b9b749
References: <20260119074425.4005867-1-hch@lst.de>
	<CGME20260123121444epcas5p4e729259011e031a28be8379ea3b9b749@epcas5p4.samsung.com>

------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_11f367_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

I ran experiments[1] on two devices - Samsung PM1733 and Intel Optane
with PI enabled (4K + 8b format). On my setup, I didn't observe any
noticeable difference for sequential write workloads. Sequential reads,
however, show a clear performance drop while using bounce buffering,
which is expected.
Used these fio commands listed below[2]

Feel free to add:
Tested-by: Anuj Gupta <anuj20.g@samsung.com

[1]
Intel Optane:

Sequential write
   | size | zero copy  |  bounce    | 
   +------+------------+------------+
   |   4k | 158MiB/s   | 161MiB/s   |
   |  64K | 4522MiB/s  | 4506MiB/s  |
   |   1M | 4573MiB/s  | 4571MiB/s  |
   +------+-------------------------+

Sequential read
   | size | zero copy  |  bounce    | 
   +------+------------+------------+
   |   4k | 1693MiB/s  | 1245MiB/s  |
   |  64K | 6518MiB/s  | 4763MiB/s  |
   |   1M | 6731MiB/s  | 5475MiB/s  |
   +------+-------------------------+
   
   
For Samsung PM1733:

Sequential write
   | size | zero copy  |  bounce    | 
   +------+------------+------------+
   |   4k | 155MiB/s   | 153MiB/s   |
   |  64K | 3899MiB/s  | 3868MiB/s  |
   |   1M | 4117MiB/s  | 4116MiB/s  |
   +------+-------------------------+

Sequential read
   | size | zero copy  |  bounce    | 
   +------+------------+------------+
   |   4k | 602MiB/s   | 244MiB/s  |
   |  64K | 4613MiB/s  | 2141MiB/s  |
   |   1M | 5868MiB/s  | 5162MiB/s  |
   +------+-------------------------+
   

[2]
Write benchmark -
fio --name=write_new_4k --filename=/mnt/writefile --rw=write --bs=4k --size=20G --ioengine=io_uring --direct=1 --iodepth=16 --numjobs=1 --time_based=1 --runtime=30 --group_reporting

Read benchmark -
Prepare the file:
fio --name=prep_create_prepfile --filename=/mnt/prepfile --rw=write --bs=1M --size=20G --ioengine=io_uring --direct=1 --iodepth=16 --numjobs=1 --group_reporting

Then run the read workload:
fio --name=read_4k --filename=/mnt/prepfile --rw=read --bs=4k --size=20G --ioengine=io_uring --direct=1 --iodepth=16 --numjobs=1 --time_based=1 --runtime=30 --group_reporting

------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_11f367_
Content-Type: text/plain; charset="utf-8"


------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_11f367_--
