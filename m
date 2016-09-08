Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4E6867CA0
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 16:53:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1E5E7304048
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 14:53:32 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7m7MXuOhMqVpNjyq (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 08 Sep 2016 14:53:31 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: add XBF_XBF_NO_IOACCT to buf trace output
Message-ID: <4074f575-f4cf-e8ee-7c79-0bbc45333f5d@redhat.com>
Date: Thu, 8 Sep 2016 16:53:28 -0500
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>, linux-xfs@vger.kernel.org

When XBF_NO_IOACCT got added, it missed the translation
in XFS_BUF_FLAGS, so we see "0x8" in trace output rather
than the flag name.  Fix it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 1c2e52b..424f6b0 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -71,6 +71,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_READ,		"READ" }, \
 	{ XBF_WRITE,		"WRITE" }, \
 	{ XBF_READ_AHEAD,	"READ_AHEAD" }, \
+	{ XBF_NO_IOACCT,	"NO_IOACCT" }, \
 	{ XBF_ASYNC,		"ASYNC" }, \
 	{ XBF_DONE,		"DONE" }, \
 	{ XBF_STALE,		"STALE" }, \

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
