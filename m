Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 60FF77F5D
	for <xfs@oss.sgi.com>; Sat, 12 Oct 2013 02:56:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 36C15304048
	for <xfs@oss.sgi.com>; Sat, 12 Oct 2013 00:56:45 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 080hXApMKf6tb9xz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 Oct 2013 00:56:41 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VUu3z-0000k7-Sc
	for xfs@oss.sgi.com; Sat, 12 Oct 2013 07:56:39 +0000
Message-Id: <20131012075503.370510641@bombadil.infradead.org>
Date: Sat, 12 Oct 2013 00:55:03 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/5] refactor the preallocation and hole punching code
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
To: xfs@oss.sgi.com

This series massages the preallocation and hole punching code into something
sane.  The big catchall xfs_change_file_space function is gone, fallocate
and the ioctl entry point now directly call the low-level functions, and
fallocate can avoid packing its arguments into the xfs_flock form and
duplicating error checking already done in the VFS.  In addition we also
use a common locking patter now, that is preallocations using the ioctl
path now also take iolock, just like fallocate and all other ioctl cases
already did beforehand.


Changes since version 1:
 - remove the unused setprealloc variable in xfs_file_fallocate
 - rebased

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
