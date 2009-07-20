Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6K1jngN006802
	for <linux-xfs@oss.sgi.com>; Sun, 19 Jul 2009 20:45:50 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DC75A99A8C
	for <linux-xfs@oss.sgi.com>; Sun, 19 Jul 2009 18:54:30 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.177]) by cuda.sgi.com with ESMTP id
	AADSetCenGfx6DiG for <linux-xfs@oss.sgi.com>;
	Sun, 19 Jul 2009 18:54:30 -0700 (PDT)
Date: Sun, 19 Jul 2009 18:46:25 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: [PATCH] don't fail if nslookup is not found (was: xfstests: nslookup
	not found)
In-Reply-To: <20090720001637.GA31674@infradead.org>
Message-ID: <alpine.DEB.2.01.0907191840150.6439@bogon>
References: <alpine.DEB.2.01.0907191050010.6439@bogon>
	<20090719182012.GA10936@infradead.org>
	<alpine.DEB.2.01.0907191653240.6439@bogon>
	<20090720001637.GA31674@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@oss.sgi.com

On Sun, 19 Jul 2009 at 20:16, Christoph Hellwig wrote:
> Yes, that's exactly it.  Can you resend it with a proper subject,
> description and add your Signed-off-by tag?


When nslookup is not available, execution would stop. This patch moves the 
check for nslookup and the _get_fqdn function into the ./new script (since 
this is the only place where it's used) and we don't fail any more but try 
to find out our FQDN without nslookup.

Signed-off-by: Christian Kujau <lists@nerdbynature.de>

--- common.config.orig	2009-07-19 21:43:15.000000000 +0200
+++ common.config	2009-07-19 21:43:31.000000000 +0200
@@ -120,9 +120,6 @@ export UMOUNT_PROG="`set_prog_path umoun
 export FSSTRESS_PROG="`set_prog_path fsstress $PWD/ltp/fsstress`"
 [ "$FSSTRESS_PROG" = "" ] && _fatal "fsstress not found"
 
-export NSLOOKUP_PROG="`set_prog_path nslookup`"
-[ "$NSLOOKUP_PROG" = "" ] && _fatal "nslookup not found"
-
 export PERL_PROG="`set_prog_path perl`"
 [ "$PERL_PROG" = "" ] && _fatal "perl not found"
 
--- common.rc.orig	2009-07-19 21:44:42.000000000 +0200
+++ common.rc	2009-07-19 21:45:06.000000000 +0200
@@ -330,14 +330,6 @@ _get_pids_by_name()
 	-e "/[0-9]:[0-9][0-9]  *$1 /s/ .*//p"
 }
 
-# fqdn for localhost
-#
-_get_fqdn()
-{
-    host=`hostname`
-    $NSLOOKUP_PROG $host | $AWK_PROG '{ if ($1 == "Name:") print $2 }'
-}
-
 # fix malloc libs output
 #
 _fix_malloc()
--- new.orig	2009-07-19 21:43:20.000000000 +0200
+++ new	2009-07-20 01:45:51.000000000 +0200
@@ -32,6 +32,17 @@ _cleanup()
     :
 }
 
+# fqdn for localhost
+_get_fqdn()
+{
+    NSLOOKUP_PROG="`set_prog_path nslookup`"
+    if [ "$NSLOOKUP_PROG" = "" ]; then
+	getent hosts `uname -n` | awk '{print $2}'
+    else
+	$NSLOOKUP_PROG `hostname` | $AWK_PROG '{ if ($1 == "Name:") print $2 }'
+    fi
+}
+
 if [ ! -f group ]
 then
     echo "Creating the group index ..."


-- 
BOFH excuse #334:

50% of the manual is in .pdf readme files

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
