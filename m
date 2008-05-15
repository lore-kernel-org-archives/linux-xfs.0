Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 May 2008 18:17:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4F1Gq76022184
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 18:16:55 -0700
Date: Thu, 15 May 2008 11:17:35 +1000
From: David Chinner <dgc@sgi.com>
Subject: [patch] xfsqa 166 - fix filter pathname issue
Message-ID: <20080515011735.GL155679365@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

If the path to the file being bmap'd has a [0-9] in it,
the output filter matches it and we get golden output
failure. Be more specific on the match.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 xfstests/166 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: xfs-cmds/xfstests/166
===================================================================
--- xfs-cmds.orig/xfstests/166	2008-05-08 09:57:55.000000000 +1000
+++ xfs-cmds/xfstests/166	2008-05-15 09:10:09.890128276 +1000
@@ -33,7 +33,7 @@ _cleanup()
 _filter_blocks()
 {
 	$AWK_PROG '
-/[0-9]/ {
+/^ +[0-9]/ {
 	if (!written_size) {
 		written_size = $6
 		unwritten1 = ((1048576/512) / 2) - written_size
