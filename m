Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2F7nu5h256630 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 02:50:17 -0500
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 237AD199CB8
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 00:49:13 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	7ELRlRxs2HpAapia for <xfs@oss.sgi.com>;
	Sun, 15 Mar 2009 00:49:13 -0700 (PDT)
Date: Sun, 15 Mar 2009 18:49:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/7] xfs: cleanup log unmount handling
Message-ID: <20090315074910.GP26138@disturbed>
References: <20090220085207.663702000@bombadil.infradead.org>
	<20090220085228.602565000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090220085228.602565000@bombadil.infradead.org>
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

On Fri, Feb 20, 2009 at 03:52:08AM -0500, Christoph Hellwig wrote:
> Kill the current xfs_log_unmount wrapper and opencode the two function
> calls in the only caller.  Rename the current xfs_log_unmount_dealloc to
> xfs_log_unmount as it undoes xfs_log_mount and the new name makes that
> more clear.

Reviewed-by: Dave Chinner <david@fromorbit.com>


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
