Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBKHwHa9154562 for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 11:58:17 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 86063146D991
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 10:00:14 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id L0YSTjMvNj6tYo9E for
	<xfs@oss.sgi.com>; Mon, 20 Dec 2010 10:00:14 -0800 (PST)
Date: Mon, 20 Dec 2010 13:00:13 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for November 2010
Message-ID: <20101220180013.GA16283@infradead.org>
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

>From looking at the kernel git commits November looked like a pretty
slow month with just two hand full fixes going into the release candidates
for Linux 2.6.37, and none at all going into the development tree.
But in this case git statistics didn't tell the whole story - there
was a lot of activity on patches for the next merge window on the list.
The focus in November was still at metadata scalability, with various
patchsets that improves parallel creates and unlinks again, and also
improves 8-way dbench throughput by 30%.  In addition to that there
were patches to improve preallocation for NFS servers, to simplify
the writeback code, and to remove the XFS-internal percpu counters
for free space for the generic kernel percpu counters, which just needed
a small improvement.

On the user space side we saw the release of xfsprogs 3.1.4, which
contains various accumulated bug fixes and Debian packaging updates.
The xfsdump tree saw a large update to speed up restore by using
mmap for an internal database and remove the limitation of ~ 214
million directory entries per dump file.  The xfstests test suite
saw three new testcases and various fixes, including support for the
hfsplus filesystem.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
