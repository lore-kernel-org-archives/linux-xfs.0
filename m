Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4E0E77CA1
	for <xfs@oss.sgi.com>; Mon, 12 Sep 2016 07:35:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9A25EAC001
	for <xfs@oss.sgi.com>; Mon, 12 Sep 2016 05:35:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NO5PZKBeCIOG9Ezu (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 12 Sep 2016 05:35:34 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: fix exit code documentation in manpage
Message-ID: <62881d1e-8980-00c6-1d04-642a49b3b252@redhat.com>
Date: Mon, 12 Sep 2016 07:35:32 -0500
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

xfs_repair cannot proceed with a dirty log, and exits with
a status code of 2 in that case; fix the manpage to
reflect this.

(This has been the case for years, but was never documented).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/man/man8/xfs_repair.8 b/man/man8/xfs_repair.8
index 1b4d9e3..57c970a 100644
--- a/man/man8/xfs_repair.8
+++ b/man/man8/xfs_repair.8
@@ -509,7 +509,9 @@ If the directory were small, the message would read "junking entry ...".
 will return a status of 1 if filesystem corruption was detected and
 0 if no filesystem corruption was detected.
 .B xfs_repair
-run without the \-n option will always return a status code of 0.
+run without the \-n option will return a status code of 2 if the log is
+dirty and needs to be replayed, otherwise it will always return a status
+code of 0.
 .SH BUGS
 The filesystem to be checked and repaired must have been
 unmounted cleanly using normal system administration procedures

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
