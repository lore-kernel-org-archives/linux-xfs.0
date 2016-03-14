Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 296F37CD8
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 16:03:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 88776304062
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 14:02:58 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id ACkS54wnQrPD4khU (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Mar 2016 14:02:54 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1afZdc-0000GL-5a
	for xfs@oss.sgi.com; Mon, 14 Mar 2016 21:02:52 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [RFC] iomap infrastructure and multipage writes
Date: Mon, 14 Mar 2016 22:02:43 +0100
Message-Id: <1457989370-6904-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Because I've seen some issues with the amount of overhead we spend
in the bmap btree when using reflinks I though I'd dust up the
multipage write code again.  This was first started by Dave Chinner
a long time ago, then I did beat it into shape for production runs
in a very constrained ARM NAS enviroment for Tuxera almost as long
ago, and now half a dozen rewrites later it's back.

The basic idea is to avoid the crazy per-block get_blocks overhead
and make use of extents in the buffered write path by iterating over
them instead.

I could probably write a lot more here, but for now I'd like people
to take a look at this version.  It passes xfstests fine on blocksize ==
PAGE_SIZE setups, but I haven't done much testing with small block
sizes yet.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
