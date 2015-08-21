Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3D0127F90
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 16:36:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BEF33AC003
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 14:36:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QvoEmUPgWwoGq3Hu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 21 Aug 2015 14:36:55 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 71A5649
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 21:36:54 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7LLaqia005683
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 17:36:54 -0400
Message-ID: <55D799F5.9020304@redhat.com>
Date: Fri, 21 Aug 2015 16:36:53 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: document dax mount option
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
To: xfs-oss <xfs@oss.sgi.com>

Add dax to the list of mount options in xfs.txt.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
index 8146e9f..e7e935d 100644
--- a/Documentation/filesystems/xfs.txt
+++ b/Documentation/filesystems/xfs.txt
@@ -58,6 +58,11 @@ default behaviour.
 	This allows for drive level write caching to be enabled, for
 	devices that support write barriers.
 
+  dax
+	Use direct access (no page cache) for block devices which are
+	memory-like, performing reads and writes directly to the storage
+	device.  See Documentation/filesystems/dax.txt.
+
   discard
   nodiscard (*)
 	Enable/disable the issuing of commands to let the block

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
