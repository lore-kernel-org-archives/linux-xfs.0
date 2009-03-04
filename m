Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n24HN8aI097818 for <xfs@oss.sgi.com>; Wed, 4 Mar 2009 11:23:09 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DAE021C18586
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2009 09:22:41 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id TbA5mAg82QwVOQZu for
	<xfs@oss.sgi.com>; Wed, 04 Mar 2009 09:22:41 -0800 (PST)
Date: Wed, 4 Mar 2009 12:22:40 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for February 2009
Message-ID: <20090304172240.GA645@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org


In February various smaller fixes have been sent to Linus for 2.6.29,
including a revert of the faster vmap APIs which don't seem to be quite
ready yet on the VM side.  At the same time various patches have been
queued up for 2.6.30, with another big batch pending.  There also has
been a repost of the CRC patch series, including support for a new,
larger inode core.

SGI released various bits of work in progress from former employees
that will be extremely helpful for the future development of XFS,
thanks a lot to Mark Goodwin for making this happen.

On the userspace side the long awaited 3.0.0 releases of xfsprogs and
xfsdump finally happened early in the month, accompanies by a 2.2.9
release of the dmapi userspace.  There have been some issues with packaging
so a new minor release might follow soon.

The xfs_irecover tool has been relicensed so that it can be merged into
the GPLv2 codebase of xfsprogs, but the actual integration work hasn't
happened yet.

Important bits of XFS documentation that have been available on the XFS
website in PDF form have been released in the document source form under
the Creative Commons license so that they can be updates as a community
effort, and checked into a public git tree.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
