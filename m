Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FFEY67020139 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 10:14:54 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E54E19A4A3
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 08:14:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id eyz1F0wR2Vz6dNjv for
	<xfs@oss.sgi.com>; Sun, 15 Mar 2009 08:14:12 -0700 (PDT)
Date: Sun, 15 Mar 2009 11:13:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] [XFS] Fix double free of inode
Message-ID: <20090315151340.GA7145@infradead.org>
References: <1237116342-25701-1-git-send-email-david@fromorbit.com>
	<1237116342-25701-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1237116342-25701-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Mar 15, 2009 at 10:25:42PM +1100, Dave Chinner wrote:
> If we fail to initialise the VFS inode in inode_init_always(),
> it will call ->delete_inode internally resulting in the inode being
> freed. Hence we need to delay the call to inode_init_always()
> until after the XFS inode is sufficient set up to handle a
> call to ->delete_inode, and then if that fails do not touch
> the inode again at all as it has been freed.

Looks good, but the changelog should mention the setting of the
I_NEW bit, too.


Reviewed-by: Christoph Hellwig <hch@lst.de>

I suspect this should go into 2.6.29-stable after some testing, too.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
