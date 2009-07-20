Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6KLLB9c111703 for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 16:21:12 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 643AD374466
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 14:21:54 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Xw5j2FsRWmqu1mpo for
	<xfs@oss.sgi.com>; Mon, 20 Jul 2009 14:21:54 -0700 (PDT)
Date: Mon, 20 Jul 2009 17:21:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] use XFS_CORRUPTION_ERROR in xfs_btree_check_sblock
Message-ID: <20090720212153.GA6832@infradead.org>
References: <4A6492AF.3030809@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A6492AF.3030809@sandeen.net>
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
Cc: xfs mailing list <xfs@oss.sgi.com>

On Mon, Jul 20, 2009 at 10:52:15AM -0500, Eric Sandeen wrote:
> In Red Hat Bug 512552
>  - Can't write to XFS mount during raid5 resync
> 
> a user ran into corruption while resyncing a raid, and we failed
> a consistency test, but didn't get much more info; it'd be nice
> to call XFS_CORRUPTION_ERROR here so we can see the buffer
> contents.
> 
> Compile-tested only...

Looks good to me, I'll throw it into my XFSQA queue..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
