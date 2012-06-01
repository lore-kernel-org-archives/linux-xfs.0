Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q51DIhMU149871 for <xfs@oss.sgi.com>; Fri, 1 Jun 2012 08:18:43 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F2051304067
	for <xfs@oss.sgi.com>; Fri,  1 Jun 2012 06:18:39 -0700 (PDT)
Received: from [134.15.95.98] (cf-vpn-hw-arenaud-1.corp.sgi.com [134.15.95.98])
	by estes.americas.sgi.com (Postfix) with ESMTP id ABF587001A4A
	for <xfs@oss.sgi.com>; Fri,  1 Jun 2012 08:18:39 -0500 (CDT)
Message-ID: <4FC8C12A.4010805@sgi.com>
Date: Fri, 01 Jun 2012 09:18:34 -0400
From: Alain Renaud <arenaud@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] xfstest: Cleanup test permission and gitignore state.
Content-Type: multipart/mixed; boundary="------------010606050302090103040709"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------010606050302090103040709
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


The new test 284/285/286 do not have execute permission set so set
them. Also test 285 and 286 create 2 executable that are not in .gitignore
so add then to the list.

Signed-off-by: Alain Renaud <arenaud@sgi.com>

diff --git a/.gitignore b/.gitignore
index 900ff95..c53c0d9 100644
--- a/.gitignore
+++ b/.gitignore
@@ -88,6 +88,8 @@ src/aio-dio-regress/aio-dio-subblock-eof-read
  src/aio-dio-regress/aio-free-ring-with-bogus-nr-pages
  src/aio-dio-regress/aio-io-setup-with-nonwritable-context-pointer
  src/aio-dio-regress/aiodio_sparse2
+src/seek_copy_test
+src/seek_sanity_test
   dmapi/src/common/cmd/read_invis
  dmapi/src/common/cmd/set_region
diff --git a/284 b/284
old mode 100644
new mode 100755
diff --git a/285 b/285
old mode 100644
new mode 100755
diff --git a/286 b/286
old mode 100644
new mode 100755

--------------010606050302090103040709
Content-Type: text/plain; charset=UTF-8;
 name="Attached Message Part"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="Attached Message Part"


--------------010606050302090103040709
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------010606050302090103040709--
