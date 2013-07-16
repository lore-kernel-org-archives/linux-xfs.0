Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A582E7F4E
	for <linux-xfs@oss.sgi.com>; Mon, 15 Jul 2013 21:16:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 72041304043
	for <linux-xfs@oss.sgi.com>; Mon, 15 Jul 2013 19:16:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id k2NQu60xPrMaRGOY for
	<linux-xfs@oss.sgi.com>; Mon, 15 Jul 2013 19:16:53 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r6G2GrX6030959
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-xfs@oss.sgi.com>; Mon, 15 Jul 2013 22:16:53 -0400
Received: from Liberator-563.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r6G2Gqf1016711
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-xfs@oss.sgi.com>; Mon, 15 Jul 2013 22:16:53 -0400
Message-ID: <51E4AD14.7080904@redhat.com>
Date: Mon, 15 Jul 2013 21:16:52 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_metadump: manpage fix regarding frozen fs
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
To: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

The xfs_metadump manpage states that metadump works
on a frozen filesystem; it does not.  In fact, there is
no way to detect a frozen filesystem, so we can't make it
work, either.

So just remove this from the manpage; unmounted or RO
mounted is what is enforced by xfs_metadump.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
index 26cea97..4fa1b1c 100644
--- a/man/man8/xfs_metadump.8
+++ b/man/man8/xfs_metadump.8
@@ -32,10 +32,8 @@ is \-, then the output is sent to stdout. This allows the output to be
 redirected to another program such as a compression application.
 .PP
 .B xfs_metadump
-should only be used to copy unmounted filesystems, read-only mounted
-filesystems, or frozen filesystems (see
-.BR xfs_freeze (8)).
-Otherwise, the generated dump could be inconsistent or corrupt.
+may only be used to copy unmounted filesystems, or read-only mounted
+filesystems.
 .PP
 .B xfs_metadump
 does not alter the source filesystem in any way. The

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
