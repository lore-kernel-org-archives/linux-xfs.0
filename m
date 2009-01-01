Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n01MvIUd001619 for <xfs@oss.sgi.com>; Thu, 1 Jan 2009 16:57:18 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C99B758778
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 14:57:17 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id MLRbiziELxM1GO6T for
	<xfs@oss.sgi.com>; Thu, 01 Jan 2009 14:57:17 -0800 (PST)
Date: Thu, 1 Jan 2009 17:57:17 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] remove flags param from xfs_free_eofblocks
Message-ID: <20090101225717.GE7510@infradead.org>
References: <495D478B.9080702@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <495D478B.9080702@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Jan 01, 2009 at 04:45:31PM -0600, Eric Sandeen wrote:
> Remove unused XFS_FREE_EOF_NOLOCK and make XFS_FREE_EOF_LOCK default.
> 
> XFS_FREE_EOF_NOLOCK is never used, so remove it, make
> XFS_FREE_EOF_LOCK the only behavior, and remove the
> flags parameters.

Looks good to me.  

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
