Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02366C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Dec 2021 16:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237213AbhLHQsz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Dec 2021 11:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237175AbhLHQsy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Dec 2021 11:48:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F67BC061746;
        Wed,  8 Dec 2021 08:45:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9F432CE2240;
        Wed,  8 Dec 2021 16:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2419C00446;
        Wed,  8 Dec 2021 16:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638981918;
        bh=03bZNhGRjio/qartAV6+qsBHGxlIaIdeAeeGTTBZzNk=;
        h=Date:From:To:Cc:Subject:From;
        b=FaLQyr0OVrZm5Gg16FoD6bN3nRtRb/R8LHGwLEaPiqkLFhgcDVwUDDx6UcPgWnQ0v
         /CiNZtR45aywCjS6oGMwL6PQsX7xThKWimF9u//+8JSS0Lg/Rdm7ANzZRanGevtUEp
         OYK5lA6R/hC+joJfgv8MeTihAPUgDvybZn1aNNZLUZGTQlEpnwc+1g9GHsvXDv52Wv
         y40nxqF+NMtxH95/BHvrmXys6+3xB+y1hzaQ8csTEHPV9WS01jeMqc9IsbqRNxb8hi
         iKgHAawecYLmU50j7iv/dKsXIx4r23WMrBZkQVLWylCbKLkzWmnSxZ5+PNknuflz0g
         WQOc3/Y93Z69w==
Date:   Wed, 8 Dec 2021 08:45:18 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Subject: [PATCH] fsstress: consistently index the ops array by OP_ type
Message-ID: <20211208164518.GA69210@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

A mismerge during a git rebase some time ago broke fsstress in my
development tree, because it added OP_XCHGRANGE into the opt_y typedef
definition at a different offset than the actual entry in the ops array.
This broke the relationship ops[i].op == i.

Since most of fsstress.c blindly assumes that it's ok to index the ops
array by OP_ type, this off-by-one error meant that when I created an
fstest with "-f unlink=1", it actually set the frequency of the adjacent
operation (unresvsp) to 1.  I didn't notice this until I started to
investigate how a filesystem created with "-z -f creat=4 -f unlink=4"
could end up with 1.8 million files after 30 seconds.

Eliminate the possibility for future screwups like this by using indexed
array initializers.  This enables us to remove the separate op field in
struct opdesc, for a minor savings of memory footprint and reduction in
footgun opportunity.

