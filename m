Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9EDBk1m192607 for <xfs@oss.sgi.com>; Wed, 14 Oct 2009 08:11:48 -0500
Date: Wed, 14 Oct 2009 09:13:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] free temporary cursor in xfs_dialloc
Message-ID: <20091014131314.GA15001@infradead.org>
References: <4AD54BAF.2050206@sandeen.net> <4AD54CA4.6000301@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4AD54CA4.6000301@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Thanks Eric,

the patch looks correct to me, this was the only path in that area not
freeing the tcur (or freeing cur and assigning tcur to cur) before
jumping to newino/alloc_inode.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
