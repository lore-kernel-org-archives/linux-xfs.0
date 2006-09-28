Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Sep 2006 19:07:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8S27caG001649
	for <xfs@oss.sgi.com>; Wed, 27 Sep 2006 19:07:39 -0700
Received: from prod.aconex.com (mail.app.aconex.com [203.89.192.138])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7DA05D112418
	for <xfs@oss.sgi.com>; Wed, 27 Sep 2006 17:55:38 -0700 (PDT)
Received: from page.mel.office.aconex.com (unknown [192.168.0.210])
	by prod.aconex.com (Postfix) with ESMTP id C14AF289B5
	for <xfs@oss.sgi.com>; Thu, 28 Sep 2006 10:55:33 +1000 (EST)
Received: from localhost (page.mel.aconex.com [127.0.0.1])
	by page.mel.office.aconex.com (Postfix) with ESMTP id A2DA353403A
	for <xfs@oss.sgi.com>; Thu, 28 Sep 2006 10:55:33 +1000 (EST)
Received: from page.mel.office.aconex.com ([127.0.0.1])
 by localhost (mail.aconex.com [127.0.0.1]) (amavisd-new, port 10024)
 with LMTP id 30205-01-25 for <xfs@oss.sgi.com>;
 Thu, 28 Sep 2006 10:55:32 +1000 (EST)
Received: from edge (unknown [192.168.0.246])
	by page.mel.office.aconex.com (Postfix) with ESMTP id AD9AF534039
	for <xfs@oss.sgi.com>; Thu, 28 Sep 2006 10:55:31 +1000 (EST)
Subject: [PATCH] fix xfs_admin command PATH
From: Nathan Scott <nathans@xfs.org>
Content-Type: multipart/mixed; boundary="=-gmm4poRh7ZPYp3P0vKCl"
Date: Thu, 28 Sep 2006 10:53:36 +1000
Message-Id: <1159404816.3497.15.camel@edge>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--=-gmm4poRh7ZPYp3P0vKCl
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

I noticed an error labelling a filesystem on Fedora the other day,
this should fix it.  Possibly other scripts are affected, dunno -
the problem occurs when /usr/sbin is not in the PATH (it typically
happens after a su to root).

cheers.

--
Nathan


--=-gmm4poRh7ZPYp3P0vKCl
Content-Disposition: attachment; filename=admin.patch
Content-Type: text/x-patch; name=admin.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- /fedora/usr/sbin/xfs_admin.orig	2006-09-26 16:01:10.000000000 +1000
+++ /fedora/usr/sbin/xfs_admin	2006-09-26 16:01:47.000000000 +1000
@@ -33,6 +33,7 @@
 
 OPTS=""
 USAGE="Usage: xfs_admin [-efluV] [-L label] [-U uuid] special"
+export PATH="/sbin:/usr/sbin:$PATH"
 
 while getopts "efluL:U:V" c
 do

--=-gmm4poRh7ZPYp3P0vKCl--
