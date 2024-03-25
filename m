Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A02615956F
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 06:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711348499; cv=none; b=ne7KpHI9bsQe+qdw22gd31GhbFyIEB0GwdauyBLS/EaRjbIpRWY/XRvo74mKkE0VOZqQhWfABJqMJF0DP+pri3qEJCJKWwUTn6xPQQhqJ1rUhOZ3bAW5y6vZcejcllgx4UQv+HvcvoP0ac6oDuOKWYbjcHI9QOK5KhcofmRnqi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711348499; c=relaxed/simple;
	bh=2l4i4UwrZC8fkwZ32BriKxWJXWYlAFUN/wT6n0U7++M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Fzk0u3w0SowIx0Yv4R/ZgZXbt8+uOVg+NFk0/uEsgO3qUk/74WYB0s8pCn2Wkkfic66EeGG80QQHlfI47PQz0M/le0eJ2KSPb/XDxMMJIPIG69g/ZLtmSZdaEzrUYnjpWB0BQ/B9OLxs9UiXXl05VmR/eSAqL2JUt6+THFBvz50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=h/3Vq8dw; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h/3Vq8dw"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42P6M5Z3002218;
	Mon, 25 Mar 2024 06:34:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=s2wh4SiVsGAgvzDNZ158ztuCBwP2SApQiAaPTcvSkVM=;
 b=h/3Vq8dwip5jG6VbUpozXvdqDV1lrsyZhYyAkDregF8BpFhRc/uKpBD3gtKVUVpeU5U0
 A/uRh6rvsjksLJ0XeSl2zlc4nCZa3LZif6Tac2tc8wH8lwwbUteNtML57cEjxin+SeBV
 rhtxvgFEQyqKffP0yzyy0JuzXHVqq+PjeQJfphPI5ENIZ5okTxOIg9OdSdojLu1MS/gh
 ekcRImuiYNy0eDgF6MrvYqWJ4OOqTUp/A7DYnWKeuO47F7qUjKDW/gr3h4rxjJfd+rGd
 UBw9oRPD+J2q6hJq7oNYEtRrcUAVyujATTAuvtmPNwUjCX/qIONi8OPDm+xlT5lPNHMC 6g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x28ct190x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Mar 2024 06:34:53 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42P6VK5S039819;
	Mon, 25 Mar 2024 06:34:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh5615h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Mar 2024 06:34:52 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42P6Yqmg035669;
	Mon, 25 Mar 2024 06:34:52 GMT
Received: from srikcs-casa.osdevelopmeniad.oraclevcn.com (srikcs-casa.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.56])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3x1nh56153-1;
	Mon, 25 Mar 2024 06:34:52 +0000
From: Srikanth C S <srikanth.c.s@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org, srikanth.c.s@oracle.com, djwong@kernel.org,
        rajesh.sivaramasubramaniom@oracle.com
Subject: [PATCH v2] xfs_repair: Dump both inode details in Phase 6 duplicate file check
Date: Mon, 25 Mar 2024 06:34:43 +0000
Message-Id: <20240325063443.2398800-1-srikanth.c.s@oracle.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_04,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 spamscore=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250034
X-Proofpoint-GUID: yELjdyn6wXS-QEc78n34v_TSZYs2YtVs
X-Proofpoint-ORIG-GUID: yELjdyn6wXS-QEc78n34v_TSZYs2YtVs

The current check for duplicate names only dumps the inode number of the
parent directory and the inode number of the actual inode in question.
But, the inode number of original inode is not dumped. This patch dumps
the original inode too.

xfs_repair output before applying this patch
Phase 6 - check inode connectivity...
        - traversing filesystem ...
entry "dup-name1" (ino 132) in dir 128 is a duplicate name, would junk entry
entry "dup-name1" (ino 133) in dir 128 is a duplicate name, would junk entry

After this patch
Phase 6 - check inode connectivity...
        - traversing filesystem ...
entry "dup-name1" (ino 132) in dir 128 already points to ino 131, would junk entry
entry "dup-name1" (ino 133) in dir 128 already points to ino 131, would junk entry

The entry_junked() function takes in only 4 arguments. In order to
print the original inode number, modifying the function to take 5 parameters

Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
---
 repair/phase6.c | 51 +++++++++++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 3870c5c9..3d5af436 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -151,9 +151,10 @@ dir_read_buf(
 }
 
 /*
- * Returns 0 if the name already exists (ie. a duplicate)
+ * Returns inode number of original file if the name already exists
+ * (ie. a duplicate)
  */
