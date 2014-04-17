Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 00B557F56
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 23:18:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BE0C98F8049
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 21:18:32 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sLMUtVQrps4JG5TF for
	<xfs@oss.sgi.com>; Wed, 16 Apr 2014 21:18:31 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3H4IVgt018342
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 00:18:31 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 2/3] generic/009: fix _require_xfs_io_command
Date: Thu, 17 Apr 2014 12:16:53 +0800
Message-Id: <1397708214-8197-2-git-send-email-eguan@redhat.com>
In-Reply-To: <1397708214-8197-1-git-send-email-eguan@redhat.com>
References: <1397708214-8197-1-git-send-email-eguan@redhat.com>
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
Cc: Eryu Guan <eguan@redhat.com>

_require_xfs_io_falloc "fzero" should be a typo, it requires falloc command.
Use the correct _require_xfs_io_command "fzero".

fiemap is also needed, add that too.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/generic/009 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/generic/009 b/tests/generic/009
index b7b0b3f..1e487b4 100644
--- a/tests/generic/009
+++ b/tests/generic/009
@@ -44,7 +44,8 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_os Linux
-_require_xfs_io_falloc "fzero"
+_require_xfs_io_fiemap
+_require_xfs_io_command "fzero"
 
 testfile=$TEST_DIR/009.$$
 
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
