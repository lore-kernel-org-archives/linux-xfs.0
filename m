Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Jun 2007 00:03:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5773oWt032118
	for <xfs@oss.sgi.com>; Thu, 7 Jun 2007 00:03:52 -0700
Message-ID: <4667ADAF.7000904@sgi.com>
Date: Thu, 07 Jun 2007 17:03:11 +1000
From: Tim Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: review: xfs_growfs_data_private() not logging agf length change
Content-Type: multipart/mixed;
 boundary="------------000807030904070307000007"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------000807030904070307000007
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Looks like we forgot to log the agf_length change here.

(cut 'n' pasted patch)

--Tim

===========================================================================
Index: fs/xfs/xfs_fsops.c
===========================================================================

--- a/fs/xfs/xfs_fsops.c    2007-04-17 18:02:46.000000000 +1000
+++ b/fs/xfs/xfs_fsops.c    2007-04-17 17:59:44.467987572 +1000
@@ -328,6 +328,7 @@ xfs_growfs_data_private(
         be32_add(&agf->agf_length, new);
         ASSERT(be32_to_cpu(agf->agf_length) ==
                be32_to_cpu(agi->agi_length));
+        xfs_alloc_log_agf(tp, bp, XFS_AGF_LENGTH);
         /*
          * Free the new space.
          */

--------------000807030904070307000007
Content-Type: text/plain;
 name="agf_length.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="agf_length.patch"

--- .pc/agf_length.patch/fs/xfs/xfs_fsops.c	2007-06-07 16:19:27.000000000 +1000
+++ fs/xfs/xfs_fsops.c	2007-06-07 16:23:41.302363734 +1000
@@ -332,6 +332,7 @@ xfs_growfs_data_private(
 		be32_add(&agf->agf_length, new);
 		ASSERT(be32_to_cpu(agf->agf_length) ==
 		       be32_to_cpu(agi->agi_length));
+		xfs_alloc_log_agf(tp, bp, XFS_AGF_LENGTH);
 		/*
 		 * Free the new space.
 		 */

--------------000807030904070307000007--
