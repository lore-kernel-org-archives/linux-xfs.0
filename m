Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 22 Mar 2008 18:03:34 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2N13Q2x009810
	for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 18:03:27 -0700
Received: from wa-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 799F96D66F0
	for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 18:04:00 -0700 (PDT)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.183]) by cuda.sgi.com with ESMTP id gfkv3MFTfAMbgvE6 for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 18:04:00 -0700 (PDT)
Received: by wa-out-1112.google.com with SMTP id k22so2598720waf.18
        for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 18:03:59 -0700 (PDT)
Message-ID: <47E5AC7D.4080708@gmail.com>
Date: Sun, 23 Mar 2008 09:03:57 +0800
From: Kevin Xu <cgxu.gg@gmail.com>
MIME-Version: 1.0
Subject: [PATCH]fix the algorithm for addname in xfs_da_node_lookup_int
Content-Type: multipart/mixed;
 boundary="------------040805070705080301070307"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfscn@googlegroups.com
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------040805070705080301070307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

fix the algorithm for addname in xfs_da_node_lookup_int


--------------040805070705080301070307
Content-Type: text/x-patch;
 name="usig-xfs-fix-080323.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="usig-xfs-fix-080323.patch"

--- linux-2.6-xfs/fs/xfs/xfs_da_btree.c	2007-09-21 14:14:35.000000000 +0800
+++ linux-xfs-usig/fs/xfs/xfs_da_btree.c	2008-03-23 08:19:13.583751436 +0800
@@ -1161,7 +1161,7 @@ xfs_da_node_lookup_int(xfs_da_state_t *s
 			ASSERT(0);
 			return XFS_ERROR(EFSCORRUPTED);
 		}
-		if (((retval == ENOENT) || (retval == ENOATTR)) &&
+		if ((((retval == ENOENT) && (state->extrablk.index == -1)) || (retval == ENOATTR)) &&
 		    (blk->hashval == args->hashval)) {
 			error = xfs_da_path_shift(state, &state->path, 1, 1,
 							 &retval);



--------------040805070705080301070307--
