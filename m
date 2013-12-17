Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 053F67F3F
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 08:02:39 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E98CE8F8049
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 06:02:38 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QbF7vwHZF4IpZ08q for
	<xfs@oss.sgi.com>; Tue, 17 Dec 2013 06:02:38 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rBHE2bMw012749
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 09:02:37 -0500
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/3] xfstests 321, 322: do not remove lost+found
Date: Tue, 17 Dec 2013 15:02:27 +0100
Message-Id: <1387288947-12650-3-git-send-email-lczerner@redhat.com>
In-Reply-To: <1387288947-12650-1-git-send-email-lczerner@redhat.com>
References: <1387288947-12650-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 tests/generic/321 | 2 +-
 tests/generic/322 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/generic/321 b/tests/generic/321
index 1d17147..345416c 100644
--- a/tests/generic/321
+++ b/tests/generic/321
@@ -51,7 +51,7 @@ rm -f $seqres.full
 _clean_working_dir()
 {
 	_mount_flakey
-	rm -rf $SCRATCH_MNT/*
+	rm -rf $SCRATCH_MNT/foo $SCRATCH_MNT/bar
 	_unmount_flakey
 }
 
diff --git a/tests/generic/322 b/tests/generic/322
index 94f8f68..c43fcb1 100644
--- a/tests/generic/322
+++ b/tests/generic/322
@@ -51,7 +51,7 @@ rm -f $seqres.full
 _clean_working_dir()
 {
 	_mount_flakey
-	rm -rf $SCRATCH_MNT/*
+	rm -rf $SCRATCH_MNT/foo $SCRATCH_MNT/bar
 	_unmount_flakey
 }
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
