Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56CD9C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13EA720809
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:37:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J52UP0JB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407216AbgJZXhb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:37:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56528 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407215AbgJZXhb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:37:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPmra165230;
        Mon, 26 Oct 2020 23:37:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ny492RS1Uv1i4e/tReg9IKpnDO1y+opzEddML5D25Dc=;
 b=J52UP0JBf0AIx7Dqb3ZTqYgtIkrTZrkx/hT4ARqAw4ozJbVMgPNmPEfdtoCqcCaudvIT
 Sn7ejMStG/G6rjVgQAT29UjUNNvueB62YJDX8HN0U+69Ka0yIUYR6w4sGxr3fY2VMPZz
 9cNIrYS2AyCcVNubBbKrAR3pdu8FuQ/3N2x8W/Ch7QISLan4kkTfVk6cn0D8ahc1yUd8
 0bJRO8YlLfRxO0J7SFUYpsliAzew14ReI3PYRWhocpSHjtKo1VzWA+gkCypT6Qv9iAJP
 wiDFJvU7lb+snkQRWifrvbl/sPE91dqA+w0AJrAqDn1JjzAUVNiE8qrnxMZHIXpEREpX oQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34dgm3vuwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:37:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPGKs120983;
        Mon, 26 Oct 2020 23:37:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34cx6va799-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:37:25 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNbOXf013580;
        Mon, 26 Oct 2020 23:37:24 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:37:23 -0700
Subject: [PATCH 04/21] xfs: Convert xfs_attr_sf macros to inline functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Dave Chinner <dchinner@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:37:22 -0700
Message-ID: <160375544280.882906.9293864103925068100.stgit@magnolia>
In-Reply-To: <160375541713.882906.11902959014062334120.stgit@magnolia>
References: <160375541713.882906.11902959014062334120.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=9
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=9 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Carlos Maiolino <cmaiolino@redhat.com>

Source kernel commit: e01b7eed5d0a9b101da53701e92136c3985998af

xfs_attr_sf_totsize() requires access to xfs_inode structure, so, once
xfs_attr_shortform_addname() is its only user, move it to xfs_attr.c
instead of playing with more #includes.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/attrshort.c             |    8 ++++----
 db/metadump.c              |    4 ++--
 include/platform_defs.h.in |   27 +++++++++++++++++++++++++++
 libxfs/xfs_attr.c          |   14 +++++++++++---
 libxfs/xfs_attr_leaf.c     |   18 +++++++++---------
 libxfs/xfs_attr_sf.h       |   30 +++++++++++++++++++-----------
 repair/attr_repair.c       |    8 ++++----
 7 files changed, 76 insertions(+), 33 deletions(-)


diff --git a/db/attrshort.c b/db/attrshort.c
index 5746c66a62e0..6275ad7a1141 100644
--- a/db/attrshort.c
+++ b/db/attrshort.c
@@ -77,8 +77,8 @@ attr_sf_entry_size(
 	sf = (struct xfs_attr_shortform *)((char *)obj + byteize(startoff));
 	e = &sf->list[0];
 	for (i = 0; i < idx; i++)
-		e = XFS_ATTR_SF_NEXTENTRY(e);
-	return bitize((int)XFS_ATTR_SF_ENTSIZE(e));
+		e = xfs_attr_sf_nextentry(e);
+	return bitize((int)xfs_attr_sf_entsize(e));
 }
 
 static int
@@ -134,7 +134,7 @@ attr_shortform_list_offset(
 	sf = (struct xfs_attr_shortform *)((char *)obj + byteize(startoff));
 	e = &sf->list[0];
 	for (i = 0; i < idx; i++)
-		e = XFS_ATTR_SF_NEXTENTRY(e);
+		e = xfs_attr_sf_nextentry(e);
 	return bitize((int)((char *)e - (char *)sf));
 }
 
@@ -154,6 +154,6 @@ attrshort_size(
 	sf = (struct xfs_attr_shortform *)((char *)obj + byteize(startoff));
 	e = &sf->list[0];
 	for (i = 0; i < sf->hdr.count; i++)
-		e = XFS_ATTR_SF_NEXTENTRY(e);
+		e = xfs_attr_sf_nextentry(e);
 	return bitize((int)((char *)e - (char *)sf));
 }
diff --git a/db/metadump.c b/db/metadump.c
index 468235cc94b1..6ff8c8725255 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1399,7 +1399,7 @@ process_sf_attr(
 						"%llu", (long long)cur_ino);
 			break;
 		} else if ((char *)asfep - (char *)asfp +
-				XFS_ATTR_SF_ENTSIZE(asfep) > ino_attr_size) {
+				xfs_attr_sf_entsize(asfep) > ino_attr_size) {
 			if (show_warnings)
 				print_warning("attr entry length in inode %llu "
 					"overflows space", (long long)cur_ino);
@@ -1414,7 +1414,7 @@ process_sf_attr(
 		}
 
 		asfep = (struct xfs_attr_sf_entry *)((char *)asfep +
-				XFS_ATTR_SF_ENTSIZE(asfep));
+				xfs_attr_sf_entsize(asfep));
 	}
 
 	/* zero stale data in rest of space in attr fork, if any */
diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index a11b58719380..f8c456261b62 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -83,4 +83,31 @@ extern int	platform_nproc(void);
 #define NSEC_PER_SEC	(1000000000ULL)
 #define NSEC_PER_USEC	(1000ULL)
 
+/*
+ * Compute a*b+c, returning SIZE_MAX on overflow. Internal helper for
+ * struct_size() below.
+ */
+static inline size_t __ab_c_size(size_t a, size_t b, size_t c)
+{
+	return (a * b) + c;
+}
+
+#define __must_be_array(a) (0)
+
+/**
+ * struct_size() - Calculate size of structure with trailing array.
+ * @p: Pointer to the structure.
+ * @member: Name of the array member.
+ * @count: Number of elements in the array.
+ *
+ * Calculates size of memory needed for structure @p followed by an
+ * array of @count number of @member elements.
+ *
+ * Return: number of bytes needed or SIZE_MAX on overflow.
+ */
+#define struct_size(p, member, count)					\
+	__ab_c_size(count,						\
+		    sizeof(*(p)->member) + __must_be_array((p)->member),\
+		    sizeof(*(p)))
+
 #endif	/* __XFS_PLATFORM_DEFS_H__ */
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 1c1092fe6d53..0c75f46fed11 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -428,7 +428,7 @@ xfs_attr_set(
 		 */
 		if (XFS_IFORK_Q(dp) == 0) {
 			int sf_size = sizeof(struct xfs_attr_sf_hdr) +
-				XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen,
+				xfs_attr_sf_entsize_byname(args->namelen,
 						args->valuelen);
 
 			error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
@@ -523,6 +523,14 @@ xfs_attr_set(
  * External routines when attribute list is inside the inode
  *========================================================================*/
 
+static inline int xfs_attr_sf_totsize(struct xfs_inode *dp)
+{
+	struct xfs_attr_shortform *sf;
+
+	sf = (struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
+	return be16_to_cpu(sf->hdr.totsize);
+}
+
 /*
  * Add a name to the shortform attribute list structure
  * This is the external routine.
@@ -555,8 +563,8 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
 	    args->valuelen >= XFS_ATTR_SF_ENTSIZE_MAX)
 		return -ENOSPC;
 
-	newsize = XFS_ATTR_SF_TOTSIZE(args->dp);
-	newsize += XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
+	newsize = xfs_attr_sf_totsize(args->dp);
+	newsize += xfs_attr_sf_entsize_byname(args->namelen, args->valuelen);
 
 	forkoff = xfs_attr_shortform_bytesfit(args->dp, newsize);
 	if (!forkoff)
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 77cd19fd228a..08117446bc66 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -681,9 +681,9 @@ xfs_attr_sf_findname(
 	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
 	sfe = &sf->list[0];
 	end = sf->hdr.count;
-	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
+	for (i = 0; i < end; sfe = xfs_attr_sf_nextentry(sfe),
 			     base += size, i++) {
-		size = XFS_ATTR_SF_ENTSIZE(sfe);
+		size = xfs_attr_sf_entsize(sfe);
 		if (!xfs_attr_match(args, sfe->namelen, sfe->nameval,
 				    sfe->flags))
 			continue;
@@ -730,7 +730,7 @@ xfs_attr_shortform_add(
 		ASSERT(0);
 
 	offset = (char *)sfe - (char *)sf;
-	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
+	size = xfs_attr_sf_entsize_byname(args->namelen, args->valuelen);
 	xfs_idata_realloc(dp, size, XFS_ATTR_FORK);
 	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
 	sfe = (struct xfs_attr_sf_entry *)((char *)sf + offset);
@@ -789,7 +789,7 @@ xfs_attr_shortform_remove(
 	error = xfs_attr_sf_findname(args, &sfe, &base);
 	if (error != -EEXIST)
 		return error;
-	size = XFS_ATTR_SF_ENTSIZE(sfe);
+	size = xfs_attr_sf_entsize(sfe);
 
 	/*
 	 * Fix up the attribute fork data, covering the hole
@@ -846,7 +846,7 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
 	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
-				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
+				sfe = xfs_attr_sf_nextentry(sfe), i++) {
 		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
 				sfe->flags))
 			return -EEXIST;
@@ -873,7 +873,7 @@ xfs_attr_shortform_getvalue(
 	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
-				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
+				sfe = xfs_attr_sf_nextentry(sfe), i++) {
 		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
 				sfe->flags))
 			return xfs_attr_copy_value(args,
@@ -948,7 +948,7 @@ xfs_attr_shortform_to_leaf(
 		ASSERT(error != -ENOSPC);
 		if (error)
 			goto out;
-		sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
+		sfe = xfs_attr_sf_nextentry(sfe);
 	}
 	error = 0;
 	*leaf_bp = bp;
@@ -989,7 +989,7 @@ xfs_attr_shortform_allfit(
 			return 0;
 		if (be16_to_cpu(name_loc->valuelen) >= XFS_ATTR_SF_ENTSIZE_MAX)
 			return 0;
-		bytes += XFS_ATTR_SF_ENTSIZE_BYNAME(name_loc->namelen,
+		bytes += xfs_attr_sf_entsize_byname(name_loc->namelen,
 					be16_to_cpu(name_loc->valuelen));
 	}
 	if ((dp->i_mount->m_flags & XFS_MOUNT_ATTR2) &&
@@ -1047,7 +1047,7 @@ xfs_attr_shortform_verify(
 		 * within the data buffer.  The next entry starts after the
 		 * name component, so nextentry is an acceptable test.
 		 */
-		next_sfep = XFS_ATTR_SF_NEXTENTRY(sfep);
+		next_sfep = xfs_attr_sf_nextentry(sfep);
 		if ((char *)next_sfep > endp)
 			return __this_address;
 
diff --git a/libxfs/xfs_attr_sf.h b/libxfs/xfs_attr_sf.h
index 29934103ce55..37578b369d9b 100644
--- a/libxfs/xfs_attr_sf.h
+++ b/libxfs/xfs_attr_sf.h
@@ -26,18 +26,26 @@ typedef struct xfs_attr_sf_sort {
 	unsigned char	*name;		/* name value, pointer into buffer */
 } xfs_attr_sf_sort_t;
 
-#define XFS_ATTR_SF_ENTSIZE_BYNAME(nlen,vlen)	/* space name/value uses */ \
-	((sizeof(struct xfs_attr_sf_entry) + (nlen) + (vlen)))
 #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \
 	((1 << (NBBY*(int)sizeof(uint8_t))) - 1)
-#define XFS_ATTR_SF_ENTSIZE(sfep)		/* space an entry uses */ \
-	((int)sizeof(struct xfs_attr_sf_entry) + \
-		(sfep)->namelen+(sfep)->valuelen)
-#define XFS_ATTR_SF_NEXTENTRY(sfep)		/* next entry in struct */ \
-	((struct xfs_attr_sf_entry *)((char *)(sfep) + \
-		XFS_ATTR_SF_ENTSIZE(sfep)))
-#define XFS_ATTR_SF_TOTSIZE(dp)			/* total space in use */ \
-	(be16_to_cpu(((struct xfs_attr_shortform *)	\
-		((dp)->i_afp->if_u1.if_data))->hdr.totsize))
+
+/* space name/value uses */
+static inline int xfs_attr_sf_entsize_byname(uint8_t nlen, uint8_t vlen)
+{
+	return sizeof(struct xfs_attr_sf_entry) + nlen + vlen;
+}
+
+/* space an entry uses */
+static inline int xfs_attr_sf_entsize(struct xfs_attr_sf_entry *sfep)
+{
+	return struct_size(sfep, nameval, sfep->namelen + sfep->valuelen);
+}
+
+/* next entry in struct */
+static inline struct xfs_attr_sf_entry *
+xfs_attr_sf_nextentry(struct xfs_attr_sf_entry *sfep)
+{
+	return (void *)sfep + xfs_attr_sf_entsize(sfep);
+}
 
 #endif	/* __XFS_ATTR_SF_H__ */
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index e0580141c479..a02ed30d6234 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -314,7 +314,7 @@ process_shortform_attr(
 					currententry->valuelen);
 
 		remainingspace = remainingspace -
-					XFS_ATTR_SF_ENTSIZE(currententry);
+					xfs_attr_sf_entsize(currententry);
 
 		if (junkit) {
 			if (!no_modify) {
@@ -324,7 +324,7 @@ process_shortform_attr(
 					i, ino);
 				tempentry = (struct xfs_attr_sf_entry *)
 					((intptr_t) currententry +
-					 XFS_ATTR_SF_ENTSIZE(currententry));
+					 xfs_attr_sf_entsize(currententry));
 				memmove(currententry,tempentry,remainingspace);
 				asf->hdr.count -= 1;
 				i--; /* no worries, it will wrap back to 0 */
@@ -339,8 +339,8 @@ process_shortform_attr(
 
 		/* Let's get ready for the next entry... */
 		nextentry = (struct xfs_attr_sf_entry *)((intptr_t) nextentry +
-			 		XFS_ATTR_SF_ENTSIZE(currententry));
-		currentsize = currentsize + XFS_ATTR_SF_ENTSIZE(currententry);
+					xfs_attr_sf_entsize(currententry));
+		currentsize = currentsize + xfs_attr_sf_entsize(currententry);
 
 	} /* end the loop */
 

