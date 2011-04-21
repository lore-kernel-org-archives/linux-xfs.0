Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3L4fSuU134551 for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 23:41:29 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B72193FD010
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 21:44:56 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id bpwAugSWWLEASMrv for
	<xfs@oss.sgi.com>; Wed, 20 Apr 2011 21:44:56 -0700 (PDT)
Date: Thu, 21 Apr 2011 00:44:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfs: obey minleft values during extent allocation
	correctly.
Message-ID: <20110421044456.GA28859@infradead.org>
References: <1303360144-10632-1-git-send-email-david@fromorbit.com>
	<1303360144-10632-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1303360144-10632-5-git-send-email-david@fromorbit.com>
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

On Thu, Apr 21, 2011 at 02:29:04PM +1000, Dave Chinner wrote:
> A further problem is that bmbt block allocation doesn't set the
> total number of blocks correctly for the allocation, thereby
> allowing it to allocate a block from the AGFL before failing on the
> second block in xfs_alloc_fix_freelist(). The total needs to be set
> so that it skips AGs that only have the minimum reserved
> amount of AGFL blocks free in them.

This patch doesn't contain the hunk to set "total".

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
