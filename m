Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n08LDhjq003816 for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 15:13:43 -0600
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 85A041BA1F78
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2009 13:13:42 -0800 (PST)
Received: from rv-out-0708.google.com (rv-out-0708.google.com
	[209.85.198.241]) by cuda.sgi.com with ESMTP id
	FLapJtkBKNyL9McJ for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2009 13:13:42 -0800 (PST)
Received: by rv-out-0708.google.com with SMTP id f25so8466473rvb.32
	for <xfs@oss.sgi.com>; Thu, 08 Jan 2009 13:13:41 -0800 (PST)
Date: Thu, 8 Jan 2009 13:13:34 -0800
From: Brandon Philips <brandon@ifup.org>
Subject: [PATCH] acl: add getfacl -R -L -P tests
Message-ID: <20090108211334.GC8749@jenkins.ifup.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Andreas =?iso-8859-1?Q?Gr=FCnbacher?= <agruen@suse.de>
Cc: xfs@oss.sgi.com

Oops, missed this one when I sent out the series.

Add tests against patches from Andreas to fix up walk_tree.c.

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 test/getfacl-recursive.test |  194 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 194 insertions(+)

Index: acl-2.2.47/test/getfacl-recursive.test
===================================================================
--- /dev/null
+++ acl-2.2.47/test/getfacl-recursive.test
@@ -0,0 +1,194 @@
+Tests for proper path recursion
+
+	$ mkdir -p 1/2/3
+	$ mkdir 1/link
+	$ touch 1/link/file
+	$ ln -s `pwd`/1/link 1/2/link
+	$ getfacl -P -R 1/2
+	> # file: 1/2
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rwx
+	> group::r-x
+	> other::r-x
+	>
+	> # file: 1/2/3
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rwx
+	> group::r-x
+	> other::r-x
+	>
+
+	$ getfacl -R 1/2
+	> # file: 1/2
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rwx
+	> group::r-x
+	> other::r-x
+	>
+	> # file: 1/2/3
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rwx
+	> group::r-x
+	> other::r-x
+	>
+
+	$ getfacl -R -L 1/2
+	> # file: 1/2
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rwx
+	> group::r-x
+	> other::r-x
+	>
+	> # file: 1/2/3
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rwx
+	> group::r-x
+	> other::r-x
+	>
+	> # file: 1/2/link
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rwx
+	> group::r-x
+	> other::r-x
+	>
+	> # file: 1/2/link/file
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rw-
+	> group::r--
+	> other::r--
+	>
+
+	$ getfacl -P -R 1
+	> # file: 1
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rwx
+	> group::r-x
+	> other::r-x
+	>
+	> # file: 1/2
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rwx
+	> group::r-x
+	> other::r-x
+	>
+	> # file: 1/2/3
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rwx
+	> group::r-x
+	> other::r-x
+	>
+	> # file: 1/link
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rwx
+	> group::r-x
+	> other::r-x
+	>
+	> # file: 1/link/file
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rw-
+	> group::r--
+	> other::r--
+	>
+
+	$ getfacl -R 1
+	> # file: 1
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rwx
+	> group::r-x
+	> other::r-x
+	>
+	> # file: 1/2
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rwx
+	> group::r-x
+	> other::r-x
+	>
+	> # file: 1/2/3
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rwx
+	> group::r-x
+	> other::r-x
+	>
+	> # file: 1/link
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rwx
+	> group::r-x
+	> other::r-x
+	>
+	> # file: 1/link/file
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rw-
+	> group::r--
+	> other::r--
+	>
+
+	$ getfacl -R -L 1
+	> # file: 1
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rwx
+	> group::r-x
+	> other::r-x
+	>
+	> # file: 1/2
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rwx
+	> group::r-x
+	> other::r-x
+	>
+	> # file: 1/2/3
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rwx
+	> group::r-x
+	> other::r-x
+	>
+	> # file: 1/2/link
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rwx
+	> group::r-x
+	> other::r-x
+	>
+	> # file: 1/2/link/file
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rw-
+	> group::r--
+	> other::r--
+	>
+	> # file: 1/link
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rwx
+	> group::r-x
+	> other::r-x
+	>
+	> # file: 1/link/file
+	> # owner: %TUSER
+	> # group: %TGROUP
+	> user::rw-
+	> group::r--
+	> other::r--
+	>
+
+	$ rm -R 1/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
