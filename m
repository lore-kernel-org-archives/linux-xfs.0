Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AKUFL5073453 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 14:30:15 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 555C310651D
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:29:38 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 6AeFyDoDJRHURo69 for
	<xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:29:38 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LWzEg-0005j6-B6
	for xfs@oss.sgi.com; Tue, 10 Feb 2009 20:29:38 +0000
Message-Id: <20090210202241.546501000@bombadil.infradead.org>
Date: Tue, 10 Feb 2009 15:22:41 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/13] Updated CRC patches
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


This is an updated version of the CRC patches, against the current
development tree.  There are new patches for CRCs on the inode (including
a new version 3 inode format leaving space for other requested fields),
the AGFL (including a proper header for it) and quotas.

The log crc patch has been updated to properly deal with split logbuffers
and to checksum not only the log payload but also the log record header
and cycle data.

In general the kernel code should be pretty solid now, but the dir2 and
attr CRC support is still missing.  The inode crc patch will probably
get some sort of makeover after Dave's icreate transaction and the
reworked unlinked inode list handling go in.

The userspace support is available at:

	http://verein.lst.de/~hch/xfs/patches.xfsprogs.crc-20090210.tgz

and has gotten update for the new features, as well as support in xfs_db
for all the new fields.  It's not quite as solid as the kernel code yet,
we'll need another large libxfs resync and a solution to the different
uuid prototypes in userspace first.

There's a couple of new xfsqa failures with these patches, most are
due to different logprint output, or because the CRC catch xfs_db
induced corruptions in a different way than the old code would.
Some are because the new minimal inode size of 512 bytes confuse
various tests.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
