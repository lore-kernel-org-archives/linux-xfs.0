Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B20C2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4747D2076A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:32:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k1fRAorw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406460AbgJZXcw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:32:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35398 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406455AbgJZXcv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:32:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQknn158638;
        Mon, 26 Oct 2020 23:32:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=TRcq9dMW2AaWSqTrYFW4qiPgeNExd/VVLtzK45F/hKM=;
 b=k1fRAorwahMcUuMqkhx8pnCsBvtQzyL3F94sUCH+aJJ6fbnCUuE79t+/JXlh2mXrAIAP
 5/J9Ddieg8IzyIfqfS5ZM3rJqAlGwP8bLoBstQ4Ot5dmcN3ZNGvoMz3lZQqvnrttMuQ+
 uIzyhSW0uwhbX1CEWYztsSrAiRBESck6Zae2XBRX1G0Ek6NUfLf5wlUNCaxJii3VvHAl
 s5VTTnkyBS0y/LJwez7rAaq8xx4amYTA4uwCgtsNtnqDKgtlrv09+3GGmUmJItGeeLjW
 BZWvaY5mMeehk9qdPMfte8uT4pqRj5JtLNuPTSlDJ+fSSe2YtnVfO74vrQghTcUhFW0X KA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34cc7kq8e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:32:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPx0S110434;
        Mon, 26 Oct 2020 23:32:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34cx5wfqy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:32:47 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNWku6004928;
        Mon, 26 Oct 2020 23:32:46 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:32:41 -0700
Subject: [PATCH 2/2] xfs_db: add an ls command
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:32:41 -0700
Message-ID: <160375516100.880118.14555322605178437533.stgit@magnolia>
In-Reply-To: <160375514873.880118.10145241423813965771.stgit@magnolia>
References: <160375514873.880118.10145241423813965771.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=2 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=2
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add to xfs_db the ability to list a directory.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/namei.c               |  380 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_api_defs.h |    1 
 man/man8/xfs_db.8        |   14 ++
 3 files changed, 395 insertions(+)


diff --git a/db/namei.c b/db/namei.c
index 3c9889d62338..b2c036e6777a 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -221,8 +221,388 @@ static const cmdinfo_t path_cmd = {
 	.help		= path_help,
 };
 
