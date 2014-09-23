Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 405CF7F3F
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 10:43:12 -0500 (CDT)
Received: from dhcp-128-162-232-117.americas.sgi.com
	(dhcp-128-162-232-117.americas.sgi.com [128.162.232.117])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BD023AC006
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 08:43:08 -0700 (PDT)
Received: from dhcp-128-162-232-117.americas.sgi.com (localhost [127.0.0.1])
	by dhcp-128-162-232-117.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s8NFhAEC002931
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 10:43:10 -0500 (CDT)
	(envelope-from tinguely@dhcp-128-162-232-117.americas.sgi.com)
Message-Id: <20140923154140.315778789@sgi.com>
Date: Tue, 23 Sep 2014 10:41:29 -0500
From: Mark Tingueyl <tinguely@sgi.com>
Subject: [PATCH] xfsprogs: fix xfsctl manual XFS_IOC_FSSETXATTR valid fields
Content-Disposition: inline;
	filename=xfsprogs-project-id-XFS_IOC_FSSETXATTR.patch
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

The xfsctl manual page fails to mention that fsx_projid is a
setable field.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 man/man3/xfsctl.3 |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: b/man/man3/xfsctl.3
===================================================================
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -245,9 +245,10 @@ Set additional attributes associated wit
 The final argument points to a variable of type
 .BR "struct fsxattr" ,
 but only the following fields are used in this call:
-.B fsx_xflags
+.BR fsx_xflags ,
+.B fsx_extsize
 and
-.BR fsx_extsize .
+.BR fsx_projid .
 The
 .B fsx_xflags
 realtime file bit and the file's extent size may be changed only


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
