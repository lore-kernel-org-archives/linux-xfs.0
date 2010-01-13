Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0D3oUXW112059 for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 21:50:30 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D39D91246F9C
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 19:51:25 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id 9yY1PTdFDLnDzSLp for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2010 19:51:25 -0800 (PST)
Message-ID: <4B4D433C.7080501@sandeen.net>
Date: Tue, 12 Jan 2010 21:51:24 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: Make the compile output cleaner
References: <1263350021-5733-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1263350021-5733-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> We don't need to see every compiler command line for every file that
> is compiled. This makes it hard to see warnings and errors during
> compile. For progress notification, we really only need to see the
> diretory/file being operated on.
>
> Turn down the verbosity of output by suppressing various make output
> and provide better overall visibility of which directory is being
> operated on, what the operation is and what is being done to the
> files by the build/clean process.
>
> Sample output from a build:
>
> ....
> Building libxlog
>     [CC] xfs_log_recover.c
>     [CC] util.c
>     [LD] libxlog.la
>   

...

swanky!

What would you think of this on top of it, ripped straight from
kbuild - that way "make V=1" works the same way as kbuild, but
the default is still to be quiet.

Also, just to show my kbuild bias, maybe consider outputting the target
on the quiet line, instead of the source?  :)  But no biggie.

-Eric



diff --git a/Makefile b/Makefile
index 2fbfb51..46e6a3e 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,20 @@
 #
 # Copyright (c) 2000-2006 Silicon Graphics, Inc.  All Rights Reserved.
 #
-Q ?= @
+
+ifeq ("$(origin V)", "command line")
+  BUILD_VERBOSE = $(V)
+endif
+ifndef BUILD_VERBOSE
+  BUILD_VERBOSE = 0
+endif
+
+ifeq ($(BUILD_VERBOSE),1)
+  Q =
+else
+  Q = @
+endif
+
 MAKEOPTS = --no-print-directory Q=$(Q)
 
 TOPDIR = .
diff --git a/include/buildrules b/include/buildrules
index a0c77a9..72edc69 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -50,11 +50,11 @@ $(LTLIBRARY) : $(SUBDIRS) $(LTOBJECTS)
 	$(Q)$(LTLINK) $(LTLDFLAGS) -o $(LTLIBRARY) $(LTOBJECTS) $(LTLIBS)
 
 %.lo: %.c
-	@echo "    [CC] $<"
+	@echo "    [CC] $@"
 	$(Q)$(LTCOMPILE) -c $<
 else
 %.o: %.c
-	@echo "    [CC] $<"
+	@echo "    [CC] $@"
 	$(Q)$(CC) $(CFLAGS) -c $<
 
 endif


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