-static int
+static xfs_ino_t
 dir_hash_add(
 	struct xfs_mount	*mp,
 	struct dir_hash_tab	*hashtab,
@@ -166,7 +167,7 @@ dir_hash_add(
 	xfs_dahash_t		hash = 0;
 	int			byhash = 0;
 	struct dir_hash_ent	*p;
-	int			dup;
+	xfs_ino_t		dup_inum;
 	short			junk;
 	struct xfs_name		xname;
 	int			error;
@@ -176,7 +177,7 @@ dir_hash_add(
 	xname.type = ftype;
 
 	junk = name[0] == '/';
-	dup = 0;
+	dup_inum = NULLFSINO;
 
 	if (!junk) {
 		hash = libxfs_dir2_hashname(mp, &xname);
@@ -188,7 +189,7 @@ dir_hash_add(
 		for (p = hashtab->byhash[byhash]; p; p = p->nextbyhash) {
 			if (p->hashval == hash && p->name.len == namelen) {
 				if (memcmp(p->name.name, name, namelen) == 0) {
-					dup = 1;
+					dup_inum = p->inum;
 					junk = 1;
 					break;
 				}
@@ -234,7 +235,7 @@ dir_hash_add(
 	p->name.name = p->namebuf;
 	p->name.len = namelen;
 	p->name.type = ftype;
-	return !dup;
+	return dup_inum;
 }
 
 /* Mark an existing directory hashtable entry as junk. */
@@ -1173,9 +1174,13 @@ entry_junked(
 	const char 	*msg,
 	const char	*iname,
 	xfs_ino_t	ino1,
-	xfs_ino_t	ino2)
+	xfs_ino_t	ino2,
+	xfs_ino_t	ino3)
 {
-	do_warn(msg, iname, ino1, ino2);
+	if(ino3 != NULLFSINO)
+		do_warn(msg, iname, ino1, ino2, ino3);
+	else
+		do_warn(msg, iname, ino1, ino2);
 	if (!no_modify)
 		do_warn(_("junking entry\n"));
 	else
@@ -1470,6 +1475,7 @@ longform_dir2_entry_check_data(
 	int			i;
 	int			ino_offset;
 	xfs_ino_t		inum;
+	xfs_ino_t		dup_inum;
 	ino_tree_node_t		*irec;
 	int			junkit;
 	int			lastfree;
@@ -1680,7 +1686,7 @@ longform_dir2_entry_check_data(
 			nbad++;
 			if (entry_junked(
 	_("entry \"%s\" in directory inode %" PRIu64 " points to non-existent inode %" PRIu64 ", "),
-					fname, ip->i_ino, inum)) {
+					fname, ip->i_ino, inum, NULLFSINO)) {
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(&da, bp, dep);
 			}
@@ -1697,7 +1703,7 @@ longform_dir2_entry_check_data(
 			nbad++;
 			if (entry_junked(
 	_("entry \"%s\" in directory inode %" PRIu64 " points to free inode %" PRIu64 ", "),
-					fname, ip->i_ino, inum)) {
+					fname, ip->i_ino, inum, NULLFSINO)) {
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(&da, bp, dep);
 			}
@@ -1715,7 +1721,7 @@ longform_dir2_entry_check_data(
 				nbad++;
 				if (entry_junked(
 	_("%s (ino %" PRIu64 ") in root (%" PRIu64 ") is not a directory, "),
-						ORPHANAGE, inum, ip->i_ino)) {
+						ORPHANAGE, inum, ip->i_ino, NULLFSINO)) {
 					dep->name[0] = '/';
 					libxfs_dir2_data_log_entry(&da, bp, dep);
 				}
@@ -1732,12 +1738,13 @@ longform_dir2_entry_check_data(
 		/*
 		 * check for duplicate names in directory.
 		 */
-		if (!dir_hash_add(mp, hashtab, addr, inum, dep->namelen,
-				dep->name, libxfs_dir2_data_get_ftype(mp, dep))) {
+		dup_inum = dir_hash_add(mp, hashtab, addr, inum, dep->namelen,
+				dep->name, libxfs_dir2_data_get_ftype(mp, dep));
+		if (dup_inum != NULLFSINO) {
 			nbad++;
 			if (entry_junked(
-	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name, "),
-					fname, inum, ip->i_ino)) {
+	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " already points to ino %" PRIu64 ", "),
+					fname, inum, ip->i_ino, dup_inum)) {
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(&da, bp, dep);
 			}
@@ -1768,7 +1775,7 @@ longform_dir2_entry_check_data(
 				nbad++;
 				if (entry_junked(
 	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is not in the the first block, "), fname,
-						inum, ip->i_ino)) {
+						inum, ip->i_ino, NULLFSINO)) {
 					dir_hash_junkit(hashtab, addr);
 					dep->name[0] = '/';
 					libxfs_dir2_data_log_entry(&da, bp, dep);
@@ -1801,7 +1808,7 @@ longform_dir2_entry_check_data(
 				nbad++;
 				if (entry_junked(
 	_("entry \"%s\" in dir %" PRIu64 " is not the first entry, "),
-						fname, inum, ip->i_ino)) {
+						fname, inum, ip->i_ino, NULLFSINO)) {
 					dir_hash_junkit(hashtab, addr);
 					dep->name[0] = '/';
 					libxfs_dir2_data_log_entry(&da, bp, dep);
@@ -2456,6 +2463,7 @@ shortform_dir2_entry_check(
 {
 	xfs_ino_t		lino;
 	xfs_ino_t		parent;
+	xfs_ino_t		dup_inum;
 	struct xfs_dir2_sf_hdr	*sfp;
 	struct xfs_dir2_sf_entry *sfep;
 	struct xfs_dir2_sf_entry *next_sfep;
@@ -2639,13 +2647,14 @@ shortform_dir2_entry_check(
 		/*
 		 * check for duplicate names in directory.
 		 */
-		if (!dir_hash_add(mp, hashtab, (xfs_dir2_dataptr_t)
+		dup_inum = dir_hash_add(mp, hashtab, (xfs_dir2_dataptr_t)
 				(sfep - xfs_dir2_sf_firstentry(sfp)),
 				lino, sfep->namelen, sfep->name,
-				libxfs_dir2_sf_get_ftype(mp, sfep))) {
+				libxfs_dir2_sf_get_ftype(mp, sfep));
+		if (dup_inum != NULLFSINO) {
 			do_warn(
-_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name, "),
-				fname, lino, ino);
+_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " already points to ino %" PRIu64 ", "),
+				fname, lino, ino, dup_inum);
 			next_sfep = shortform_dir2_junk(mp, sfp, sfep, lino,
 						&max_size, &i, &bytes_deleted,
 						ino_dirty);
-- 
2.25.1

