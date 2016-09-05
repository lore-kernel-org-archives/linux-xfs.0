Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7724B7CA1
	for <xfs@oss.sgi.com>; Mon,  5 Sep 2016 10:05:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3FBF38F8035
	for <xfs@oss.sgi.com>; Mon,  5 Sep 2016 08:05:42 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 4w8tPCKvpQaZb7GZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 05 Sep 2016 08:05:40 -0700 (PDT)
Date: Mon, 5 Sep 2016 08:05:37 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/71] xfs: count the blocks in a btree
Message-ID: <20160905150537.GG7662@infradead.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
	<147216793514.867.6884435099045085232.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147216793514.867.6884435099045085232.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Aug 25, 2016 at 04:32:15PM -0700, Darrick J. Wong wrote:
> Provide a helper method to count the number of blocks in a short form
> btree.  The refcount and rmap btrees need to know the number of blocks
> already in use to set up their per-AG block reservations during mount.
> 
> v2: Use btree_visit_blocks instead of open-coding our own traversal
> routine.

Same comments as with the last patch.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
