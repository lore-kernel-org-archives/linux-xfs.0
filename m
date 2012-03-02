Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22GVtdR102262 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 10:31:55 -0600
Message-ID: <4F50F5F9.5030406@sgi.com>
Date: Fri, 02 Mar 2012 10:31:53 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 6/8] xfs: make xfs_inode_item_size idempotent
References: <20120229095347.009884687@bombadil.infradead.org>
	<20120229095509.185485494@bombadil.infradead.org>
In-Reply-To: <20120229095509.185485494@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 02/29/12 03:53, Christoph Hellwig wrote:
> Move all code messing with the inode log item flags into xfs_inode_item_format
> to make sure xfs_inode_item_size really only calculates the the number of
> vectors, but doesn't modify any state of the inode item.
>
> Reviewed-by: Dave Chinner<dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
>
> ---

Looks good.

Reviewed-by: Mark Tinguely

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
