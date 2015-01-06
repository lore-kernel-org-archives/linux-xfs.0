Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0DCEA7F54
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 10:29:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DDA8F8F8037
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 08:29:32 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id j7k9BlGNpY06DgUo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 08:29:30 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: a simple and scalable pNFS block layout server
Date: Tue,  6 Jan 2015 17:28:23 +0100
Message-Id: <1420561721-9150-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

This series adds support for the pNFS operations in NFS v4.1, as well
as a block layout driver that can export block based filesystems that
implement a few additional export operations.  Support for XFS is
provided in this series, but other filesystems could be added easily.

The core pNFS code of course owns its heritage to the existing Linux
pNFS server prototype, but except for a few bits and pieces in the
XDR path nothing is left from it.

The design of this new pNFS server is fairly different from the old
one - while the old one implemented very little semantics in nfsd
and left almost everything to filesystems my implementation implements
as much as possible in common nfsd code, then dispatches to a layout
driver that still is part of nfsd and only then calls into the
filesystem, thus keeping it free from intimate pNFS knowledge.

More details are document in the individual patch descriptions and
code comments.

This code is also available from:

	git://git.infradead.org/users/hch/pnfs.git pnfsd-for-3.20

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
