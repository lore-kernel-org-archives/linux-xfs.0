Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:59422 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbeLTTEZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Dec 2018 14:04:25 -0500
Date: Thu, 20 Dec 2018 11:04:01 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] iomap: take responsibility for the filesystem iomap code
Message-ID: <20181220190401.GD27208@magnolia>
References: <20181220053622.GD27176@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181220053622.GD27176@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, Amir Goldstein <amir73il@gmail.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

XFS is the primary user of the filesystem iomap code, so we (the XFS
community, specifically) will explicitly take responsibility for its
maintenance.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: maintain alphabetization, add Christoph as a Real Person patch
mailing target.  Still looking for acks from Christoph & Dave...
---
 MAINTAINERS |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3318f30903b2..a3ccbeebb377 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7783,6 +7783,17 @@ L:	linux-serial@vger.kernel.org
 S:	Maintained
 F:	drivers/tty/serial/ioc3_serial.c
 
+IOMAP FILESYSTEM LIBRARY
+M:	Christoph Hellwig <hch@infradead.org>
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
