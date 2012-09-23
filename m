Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8NJNQOf026967 for <xfs@oss.sgi.com>; Sun, 23 Sep 2012 14:23:26 -0500
Received: from mail-lb0-f181.google.com (mail-lb0-f181.google.com
	[209.85.217.181]) by cuda.sgi.com with ESMTP id
	Bwb3dnBrz8XfV20T (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 23 Sep 2012 12:24:41 -0700 (PDT)
Received: by lbbgg6 with SMTP id gg6so1076235lbb.26
	for <xfs@oss.sgi.com>; Sun, 23 Sep 2012 12:24:39 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/6] xfstest: add fio git submodule
Date: Sun, 23 Sep 2012 23:24:31 +0400
Message-Id: <1348428276-13161-1-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <a>
References: <a>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, hch@lst.de, xfs@oss.sgi.com

FIO is very flexible io generator, i would call it IO swiss knife.
Currently we have tonnes of hardcoded application which reproduces
some predefined scenario. This approach has obvious dissadvantages
1) Lack of flexability: once written it is hard to modify it in future
2) Code base is large, many routines written again and again

At the same time add new fio based tast is just add simle INI file.
This greatly simplify code review. I do beleve that some day we will
replace most of hardcoded io binaries with fio.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 .gitmodules                  |    3 +++
 common.config                |    3 +++
 src/Makefile                 |    8 +++++---
 src/aio-dio-regress/Makefile |    4 ++--
 src/fio                      |    1 +
 5 files changed, 14 insertions(+), 5 deletions(-)
 create mode 100644 .gitmodules
 create mode 160000 src/fio

diff --git a/.gitmodules b/.gitmodules
new file mode 100644
index 0000000..f0481ea
--- /dev/null
+++ b/.gitmodules
@@ -0,0 +1,3 @@
+[submodule "src/fio"]
+	path = src/fio
+	url = git://git.kernel.dk/fio.git
diff --git a/common.config b/common.config
index 7bed1c5..25cddb4 100644
--- a/common.config
+++ b/common.config
@@ -138,6 +138,9 @@ export DF_PROG="`set_prog_path df`"
 [ "$DF_PROG" = "" ] && _fatal "df not found"
 [ "$HOSTOS" = "Linux" ] && export DF_PROG="$DF_PROG -T"
 
+export FIO_PROG="`set_prog_path $PWD/src/fio/fio`"
+[ "$FIO_PROG" = "" ] && _fatal "fio not found"
+
 export XFS_LOGPRINT_PROG="`set_prog_path xfs_logprint`"
 export XFS_REPAIR_PROG="`set_prog_path xfs_repair`"
 export XFS_CHECK_PROG="`set_prog_path xfs_check`"
diff --git a/src/Makefile b/src/Makefile
index 67250ee..255bdd4 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -52,16 +52,18 @@ LLDLIBS += $(LIBGDBM)
 endif
 
 ifeq ($(HAVE_AIO), true)
-SUBDIRS += aio-dio-regress
+SUBDIRS += aio-dio-regress \
+		fio
+
 endif
 
 CFILES = $(TARGETS:=.c)
 LDIRT = $(TARGETS)
 
 
-default: depend $(TARGETS) $(SUBDIRS)
+default: .depend $(TARGETS) $(SUBDIRS)
 
-depend: .dep
+.depend: .dep
 
 include $(BUILDRULES)
 
diff --git a/src/aio-dio-regress/Makefile b/src/aio-dio-regress/Makefile
index 79dd55d..fcead9a 100644
--- a/src/aio-dio-regress/Makefile
+++ b/src/aio-dio-regress/Makefile
@@ -8,9 +8,9 @@ LDIRT = $(TARGETS)
 
 LLDLIBS = -laio -lpthread
 
-default: depend $(TARGETS)
+default: .depend $(TARGETS)
 
-depend: .dep
+.depend: .dep
 
 include $(BUILDRULES)
 
diff --git a/src/fio b/src/fio
new file mode 160000
index 0000000..e12d280
--- /dev/null
+++ b/src/fio
@@ -0,0 +1 @@
+Subproject commit e12d2800f811cb64d376cfdaed9a1257f3fa9c99
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
