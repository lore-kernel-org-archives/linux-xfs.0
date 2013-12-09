Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 653637F3F
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 01:03:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0D46DAC004
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 23:03:33 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id nxoFQCtshXSlanj3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 08 Dec 2013 23:03:18 -0800 (PST)
Date: Sun, 8 Dec 2013 23:03:16 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/11] xfs: rename xfs_ilock_map_shared
Message-ID: <20131209070316.GA27054@infradead.org>
References: <20131206203006.914776999@bombadil.infradead.org>
	<20131206203128.511935311@bombadil.infradead.org>
	<20131208223359.GD31386@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131208223359.GD31386@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Dec 09, 2013 at 09:33:59AM +1100, Dave Chinner wrote:
> While we are changing this, I think it makes sense to move it to
> being a static inline function given how simple it is....

I actually tried that first, but with XFS_DINODE_FMT_BTREE in
fs/xfs/xfs_dinode.h, struct xfsicdinode in xfs_log_format.h
and the resulting dependencies it didn't seem workable.  My inode
reshuffle might provide relief eventually.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