+/* List a directory's entries. */
+
+static const char *filetype_strings[XFS_DIR3_FT_MAX] = {
+	[XFS_DIR3_FT_UNKNOWN]	= N_("unknown"),
+	[XFS_DIR3_FT_REG_FILE]	= N_("regular"),
+	[XFS_DIR3_FT_DIR]	= N_("directory"),
+	[XFS_DIR3_FT_CHRDEV]	= N_("chardev"),
+	[XFS_DIR3_FT_BLKDEV]	= N_("blkdev"),
+	[XFS_DIR3_FT_FIFO]	= N_("fifo"),
+	[XFS_DIR3_FT_SOCK]	= N_("socket"),
+	[XFS_DIR3_FT_SYMLINK]	= N_("symlink"),
+	[XFS_DIR3_FT_WHT]	= N_("whiteout"),
+};
+
+static const char *
+get_dstr(
+	struct xfs_mount	*mp,
+	uint8_t			filetype)
+{
+	if (!xfs_sb_version_hasftype(&mp->m_sb))
+		return filetype_strings[XFS_DIR3_FT_UNKNOWN];
+
+	if (filetype >= XFS_DIR3_FT_MAX)
+		return filetype_strings[XFS_DIR3_FT_UNKNOWN];
+
+	return filetype_strings[filetype];
+}
+
+static void
+dir_emit(
+	struct xfs_mount	*mp,
+	char			*name,
+	ssize_t			namelen,
+	xfs_ino_t		ino,
+	uint8_t			dtype)
+{
+	char			*display_name;
+	struct xfs_name		xname = { .name = name };
+	const char		*dstr = get_dstr(mp, dtype);
+	xfs_dahash_t		hash;
+	bool			good;
+
+	if (namelen < 0) {
+		/* Negative length means that name is null-terminated. */
+		display_name = name;
+		xname.len = strlen(name);
+		good = true;
+	} else {
+		/*
+		 * Otherwise, name came from a directory entry, so we have to
+		 * copy the string to a buffer so that we can add the null
+		 * terminator.
+		 */
+		display_name = malloc(namelen + 1);
+		memcpy(display_name, name, namelen);
+		display_name[namelen] = 0;
+		xname.len = namelen;
+		good = libxfs_dir2_namecheck(name, namelen);
+	}
+	hash = libxfs_dir2_hashname(mp, &xname);
+
+	dbprintf("%-18llu %-14s 0x%08llx %3d %s", ino, dstr, hash, xname.len,
+			display_name);
+	if (!good)
+		dbprintf(_(" (corrupt)"));
+	dbprintf("\n");
+
+	if (display_name != name)
+		free(display_name);
+}
+
+static int
+list_sfdir(
+	struct xfs_da_args		*args)
+{
+	struct xfs_inode		*dp = args->dp;
+	struct xfs_mount		*mp = dp->i_mount;
+	struct xfs_dir2_sf_entry	*sfep;
+	struct xfs_dir2_sf_hdr		*sfp;
+	xfs_ino_t			ino;
+	unsigned int			i;
+	uint8_t				filetype;
+
+	sfp = (struct xfs_dir2_sf_hdr *)dp->i_df.if_u1.if_data;
+
+	/* . and .. entries */
+	dir_emit(args->dp->i_mount, ".", -1, dp->i_ino, XFS_DIR3_FT_DIR);
+
+	ino = libxfs_dir2_sf_get_parent_ino(sfp);
+	dir_emit(args->dp->i_mount, "..", -1, ino, XFS_DIR3_FT_DIR);
+
+	/* Walk everything else. */
+	sfep = xfs_dir2_sf_firstentry(sfp);
+	for (i = 0; i < sfp->count; i++) {
+		ino = libxfs_dir2_sf_get_ino(mp, sfp, sfep);
+		filetype = libxfs_dir2_sf_get_ftype(mp, sfep);
+
+		dir_emit(args->dp->i_mount, (char *)sfep->name, sfep->namelen,
+				ino, filetype);
+		sfep = libxfs_dir2_sf_nextentry(mp, sfp, sfep);
+	}
+
+	return 0;
+}
+
+/* List entries in block format directory. */
+static int
+list_blockdir(
+	struct xfs_da_args	*args)
+{
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_buf		*bp;
+	struct xfs_da_geometry	*geo = mp->m_dir_geo;
+	unsigned int		offset;
+	unsigned int		end;
+	int			error;
+
+	error = xfs_dir3_block_read(NULL, dp, &bp);
+	if (error)
+		return error;
+
+	end = xfs_dir3_data_end_offset(geo, bp->b_addr);
+	for (offset = geo->data_entry_offset; offset < end;) {
+		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
+		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
+		uint8_t				filetype;
+
+		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
+			/* Unused entry */
+			offset += be16_to_cpu(dup->length);
+			continue;
+		}
+
+		/* Real entry */
+		offset += libxfs_dir2_data_entsize(mp, dep->namelen);
+		filetype = libxfs_dir2_data_get_ftype(dp->i_mount, dep);
+		dir_emit(mp, (char *)dep->name, dep->namelen,
+				be64_to_cpu(dep->inumber), filetype);
+	}
+
+	libxfs_trans_brelse(args->trans, bp);
+	return error;
+}
+
+/* List entries in leaf format directory. */
+static int
+list_leafdir(
+	struct xfs_da_args	*args)
+{
+	struct xfs_bmbt_irec	map;
+	struct xfs_iext_cursor	icur;
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_buf		*bp = NULL;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(dp, XFS_DATA_FORK);
+	struct xfs_da_geometry	*geo = mp->m_dir_geo;
+	xfs_dablk_t		dabno = 0;
+	int			error = 0;
+
+	/* Read extent map. */
+	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
+		error = -libxfs_iread_extents(NULL, dp, XFS_DATA_FORK);
+		if (error)
+			return error;
+	}
+
+	while (dabno < geo->leafblk) {
+		unsigned int	offset;
+		unsigned int	length;
+
+		/* Find mapping for leaf block. */
+		if (!xfs_iext_lookup_extent(dp, ifp, dabno, &icur, &map))
+			break;
+		if (map.br_startoff >= geo->leafblk)
+			break;
+		libxfs_trim_extent(&map, dabno, geo->leafblk - dabno);
+
+		/* Read the directory block of that first mapping. */
+		error = xfs_dir3_data_read(NULL, dp, map.br_startoff, 0, &bp);
+		if (error)
+			break;
+
+		for (offset = geo->data_entry_offset; offset < geo->blksize;) {
+			struct xfs_dir2_data_entry	*dep;
+			struct xfs_dir2_data_unused	*dup;
+			uint8_t				filetype;
+
+			dup = bp->b_addr + offset;
+			dep = bp->b_addr + offset;
+
+			if (be16_to_cpu(dup->freetag) ==
+			    XFS_DIR2_DATA_FREE_TAG) {
+				/* Skip unused entry */
+				length = be16_to_cpu(dup->length);
+				offset += length;
+				continue;
+			}
+
+			offset += libxfs_dir2_data_entsize(mp, dep->namelen);
+			filetype = libxfs_dir2_data_get_ftype(mp, dep);
+
+			dir_emit(mp, (char *)dep->name, dep->namelen,
+					be64_to_cpu(dep->inumber), filetype);
+		}
+
+		dabno += XFS_DADDR_TO_FSB(mp, bp->b_length);
+		libxfs_buf_relse(bp);
+		bp = NULL;
+	}
+
+	if (bp)
+		libxfs_buf_relse(bp);
+
+	return error;
+}
+
+/* Read the directory, display contents. */
+int
+listdir(
+	struct xfs_inode	*dp)
+{
+	struct xfs_da_args	args = {
+		.dp		= dp,
+		.geo		= dp->i_mount->m_dir_geo,
+	};
+	int			error;
+	int			isblock;
+
+	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
+		return list_sfdir(&args);
+
+	error = -libxfs_dir2_isblock(&args, &isblock);
+	if (error)
+		return error;
+
+	if (isblock)
+		return list_blockdir(&args);
+	return list_leafdir(&args);
+}
+
+/* If the io cursor points to a directory, list its contents. */
+static int
+ls_cur(
+	char			*tag,
+	bool			direct)
+{
+	struct xfs_inode	*dp;
+	int			ret = 0;
+
+	if (iocur_top->typ != &typtab[TYP_INODE]) {
+		dbprintf(_("current object is not an inode.\n"));
+		return -1;
+	}
+
+	ret = -libxfs_iget(mp, NULL, iocur_top->ino, 0, &dp);
+	if (ret) {
+		dbprintf(_("failed to iget directory %llu, error %d\n"),
+				(unsigned long long)iocur_top->ino, ret);
+		return -1;
+	}
+
+	if (S_ISDIR(VFS_I(dp)->i_mode) && !direct) {
+		/* List the contents of a directory. */
+		if (tag)
+			dbprintf(_("%s:\n"), tag);
+
+		ret = listdir(dp);
+		if (ret) {
+			dbprintf(_("failed to list directory %llu: %s\n"),
+					(unsigned long long)iocur_top->ino,
+					strerror(ret));
+			ret = -1;
+			goto rele;
+		}
+	} else if (direct || !S_ISDIR(VFS_I(dp)->i_mode)) {
+		/* List the directory entry associated with a single file. */
+		char		inum[32];
+
+		if (!tag) {
+			snprintf(inum, sizeof(inum), "<%llu>",
+					(unsigned long long)iocur_top->ino);
+			tag = inum;
+		} else {
+			char	*p = strrchr(tag, '/');
+
+			if (p)
+				tag = p + 1;
+		}
+
+		dir_emit(mp, tag, -1, iocur_top->ino,
+				libxfs_mode_to_ftype(VFS_I(dp)->i_mode));
+	} else {
+		dbprintf(_("current inode %llu is not a directory.\n"),
+				(unsigned long long)iocur_top->ino);
+		ret = -1;
+		goto rele;
+	}
+
+rele:
+	libxfs_irele(dp);
+	return ret;
+}
+
+static void
+ls_help(void)
+{
+	dbprintf(_(
+"\n"
+" List the contents of the currently selected directory inode.\n"
+"\n"
+" Options:\n"
+"   -d -- List directories themselves, not their contents.\n"
+"\n"
+" Directory contents will be listed in the format:\n"
+" inode_number	type	hash	name_length	name\n"
+	));
+}
+
+static int
+ls_f(
+	int			argc,
+	char			**argv)
+{
+	bool			direct = false;
+	int			c;
+	int			ret = 0;
+
+	while ((c = getopt(argc, argv, "d")) != -1) {
+		switch (c) {
+		case 'd':
+			direct = true;
+			break;
+		default:
+			ls_help();
+			return 0;
+		}
+	}
+
+	if (optind == argc) {
+		if (ls_cur(NULL, direct))
+			exitcode = 1;
+		return 0;
+	}
+
+	for (c = optind; c < argc; c++) {
+		push_cur();
+
+		ret = path_walk(argv[c]);
+		if (ret)
+			goto err_cur;
+
+		ret = ls_cur(argv[c], direct);
+		if (ret)
+			goto err_cur;
+
+		pop_cur();
+	}
+
+	return 0;
+err_cur:
+	pop_cur();
+	if (ret)
+		exitcode = 1;
+	return 0;
+}
+
+static const cmdinfo_t ls_cmd = {
+	.name		= "ls",
+	.altname	= "l",
+	.cfunc		= ls_f,
+	.argmin		= 0,
+	.argmax		= -1,
+	.canpush	= 0,
+	.args		= "[-d] [paths...]",
+	.oneline	= N_("list directory contents"),
+	.help		= ls_help,
+};
+
 void
 namei_init(void)
 {
 	add_command(&path_cmd);
+	add_command(&ls_cmd);
 }
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index e7e42e93a07e..7029d0e7daf7 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -187,6 +187,7 @@
 #define xfs_trans_resv_calc		libxfs_trans_resv_calc
 #define xfs_trans_roll_inode		libxfs_trans_roll_inode
 #define xfs_trans_roll			libxfs_trans_roll
+#define xfs_trim_extent			libxfs_trim_extent
 
 #define xfs_verify_agbno		libxfs_verify_agbno
 #define xfs_verify_agino		libxfs_verify_agino
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index d67e108a706a..fefe862b7564 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -806,6 +806,20 @@ This makes it easier to find discrepancies in the reservation calculations
 between xfsprogs and the kernel, which will help when diagnosing minimum
 log size calculation errors.
 .TP
+.BI "ls [\-d] [" dir_path "]..."
+List the contents of the given paths.
+If a path resolves to a directory, the directory will be listed.
+If a path resolves to a file that is not a directory, the entry for the file
+within the parent directory will be listed.
+If no paths are supplied and the IO cursor points at a directory inode,
+the contents of that directory will be listed.
+If no paths are supplied and the IO cursor points at a file that is not a
+directory, a directory entry will be synthesized for the file.
+If the
+.B \-d
+option is specified, list the directory itself and not its contents.
+The output format is: inode number, file type, hash, name length, name.
+.TP
 .BI "metadump [\-egow] " filename
 Dumps metadata to a file. See
 .BR xfs_metadump (8)

