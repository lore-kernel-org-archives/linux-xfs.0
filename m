Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 744617CEC
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 03:00:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 42401304051
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 01:00:46 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id o8JMmHOyuT69r5Lx (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 01 Aug 2016 01:00:44 -0700 (PDT)
Date: Mon, 1 Aug 2016 01:00:37 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/47] xfs: introduce interval queries on btrees
Message-ID: <20160801080037.GA30547@infradead.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907701913.25461.16492865819245768513.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146907701913.25461.16492865819245768513.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

On Wed, Jul 20, 2016 at 09:56:59PM -0700, Darrick J. Wong wrote:
> Create a function to enable querying of btree records mapping to a
> range of keys.  This will be used in subsequent patches to allow
> querying the reverse mapping btree to find the extents mapped to a
> range of physical blocks, though the generic code can be used for
> any range query.
> 
> v2: add some shortcuts so that we can jump out of processing once
> we know there won't be any more records to find.
> 
> v3: document the range query algorithm, refactor the pop-up code,
> fix the diff_two_keys usage.
> 
> v4: The overlapped query range function should use the btree get_block
> helper because the root block could be an inode, in which case
> bc_bufs[nlevels-1] will be NULL.  Refactor the key calculations
> so that we can return -EINVAL if low > high.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
