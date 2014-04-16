Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B8FA87F69
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 16:37:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 49D5FAC002
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 14:37:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DtnKBHQRNw2CnOtF for
	<xfs@oss.sgi.com>; Wed, 16 Apr 2014 14:37:30 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3GLbT5G031327
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 17:37:29 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s3GLbSmi002759
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 17:37:29 -0400
Message-ID: <534EF81D.20205@redhat.com>
Date: Wed, 16 Apr 2014 16:37:33 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: log running test to dmesg
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

We already log the running test to system logs via "logger"
but viro pointed out that we can use /dev/kmsg to insert it
into dmesg as well.  When looking at the serial console that
could be pretty useful.

Thanks to viro for the test -w suggestion too.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/check b/check
index 268417c..09b2320 100755
--- a/check
+++ b/check
@@ -457,6 +457,7 @@ do
 	$timestamp && echo -n "	["`date "+%T"`"]"
 	[ ! -x $seq ] && chmod u+x $seq # ensure we can run it
 	$LOGGER_PROG "run xfstest $seqnum"
+	test -w /dev/kmsg && echo "run xfstest $seqnum" > /dev/kmsg
 	./$seq >$tmp.rawout 2>&1
 	sts=$?
 	$timestamp && _timestamp


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
