Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBUIElrB000556 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 12:14:49 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 415921797FF8
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 10:14:46 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id ItP6JaWeyTAHdasR for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 10:14:46 -0800 (PST)
Message-Id: <20081230181446.216372641@sandeen.net>
References: <20081230181413.518122170@sandeen.net>
Date: Tue, 30 Dec 2008 12:14:15 -0600
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [patch 2/4] acl: fix setfacl segfault when using only "--" as
	parameter.
Content-Disposition: inline; filename=acl-2.2.39-segfault.patch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

Resolves Red Hat bug:
 430458 - execute command "setfacl -- --test" will occur Segmentation Fault

From: Jiri Moskovcak <jmoskovc@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: xfs-cmds/acl/setfacl/setfacl.c
===================================================================
--- xfs-cmds.orig/acl/setfacl/setfacl.c
+++ xfs-cmds/acl/setfacl/setfacl.c
@@ -599,6 +599,8 @@ int main(int argc, char *argv[])
 		}
 	}
 	while (optind < argc) {
+		if(!seq)
+			goto synopsis;
 		if (seq_empty(seq))
 			goto synopsis;
 		saw_files = 1;

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
