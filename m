Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q77EQF94080441 for <xfs@oss.sgi.com>; Tue, 7 Aug 2012 09:26:15 -0500
Message-ID: <50212583.6020800@sgi.com>
Date: Tue, 07 Aug 2012 09:26:11 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: unlock the AGI buffer when looping in xfs_dialloc
References: <20120807060202.GA4005@infradead.org>
In-Reply-To: <20120807060202.GA4005@infradead.org>
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

On 08/07/12 01:02, Christoph Hellwig wrote:
> Also update some commens in the area to make the code easier to read.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
>

Looks great. Just last weekend, I noticed that the unlock is also
missing in the current version of xfs_dialloc() and not just patch #7.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
