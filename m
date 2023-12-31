Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE92C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YD4yEgYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D00C433C8;
	Sun, 31 Dec 2023 23:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064297;
	bh=MEZDtEHAaTzBfu3pxZnYFoYz7wdnlbra0j+KO0FNyc0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YD4yEgYAJNkE3DkCfQZ0s+CKAvGgUk/XwFWsdJTu8igoxe+iG4GtAyqrdCr7cxIhg
	 q/SfBeGnUiLI5fBIzXftBhasLx9C+NILBHdAjsoeJJrXzlySiqasW1GJEfKMU67Hxb
	 iFlGq5ST+aKq6REwbg0JcVx7YjN9+h361dTitvuckGIWT7j96ZmoWjC2KEQUv+TSqr
	 wQ79dDSDNkpmrjyAYerv+PZeJ/m2MajOmVwq0XeXLtjuvGHXwPKOIKwYqyH6vuJkYK
	 x+KPswUzPGSq/TFzHl4ay/7y62xTeLlFKLdHWV2cok+fj9e8AELsPjxddNDlyuv1DZ
	 dnQuLSJ9/R8oQ==
Date: Sun, 31 Dec 2023 15:11:37 -0800
Subject: [PATCH 25/32] xfs_db: report parent pointers embedded in xattrs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006434.1804688.3757235808372242607.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
References: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Decode the parent pointer inode, generation, namehash, and name fields
if the parent pointer passes basic validation checks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/attr.c      |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/attrshort.c |   48 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+)


diff --git a/db/attr.c b/db/attr.c
index f29e4a54454..9e7bbd164df 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -19,6 +19,8 @@ static int	attr_leaf_entries_count(void *obj, int startoff);
 static int	attr_leaf_hdr_count(void *obj, int startoff);
 static int	attr_leaf_name_local_count(void *obj, int startoff);
 static int	attr_leaf_name_local_name_count(void *obj, int startoff);
+static int	attr_leaf_name_pptr_count(void *obj, int startoff);
+static int	attr_leaf_name_pptr_namelen(void *obj, int startoff);
 static int	attr_leaf_name_local_value_count(void *obj, int startoff);
 static int	attr_leaf_name_local_value_offset(void *obj, int startoff,
 						  int idx);
