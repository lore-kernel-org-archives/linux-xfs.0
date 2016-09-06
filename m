Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 279107CA0
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 10:09:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CFF338F8033
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 08:09:07 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id NsqDBJsLOyPzqJng (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Sep 2016 08:09:06 -0700 (PDT)
Date: Tue, 6 Sep 2016 08:09:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 14/71] xfs: add refcount btree operations
Message-ID: <20160906150902.GH24287@infradead.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
	<147216800795.867.8161276170370290222.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147216800795.867.8161276170370290222.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Aug 25, 2016 at 04:33:28PM -0700, Darrick J. Wong wrote:
> Implement the generic btree operations required to manipulate refcount
> btree blocks.  The implementation is similar to the bmapbt, though it
> will only allocate and free blocks from the AG.
> 
> v2: Remove init_rec_from_key since we no longer need it, and add
> tracepoints when refcount btree operations fail.
> 
> Since the refcount root and level fields are separate from the
> existing roots and levels array, they need a separate logging flag.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> [hch: fix logging of AGF refcount btree fields]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

No need to mention this little fixlet from ages ago.

More importantly: why is this a separate patch from the remaining
"meat" in xfs_refcount_btree.c

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
