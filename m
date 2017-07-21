Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19491 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753502AbdGUWBZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 18:01:25 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6LM1Oda015015
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 22:01:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v6LM1OQK004518
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 22:01:24 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v6LM1O9e025990
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 22:01:24 GMT
Date: Fri, 21 Jul 2017 15:01:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: check that dir block entries don't off the end of the
 buffer
Message-ID: <20170721220122.GW4224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

When we're checking the entries in a directory buffer, make sure that
the entry length doesn't push us off the end of the buffer.  Found via
xfs/388 writing ones to the freetag length field and xfs_repair crashing.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_data.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index d478065..8727a43 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -136,6 +136,8 @@ __xfs_dir3_data_check(
 		 */
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
 			XFS_WANT_CORRUPTED_RETURN(mp, lastfree == 0);
+			XFS_WANT_CORRUPTED_RETURN(mp, endp >=
+					p + be16_to_cpu(dup->length));
 			XFS_WANT_CORRUPTED_RETURN(mp,
 				be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) ==
 					       (char *)dup - (char *)hdr);
@@ -164,6 +166,8 @@ __xfs_dir3_data_check(
 		XFS_WANT_CORRUPTED_RETURN(mp, dep->namelen != 0);
 		XFS_WANT_CORRUPTED_RETURN(mp,
 			!xfs_dir_ino_validate(mp, be64_to_cpu(dep->inumber)));
+		XFS_WANT_CORRUPTED_RETURN(mp, endp >=
+				p + ops->data_entsize(dep->namelen));
 		XFS_WANT_CORRUPTED_RETURN(mp,
 			be16_to_cpu(*ops->data_entry_tag_p(dep)) ==
 					       (char *)dep - (char *)hdr);
