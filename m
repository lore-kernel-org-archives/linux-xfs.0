Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C5E937F59
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 16:05:27 -0500 (CDT)
Received: from eagdhcp-232-128.americas.sgi.com
	(eagdhcp-232-128.americas.sgi.com [128.162.232.128])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 965E48F8049
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 14:05:24 -0700 (PDT)
Received: from eagdhcp-232-128.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-128.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s3NL5PGa002939
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 16:05:25 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-128.americas.sgi.com)
Message-Id: <20140423210445.700477624@sgi.com>
Date: Wed, 23 Apr 2014 16:04:35 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [RFC] libxfs: adding attribute fork frees xfs_inode ptr
References: <20140423210034.892939354@sgi.com>
Content-Disposition: inline;
	filename=xfsprogs-fix-dp-release-when-adding-attr-fork.patch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS Mailing List <xfs@oss.sgi.com>

User space does not currently perform any attribute adding/deleting,
but if we do want to fix attributes or use them for parent inode
pointers, user space should support attributes.

The adding an attribute fork is done in an embedded transaction
inside xfs_attr_set_int(). The xfs_trans_commit in xfs_bmap_add_attrfork()
will free the xfs_inode pointer causing xfs_attr_calc_size() in
xfs_attr_set_int() to fail.

I don't see that we have any hold counts on the xfs_inode, so this is
a dirty FYI/RFC of a work around for this problem by calling xfs_iget()
to read back in the just freed inode.

---
 libxfs/xfs_attr.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: b/libxfs/xfs_attr.c
===================================================================
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -223,11 +223,15 @@ xfs_attr_set_int(
 	 * (inode must not be locked when we call this routine)
 	 */
 	if (XFS_IFORK_Q(dp) == 0) {
+		xfs_ino_t	ino = dp->i_ino;
 		int sf_size = sizeof(xfs_attr_sf_hdr_t) +
 			      XFS_ATTR_SF_ENTSIZE_BYNAME(name->len, valuelen);
 
 		if ((error = xfs_bmap_add_attrfork(dp, sf_size, rsvd)))
 			return(error);
+		error = libxfs_iget(mp, NULL, ino, 0, &dp, 0);
+		if (error)
+			return(error);
 	}
 
 	/*


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