@@ -111,6 +113,8 @@ const field_t	attr_leaf_map_flds[] = {
 
 #define	LNOFF(f)	bitize(offsetof(xfs_attr_leaf_name_local_t, f))
 #define	LVOFF(f)	bitize(offsetof(xfs_attr_leaf_name_remote_t, f))
+#define	PPOFF(f)	bitize(offsetof(xfs_attr_leaf_name_local_t, nameval) + \
+			       offsetof(struct xfs_parent_name_rec, f))
 const field_t	attr_leaf_name_flds[] = {
 	{ "valuelen", FLDT_UINT16D, OI(LNOFF(valuelen)),
 	  attr_leaf_name_local_count, FLD_COUNT, TYP_NONE },
@@ -118,6 +122,14 @@ const field_t	attr_leaf_name_flds[] = {
 	  attr_leaf_name_local_count, FLD_COUNT, TYP_NONE },
 	{ "name", FLDT_CHARNS, OI(LNOFF(nameval)),
 	  attr_leaf_name_local_name_count, FLD_COUNT, TYP_NONE },
+	{ "parent_ino", FLDT_INO, OI(PPOFF(p_ino)),
+	  attr_leaf_name_pptr_count, FLD_COUNT, TYP_INODE },
+	{ "parent_gen", FLDT_UINT32D, OI(PPOFF(p_gen)),
+	  attr_leaf_name_pptr_count, FLD_COUNT, TYP_NONE },
+	{ "parent_namehash", FLDT_UINT32X, OI(PPOFF(p_namehash)),
+	  attr_leaf_name_pptr_count, FLD_COUNT, TYP_NONE },
+	{ "parent_name", FLDT_CHARNS, attr_leaf_name_local_value_offset,
+	  attr_leaf_name_pptr_namelen, FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ "value", FLDT_CHARNS, attr_leaf_name_local_value_offset,
 	  attr_leaf_name_local_value_count, FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ "valueblk", FLDT_UINT32X, OI(LVOFF(valueblk)),
@@ -273,6 +285,26 @@ attr_leaf_name_local_count(
 				    __attr_leaf_name_local_count);
 }
 
+static int
+__attr_leaf_name_pptr_count(
+	struct xfs_attr_leafblock	*leaf,
+	struct xfs_attr_leaf_entry      *e,
+	int				i)
+{
+	if ((e->flags & XFS_ATTR_NSP_ONDISK_MASK) == XFS_ATTR_PARENT)
+		return 1;
+	return 0;
+}
+
+static int
+attr_leaf_name_pptr_count(
+	void				*obj,
+	int				startoff)
+{
+	return attr_leaf_entry_walk(obj, startoff,
+			__attr_leaf_name_pptr_count);
+}
+
 static int
 __attr_leaf_name_local_name_count(
 	struct xfs_attr_leafblock	*leaf,
@@ -283,6 +315,8 @@ __attr_leaf_name_local_name_count(
 
 	if (!(e->flags & XFS_ATTR_LOCAL))
 		return 0;
+	if ((e->flags & XFS_ATTR_NSP_ONDISK_MASK) == XFS_ATTR_PARENT)
+		return 0;
 
 	l = xfs_attr3_leaf_name_local(leaf, i);
 	return l->namelen;
@@ -297,6 +331,32 @@ attr_leaf_name_local_name_count(
 				    __attr_leaf_name_local_name_count);
 }
 
+static int
+__attr_leaf_name_pptr_namelen(
+	struct xfs_attr_leafblock	*leaf,
+	struct xfs_attr_leaf_entry      *e,
+	int				i)
+{
+	struct xfs_attr_leaf_name_local	*l;
+
+	if (!(e->flags & XFS_ATTR_LOCAL))
+		return 0;
+	if ((e->flags & XFS_ATTR_NSP_ONDISK_MASK) != XFS_ATTR_PARENT)
+		return 0;
+
+	l = xfs_attr3_leaf_name_local(leaf, i);
+	return be16_to_cpu(l->valuelen);
+}
+
+static int
+attr_leaf_name_pptr_namelen(
+	void				*obj,
+	int				startoff)
+{
+	return attr_leaf_entry_walk(obj, startoff,
+				    __attr_leaf_name_pptr_namelen);
+}
+
 static int
 __attr_leaf_name_local_value_count(
 	struct xfs_attr_leafblock	*leaf,
@@ -307,6 +367,8 @@ __attr_leaf_name_local_value_count(
 
 	if (!(e->flags & XFS_ATTR_LOCAL))
 		return 0;
+	if ((e->flags & XFS_ATTR_NSP_ONDISK_MASK) == XFS_ATTR_PARENT)
+		return 0;
 
 	l = xfs_attr3_leaf_name_local(leaf, i);
 	return be16_to_cpu(l->valuelen);
diff --git a/db/attrshort.c b/db/attrshort.c
index 872d771d5ed..9cd3411bee4 100644
--- a/db/attrshort.c
+++ b/db/attrshort.c
@@ -13,6 +13,8 @@
 #include "attrshort.h"
 
 static int	attr_sf_entry_name_count(void *obj, int startoff);
+static int	attr_sf_entry_pptr_count(void *obj, int startoff);
+static int	attr_sf_entry_pptr_namelen(void *obj, int startoff);
 static int	attr_sf_entry_value_count(void *obj, int startoff);
 static int	attr_sf_entry_value_offset(void *obj, int startoff, int idx);
 static int	attr_shortform_list_count(void *obj, int startoff);
@@ -34,6 +36,8 @@ const field_t	attr_sf_hdr_flds[] = {
 };
 
 #define	EOFF(f)	bitize(offsetof(struct xfs_attr_sf_entry, f))
+#define	PPOFF(f) bitize(offsetof(struct xfs_attr_sf_entry, nameval) + \
+			offsetof(struct xfs_parent_name_rec, f))
 const field_t	attr_sf_entry_flds[] = {
 	{ "namelen", FLDT_UINT8D, OI(EOFF(namelen)), C1, 0, TYP_NONE },
 	{ "valuelen", FLDT_UINT8D, OI(EOFF(valuelen)), C1, 0, TYP_NONE },
@@ -49,11 +53,33 @@ const field_t	attr_sf_entry_flds[] = {
 	  TYP_NONE },
 	{ "name", FLDT_CHARNS, OI(EOFF(nameval)), attr_sf_entry_name_count,
 	  FLD_COUNT, TYP_NONE },
+	{ "parent_ino", FLDT_INO, OI(PPOFF(p_ino)), attr_sf_entry_pptr_count,
+	  FLD_COUNT, TYP_INODE },
+	{ "parent_gen", FLDT_UINT32D, OI(PPOFF(p_gen)), attr_sf_entry_pptr_count,
+	  FLD_COUNT, TYP_NONE },
+	{ "parent_namehash", FLDT_UINT32X, OI(PPOFF(p_namehash)),
+	  attr_sf_entry_pptr_count, FLD_COUNT, TYP_NONE },
+	{ "parent_name", FLDT_CHARNS, attr_sf_entry_value_offset,
+	  attr_sf_entry_pptr_namelen, FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ "value", FLDT_CHARNS, attr_sf_entry_value_offset,
 	  attr_sf_entry_value_count, FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ NULL }
 };
 
+static int
+attr_sf_entry_pptr_count(
+	void				*obj,
+	int				startoff)
+{
+	struct xfs_attr_sf_entry	*e;
+
+	ASSERT(bitoffs(startoff) == 0);
+	e = (struct xfs_attr_sf_entry *)((char *)obj + byteize(startoff));
+	if ((e->flags & XFS_ATTR_NSP_ONDISK_MASK) == XFS_ATTR_PARENT)
+		return 1;
+	return 0;
+}
+
 static int
 attr_sf_entry_name_count(
 	void				*obj,
@@ -63,6 +89,8 @@ attr_sf_entry_name_count(
 
 	ASSERT(bitoffs(startoff) == 0);
 	e = (struct xfs_attr_sf_entry *)((char *)obj + byteize(startoff));
+	if ((e->flags & XFS_ATTR_NSP_ONDISK_MASK) == XFS_ATTR_PARENT)
+		return 0;
 	return e->namelen;
 }
 
@@ -84,6 +112,22 @@ attr_sf_entry_size(
 	return bitize((int)xfs_attr_sf_entsize(e));
 }
 
+static int
+attr_sf_entry_pptr_namelen(
+	void				*obj,
+	int				startoff)
+{
+	struct xfs_attr_sf_entry	*e;
+
+	ASSERT(bitoffs(startoff) == 0);
+	e = (struct xfs_attr_sf_entry *)((char *)obj + byteize(startoff));
+
+	if ((e->flags & XFS_ATTR_NSP_ONDISK_MASK) != XFS_ATTR_PARENT)
+		return 0;
+
+	return e->valuelen;
+}
+
 static int
 attr_sf_entry_value_count(
 	void				*obj,
@@ -93,6 +137,10 @@ attr_sf_entry_value_count(
 
 	ASSERT(bitoffs(startoff) == 0);
 	e = (struct xfs_attr_sf_entry *)((char *)obj + byteize(startoff));
+
+	if ((e->flags & XFS_ATTR_NSP_ONDISK_MASK) == XFS_ATTR_PARENT)
+		return 0;
+
 	return e->valuelen;
 }
 

