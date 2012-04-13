Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3D9oPOe020290 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 04:50:25 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OooYLM5DVzPdgNtS for
	<xfs@oss.sgi.com>; Fri, 13 Apr 2012 02:50:24 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q3D9oOME004558
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 05:50:24 -0400
From: tmarek@redhat.com
Subject: [PATCH 3/5] xfstests 198, 240: added check for aiodio-sparse2
Date: Fri, 13 Apr 2012 11:49:44 +0200
Message-Id: <1334310586-2281-3-git-send-email-tmarek@redhat.com>
In-Reply-To: <1334310586-2281-1-git-send-email-tmarek@redhat.com>
References: <1334310586-2281-1-git-send-email-tmarek@redhat.com>
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
Cc: Tom Marek <tmarek@redhat.com>, lczerner@redhat.com, dchinner@redhat.com

From: Tom Marek <tmarek@redhat.com>

Tests number 198 and 240 could fail when aiodio-sparse2 was not build.
Check whether aiodio-sparse is built was added to both tests.

Signed-off-by: Tom Marek <tmarek@redhat.com>

Reviewed-by: Lukas Czerner <lczerner@redhat.com>
---
 198 |    2 ++
 240 |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/198 b/198
index e46ec8d..b9b47b2 100755
--- a/198
+++ b/198
@@ -45,6 +45,8 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
+[-x $here/src/aio-dio-regress/aiodio_sparse2] || _notrun "src/aio-dio-regress/aiodio_sparse2 not built"
+
 echo "Silence is golden."
 
 # real QA test starts here
diff --git a/240 b/240
index 563449e..5a563ca 100755
--- a/240
+++ b/240
@@ -53,6 +53,8 @@ _supported_os Linux
 
 _require_sparse_files
 
+[-x $here/src/aio-dio-regress/aiodio_sparse2] || _notrun "src/aio-dio-regress/aiodio_sparse2 not built"
+
 echo "Silence is golden."
 
 # real QA test starts here
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
