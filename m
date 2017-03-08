Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31869 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754516AbdCHVBS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2017 16:01:18 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v28L1GHj022692
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2017 21:01:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v28L1FDO028508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2017 21:01:15 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v28L1DBb030101
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2017 21:01:14 GMT
Date: Wed, 8 Mar 2017 13:01:12 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC PATCH] xfs: don't run off the end of the buffer reading inline
 dirents
Message-ID: <20170308210112.GR5280@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

Check that we don't run off the end of the inline data buffer when we're
trying to read directory entries.  xfs/348 triggered kernel memory being
exposed to userspace and a related complaint from the usercopy code.

Evidently once we call dir_emit, the VFS ignores error return values
since it's already begun copying data back to userspace.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dir2_readdir.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 003a99b..70bdd21 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -69,6 +69,7 @@ xfs_dir2_sf_getdents(
 	xfs_dir2_dataptr_t	dotdot_offset;
 	xfs_ino_t		ino;
 	struct xfs_da_geometry	*geo = args->geo;
+	char *endp;
 
 	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
 	/*
@@ -83,6 +84,7 @@ xfs_dir2_sf_getdents(
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	endp = dp->i_df.if_u1.if_data + dp->i_df.if_bytes;
 
 	if (dp->i_d.di_size < xfs_dir2_sf_hdr_size(sfp->i8count))
 		return -EFSCORRUPTED;
@@ -130,6 +132,12 @@ xfs_dir2_sf_getdents(
 	for (i = 0; i < sfp->count; i++) {
 		__uint8_t filetype;
 
+		/* If we pass the end of the buffer, we're done. */
+		if (((char *)sfep + sizeof(*sfep)) >= endp ||
+		    (char *)dp->d_ops->sf_nextentry(sfp, sfep) > endp) {
+			break;
+		}
+
 		off = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
 				xfs_dir2_sf_get_offset(sfep));
 
