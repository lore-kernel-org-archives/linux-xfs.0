Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n462RlRC081314 for <xfs@oss.sgi.com>; Tue, 5 May 2009 21:27:47 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 74E842653BA
	for <xfs@oss.sgi.com>; Tue,  5 May 2009 19:27:26 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id dhaRzFjnlvm74qNc for
	<xfs@oss.sgi.com>; Tue, 05 May 2009 19:27:26 -0700 (PDT)
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by postoffice2.aconex.com (Spam Firewall) with ESMTP id DAC51524592
	for <xfs@oss.sgi.com>; Wed,  6 May 2009 12:27:17 +1000 (EST)
Received: from postoffice.aconex.com (postoffice.yarra.acx [192.168.102.1]) by
	postoffice2.aconex.com with ESMTP id 7AARmFNmNSRhdDc6 for
	<xfs@oss.sgi.com>; Wed, 06 May 2009 12:27:17 +1000 (EST)
Received: from gatekeeper.aconex.com (gatekeeper.yarra.acx [192.168.102.10])
	by postoffice.aconex.com (Postfix) with ESMTP id 1B7A52C042
	for <xfs@oss.sgi.com>; Wed,  6 May 2009 12:25:33 +1000 (EST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by gatekeeper.aconex.com (Postfix) with ESMTP id D974FC7BD2
	for <xfs@oss.sgi.com>; Wed,  6 May 2009 12:31:13 +1000 (EST)
Received: from gatekeeper.aconex.com ([127.0.0.1])
	by localhost (gatekeeper.aconex.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id UdtaG8z2I2lJ for <xfs@oss.sgi.com>;
	Wed,  6 May 2009 12:31:09 +1000 (EST)
Received: from mail-au.aconex.com (mail-au.aconex.com [192.168.102.12])
	by gatekeeper.aconex.com (Postfix) with ESMTP id 23A4CC7A0A
	for <xfs@oss.sgi.com>; Wed,  6 May 2009 12:31:09 +1000 (EST)
Date: Wed, 6 May 2009 12:27:12 +1000 (EST)
From: Nathan Scott <nscott@aconex.com>
Message-ID: <1955797473.4518331241576832973.JavaMail.root@mail-au.aconex.com>
Subject: [PATCH] xfsprogs man page errors
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Fixes up some errors reported by lintian... can someone ACK these,
& I'll commit 'em along with some Debian packaging updates needed
for the revamped build.

thanks.

-- 
Nathan

diff --git a/man/man8/xfs_estimate.8 b/man/man8/xfs_estimate.8
index 70a2ac6..bb458ec 100644
--- a/man/man8/xfs_estimate.8
+++ b/man/man8/xfs_estimate.8
@@ -101,4 +101,3 @@ directory                     bsize   blocks    megabytes    logsize
 % \f4xfs_estimate /var/tmp\f1\f7
 /var/tmp will take about 14.0 megabytes
 .fi
-.Ee
diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
index 08c354a..f3b54cc 100644
--- a/man/man8/xfs_quota.8
+++ b/man/man8/xfs_quota.8
@@ -619,7 +619,7 @@ of the tree, or if the inode flag is not set.
 .PP
 Option
 .B \-d
-can be used to limit recursion level (-1 is infinite, 0 is top level only,
+can be used to limit recursion level (\-1 is infinite, 0 is top level only,
 1 is first level ... ).
 Option
 .B \-p

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
