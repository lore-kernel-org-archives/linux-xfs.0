Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 99C6A7F3F
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 10:14:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 39835AC005
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 08:14:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Hcdg7Kh7r9NKDvom for
	<xfs@oss.sgi.com>; Wed, 10 Jul 2013 08:14:50 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r6AFEn8Q014818
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 11:14:49 -0400
Received: from andromeda.usersys.redhat.com.com (ovpn-113-117.phx2.redhat.com
	[10.3.113.117])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r6AFEm85021141
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 11:14:49 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH v2] mkfs: add missing noalign suboption information
Date: Wed, 10 Jul 2013 12:14:40 -0300
Message-Id: <1373469280-12617-1-git-send-email-cmaiolino@redhat.com>
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

Changelog:

	V2:
	   -rephase noalign data-section option
	   -add noalign realtime device option

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 man/man8/mkfs.xfs.8 | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 04c19b4..61122f0 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -244,6 +244,11 @@ will automatically query the logical volume for appropriate
 and
 .B swidth
 values.
+.TP
+.BI noalign
+This option disables automatic geometry detection and creates the filesystem
+without stripe geometry alignment even if the underlying storage device provides
+this information.
 .RE
 .TP
 .B \-f
@@ -695,6 +700,10 @@ This is used to specify the size of the real-time section.
 This suboption is only needed if the real-time section of the
 filesystem should occupy less space than the size of the partition
 or logical volume containing the section.
+.TP
+.BI noalign
+This option disables stripe size detection, enforcing a realtime device with no
+stripe geometry.
 .RE
 .TP
 .BI \-s " sector_size"
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
