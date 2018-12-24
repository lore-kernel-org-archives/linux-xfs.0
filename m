Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:43774 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbeLXAhn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Dec 2018 19:37:43 -0500
Date: Sun, 23 Dec 2018 16:37:11 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v3] iomap: take responsibility for the filesystem iomap code
Message-ID: <20181224003711.GK27208@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181220053622.GD27176@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, Amir Goldstein <amir73il@gmail.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

XFS is the primary user of the filesystem iomap code, so we (the XFS
community, specifically) will explicitly take responsibility for its
maintenance.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
v3: I decided that perhaps I ought to be listed for iomap after all.
Still looking for an ack from Christoph...

v2: maintain alphabetization, add Christoph as a Real Person patch
mailing target.  Still looking for acks from Christoph & Dave...
---
 MAINTAINERS |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3318f30903b2..d2c034aed4be 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7783,6 +7783,18 @@ L:	linux-serial@vger.kernel.org
 S:	Maintained
 F:	drivers/tty/serial/ioc3_serial.c
 
+IOMAP FILESYSTEM LIBRARY
+M:	Christoph Hellwig <hch@infradead.org>
+M:	Darrick J. Wong <darrick.wong@oracle.com>
+M:	linux-xfs@vger.kernel.org
+M:	linux-fsdevel@vger.kernel.org
+L:	linux-xfs@vger.kernel.org
+L:	linux-fsdevel@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
+S:	Supported
+F:	fs/iomap.c
+F:	include/linux/iomap.h
+
 IOMMU DRIVERS
 M:	Joerg Roedel <joro@8bytes.org>
 L:	iommu@lists.linux-foundation.org
