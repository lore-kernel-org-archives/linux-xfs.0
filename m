Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0QEDXK6145209 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 08:13:33 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ACAF48C485E
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 06:15:57 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sufmeDO8D7Hyr9Bo for
	<xfs@oss.sgi.com>; Wed, 26 Jan 2011 06:15:57 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0QEFuue010380
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 09:15:56 -0500
Received: from localhost.localdomain (test1244.test.redhat.com [10.10.10.244])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id p0QEFupv004930
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 09:15:56 -0500
From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Xfstests: make 014 only run on xfs
Date: Wed, 26 Jan 2011 09:05:29 -0500
Message-Id: <1296050729-17316-1-git-send-email-josef@redhat.com>
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

This test relies on mounting with -o allocsize, which is an xfs specific mount
option, so make the test only work on xfs.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 014 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/014 b/014
index e6e0a6f..c6be9bd 100755
--- a/014
+++ b/014
@@ -44,7 +44,7 @@ _cleanup()
 . ./common.rc
 . ./common.filter
 
-_supported_fs generic
+_supported_fs xfs
 _supported_os IRIX Linux
 
 _require_sparse_files
-- 
1.6.6.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
