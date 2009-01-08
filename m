Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n082LOIf025721 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 20:21:24 -0600
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 70AFA6E2C0
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2009 18:21:24 -0800 (PST)
Received: from rv-out-0708.google.com (rv-out-0708.google.com
	[209.85.198.246]) by cuda.sgi.com with ESMTP id
	RXiSQNhmT7jo1Y4U for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2009 18:21:24 -0800 (PST)
Received: by rv-out-0708.google.com with SMTP id f25so8074933rvb.32
	for <xfs@oss.sgi.com>; Wed, 07 Jan 2009 18:21:24 -0800 (PST)
Message-Id: <20090108022109.434435659@ifup.org>
Date: Wed, 07 Jan 2009 18:19:51 -0800
From: brandon@ifup.org
Subject: [patch 4/4] [PATCH] attr: Tests for path recursion with -L -P -R
References: <20090108021947.404730068@ifup.org>
Content-Disposition: inline;
	filename=attr-tests-for-path-recursion-with-l-p-r.patch
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
Cc: Brandon Philips <bphilips@suse.de>

Add tests against patches from Andreas to fix up walk_tree.c.

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 test/attr.test |  116 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)

Index: attr-2.4.43/test/attr.test
===================================================================
--- attr-2.4.43.orig/test/attr.test
+++ attr-2.4.43/test/attr.test
@@ -253,3 +253,119 @@ Tests for attribute names that contains
 
 	$ cd ..
 	$ rm -rf d
+
+Tests for proper path recursion reported by Tony Ernst <tee@sgi.com> bnc#457660
+
+	$ mkdir -p 1/2/3
+	$ setfattr -n "user.9" 1
+	$ setfattr -n "user.a" 1
+	$ setfattr -n "user.9" 1/2
+	$ setfattr -n "user.a" 1/2
+	$ setfattr -n "user.9" 1/2/3
+	$ setfattr -n "user.a" 1/2/3
+
+	$ getfattr -h -L -R -m '.' -e hex 1
+	> # file: 1
+	> user.9
+	> user.a
+	>
+	> # file: 1/2
+	> user.9
+	> user.a
+	>
+	> # file: 1/2/3
+	> user.9
+	> user.a
+	>
+
+	$ getfattr -h -P -R -m '.' -e hex 1/2
+	> # file: 1/2
+	> user.9
+	> user.a
+	>
+	> # file: 1/2/3
+	> user.9
+	> user.a
+	>
+
+	$ rm -R 1
+
+Test for proper recursion of directory structures with -L -P -R
+
+	$ mkdir -p 1/sub
+	$ mkdir 1/link
+	$ touch 1/link/link-file
+	$ touch 1/sub/sub-file
+	$ ln -s `pwd`/1/link 1/sub/link
+	$ setfattr -n "user.a" 1
+	$ setfattr -n "user.a" 1/link/link-file
+	$ setfattr -n "user.a" 1/link
+	$ setfattr -n "user.a" 1/sub/sub-file
+	$ setfattr -n "user.a" 1/sub
+	$ getfattr -P -R 1
+	> # file: 1
+	> user.a
+	>
+	> # file: 1/sub
+	> user.a
+	>
+	> # file: 1/sub/link
+	> user.a
+	>
+	> # file: 1/sub/sub-file
+	> user.a
+	>
+	> # file: 1/link
+	> user.a
+	>
+	> # file: 1/link/link-file
+	> user.a
+	>
+	$ getfattr -R -P 1/sub
+	> # file: 1/sub
+	> user.a
+	>
+	> # file: 1/sub/link
+	> user.a
+	>
+	> # file: 1/sub/sub-file
+	> user.a
+	>
+	$ getfattr -L -R 1
+	> # file: 1
+	> user.a
+	>
+	> # file: 1/sub
+	> user.a
+	>
+	> # file: 1/sub/link
+	> user.a
+	>
+	> # file: 1/sub/link/link-file
+	> user.a
+	>
+	> # file: 1/sub/sub-file
+	> user.a
+	>
+	> # file: 1/link
+	> user.a
+	>
+	> # file: 1/link/link-file
+	> user.a
+	>
+	$ getfattr -R 1/sub/link
+	> # file: 1/sub/link
+	> user.a
+	>
+	> # file: 1/sub/link/link-file
+	> user.a
+	>
+	$ getfattr -L -R 1/sub/link
+	> # file: 1/sub/link
+	> user.a
+	>
+	> # file: 1/sub/link/link-file
+	> user.a
+	>
+
+	$ rm -R 1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
