Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5L1Vu0j208425 for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 20:31:56 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 954A41E4C0E9
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 18:31:54 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	wW0NZySyvFXHyDH7 for <xfs@oss.sgi.com>;
	Mon, 20 Jun 2011 18:31:54 -0700 (PDT)
Date: Tue, 21 Jun 2011 11:31:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: kill xfs_itruncate_start
Message-ID: <20110621013152.GM32466@dastard>
References: <20110617131301.GB2141@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110617131301.GB2141@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Jun 17, 2011 at 09:13:01AM -0400, Christoph Hellwig wrote:
> xfs_itruncate_start is a rather length wrapper that evaluates to a call
> to xfs_ioend_wait and xfs_tosspages, and only has two callers.
> 
> Instead of using the complicated checks left over from IRIX where we
> can to truncate the pagecache just call xfs_tosspages
> (aka truncate_inode_pages) directly as we want to get rid of all data
> after i_size, and truncate_inode_pages handles incorrect alignments
> and too large offsets just fine.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks sane given that the complexity is necessary for handling the 
XFS_ITRUNC_MAYBE case correctly, and that flag is unused and
therefore never needed in the Linux code base. It also means that
xfs_free_eofblocks() won't get hung up on IO in progress needlessly.

Well spotted!

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
