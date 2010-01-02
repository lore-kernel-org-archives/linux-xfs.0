Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o02MFLdd163739 for <xfs@oss.sgi.com>; Sat, 2 Jan 2010 16:15:21 -0600
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1497A1DAC2C4
	for <xfs@oss.sgi.com>; Sat,  2 Jan 2010 14:16:10 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.187]) by cuda.sgi.com with ESMTP id
	FQsXRdoEBAcxcPWz for <xfs@oss.sgi.com>;
	Sat, 02 Jan 2010 14:16:10 -0800 (PST)
Received: from localhost ([127.0.0.1])
	by bogon.housecafe.de with esmtp (Exim 4.69)
	(envelope-from <lists@nerdbynature.de>) id 1NRCGW-0001Sm-4i
	for xfs@oss.sgi.com; Sat, 02 Jan 2010 23:16:08 +0100
Date: Sat, 2 Jan 2010 14:16:08 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: [PATCH] use CFLAGS in src/Makefile
Message-ID: <alpine.DEB.2.01.1001021409290.3483@bogon.housecafe.de>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

Hi,

while compiling xfstests after configuring with a different CFLAGS value, 
gcc fails in ./src:

[...]
make[2]: Entering directory `/usr/local/src/xfstests-git/src'
gcc -g -O2 -DDEBUG  -I../include -DVERSION=\"1.0.0\" -L/opt/xfsprogs/lib  
-DREAD iopat.c -o preallo_rw_pattern_reader
iopat.c:21:21: error: xfs/xfs.h: No such file or directory
[...]

Somehow CFLAGS isn't passed to gcc, but "GCFLAGS" is. I'm not too savvy 
with the xfstests build system, but in include/builddefs.in we see:

   # Global, Platform, Local CFLAGS
   CFLAGS += $(GCFLAGS) $(PCFLAGS) $(LCFLAGS)

...thus I'm proposing the following fix:


--- xfstests-git/src/Makefile.orig	2010-01-02 14:01:32.692011000 -0800
+++ xfstests-git/src/Makefile	2010-01-02 14:04:13.352011000 -0800
@@ -97,10 +97,10 @@ dmiperf: dmiperf.o
 	$(LINKTEST) $(LIBATTR) $(LDLIBS)
 
 preallo_rw_pattern_reader:
-	$(CC) $(GCFLAGS) $(LDFLAGS) -DREAD iopat.c -o preallo_rw_pattern_reader
+	$(CC) $(CFLAGS) $(LDFLAGS) -DREAD iopat.c -o preallo_rw_pattern_reader
 
 preallo_rw_pattern_writer:
-	$(CC) $(GCFLAGS) $(LDFLAGS) -DWRITE iopat.c -o preallo_rw_pattern_writer
+	$(CC) $(CFLAGS) $(LDFLAGS) -DWRITE iopat.c -o preallo_rw_pattern_writer
 
 ftrunc: ftrunc.o
 	$(LINKTEST)


Thanks,
Christian.
-- 
BOFH excuse #267:

The UPS is on strike.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
