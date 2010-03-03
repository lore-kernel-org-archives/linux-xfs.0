Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o236ILnE048462 for <xfs@oss.sgi.com>; Wed, 3 Mar 2010 00:18:21 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BDAE11D0B91F
	for <xfs@oss.sgi.com>; Tue,  2 Mar 2010 22:19:37 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	l8DthcqTLclMfbTn for <xfs@oss.sgi.com>;
	Tue, 02 Mar 2010 22:19:37 -0800 (PST)
Received: from discord (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	15740701-1927428
	for <xfs@oss.sgi.com>; Wed, 03 Mar 2010 16:49:36 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1Nmhvi-0003N6-8o
	for xfs@oss.sgi.com; Wed, 03 Mar 2010 17:19:34 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1Nmhva-00039n-VA
	for xfs@oss.sgi.com; Wed, 03 Mar 2010 17:19:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfsqa: fix size specification for scratch mkfs
Date: Wed,  3 Mar 2010 17:19:21 +1100
Message-Id: <1267597162-12092-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1267597162-12092-1-git-send-email-david@fromorbit.com>
References: <1267597162-12092-1-git-send-email-david@fromorbit.com>
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

When making a specifically sized scratch filesystem, we need to
calculate the size rather than assigning the caclculation expression
to a variable and passing that into the _scratch_mkfs_sized
function. Currently sized filesystems are failing to be made and the
code is falling back to full sized filesystems so we are not testing
enospc issues correctly.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 077 |    2 +-
 204 |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/077 b/077
index 72f1b2a..4e12163 100755
--- a/077
+++ b/077
@@ -62,7 +62,7 @@ rm -f $seq.full
 umount $SCRATCH_DEV >/dev/null 2>&1
 echo "*** MKFS ***"                         >>$seq.full
 echo ""                                     >>$seq.full
-let SIZE=50*1024*1024
+SIZE=`expr 50 \* 1024 \* 1024`
 _scratch_mkfs_sized $SIZE                   >>$seq.full 2>&1 \
 	|| _fail "mkfs failed"
 _scratch_mount                              >>$seq.full 2>&1 \
diff --git a/204 b/204
index 14ebcdc..8b94f60 100755
--- a/204
+++ b/204
@@ -40,7 +40,7 @@ _supported_os Linux
 
 _require_scratch
 
-SIZE=104*1024*1024
+SIZE=`expr 104 \* 1024 \* 1024`
 _scratch_mkfs_sized $SIZE  &> /dev/null
 _scratch_mount
 
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
