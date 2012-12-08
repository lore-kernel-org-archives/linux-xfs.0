Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB8CL9Ql031206 for <xfs@oss.sgi.com>; Sat, 8 Dec 2012 06:21:09 -0600
Date: Sat, 8 Dec 2012 07:23:35 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 1/5] xfs: use b_maps[] for discontiguous buffers
Message-ID: <20121208122335.GA29107@infradead.org>
References: <20121204231801.982422341@sgi.com>
	<20121204224938.599314438@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121204224938.599314438@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Dec 04, 2012 at 05:18:02PM -0600, Mark Tinguely wrote:
> Commits starting at 77c1a08 introduced a multiple segment support
> to xfs_buf. xfs_trans_buf_item_match() could not find a multi-segment
> buffer in the transaction because it was looking at the single segment
> block number rather than the multi-segment b_maps[0].bm.bn. This
> results on a recursive buffer lock that can never be satisfied.
> 
> This patch:
>  1) Changed the remaining b_map accesses to be b_maps[0] accesses.
>  2) Renames the single segment b_map structure to __b_map to avoid
>     future confusion.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
