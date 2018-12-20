Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:44410 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728820AbeLTFgz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Dec 2018 00:36:55 -0500
Date: Wed, 19 Dec 2018 21:36:22 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC PATCH] iomap: take responsibility for the filesystem iomap code
Message-ID: <20181220053622.GD27176@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

XFS is the primary user of the filesystem iomap code, so we (the XFS
community, specifically) will explicitly take responsibility for its
maintenance.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
Just floating this as a test balloon.  Would like at acks from at least
Dave and Christoph since they wrote most of the fs iomap code.
---
 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8119141a926f..a36a88a72423 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16518,6 +16518,16 @@ L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Supported
 F:	sound/xen/*
 
+IOMAP FILESYSTEM LIBRARY
+M:	linux-xfs@vger.kernel.org
+M:	linux-fsdevel@vger.kernel.org
+L:	linux-xfs@vger.kernel.org
+L:	linux-fsdevel@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
+S:	Supported
+F:	fs/iomap.c
+F:	include/linux/iomap.h
+
 XFS FILESYSTEM
 M:	Darrick J. Wong <darrick.wong@oracle.com>
 M:	linux-xfs@vger.kernel.org
