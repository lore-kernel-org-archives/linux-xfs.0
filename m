Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.238
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525712;
	b=JZdMsJWHSUyTAfXCoH6Gvpa/aRZm8eAL2A5R7tvg2a7K4J7R0jC6ool2k3D77paAyZmK
	 WdxoHpqlvpyFqY1mDEldWG3/jg8bXx4QlYoQHmmSrs4VqPvR9xW/XnKay8X6CTAIbWBR5
	 ze5GDqKKz7ffx9EWP9ycBjV3BOIqn65z2djz+9TFMXcfeR4L/Vf67XYBJKaV8/Tb1PFdN
	 equ4OeaJEUNVVzeLHaFo4QYasi9d4C76wd55vcgROjcUow1g3VJaBRaVzohFBaxAVuAye
	 XhkdVQbNMuZsQFhlSmj0HHjr+2CtRG+u2Nx4kHR0ZMBGa4h0W10tmhOucocAYBAfclw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525712;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=SKndPVf6fv+vcZFs47JjiUiTdf9OsnJiNfTCpP00Ae4=;
	b=eIW+TErv1zlWQlEQwjZP+0c5TpReJJV4QsHE+eY+WiOzN/qgEbXLpJDiOTsBPUEM9dSo
	 MdtOieiqyWX9EQ6rWNsRs4L5HrxjSI/+Uz6CCuWXRdknb0705S3Wx4aBeT4ggI0in1UMq
	 EZgSbGbgUxgnG2bjkgJSDHMxH0lKkorUCZ6EdGFppgr/PkafHASXwRn2Pe6FNlCYcr6yu
	 UqmpPQ8JXGGX83hai7mzx45WvdJPuDCEQTxe9bmwnMJ3skPlW4stTJYiAbs1fxNxKJ8ER
	 KLlivskRodRxDAhTwSveLOBqMnwhyW/lcpNSx5wEYPsQxNioWl/be5TrIyDynjl52OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QT3py5ik;
	arc=none smtp.remote-ip=95.215.58.238
Received: from mta1.migadu.com (out-238.mta1.migadu.com [95.215.58.238])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC13606A31E
	for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2026 13:08:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DC13606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QT3py5ik
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=HPXWZ66xG0/7jSLpD6luU5x0piuUjMnwo5mW3igEPTg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795525709; v=1; x=1796130509;
 b=QT3py5ikqum6bM+tON3uCk1BgKwC+nXCTH9JFf5IxbJZHlvVY5BfdrswDUNwjzvMKw+4WiY2
 Xy8a+2nLTF/aXyJEMwSNdwizW5/1QG46RJd8MlPXtjG1ofv8K9t4ATNZO1sqSrl+AFafsrJTqO0
 mZyiKQ40aIaT+GXfslxRlZaY=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a71e5be8c34d1f0a;
	Tue, 24 Nov 2026 13:08:29 +0000
X-Mizu-Trace-ID: a71e5be8c34d1f0a
X-Migadu-Flow: FLOW_OUT
Date: Tue, 24 Nov 2026 14:08:23 +0100
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Daejun Park <daejun7.park@samsung.com>
Cc: Dave Chinner <dgc@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Brian Foster <bfoster@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: (2) [PATCH v2 0/2] xfs: skip redundant fsync cache flushes
Message-ID: <awWJ54ztH1pWu61B@quentin>
References: <avQPb5z4ExBOiEJq@dread>
 <20261111-xfs-fsync-flush-seq-v2-0-b5c00c25d276@samsung.com>
 <CGME20261111064724epcas2p11498de70e50f2fbf4e21d5e7a723e01d@epcms2p5>
 <20261117023345epcms2p5117009330b6c600f68c598d5e08aef5e@epcms2p5>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117023345epcms2p5117009330b6c600f68c598d5e08aef5e@epcms2p5>

On Tue, Nov 17, 2026 at 11:33:45AM +0900, Daejun Park wrote:
> On Wed, Nov 11, 2026 at 05:47:11PM +1100, Dave Chinner wrote:
> > On Wed, Nov 11, 2026 at 12:17:10PM +0900, Daejun Park via B4 Relay wrote:
> [...]
> > > 16 fio jobs of 4k append + fsync in a QEMU guest: 1111 -> 4498
> > > fsyncs/s.
> 
> Correction: fio preallocated these files by default, so they were not
> appends. Real appends (--fallocate=none) on the same disk give
> 1311 -> 3416 fsyncs/s.
> 
> [...]
> > Hence the numbers look promising for low concurrency fsync
> > workloads, but I'd really like to know waht happens at the high end
> > when log force count rather than per-file fsync latency is the
> > performance limiting factor. I suspect that it will improve
> > performance by further mitigating the number of log writes and/or
> > cache flushes that need to be done, but it really needs to be
> > tested....
> 
> Thanks. When flushes are expensive, v2 is faster from 128 to 512
> clients but writes more log per fsync. When flushes are cheap, v2 sends

It looks like the delay caused by flush acted as a group commit delay
which allowed for more batching and optimization before the logs were
written out?

> 60-80% fewer flushes and changes throughput and log writes per fsync
> by under 5%.
> 
> Setup: dbench 4.00 -t 30 in a QEMU guest (40 GiB) on a 990 PRO
> partition, for-next 48326a2382d8 without and with v2, three runs each,
> execute phase only.
> 
> 1) virtio-blk cache=none, volatile write cache on, 8 vCPUs:
> 
> clients  MB/s          log writes/fsync  max_latency ms
> 128      1963 -> 6886  0.10 -> 0.12        433 -> 331
> 256      3173 -> 6282  0.11 -> 0.38        312 -> 1956
> 512      4696 -> 5294  0.13 -> 0.37        468 -> 20595
> 1024     4466 -> 4751  0.28 -> 0.38      11128 -> 28947
> 2048     3973 -> 4043  0.25 -> 0.38      21153 -> 21225
> 

Could you detail your setup and how you measure log writes/fsync and the
latency numbers?

I can also try to reproduce it locally.

-- 
Pankaj
