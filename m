Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 May 2008 23:10:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4M6AZLm018207
	for <xfs@oss.sgi.com>; Wed, 21 May 2008 23:10:36 -0700
Date: Thu, 22 May 2008 16:11:20 +1000
From: David Chinner <dgc@sgi.com>
Subject: [patch] xfsqa 078 - use rmdir to remove directories 
Message-ID: <20080522061120.GP173056135@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


If test 078 fails and you try to run it again immediately, it
will execute a 'rm -f' on a directory which will fail. This should
be a rmdir....

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 xfstests/078 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: xfs-cmds/xfstests/078
===================================================================
--- xfs-cmds.orig/xfstests/078	2008-03-20 09:10:02.000000000 +1100
+++ xfs-cmds/xfstests/078	2008-05-15 23:21:58.192413673 +1000
@@ -50,8 +50,8 @@ _filter_io()
 # real QA test starts here
 
 echo "*** create loop mount point"
-rm -f $LOOP_MNT 2>/dev/null
-mkdir $LOOP_MNT || _fail "cannot create loopback mount point"
+rmdir $LOOP_MNT 2>/dev/null
+mkdir -p $LOOP_MNT || _fail "cannot create loopback mount point"
 
 _grow_loop()
 {
