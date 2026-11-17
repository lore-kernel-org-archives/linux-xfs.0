Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794882834;
	b=vZCzZqxwkMSc8wLjhzjD14o65/y7umThywkiFkzM8BGJTMj8Xku4k1oPlCznlJqIUA94
	 WezJ9KylK887iowQIsGoGy7+PTwVNyxfF3/3rJp5ZDxpN3kTear7uzUxbZXgdD2ryE09s
	 CP7+oxxHkiUrASjgnOuioDyNjZH610UwLjmrX3jFnQA1a6Z+/qp5GgyImaq6L6frPVUk4
	 beKxnToD4AeCEi//G5A8XkUP/ZUGsV+OmqwrzRmzxoysdBcyYZK70VvfFnzB4QOuA+wXj
	 LGyjSezNQLtkGEsf6XXCKMZFLGniV89cXAgzJY0YWMuD4CsO1mBazQFdAG8CBN0ZA4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794882834;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Mime-Version:Subject:Reply-To:Sender:From:To:CC:X-Priority:
	 X-Content-Kind-Code:In-Reply-To:X-CPGS-Detection:X-Drm-Type:
	 X-Msg-Generator:X-Msg-Type:X-Reply-Demand:Message-ID:Date:
	 X-CMS-MailID:Content-Transfer-Encoding:Content-Type:X-Sendblock-Type:
	 CMS-TYPE:X-CPGSPASS:X-CPGSPASS:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=ArB9Q+6SpwJqEmLNKZLc+YWYiLFBbKz2m6bNXZrWRho=;
	b=bXn+6gglJgmW0XQZn8ef6NgTa5Se1oQmWg47bFvFTiqa9sOk5l3DB1XeDxxX7yYtApIp
	 LTX8TvLn6cshpAqUbefOLHMRYgsBdErdgZEaIMmi5FZuBZy0KVI1P6V41fXnCBAHUavvh
	 /POBpjZfVgpbtmk42x6WcEKmuaJNmw24NZ+je9yEH+d6Pfe0Ca2lGNY/YQMKcXaotYJ5C
	 TtgVYHceGL9MLwPmam9lzlpPXGOt15BSxTWVHm2OpbLp6TMWl82iMhWTH2n0EBYSfcF71
	 yXtbFN8XyeMygLteeMf8FNT/pA159cdsk//aucWP137WC36b253uTQnJ1ewPqlxxnjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=pDEUU2eS;
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390B5606A337
	for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2026 02:33:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 390B5606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=pDEUU2eS
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261117023351epoutp0190d0bc39ea6c3f0990eaa57dbd174670~otGzckWmT0095200952epoutp01Z
	for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2026 02:33:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261117023351epoutp0190d0bc39ea6c3f0990eaa57dbd174670~otGzckWmT0095200952epoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794882831;
	bh=ArB9Q+6SpwJqEmLNKZLc+YWYiLFBbKz2m6bNXZrWRho=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=pDEUU2eS3oJ738BdgbpTeoOsO2xczZwZqkbkB6HTxsFdoB6Y1DX4kkSPaGXP/twdy
	 oui0NJqRHjm+e3kST+ej1D23fHSpO8rBnCdZnOqHYtnDGkURYNTZolObh+c+H0RutV
	 qYndwx51v9H2v+jMI2BWSG33C/dYui4PtF8f10WI=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20261117023346epcas2p431be1ce8e7ef82827678047a5e854052~otGvBdcur1147211472epcas2p43;
	Tue, 17 Nov 2026 02:33:46 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.201]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4jT81Q0GMzz2SSKX; Tue, 17 Nov
	2026 02:33:46 +0000 (GMT)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Subject: RE:(2) [PATCH v2 0/2] xfs: skip redundant fsync cache flushes
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: Dave Chinner <dgc@kernel.org>
CC: Carlos Maiolino <cem@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Dave Chinner
	<david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>, Amir Goldstein
	<amir73il@gmail.com>, Brian Foster <bfoster@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Daejun Park
	<daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <avQPb5z4ExBOiEJq@dread>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261117023345epcms2p5117009330b6c600f68c598d5e08aef5e@epcms2p5>
