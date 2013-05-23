Return-Path: <xfs-bounces@oss.sgi.com>
Received: from lnx-rjohnston2.americas.sgi.com
	(lnx-rjohnston2.americas.sgi.com [128.162.233.55])
	by oss.sgi.com (Postfix) with ESMTP id D0AB47F37
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 09:01:01 -0500 (CDT)
Received: from lnx-rjohnston2.americas.sgi.com (localhost [127.0.0.1])
	by lnx-rjohnston2.americas.sgi.com (8.14.4/8.14.4/Debian-2ubuntu2) with
	ESMTP id r4NE1mZu020101
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 09:01:48 -0500
Date: Thu, 23 May 2013 08:52:52 -0500
Message-Id: <20130523133837.333783222@sgi.com>
From: rjohnston@sgi.com
Subject: [PATCH V2] xfsprogs: libhandle/Makefile - fix make install-dev
References: <20130522205819.586978467@gulag1.americas.sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The dependency for install-dev: is incorrect "default" and prevents libhandle
from being installed correctly.

After make && make install-dev

  # ls -l /lib64/libhandle* /usr/lib64/libhandle*
  lrwxrwxrwx 1 root root /lib64/libhandle.a -> /usr/lib64/libhandle.a
  lrwxrwxrwx 1 root root /lib64/libhandle.la -> /usr/lib64/libhandle.la
  lrwxrwxrwx 1 root root /lib64/libhandle.so -> libhandle.so.1
  -rw-r--r-- 1 root root /usr/lib64/libhandle.a
  -rw-r--r-- 1 root root /usr/lib64/libhandle.la
  lrwxrwxrwx 1 root root /usr/lib64/libhandle.so -> /lib64/libhandle.so

The shared library /lib64/libhandle.so.1.0.3 is not installed and
the link /lib64/libhandle.so.1 -> libhandle.so.1.0.3 is not created.

Change the dependency for install-dev: to "install" so the install looks like
this.

  # ls -l /lib64/libhandle* /usr/lib64/libhandle*
  lrwxrwxrwx 1 root root /lib64/libhandle.a -> /usr/lib64/libhandle.a
  lrwxrwxrwx 1 root root /lib64/libhandle.la -> /usr/lib64/libhandle.la
  lrwxrwxrwx 1 root root /lib64/libhandle.so -> libhandle.so.1
  lrwxrwxrwx 1 root root /lib64/libhandle.so.1 -> libhandle.so.1.0.3
  -rwxr-xr-x 1 root root /lib64/libhandle.so.1.0.3
  -rw-r--r-- 1 root root /usr/lib64/libhandle.a
  -rw-r--r-- 1 root root /usr/lib64/libhandle.la
  lrwxrwxrwx 1 root root /usr/lib64/libhandle.so -> /lib64/libhandle.so

Signed-off-by: Rich Johnston <rjohnston@sgi.com>
--
V1->V2
As Dave pointed out removing the ltdepend would prevent proper rebuilds.
Don't just make the install work ;) correct the dependency for install-dev.

diff --git a/libhandle/Makefile b/libhandle/Makefile
index 865ca22..081a386 100644
--- a/libhandle/Makefile
+++ b/libhandle/Makefile
@@ -22,7 +22,7 @@ include $(BUILDRULES)
 install: default
 	$(INSTALL_LTLIB)
 
-install-dev: default
+install-dev: install
 	$(INSTALL_LTLIB_DEV)
 
 install-qa: install-dev


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
