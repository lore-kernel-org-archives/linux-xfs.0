Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 087277F4E
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 20:06:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8C051AC005
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 18:06:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id f7ta5HIZ1mzQg91A (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 07 Sep 2014 18:06:38 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s8816aPM004074
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Sun, 7 Sep 2014 21:06:36 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s8816ZeT015328
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 7 Sep 2014 21:06:36 -0400
Message-ID: <540D011B.2000807@redhat.com>
Date: Sun, 07 Sep 2014 20:06:35 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: don't ASSERT on corrupt ftype
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

xfs_dir3_data_get_ftype() and xfs_dir2_sf_check() get
the file type off disk, but ASSERT if it's invalid:

	ASSERT(type < XFS_DIR3_FT_MAX);

This might be cut & paste from the "put" functions,
which should be checking that they've not been passed
bad values, but we shouldn't ASSERT on bad values
read from disk.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index c9aee52..7e42fdf 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -270,7 +270,6 @@ xfs_dir3_data_get_ftype(
  {
  	__uint8_t	ftype = dep->name[dep->namelen];
  
-	ASSERT(ftype < XFS_DIR3_FT_MAX);
  	if (ftype >= XFS_DIR3_FT_MAX)
  		return XFS_DIR3_FT_UNKNOWN;
  	return ftype;
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 5079e05..ea89250 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -635,7 +635,6 @@ xfs_dir2_sf_check(
  		offset =
  			xfs_dir2_sf_get_offset(sfep) +
  			dp->d_ops->data_entsize(sfep->namelen);
-		ASSERT(dp->d_ops->sf_get_ftype(sfep) < XFS_DIR3_FT_MAX);
  	}
  	ASSERT(i8count == sfp->i8count);
  	ASSERT((char *)sfep - (char *)sfp == dp->i_d.di_size);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
