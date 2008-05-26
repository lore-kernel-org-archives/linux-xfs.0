Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 May 2008 19:21:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4Q2LNjV028884
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 19:21:25 -0700
Date: Mon, 26 May 2008 12:23:00 +1000
Subject: REVIEW: Update common.filter for CI output in mkfs
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Message-ID: <op.ubqowml63jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Just ignore the new part of directory naming mkfs output:


--- a/xfstests/common.filter    2008-05-26 12:21:53.000000000 +1000
+++ b/xfstests/common.filter    2008-05-26 12:12:34.306024612 +1000
@@ -135,7 +135,7 @@
          print STDERR "sunit=$1\nswidth=$2\nunwritten=1\n";
         print STDOUT "         = sunit=XXX swidth=XXX, unwritten=X\n";
      }
-    if (/^naming\s+=version\s+(\d+)\s+bsize=(\d+)/) {
+    if (/^naming\s+=version\s+(\d+)\s+bsize=(\d+).*/) {
         print STDERR "dirversion=$1\ndirbsize=$2\n";
         print STDOUT "naming   =VERN bsize=XXX\n";
      }
