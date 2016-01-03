Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 29BA07F58
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 06:21:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F19E5304053
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 04:21:00 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id gCDpCC5IoRGQQe3a (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 03 Jan 2016 04:20:59 -0800 (PST)
Date: Sun, 3 Jan 2016 04:20:58 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 57/76] xfs: allocate delayed extents in CoW fork
Message-ID: <20160103122058.GE28429@infradead.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
	<20151219090248.12713.32309.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151219090248.12713.32309.stgit@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

I really don't like the separate XFS_IOEND_COW flag.  This should
be an ioend type just like XFS_IO_DELALLOC, XFS_IO_UNWRITTEN and
XFS_IO_OVERWRITE.  We might need some work in the direct I/O
completions for that to really work, though.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
