Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB6DcDCb018127 for <xfs@oss.sgi.com>; Sat, 6 Dec 2008 07:38:14 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2632C1B2DC6B
	for <xfs@oss.sgi.com>; Sat,  6 Dec 2008 05:38:11 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id zECBS3FjMrRaIhuz for <xfs@oss.sgi.com>;
	Sat, 06 Dec 2008 05:38:11 -0800 (PST)
Message-ID: <493A8042.60700@sandeen.net>
Date: Sat, 06 Dec 2008 07:38:10 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] fix up xfs-cmds build after the parallel-fest
References: <49396528.1090700@sandeen.net>	<20081205173716.GA8216@infradead.org>
	<20081206102415.GA28776@infradead.org>
In-Reply-To: <20081206102415.GA28776@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig wrote:

> On Fri, Dec 05, 2008 at 12:37:16PM -0500, Christoph Hellwig wrote:
>   
>> Thanks, this fixes the dpkg build for me.
>>     
>
> But it misses one hunk to fix the attr build, too:
>   
Grr, quilt is nice exept for that pesky quilt add step.  :)

================================================================

My big parallel build patch lost the "make configure" target.
This broke Makepkgs...

Now, IMHO, running configure from make is a little bass-ackwards;
I'd probably prefer to have Makepkgs explicitly run:

 autoconf; configure --myoptions; make

but for now, this adds back in a workable "make configure" target.
This time, for attr as well!

Also fixed "make install-lib" for acl, which was failing
in the man subdir.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfs-cmds/acl/Makefile
===================================================================
--- xfs-cmds.orig/acl/Makefile	2008-12-05 10:42:40.000000000 -0600
+++ xfs-cmds/acl/Makefile	2008-12-05 10:46:04.977513746 -0600
@@ -38,7 +38,7 @@ else
 clean:	# if configure hasn't run, nothing to clean
 endif
 
-include/builddefs:
+configure include/builddefs:
 	autoconf
 	./configure \
 		--prefix=/ \
Index: xfs-cmds/acl/man/Makefile
===================================================================
--- xfs-cmds.orig/acl/man/Makefile	2008-12-05 10:42:40.000000000 -0600
+++ xfs-cmds/acl/man/Makefile	2008-12-05 10:48:20.842513303 -0600
@@ -13,10 +13,15 @@ install : $(addsuffix -install,$(SUBDIRS
 
 install-dev : $(addsuffix -install-dev,$(SUBDIRS))
 
+install-lib: $(addsuffix -install-lib,$(SUBDIRS))
+
 %-install:
 	$(MAKE) -C $* install
 
 %-install-dev:
 	$(MAKE) -C $* install-dev
 
+%-install-lib:
+	$(MAKE) -C $* install-lib
+
 include $(BUILDRULES)
Index: xfs-cmds/attr/Makefile
===================================================================
--- xfs-cmds.orig/attr/Makefile	2008-12-06 07:35:37.000000000 -0600
+++ xfs-cmds/attr/Makefile	2008-12-06 07:35:46.973512932 -0600
@@ -39,7 +39,7 @@ else
 clean:	# if configure hasn't run, nothing to clean
 endif
 
-include/builddefs:
+configure include/builddefs:
 	autoconf
 	./configure \
 		--prefix=/ \
Index: xfs-cmds/dmapi/Makefile
===================================================================
--- xfs-cmds.orig/dmapi/Makefile	2008-12-06 07:35:27.500512631 -0600
+++ xfs-cmds/dmapi/Makefile	2008-12-06 07:35:51.122575385 -0600
@@ -36,7 +36,7 @@ else
 clean:	# if configure hasn't run, nothing to clean
 endif
 
-include/builddefs:
+configure include/builddefs:
 	autoconf
 	./configure \
 		--prefix=/ \
Index: xfs-cmds/xfsprogs/Makefile
===================================================================
--- xfs-cmds.orig/xfsprogs/Makefile	2008-12-06 07:35:25.450513137 -0600
+++ xfs-cmds/xfsprogs/Makefile	2008-12-06 07:35:52.019575218 -0600
@@ -44,7 +44,7 @@ else
 clean:	# if configure hasn't run, nothing to clean
 endif
 
-include/builddefs:
+configure include/builddefs:
 	autoconf
 	./configure \
 		--prefix=/ \
Index: xfs-cmds/xfsdump/Makefile
===================================================================
--- xfs-cmds.orig/xfsdump/Makefile	2008-12-06 07:35:23.576512995 -0600
+++ xfs-cmds/xfsdump/Makefile	2008-12-06 07:35:52.598575866 -0600
@@ -37,7 +37,7 @@ else
 clean:	# if configure hasn't run, nothing to clean
 endif
 
-include/builddefs:
+configure include/builddefs:
 	autoconf
 	./configure \
 		--prefix=/ \
Index: xfs-cmds/nfs4acl/Makefile
===================================================================
--- xfs-cmds.orig/nfs4acl/Makefile	2008-12-06 07:35:21.142512675 -0600
+++ xfs-cmds/nfs4acl/Makefile	2008-12-06 07:35:53.473513505 -0600
@@ -39,7 +39,7 @@ else
 clean:	# if configure hasn't run, nothing to clean
 endif
 
-include/builddefs:
+configure include/builddefs:
 	autoconf
 	./configure \
 		--prefix=/ \
Index: xfs-cmds/xfstests/Makefile
===================================================================
--- xfs-cmds.orig/xfstests/Makefile	2008-12-06 07:35:21.141513154 -0600
+++ xfs-cmds/xfstests/Makefile	2008-12-06 07:35:53.473513505 -0600
@@ -42,7 +42,7 @@ else
 clean:  # if configure hasn't run, nothing to clean
 endif
 
-include/builddefs:
+configure include/builddefs:
 	autoheader
 	autoconf
 	./configure \

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
