Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8E3E57F82
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 16:35:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7DE4C304043
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 14:35:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5Q0TgqCqG5r6HiUt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 21 Aug 2015 14:35:55 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id ACFB98CF42
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 21:35:54 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7LLZruB005460
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 17:35:54 -0400
Message-ID: <55D799B9.8040002@redhat.com>
Date: Fri, 21 Aug 2015 16:35:53 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: document dax in xfs.5 and other minor fixes
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

Document the dax option, fix whitespace around logdev/rtdev,
and add missing qnoenforce.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
index 3214455..fc1b776 100644
--- a/man/man5/xfs.5
+++ b/man/man5/xfs.5
@@ -140,6 +140,12 @@ devices that support write barriers.
 .sp
 Barriers are enabled by default.
 .TP
+.BR dax
+Use direct access (no page cache) for block devices which are
+memory-like, performing reads and writes directly to the storage
+device.  See Documentation/filesystems/dax.txt in the kernel
+documentation for more information.
+.TP
 .BR discard | nodiscard
 Enable/disable the issuing of commands to let the block
 device reclaim space freed by the filesystem.  This is
@@ -229,7 +235,7 @@ stripe unit configured at mkfs time.
 The default value for version 1 logs is 32768, while the
 default value for version 2 logs is MAX(32768, log_sunit).
 .TP
-.BR logdev=device and rtdev=device
+.BR logdev=device " and " rtdev=device
 Use an external log (metadata journal) and/or real-time device.
 An XFS filesystem has up to three parts: a data section, a log
 section, and a real-time section.  The real-time section is
@@ -260,7 +266,7 @@ read-only snapshots.
 Forcibly turns off all quota accounting and enforcement
 within the filesystem.
 .TP
-.B uquota/usrquota/uqnoenforce/quota
+.B uquota/usrquota/uqnoenforce/qnoenforce/quota
 User disk quota accounting enabled, and limits (optionally)
 enforced.  Refer to xfs_quota(8) for further details.
 .TP

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
