Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Apr 2008 18:55:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3N1t44u004151
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 18:55:06 -0700
Date: Wed, 23 Apr 2008 11:55:39 +1000
From: David Chinner <dgc@sgi.com>
Subject: [PATCH, XFSQA] Use common language setting
Message-ID: <20080423015539.GK103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Prevent output from being munged by language settings and
causing golden output mismatches.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 xfstests/common.config |    4 ++++
 1 file changed, 4 insertions(+)

Index: xfs-cmds/xfstests/common.config
===================================================================
--- xfs-cmds.orig/xfstests/common.config	2008-03-27 11:49:53.000000000 +1100
+++ xfs-cmds/xfstests/common.config	2008-04-23 11:52:36.980546211 +1000
@@ -32,6 +32,10 @@
 #   validity or mountedness.
 #
 
+# all tests should use a common language setting to prevent golden
+# output mismatches.
+export LANG=C
+
 # Warning: don't put freeware before /usr/bsd on IRIX coz you'll
 #  get the wrong hostname and set your system name to -s  :)
 [ -d /usr/bsd ] && PATH=$PATH:/usr/bsd
