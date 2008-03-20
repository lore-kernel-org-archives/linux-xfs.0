Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 23:34:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2K6Xws8028612
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 23:34:01 -0700
Date: Thu, 20 Mar 2008 17:34:27 +1100
From: David Chinner <dgc@sgi.com>
Subject: [PATCH] XFSQA 141: support 64k pagesize
Message-ID: <20080320063427.GB103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Make the file larger and read 64k from it instead of 16k
so that it pulls in a full page from the middle of the file.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 xfstests/141 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: xfs-cmds/xfstests/141
===================================================================
--- xfs-cmds.orig/xfstests/141	2006-12-19 14:11:09.000000000 +1100
+++ xfs-cmds/xfstests/141	2008-03-19 09:45:33.500797374 +1100
@@ -39,7 +39,7 @@ _scratch_mount
 # create file, mmap a region and mmap read it
 file=$SCRATCH_MNT/mmap
 
-xfs_io -f -c "pwrite 0 64k" -c "mmap 16k 16k" -c "mread -r" $file > /dev/null
+xfs_io -f -c "pwrite 0 1024k" -c "mmap 64k 64k" -c "mread -r" $file > /dev/null
 
 rm -f $file
 
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
