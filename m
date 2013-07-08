Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 00AA77F62
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 18:45:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 81AC0AC001
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 16:45:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id iCGpiQtR9Fsvjj2G for
	<xfs@oss.sgi.com>; Mon, 08 Jul 2013 16:45:22 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r68NjLuS025667
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 8 Jul 2013 19:45:22 -0400
Received: from andromeda.usersys.redhat.com.com (ovpn-113-117.phx2.redhat.com
	[10.3.113.117])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r68NjK8e012711
	for <xfs@oss.sgi.com>; Mon, 8 Jul 2013 19:45:21 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] mkfs: add missing noalign suboption information
Date: Mon,  8 Jul 2013 20:45:10 -0300
Message-Id: <1373327110-5533-1-git-send-email-cmaiolino@redhat.com>
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

Adds to the mkfs man page, information about noalign mkfs option which is
missing until now.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 man/man8/mkfs.xfs.8 | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 04c19b4..2435814 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -244,6 +244,12 @@ will automatically query the logical volume for appropriate
 and
 .B swidth
 values.
+.TP
+.BI noalign
+This option is used to bypass data alignment configuration. In rare
+circunstances, data alignment might decrease performance, for such cases,
+use this option to avoid data alignment, this will set stripe unit and
+stripe width to 0.
 .RE
 .TP
 .B \-f
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
