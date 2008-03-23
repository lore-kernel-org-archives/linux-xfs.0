Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 22 Mar 2008 20:34:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2N3YI8l021900
	for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 20:34:20 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2D8F46D6BF9
	for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 20:34:51 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id iKHDoOyfNIsvA99y for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 20:34:51 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 2EB7C18004B4A
	for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 22:34:19 -0500 (CDT)
Message-ID: <47E5CFBA.7060405@sandeen.net>
Date: Sat, 22 Mar 2008 22:34:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfsqa: call _notrun in common.dump if dump utils not found
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

it may not always be obvious to outsiders that xfsdump is packaged
separately from xfsprogs... is it worth checking for the binaries
rather than spewing verbose failures if it's not installed?

(and are the locations ok for irix/bsd/whatnot too...?)

... also abort if bc not found (common.filter requires this,
my minimal testing root didn't have it and much error spew
ensued... nicer to check up front IMHO)

-Eric

Index: xfstests/common.dump
===================================================================
--- xfstests.orig/common.dump
+++ xfstests/common.dump
@@ -41,6 +41,10 @@ do_quota_check=true # do quota check if 
 
 _need_to_be_root
 
+[ -x /usr/sbin/xfsdump ] || _notrun "xfsdump executable not found"
+[ -x /usr/sbin/xfsrestore ] || _notrun "xfsrestore executable not found"
+[ -x /usr/sbin/xfsinvutil ] || _notrun "xfsinvutil executable not found"
+
 # install our cleaner
 trap "_cleanup; exit \$status" 0 1 2 3 15
 
Index: xfstests/common.config
===================================================================
--- xfstests.orig/common.config
+++ xfstests/common.config
@@ -114,6 +114,9 @@ export AWK_PROG="`set_prog_path awk`"
 export SED_PROG="`set_prog_path sed`"
 [ "$SED_PROG" = "" ] && _fatal "sed not found"
 
+export BC_PROG="`set_prog_path bc`"
+[ "$BC_PROG" = "" ] && _fatal "bc not found"
+
 export PS_ALL_FLAGS="-ef"
 
 export DF_PROG="`set_prog_path df`"