Date: Tue, 17 Nov 2026 11:33:45 +0900
X-CMS-MailID: 20261117023345epcms2p5117009330b6c600f68c598d5e08aef5e
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261111064724epcas2p11498de70e50f2fbf4e21d5e7a723e01d
References: <avQPb5z4ExBOiEJq@dread>
	<20261111-xfs-fsync-flush-seq-v2-0-b5c00c25d276@samsung.com>
	<CGME20261111064724epcas2p11498de70e50f2fbf4e21d5e7a723e01d@epcms2p5>

On Wed, Nov 11, 2026 at 05:47:11PM +1100, Dave Chinner wrote:
> On Wed, Nov 11, 2026 at 12:17:10PM +0900, Daejun Park via B4 Relay wrote:
[...]
> > 16 fio jobs of 4k append + fsync in a QEMU guest: 1111 -> 4498
> > fsyncs/s.

Correction: fio preallocated these files by default, so they were not
appends. Real appends (--fallocate=none) on the same disk give
1311 -> 3416 fsyncs/s.

[...]
> Hence the numbers look promising for low concurrency fsync
> workloads, but I'd really like to know waht happens at the high end
> when log force count rather than per-file fsync latency is the
> performance limiting factor. I suspect that it will improve
> performance by further mitigating the number of log writes and/or
> cache flushes that need to be done, but it really needs to be
> tested....

Thanks. When flushes are expensive, v2 is faster from 128 to 512
clients but writes more log per fsync. When flushes are cheap, v2 sends
60-80% fewer flushes and changes throughput and log writes per fsync
by under 5%.

Setup: dbench 4.00 -t 30 in a QEMU guest (40 GiB) on a 990 PRO
partition, for-next 48326a2382d8 without and with v2, three runs each,
execute phase only.

1) virtio-blk cache=none, volatile write cache on, 8 vCPUs:

clients  MB/s          log writes/fsync  max_latency ms
128      1963 -> 6886  0.10 -> 0.12        433 -> 331
256      3173 -> 6282  0.11 -> 0.38        312 -> 1956
512      4696 -> 5294  0.13 -> 0.37        468 -> 20595
1024     4466 -> 4751  0.28 -> 0.38      11128 -> 28947
2048     3973 -> 4043  0.25 -> 0.38      21153 -> 21225

2) cache=unsafe, so flushes complete without syncing, 16 vCPUs,
agcount=16: throughput -2.5% to +1.9%, log writes per fsync -4.6% to
-0.2%.

Log writes peaked at ~12,000/s (30 KiB each), below 20,000.

The long max_latency is unlink() blocked in the xfs_inodegc_queue()
throttle: from 1024 clients on base and 256 on v2 in setup 1, and from
256 on both in setup 2.

> I'd also like to know how this affects storage that does not require
> cache flushes - in those cases flushes are no-ops, so all this
> tracking and sequencing would likely be pure overhead....

No throughput or CPU overhead measured. Setup 1 with 16 vCPUs and
agcount=16, but the guest sets write_cache to "write through", so no
flushes are sent. Five runs each:

- dbench, 1/8/16/32/512 clients: MB/s changed by -0.8% to +0.8% and
  guest CPU per fsync by -0.5% to +1.4%. A -3.0% at 128 clients
  did not repeat in 15 more runs each (+0.1%).

- fs_mark, 16 threads: create and unlink of 12.8M empty files and
  fsync of 640k 4 KiB files changed time by -0.5% to -0.1% and guest
  CPU by -1.6% to +0.6%. chown -R times (13-108 s) varied too much to
  compare.

Best regards,
Daejun
