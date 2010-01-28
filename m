Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0SGtNXM038860 for <xfs@oss.sgi.com>; Thu, 28 Jan 2010 10:55:24 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5776FF63E0E
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2010 08:56:28 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id B1wevdv9j1CQ4Nc6 for
	<xfs@oss.sgi.com>; Thu, 28 Jan 2010 08:56:28 -0800 (PST)
Received: from Liberator.local (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 5B76C9E7274
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2010 10:56:28 -0600 (CST)
Message-ID: <4B61C1BC.4050800@sandeen.net>
Date: Thu, 28 Jan 2010 10:56:28 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: filter selinux output in _acl_ls
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
To: xfs-oss <xfs@oss.sgi.com>

When selinux is on, ls -l gives us a "." to indicate selinux
attrs, which breaks some tests:

 === Test minimal ACE ===
 Setup file
--rwxrw-r-- id1 id2 file1
+-rwxrw-r--. id1 id2 file1

so filter that out.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfstests/common.attr
===================================================================
--- xfstests.orig/common.attr
+++ xfstests/common.attr
@@ -58,7 +58,10 @@ _acl_filter_id()
 #
 _acl_ls()
 {
-    ls -ln $* | awk '{ print $1, $3, $4, $NF }' | _acl_filter_id
+    ls -ln $* |	\
+    sed "s/\(.*\)\. /\1 /" | \
+    awk '{ print $1, $3, $4, $NF }' | \
+    _acl_filter_id
 } 
 
 #

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
