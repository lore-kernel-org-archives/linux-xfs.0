Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6JHvGvi238472
	for <linux-xfs@oss.sgi.com>; Sun, 19 Jul 2009 12:57:18 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C70037083C
	for <linux-xfs@oss.sgi.com>; Sun, 19 Jul 2009 10:57:57 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.186]) by cuda.sgi.com with ESMTP id
	BZqEPs2D0vUOECY0 for <linux-xfs@oss.sgi.com>;
	Sun, 19 Jul 2009 10:57:57 -0700 (PDT)
Received: from localhost.housecafe.de ([127.0.0.1] helo=localhost)
	by bogon with esmtp (Exim 4.69)
	(envelope-from <lists@nerdbynature.de>) id 1MSadt-0004H8-Ev
	for linux-xfs@oss.sgi.com; Sun, 19 Jul 2009 19:57:45 +0200
Date: Sun, 19 Jul 2009 10:57:35 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: xfstests: nslookup not found
Message-ID: <alpine.DEB.2.01.0907191050010.6439@bogon>
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
To: linux-xfs@oss.sgi.com

Hi,

while trying to run ./check in a current xfstests tree, execution stopped 
because "nslookup" was not available. I could've just installed this tool 
but I wondered why xfstests, a filesystem testing tool, would need 
nslookup at all. Turns out that it's being used in a routine called 
"_get_fqdn", which in turn is only called once in ./new, to set a variable 
called "owner" and I ask myself: do I really want my FQDN listed in the 
testresults, that maybe even get published for analysis? I changed this 
whole _get_fqdn thingy to just "uname -n", but I'm eager to know why the 
FQDN is crucial here :-)

Thoughts?

Christian.


--- common.config.orig	2009-07-19 13:39:54.000000000 +0200
+++ common.config	2009-07-19 13:46:31.000000000 +0200
@@ -120,9 +120,6 @@ export UMOUNT_PROG="`set_prog_path umoun
 export FSSTRESS_PROG="`set_prog_path fsstress $PWD/ltp/fsstress`"
 [ "$FSSTRESS_PROG" = "" ] && _fatal "fsstress not found"
 
-export NSLOOKUP_PROG="`set_prog_path nslookup`"
-[ "$NSLOOKUP_PROG" = "" ] && _fatal "nslookup not found"
-
 export PERL_PROG="`set_prog_path perl`"
 [ "$PERL_PROG" = "" ] && _fatal "perl not found"
 
--- common.rc.orig	2009-07-19 13:41:43.000000000 +0200
+++ common.rc	2009-07-19 19:44:26.000000000 +0200
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
--- new.orig	2009-07-19 19:44:52.000000000 +0200
+++ new	2009-07-19 19:46:38.000000000 +0200
@@ -105,7 +105,7 @@ cat <<End-of-File >$id
 #-----------------------------------------------------------------------
 #
 # creator
-owner=$USER@`_get_fqdn`
+owner=$USER@`uname -n`
 
 seq=\`basename \$0\`
 echo "QA output created by \$seq"
-- 
BOFH excuse #4:

static from nylon underwear

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
