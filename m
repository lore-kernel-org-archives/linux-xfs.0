Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CD4C67F37
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 08:31:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AF250304043
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 06:31:04 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id UqAmWXEcyCGZBWHo for <xfs@oss.sgi.com>;
	Mon, 24 Aug 2015 06:31:02 -0700 (PDT)
Message-ID: <55DB1C95.1060002@sandeen.net>
Date: Mon, 24 Aug 2015 08:31:01 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfsprogs: Minor fixes for xfs.5
References: <55D799B9.8040002@redhat.com>
In-Reply-To: <55D799B9.8040002@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Fix whitespace around logdev/rtdev mount option,
and add missing qnoenforce.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
index 3214455..fc1b776 100644
--- a/man/man5/xfs.5
+++ b/man/man5/xfs.5
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
+.B uquota/usrquota/quota/uqnoenforce/qnoenforce
 User disk quota accounting enabled, and limits (optionally)
 enforced.  Refer to xfs_quota(8) for further details.
 .TP


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