While we're at it, reformat the ops table to be more pleasing to the
eye.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 ltp/fsstress.c |  140 ++++++++++++++++++++++++++------------------------------
 1 file changed, 66 insertions(+), 74 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 003e0e49..5f3126e6 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -153,7 +153,6 @@ typedef long long opnum_t;
 typedef void (*opfnc_t)(opnum_t, long);
 
 typedef struct opdesc {
-	opty_t	op;
 	char	*name;
 	opfnc_t	func;
 	int	freq;
@@ -279,74 +278,74 @@ void	write_f(opnum_t, long);
 void	writev_f(opnum_t, long);
 char	*xattr_flag_to_string(int);
 
-opdesc_t	ops[] = {
-     /* { OP_ENUM, "name", function, freq, iswrite }, */
-	{ OP_AFSYNC, "afsync", afsync_f, 0, 1 },
-	{ OP_ALLOCSP, "allocsp", allocsp_f, 1, 1 },
-	{ OP_AREAD, "aread", aread_f, 1, 0 },
-	{ OP_ATTR_REMOVE, "attr_remove", attr_remove_f, /* 1 */ 0, 1 },
-	{ OP_ATTR_SET, "attr_set", attr_set_f, /* 2 */ 0, 1 },
-	{ OP_AWRITE, "awrite", awrite_f, 1, 1 },
-	{ OP_BULKSTAT, "bulkstat", bulkstat_f, 1, 0 },
-	{ OP_BULKSTAT1, "bulkstat1", bulkstat1_f, 1, 0 },
-	{ OP_CHOWN, "chown", chown_f, 3, 1 },
-	{ OP_CLONERANGE, "clonerange", clonerange_f, 4, 1 },
-	{ OP_COPYRANGE, "copyrange", copyrange_f, 4, 1 },
-	{ OP_CREAT, "creat", creat_f, 4, 1 },
-	{ OP_DEDUPERANGE, "deduperange", deduperange_f, 4, 1},
-	{ OP_DREAD, "dread", dread_f, 4, 0 },
-	{ OP_DWRITE, "dwrite", dwrite_f, 4, 1 },
-	{ OP_FALLOCATE, "fallocate", fallocate_f, 1, 1 },
-	{ OP_FDATASYNC, "fdatasync", fdatasync_f, 1, 1 },
-	{ OP_FIEMAP, "fiemap", fiemap_f, 1, 1 },
-	{ OP_FREESP, "freesp", freesp_f, 1, 1 },
-	{ OP_FSYNC, "fsync", fsync_f, 1, 1 },
-	{ OP_GETATTR, "getattr", getattr_f, 1, 0 },
-	{ OP_GETDENTS, "getdents", getdents_f, 1, 0 },
+struct opdesc	ops[OP_LAST]	= {
+     /* [OP_ENUM]	   = {"name",	       function,	freq, iswrite }, */
+	[OP_AFSYNC]	   = {"afsync",	       afsync_f,	0, 1 },
+	[OP_ALLOCSP]	   = {"allocsp",       allocsp_f,	1, 1 },
+	[OP_AREAD]	   = {"aread",	       aread_f,		1, 0 },
+	[OP_ATTR_REMOVE]   = {"attr_remove",   attr_remove_f,	0, 1 },
+	[OP_ATTR_SET]	   = {"attr_set",      attr_set_f,	0, 1 },
+	[OP_AWRITE]	   = {"awrite",	       awrite_f,	1, 1 },
+	[OP_BULKSTAT]	   = {"bulkstat",      bulkstat_f,	1, 0 },
+	[OP_BULKSTAT1]	   = {"bulkstat1",     bulkstat1_f,	1, 0 },
+	[OP_CHOWN]	   = {"chown",	       chown_f,		3, 1 },
+	[OP_CLONERANGE]	   = {"clonerange",    clonerange_f,	4, 1 },
+	[OP_COPYRANGE]	   = {"copyrange",     copyrange_f,	4, 1 },
+	[OP_CREAT]	   = {"creat",	       creat_f,		4, 1 },
+	[OP_DEDUPERANGE]   = {"deduperange",   deduperange_f,	4, 1 },
+	[OP_DREAD]	   = {"dread",	       dread_f,		4, 0 },
+	[OP_DWRITE]	   = {"dwrite",	       dwrite_f,	4, 1 },
+	[OP_FALLOCATE]	   = {"fallocate",     fallocate_f,	1, 1 },
+	[OP_FDATASYNC]	   = {"fdatasync",     fdatasync_f,	1, 1 },
+	[OP_FIEMAP]	   = {"fiemap",	       fiemap_f,	1, 1 },
+	[OP_FREESP]	   = {"freesp",	       freesp_f,	1, 1 },
+	[OP_FSYNC]	   = {"fsync",	       fsync_f,		1, 1 },
+	[OP_GETATTR]	   = {"getattr",       getattr_f,	1, 0 },
+	[OP_GETDENTS]	   = {"getdents",      getdents_f,	1, 0 },
 	/* get extended attribute */
-	{ OP_GETFATTR, "getfattr", getfattr_f, 1, 0 },
-	{ OP_LINK, "link", link_f, 1, 1 },
+	[OP_GETFATTR]	   = {"getfattr",      getfattr_f,	1, 0 },
+	[OP_LINK]	   = {"link",	       link_f,		1, 1 },
 	/* list extent attributes */
-	{ OP_LISTFATTR, "listfattr", listfattr_f, 1, 0 },
-	{ OP_MKDIR, "mkdir", mkdir_f, 2, 1 },
-	{ OP_MKNOD, "mknod", mknod_f, 2, 1 },
-	{ OP_MREAD, "mread", mread_f, 2, 0 },
-	{ OP_MWRITE, "mwrite", mwrite_f, 2, 1 },
-	{ OP_PUNCH, "punch", punch_f, 1, 1 },
-	{ OP_ZERO, "zero", zero_f, 1, 1 },
-	{ OP_COLLAPSE, "collapse", collapse_f, 1, 1 },
-	{ OP_INSERT, "insert", insert_f, 1, 1 },
-	{ OP_READ, "read", read_f, 1, 0 },
-	{ OP_READLINK, "readlink", readlink_f, 1, 0 },
-	{ OP_READV, "readv", readv_f, 1, 0 },
+	[OP_LISTFATTR]	   = {"listfattr",     listfattr_f,	1, 0 },
+	[OP_MKDIR]	   = {"mkdir",	       mkdir_f,		2, 1 },
+	[OP_MKNOD]	   = {"mknod",	       mknod_f,		2, 1 },
+	[OP_MREAD]	   = {"mread",	       mread_f,		2, 0 },
+	[OP_MWRITE]	   = {"mwrite",	       mwrite_f,	2, 1 },
+	[OP_PUNCH]	   = {"punch",	       punch_f,		1, 1 },
+	[OP_ZERO]	   = {"zero",	       zero_f,		1, 1 },
+	[OP_COLLAPSE]	   = {"collapse",      collapse_f,	1, 1 },
+	[OP_INSERT]	   = {"insert",	       insert_f,	1, 1 },
+	[OP_READ]	   = {"read",	       read_f,		1, 0 },
+	[OP_READLINK]	   = {"readlink",      readlink_f,	1, 0 },
+	[OP_READV]	   = {"readv",	       readv_f,		1, 0 },
 	/* remove (delete) extended attribute */
-	{ OP_REMOVEFATTR, "removefattr", removefattr_f, 1, 1 },
-	{ OP_RENAME, "rename", rename_f, 2, 1 },
-	{ OP_RNOREPLACE, "rnoreplace", rnoreplace_f, 2, 1 },
-	{ OP_REXCHANGE, "rexchange", rexchange_f, 2, 1 },
-	{ OP_RWHITEOUT, "rwhiteout", rwhiteout_f, 2, 1 },
-	{ OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
-	{ OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
+	[OP_REMOVEFATTR]   = {"removefattr",   removefattr_f,	1, 1 },
+	[OP_RENAME]	   = {"rename",	       rename_f,	2, 1 },
+	[OP_RNOREPLACE]	   = {"rnoreplace",    rnoreplace_f,	2, 1 },
+	[OP_REXCHANGE]	   = {"rexchange",     rexchange_f,	2, 1 },
+	[OP_RWHITEOUT]	   = {"rwhiteout",     rwhiteout_f,	2, 1 },
+	[OP_RESVSP]	   = {"resvsp",	       resvsp_f,	1, 1 },
+	[OP_RMDIR]	   = {"rmdir",	       rmdir_f,		1, 1 },
 	/* set attribute flag (FS_IOC_SETFLAGS ioctl) */
-	{ OP_SETATTR, "setattr", setattr_f, 0, 1 },
+	[OP_SETATTR]	   = {"setattr",       setattr_f,	0, 1 },
 	/* set extended attribute */
-	{ OP_SETFATTR, "setfattr", setfattr_f, 2, 1 },
+	[OP_SETFATTR]	   = {"setfattr",      setfattr_f,	2, 1 },
 	/* set project id (XFS_IOC_FSSETXATTR ioctl) */
-	{ OP_SETXATTR, "setxattr", setxattr_f, 1, 1 },
-	{ OP_SNAPSHOT, "snapshot", snapshot_f, 1, 1 },
-	{ OP_SPLICE, "splice", splice_f, 1, 1 },
-	{ OP_STAT, "stat", stat_f, 1, 0 },
-	{ OP_SUBVOL_CREATE, "subvol_create", subvol_create_f, 1, 1},
-	{ OP_SUBVOL_DELETE, "subvol_delete", subvol_delete_f, 1, 1},
-	{ OP_SYMLINK, "symlink", symlink_f, 2, 1 },
-	{ OP_SYNC, "sync", sync_f, 1, 1 },
-	{ OP_TRUNCATE, "truncate", truncate_f, 2, 1 },
-	{ OP_UNLINK, "unlink", unlink_f, 1, 1 },
-	{ OP_UNRESVSP, "unresvsp", unresvsp_f, 1, 1 },
-	{ OP_URING_READ, "uring_read", uring_read_f, 1, 0 },
-	{ OP_URING_WRITE, "uring_write", uring_write_f, 1, 1 },
-	{ OP_WRITE, "write", write_f, 4, 1 },
-	{ OP_WRITEV, "writev", writev_f, 4, 1 },
+	[OP_SETXATTR]	   = {"setxattr",      setxattr_f,	1, 1 },
+	[OP_SNAPSHOT]	   = {"snapshot",      snapshot_f,	1, 1 },
+	[OP_SPLICE]	   = {"splice",	       splice_f,	1, 1 },
+	[OP_STAT]	   = {"stat",	       stat_f,		1, 0 },
+	[OP_SUBVOL_CREATE] = {"subvol_create", subvol_create_f,	1, 1 },
+	[OP_SUBVOL_DELETE] = {"subvol_delete", subvol_delete_f,	1, 1 },
+	[OP_SYMLINK]	   = {"symlink",       symlink_f,	2, 1 },
+	[OP_SYNC]	   = {"sync",	       sync_f,		1, 1 },
+	[OP_TRUNCATE]	   = {"truncate",      truncate_f,	2, 1 },
+	[OP_UNLINK]	   = {"unlink",	       unlink_f,	1, 1 },
+	[OP_UNRESVSP]	   = {"unresvsp",      unresvsp_f,	1, 1 },
+	[OP_URING_READ]	   = {"uring_read",    uring_read_f,	1, 0 },
+	[OP_URING_WRITE]   = {"uring_write",   uring_write_f,	1, 1 },
+	[OP_WRITE]	   = {"write",	       write_f,		4, 1 },
+	[OP_WRITEV]	   = {"writev",	       writev_f,	4, 1 },
 }, *ops_end;
 
 flist_t	flist[FT_nft] = {
@@ -1520,7 +1519,7 @@ make_freq_table(void)
 	freq_table_size = f;
 	for (p = ops, i = 0; p < ops_end; p++) {
 		for (f = 0; f < p->freq; f++, i++)
-			freq_table[i] = p->op;
+			freq_table[i] = p - ops;
 	}
 }
 
@@ -1966,7 +1965,7 @@ opty_t btrfs_ops[] = {
 void
 non_btrfs_freq(const char *path)
 {
-	opdesc_t		*p;
+	int			i;
 #ifdef HAVE_BTRFSUTIL_H
 	enum btrfs_util_error	e;
 
@@ -1974,15 +1973,8 @@ non_btrfs_freq(const char *path)
 	if (e != BTRFS_UTIL_ERROR_NOT_BTRFS)
 		return;
 #endif
-	for (p = ops; p < ops_end; p++) {
-		int i;
-		for (i = 0; i < ARRAY_SIZE(btrfs_ops); i++) {
-			if (p->op == btrfs_ops[i]) {
-				p->freq = 0;
-				break;
-			}
-		}
-	}
+	for (i = 0; i < ARRAY_SIZE(btrfs_ops); i++)
+		ops[btrfs_ops[i]].freq = 0;
 }
 
 void inode_info(char *str, size_t sz, struct stat64 *s, int verbose)
