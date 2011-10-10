Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9AIM0lN195124 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 13:22:01 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 288EC1C7CAA0
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 11:21:59 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	MTL9S1raDhZ9Xfbt for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 11:21:59 -0700 (PDT)
Date: Mon, 10 Oct 2011 14:21:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] xfstests: fix 122 for recent xfsprogs
Message-ID: <20111010182156.GA1323@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

 - filter out xfs_alloctype_t, this was an internal emum that got removed
 - filter out xfs_bmbt_rec_32_t, this is a variant of the xfs_bmbt_rec_t
   that had almost no users and was removed
 - filter out xfs_dinode_core_t, the separate dinode core is gone, and just
   checking the size of the full dinode is enough
 - accept xfs_bmbt_rec_t as the new canonical name for xfs_bmbt_rec_64_t,
   and replace the old name with the new one in the output stream.

Signed-off-by: Christoph Hellwig <hch@lst.de>


Index: xfstests-dev/122
===================================================================
--- xfstests-dev.orig/122	2011-10-10 16:49:06.000000000 +0000
+++ xfstests-dev/122	2011-10-10 17:04:07.000000000 +0000
@@ -57,6 +57,12 @@ s/sizeof\( xfs_agf_t \) = 64/sizeof( xfs
 	fi
 }
 
+# filter out known changes to xfs type names
+_type_name_filter()
+{
+	sed -e 's/xfs_bmbt_rec_64_t/xfs_bmbt_rec_t/'
+}
+
 _attribute_filter()
 {
 	sed -e 's/__attribute__ *[(][(]packed[)][)]//' \
@@ -73,7 +79,9 @@ cat >$cprog <<EOF
 EOF
 
 cat >$tmp.ignore <<EOF
+xfs_alloctype_t
 xfs_buf_cancel_t
+xfs_bmbt_rec_32_t
 xfs_swapext_t
 xfs_dirops_t
 xfs_efi_log_item_t
@@ -160,6 +168,7 @@ xfs_log_item_chunk_t
 xfs_trans_t
 xfs_dirent_t
 xfs_fsop_getparents_handlereq_t
+xfs_dinode_core_t
 EOF
 
 echo 'int main(int argc, char *argv[]) {' >>$cprog
@@ -193,7 +202,7 @@ echo 'return 0; }' >>$cprog
 # create and run program
 cc -o $oprog $cprog >> $seq.full 2>&1 || \
   _notrun "Could not compile test program (see end of $seq.full)"
-$oprog | _type_size_filter > $progout
+$oprog | _type_size_filter | _type_name_filter > $progout
 
 #
 # add addition sizes and xfs_sb_t fields that don't exist in the version
Index: xfstests-dev/122.out
===================================================================
--- xfstests-dev.orig/122.out	2011-10-10 16:53:08.000000000 +0000
+++ xfstests-dev/122.out	2011-10-10 16:56:59.000000000 +0000
@@ -50,7 +50,6 @@ sizeof( xfs_agfl_t ) = 4
 sizeof( xfs_agi_t ) = 296
 sizeof( xfs_alloc_rec_incore_t ) = 8
 sizeof( xfs_alloc_rec_t ) = 8
-sizeof( xfs_alloctype_t ) = 4
 sizeof( xfs_attr_inactive_list_t ) = 8
 sizeof( xfs_attr_leaf_entry_t ) = 8
 sizeof( xfs_attr_leaf_hdr_t ) = 32
@@ -61,14 +60,12 @@ sizeof( xfs_attr_leafblock_t ) = 56
 sizeof( xfs_attr_shortform_t ) = 8
 sizeof( xfs_attrlist_cursor_t ) = 16
 sizeof( xfs_bmbt_key_t ) = 8
-sizeof( xfs_bmbt_rec_32_t ) = 16
-sizeof( xfs_bmbt_rec_64_t ) = 16
+sizeof( xfs_bmbt_rec_t ) = 16
 sizeof( xfs_bmdr_block_t ) = 4
 sizeof( xfs_btnum_t ) = 4
 sizeof( xfs_buf_log_format_t ) = 24
 sizeof( xfs_da_blkinfo_t ) = 12
 sizeof( xfs_da_intnode_t ) = 24
-sizeof( xfs_dinode_core_t ) = 96
 sizeof( xfs_dinode_fmt_t ) = 4
 sizeof( xfs_dir2_data_free_t ) = 4
 sizeof( xfs_dir2_data_hdr_t ) = 16

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
