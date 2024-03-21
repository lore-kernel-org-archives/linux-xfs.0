Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DBF12B81
	for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 09:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711011653; cv=none; b=E4xatz05Ie0UKUmg7s958L1SvZxNbmWioaUNF/GjY8FW2JWot5OrpoePndW19HxOTkzAhiAcAzsfIJ0nXBWRNCeqJ3q0i2boV9r/tk5rZO94ceA3sG9dVjDNzVdpm06PXqMpq18qgIcleVDXl4Viq5atgWB7sjTtMFPAzYAfvKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711011653; c=relaxed/simple;
	bh=nPpeY48von1ITEw8FzyJdgn2XpQfb3D3iwGEe1x1ygY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ozKdZEAVZ1Vh0hU9b5HkZrEw+mL+75pxyDwfB7htY5hKlm8ylmuJgArIYWA2Xa3GPAWFRG1/LU/HH63uH7osLSll6XezCriN4LTH92OdB8e5tlScFJx7lpc14W9M0n+YquTtOkPO3Tg06DWcrFDY2Fpn5QLwROI2XX5Gl+C0xjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=atjugCb4; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="atjugCb4"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42L23uXh016480;
	Thu, 21 Mar 2024 09:00:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=SxdhjcDSiVlxN5Dnd7LdUTxI4NLBQUK1vUS0xXVc4+c=;
 b=atjugCb4bDnwIZAGw3r8NgZaoie5MCtmDIumdp78mbsF76r3jqhrm/2acQ4kOG02BvQU
 WvvS/CtlrFgFFt6Lozsr1Oe/BAsmMEv0yaL1imE7tlgx4ud2o1OTICuETGgP8lHbKNNj
 8bdurrW8PRuajK+CXmBCW9YWsxpeW7eriDx2mYUHqOHVuj5QfxVVOCR4bxrz6ZodCGYC
 Nzc65nj3gdTjM8jEjmyWhWJH5oA7PaIGQQZZWnZY0udafIVa05s7+2FBczDXLE7k3OOr
 Zjw795hM4FQ+AIOVGsTYUNXOXKlYrnjP8+JyGK920XUINhhzjcqLs94PxfxlSe4XUGEX vw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ww27322um-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Mar 2024 09:00:42 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42L8c3Xu007965;
	Thu, 21 Mar 2024 09:00:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ww1v8yjef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Mar 2024 09:00:41 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42L8uUbd026047;
	Thu, 21 Mar 2024 09:00:41 GMT
Received: from srikcs-casa.osdevelopmeniad.oraclevcn.com (srikcs-casa.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.56])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3ww1v8yjdj-1;
	Thu, 21 Mar 2024 09:00:41 +0000
From: Srikanth C S <srikanth.c.s@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org, rajesh.sivaramasubramaniom@oracle.com,
        srikanth.c.s@oracle.com
Subject: [PATCH RFC] xfs_repair: Dump both inode details in Phase 6 duplicate file check
Date: Thu, 21 Mar 2024 09:00:05 +0000
Message-Id: <20240321090005.2234459-1-srikanth.c.s@oracle.com>
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
 definitions=2024-03-21_06,2024-03-18_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403140000
 definitions=main-2403210061
X-Proofpoint-GUID: HOd2s5Wfv6siUHyXAq2e158ihUYsmBR9
X-Proofpoint-ORIG-GUID: HOd2s5Wfv6siUHyXAq2e158ihUYsmBR9

The current check for duplicate names only dumps the inode number of the
parent directory and the inode number of the actual inode in question.
But, the inode number of original inode is not dumped. This patch dumps
the original inode too which can be helpful for diagnosis.

xfs_repair output 
Phase 6 - check inode connectivity...
        - traversing filesystem ...
entry "dup-name1" (ino 132) in dir 128 is a duplicate name, would junk entry
entry "dup-name1" (ino 133) in dir 128 is a duplicate name, would junk entry

After this change
Phase 6 - check inode connectivity...
        - traversing filesystem ...
entry "dup-name1" (ino 132) in dir 128 is a duplicate name (ino 131), would junk entry
entry "dup-name1" (ino 133) in dir 128 is a duplicate name (ino 131), would junk entry

The entry_junked() function takes in only 4 arguments. In order to
print the original inode number, modifying the function to take 5 parameters.

Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
---
 repair/phase6.c | 51 +++++++++++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 3870c5c9..7e17ed75 100644
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
+	dup_inum = 0;
 
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
+	if(ino3)
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
+					fname, ip->i_ino, inum, 0)) {
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(&da, bp, dep);
 			}
@@ -1697,7 +1703,7 @@ longform_dir2_entry_check_data(
 			nbad++;
 			if (entry_junked(
 	_("entry \"%s\" in directory inode %" PRIu64 " points to free inode %" PRIu64 ", "),
-					fname, ip->i_ino, inum)) {
+					fname, ip->i_ino, inum, 0)) {
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(&da, bp, dep);
 			}
@@ -1715,7 +1721,7 @@ longform_dir2_entry_check_data(
 				nbad++;
 				if (entry_junked(
 	_("%s (ino %" PRIu64 ") in root (%" PRIu64 ") is not a directory, "),
-						ORPHANAGE, inum, ip->i_ino)) {
+						ORPHANAGE, inum, ip->i_ino, 0)) {
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
+		if (dup_inum) {
 			nbad++;
 			if (entry_junked(
-	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name, "),
-					fname, inum, ip->i_ino)) {
+	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name (ino %" PRIu64 "), "),
+					fname, inum, ip->i_ino, dup_inum)) {
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(&da, bp, dep);
 			}
@@ -1768,7 +1775,7 @@ longform_dir2_entry_check_data(
 				nbad++;
 				if (entry_junked(
 	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is not in the the first block, "), fname,
-						inum, ip->i_ino)) {
+						inum, ip->i_ino, 0)) {
 					dir_hash_junkit(hashtab, addr);
 					dep->name[0] = '/';
 					libxfs_dir2_data_log_entry(&da, bp, dep);
@@ -1801,7 +1808,7 @@ longform_dir2_entry_check_data(
 				nbad++;
 				if (entry_junked(
 	_("entry \"%s\" in dir %" PRIu64 " is not the first entry, "),
-						fname, inum, ip->i_ino)) {
+						fname, inum, ip->i_ino, 0)) {
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
+		if (dup_inum) {
 			do_warn(
-_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name, "),
-				fname, lino, ino);
+_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name (ino %" PRIu64 "), "),
+				fname, lino, ino, dup_inum);
 			next_sfep = shortform_dir2_junk(mp, sfp, sfep, lino,
 						&max_size, &i, &bytes_deleted,
 						ino_dirty);
-- 
2.25.1

