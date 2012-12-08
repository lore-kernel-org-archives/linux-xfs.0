Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB8C7eD3029959 for <xfs@oss.sgi.com>; Sat, 8 Dec 2012 06:07:40 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	vTOwYkVb8QGoy5FW (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 08 Dec 2012 04:10:06 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1ThJEL-0004fQ-Ix
	for xfs@oss.sgi.com; Sat, 08 Dec 2012 12:10:05 +0000
Message-Id: <20121208120812.755863148@bombadil.infradead.org>
Date: Sat, 08 Dec 2012 07:08:12 -0500
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This series massages the preallocation and hole punching code into something
sane.  The big catchall xfs_change_file_space function is gone, fallocate
and the ioctl entry point now directly call the low-level functions, and
fallocate can avoid packing its arguments into the xfs_flock form and
duplicating error checking already done in the VFS.  In addition we also
use a common locking patter now, that is preallocations using the ioctl
path now also take iolock, just like fallocate and all other ioctl cases
already did beforehand.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
