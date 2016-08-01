Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7B9217CF7
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 02:08:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 65006AC001
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 00:08:47 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id L7KPJMpKOhRUVj4V (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 01 Aug 2016 00:08:43 -0700 (PDT)
Date: Mon, 1 Aug 2016 00:08:40 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/47] xfs: move deferred operations into a separate file
Message-ID: <20160801070840.GL15590@infradead.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907703710.25461.16650495404061662831.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146907703710.25461.16650495404061662831.stgit@birch.djwong.org>
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

> + * NOTE: To avoid exceeding the transaction reservation, we limit the
> + * number of items that we attach to a given xfs_defer_pending.

This seems like a new feature compared to the old bmap_free code,
can you explain it it in a little more detail?  As I'm trying to compare
this code to the existing one there are a few things that confuse me,
most importantly the purpose of the xfs_defer_pending structure,
which seems like a new indirection.  I don't really like that
indirection at all, as it introduces another memory allocation deep
down in the commit path where we can't recover from ENOMEM.  Also there
seems to be a 1:1 relationship between it and the xfs_bmap_free_item
structure that got renamed to xfs_extent_free_item.

> +static const struct xfs_defer_op_type *defer_op_types[XFS_DEFER_OPS_TYPE_MAX];

We shouldn't really need this global array and the xfs_defer_ops_type
enum, just pass the xfs_defer_op_type pointer into xfs_defer_add.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
