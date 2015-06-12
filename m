Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5E7C47F5F
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 17:50:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 58E04304043
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 15:50:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qlWPhEheY0TalmIU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 12 Jun 2015 15:50:12 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 6DDBACC352
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 22:50:11 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t5CMoAxu026318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 18:50:11 -0400
Message-ID: <557B6222.4030903@redhat.com>
Date: Fri, 12 Jun 2015 17:50:10 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_metadump: obfuscate attrs on CRC fs
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Lots of issues in xfs_metadump obfuscation of extended
attributes with CRC filesystems; this fixes it up.

The main issues are that the headers differ, and the
space in the remote blocks differ.

Tested with a script I'm using to do other metadump
work; I still owe an xfstest for this and other bits.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Brief/hacky testcase; populate w/ many attr types with:

	MNTPT=/mount/test

        # FMT_LOCAL
        touch $MNTPT/S_IFREG.ATTR.FMT_LOCAL
        setfattr -n user.localattrname -v localattrvalue $MNTPT/S_IFREG.ATTR.FMT_LOCAL

        # FMT_EXTENTS
        touch $MNTPT/S_IFREG.ATTR.FMT_EXTENTS
        for I in `seq 1 50`; do
                setfattr -n user.extentattrname$I -v extentattrvalue $MNTPT/S_IFREG.ATTR.FMT_EXTENTS
        done

        # FMT_EXTENTS with a single remote 3k value, fill with "C"
        touch $MNTPT/S_IFREG.ATTR.FMT_EXTENTS_REMOTE3K
        xfs_io -f -c "pwrite -S 0x43 0 3k" attrvalfile &>/dev/null
        attr -q -s user.remotebtreeattrname $MNTPT/S_IFREG.ATTR.FMT_EXTENTS_REMOTE3K < attrvalfile

        # FMT_EXTENTS with a single remote 4k value, fill with "D"
        touch $MNTPT/S_IFREG.ATTR.FMT_EXTENTS_REMOTE4K
        xfs_io -f -c "pwrite -S 0x44 0 4k" attrvalfile &>/dev/null
        attr -q -s user.remotebtreeattrname $MNTPT/S_IFREG.ATTR.FMT_EXTENTS_REMOTE4K < attrvalfile

        # FMT_BTREE
        touch $MNTPT/S_IFREG.ATTR.FMT_BTREE
        for I in `seq 1 1000`; do
                setfattr -n user.btreeattrname$I -v btreelongerattrvalue $MNTPT/S_IFREG.ATTR.FMT_BTREE
        done

on a crc filesystem, an obfuscated metadump will show all these attrs in the clear
with getfattr -dR $MNTPT

diff --git a/db/metadump.c b/db/metadump.c
index 94f92bc..793f39e 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1268,39 +1268,54 @@ add_remote_vals(
 	}
 }
 
+/* Handle remote and leaf attributes */
 static void
 obfuscate_attr_block(
-	char			*block,
-	xfs_fileoff_t		offset)
+	char				*block,
+	xfs_fileoff_t			offset)
 {
-	xfs_attr_leafblock_t	*leaf;
-	int			i;
-	int			nentries;
-	xfs_attr_leaf_entry_t 	*entry;
-	xfs_attr_leaf_name_local_t *local;
-	xfs_attr_leaf_name_remote_t *remote;
+	struct xfs_attr_leafblock	*leaf;
+	struct xfs_attr3_icleaf_hdr	hdr;
+	int				i;
+	int				nentries;
+	xfs_attr_leaf_entry_t 		*entry;
+	xfs_attr_leaf_name_local_t 	*local;
+	xfs_attr_leaf_name_remote_t 	*remote;
+	__uint32_t			bs = mp->m_sb.sb_blocksize;
+
 
 	leaf = (xfs_attr_leafblock_t *)block;
 
-	if (be16_to_cpu(leaf->hdr.info.magic) != XFS_ATTR_LEAF_MAGIC) {
+	/* Get header; accounts for crc & non-crc */
+	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &hdr, leaf);
+
+	/* Remote attributes */
+	if ((hdr.magic != XFS_ATTR_LEAF_MAGIC) &&
+	    (hdr.magic != XFS_ATTR3_LEAF_MAGIC)) {
 		for (i = 0; i < attr_data.remote_val_count; i++) {
-			/* XXX: need to handle CRC headers */
 			if (attr_data.remote_vals[i] == offset)
-				memset(block, 0, mp->m_sb.sb_blocksize);
+				/* magic to handle attr and attr3 */
+				memset(block +
+					(bs - XFS_ATTR3_RMT_BUF_SPACE(mp, bs)),
+				      0, XFS_ATTR3_RMT_BUF_SPACE(mp, bs));
 		}
 		return;
 	}
 
-	nentries = be16_to_cpu(leaf->hdr.count);
+	nentries = hdr.count;
+
 	if (nentries * sizeof(xfs_attr_leaf_entry_t) +
-			sizeof(xfs_attr_leaf_hdr_t) > mp->m_sb.sb_blocksize) {
+			xfs_attr3_leaf_hdr_size(leaf) >
+				XFS_ATTR3_RMT_BUF_SPACE(mp, bs)) {
 		if (show_warnings)
 			print_warning("invalid attr count in inode %llu",
 					(long long)cur_ino);
 		return;
 	}
 
-	for (i = 0, entry = &leaf->entries[0]; i < nentries; i++, entry++) {
+	entry = xfs_attr3_leaf_entryp(leaf);
+
+	for (i = 0; i < nentries; i++, entry++) {
 		if (be16_to_cpu(entry->nameidx) > mp->m_sb.sb_blocksize) {
 			if (show_warnings)
 				print_warning(

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
