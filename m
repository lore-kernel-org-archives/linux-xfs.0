Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LDdUC4145762 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 08:39:30 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 999F01C2ECB0
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 06:39:28 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id t9CPVfL8Lom3cx9R
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 06:39:28 -0700 (PDT)
References: <20110914143005.GA28496@infradead.org>
	<4E75B660.1030502@profihost.ag> <20110918230245.GF15688@dastard>
	<4E78665E.8030409@profihost.ag>
	<20110920160226.GA25542@infradead.org>
	<4E78CBF4.1030505@profihost.ag>
	<20110920172455.GA30757@infradead.org>
	<4E78CEFD.9030603@profihost.ag>
	<20110920223047.GA13758@infradead.org>
	<4E79940A.4000502@profihost.ag>
	<20110921113935.GA8947@infradead.org>
In-Reply-To: <20110921113935.GA8947@infradead.org>
Mime-Version: 1.0 (iPhone Mail 8H7)
Message-Id: <588A4DF6-A9C7-4797-B30B-4CD38B521167@profihost.ag>
From: Stefan Priebe <s.priebe@profihost.ag>
Subject: Re: xfs deadlock in stable kernel 3.0.4
Date: Wed, 21 Sep 2011 15:39:16 +0200
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "aelder@sgi.com" <aelder@sgi.com>


> One thing I noticed is that your config seems to run many fs tasks
> a lot slower than mine, but I'm not entirely sure why.
Strange would you post your config too?

> The only interesting things I noticed in your config where that you
> use slub instead of slab, which does a lot of high order allocations
> and has caused lots of trouble in the past, and that you enable
> CONFIG_CC_OPTIMIZE_FOR_SIZE, which has caused mis-compilation
> of complicated code in the past.  I don't want to blame it directly,
> but I could see how that causes problems with some of the atomic64_t
> games XFS plays since 2.6.38.
Will remove it.

At least dave was able to reproduce so he can probably help too.

Thanks!

Stefan
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
