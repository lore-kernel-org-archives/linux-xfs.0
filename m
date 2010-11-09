Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA9Bu7ch152342 for <xfs@oss.sgi.com>; Tue, 9 Nov 2010 05:56:08 -0600
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F92C1C27E10
	for <xfs@oss.sgi.com>; Tue,  9 Nov 2010 03:57:34 -0800 (PST)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id Mf6hntCUF226hmuM for
	<xfs@oss.sgi.com>; Tue, 09 Nov 2010 03:57:34 -0800 (PST)
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by postoffice2.aconex.com (Spam & Virus Firewall) with ESMTP id
	DE8BB5835BB
	for <xfs@oss.sgi.com>; Tue,  9 Nov 2010 22:57:13 +1100 (EST)
Received: from postoffice.aconex.com (postoffice.yarra.acx [192.168.102.1]) by
	postoffice2.aconex.com with ESMTP id n3wNxQ2C809CmVzg for
	<xfs@oss.sgi.com>; Tue, 09 Nov 2010 22:57:13 +1100 (EST)
Received: from gatekeeper.aconex.com (gatekeeper.yarra.acx [192.168.102.10])
	by postoffice.aconex.com (Postfix) with ESMTP id CDE3BA5011D
	for <xfs@oss.sgi.com>; Tue,  9 Nov 2010 22:57:13 +1100 (EST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by gatekeeper.aconex.com (Postfix) with ESMTP id C8A3F9D0001
	for <xfs@oss.sgi.com>; Tue,  9 Nov 2010 22:57:13 +1100 (EST)
Received: from gatekeeper.aconex.com ([127.0.0.1])
	by localhost (gatekeeper.aconex.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id KFFC19mlU37m for <xfs@oss.sgi.com>;
	Tue,  9 Nov 2010 22:56:58 +1100 (EST)
Received: from acxmail-au2.aconex.com (acxmail-au2.aconex.com [192.168.102.14])
	by gatekeeper.aconex.com (Postfix) with ESMTP id 0C8BA9D0002
	for <xfs@oss.sgi.com>; Tue,  9 Nov 2010 22:56:58 +1100 (EST)
Date: Tue, 9 Nov 2010 22:56:58 +1100 (EST)
From: nathans@debian.org
Message-ID: <1431731622.18831289303817979.JavaMail.root@acxmail-au2.aconex.com>
In-Reply-To: <1189766076.18791289303743211.JavaMail.root@acxmail-au2.aconex.com>
Subject: [PATCH 1/2] xfsprogs: fix debian upgrade issue
MIME-Version: 1.0
Reply-To: Nathan Scott <nathans@debian.org>
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
To: xfs <xfs@oss.sgi.com>

Fix xfs_estimate issue upgrading xfsprogs/xfsdump from lenny
    
Fix bug "xfsprogs: file conflict when upgrading from lenny":
add 'Replaces: xfsdump (<< 3.0.0); thanks to Vagrant Cascadian
for the analysis.
    
Signed-off-by: Gregor Herrman <gregoa@debian.org>
Reviewed-by: Nathan Scott <nathans@debian.org>

diff --git a/debian/control b/debian/control
index 652ffcb..f429434 100644
--- a/debian/control
+++ b/debian/control
@@ -12,6 +12,7 @@ Depends: ${shlibs:Depends}, ${misc:Depends}
 Provides: fsck-backend
 Suggests: xfsdump, acl, attr, quota
 Breaks: xfsdump (<< 3.0.0)
+Replaces: xfsdump (<< 3.0.0)
 Architecture: any
 Description: Utilities for managing the XFS filesystem
  A set of commands to use the XFS filesystem, including mkfs.xfs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
