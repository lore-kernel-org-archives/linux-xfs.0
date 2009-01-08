Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n082929G024428 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 20:09:02 -0600
Received: from rv-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DCE36E0FF
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2009 18:09:01 -0800 (PST)
Received: from rv-out-0506.google.com (rv-out-0506.google.com
	[209.85.198.237]) by cuda.sgi.com with ESMTP id
	xjBFwYumgDWc1YSB for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2009 18:09:01 -0800 (PST)
Received: by rv-out-0506.google.com with SMTP id f9so7323435rvb.2
	for <xfs@oss.sgi.com>; Wed, 07 Jan 2009 18:09:01 -0800 (PST)
Message-Id: <20090108015419.298358378@ifup.org>
Date: Wed, 07 Jan 2009 17:54:00 -0800
From: brandon@ifup.org
Subject: [patch 5/5] [PATCH] acl: minor fix to cp.test
References: <20090108015355.613058570@ifup.org>
Content-Disposition: inline; filename=acl-minor-fix-to-cp.test.patch
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
To: tes@sgi.com
Cc: Brandon Philips <bphilips@suse.de>, xfs@oss.sgi.com

X -> x

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 test/cp.test |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: acl-2.2.47/test/cp.test
===================================================================
--- acl-2.2.47.orig/test/cp.test
+++ acl-2.2.47/test/cp.test
@@ -24,7 +24,7 @@ The cp utility should only copy ACLs if
 	> blubb
 
 	$ rm -r i
-	$ setfacl -R -m u:bin:rwX h
+	$ setfacl -R -m u:bin:rwx h
 	$ getfacl --omit-header h/x
 	> user::rw-
 	> user:bin:rwx

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
