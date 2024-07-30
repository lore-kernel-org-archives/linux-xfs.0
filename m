Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD4828EB
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302566; cv=none; b=H17jNZZ9dpBjH79VzhH/3OFanaYScJ+/S3uw1hdxO4MeFYRn0FCKdqaQ1abnVjlh1TO8f/dPa9T6WVOfVFwIU2w+/wVJ/c0s0MhmRJB36hooQZyP00Xz3p0TBciWGq6OIvoxejMUbGnRBkPIgHgKJwUlURget+VOhzCRKiFfTJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302566; c=relaxed/simple;
	bh=a33J4Fes1AeUQKXtwpnFOYxzZzK81D1+NtJuXD1xADg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HaCOf1VpS+/HLivCd7PN4pZA78c+xYO5aPUZNMlDWw6VH3gnlGh5GNFHnXxaC35noq0dxkLzC1bsA4sVk25ZiQVHKGSmf8ZCDSMdnp0lm39E+2SkzgsHuYJF073cobvLnfZM9GykDQfWsoz3qMQ92y4N6PW9tEnuKh3k/zBj+oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u8KyijVP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u8KyijVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592F6C32786;
	Tue, 30 Jul 2024 01:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302566;
	bh=a33J4Fes1AeUQKXtwpnFOYxzZzK81D1+NtJuXD1xADg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u8KyijVPPmzy3BrPx3IwPEjyAed2UY7r7f/FoiM5KQ/BCtv/dtTLmnveU+wQ6Y23w
	 qMJHzE9+ILqR1oM+ofpwQ/H0VG5dH23CjOCX1S/dBQytHJ373fBM/WQOlKi5yQRRg8
	 Bu/QLBlfI69/GlgRQU2z+7g/RnoH9MGGavOw1fA3oXjhzLWGk7nvmLGzg4OfHg8QPH
	 MnkbLMlTla0azKfyLNlkjNseFzpzZF+7i4pcntznZ1nXP6SlwsNt41ubOCwaGWzL0L
	 CIctR85OllkQIUsflPy25+srZNxTb96GVZ51B7lHzAaV1BfyNBjbzcIIBNTFPrdpYE
	 Ca6gB067U9O3Q==
Date: Mon, 29 Jul 2024 18:22:45 -0700
Subject: [PATCH 15/24] xfs_db: report parent pointers embedded in xattrs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229850714.1350924.16080767930927648394.stgit@frogsfrogsfrogs>
In-Reply-To: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
References: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
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

Decode the parent pointer inode, generation, and name fields if the
parent pointer passes basic validation checks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/attr.c      |   28 ++++++++++++++++++++++++++++
 db/attrshort.c |   24 ++++++++++++++++++++++++
 db/field.c     |   10 ++++++++++
 db/field.h     |    3 +++
 4 files changed, 65 insertions(+)


diff --git a/db/attr.c b/db/attr.c
index 3252f3886..3b556c43d 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -33,6 +33,8 @@ static int	attr_remote_data_count(void *obj, int startoff);
 static int	attr3_remote_hdr_count(void *obj, int startoff);
 static int	attr3_remote_data_count(void *obj, int startoff);
 
+static int	attr_leaf_value_pptr_count(void *obj, int startoff);
+
 const field_t	attr_hfld[] = {
 	{ "", FLDT_ATTR, OI(0), C1, 0, TYP_NONE },
 	{ NULL }
@@ -118,6 +120,8 @@ const field_t	attr_leaf_name_flds[] = {
 	  attr_leaf_name_local_count, FLD_COUNT, TYP_NONE },
 	{ "name", FLDT_CHARNS, OI(LNOFF(nameval)),
 	  attr_leaf_name_local_name_count, FLD_COUNT, TYP_NONE },
+	{ "parent_dir", FLDT_PARENT_REC, attr_leaf_name_local_value_offset,
+	  attr_leaf_value_pptr_count, FLD_COUNT | FLD_OFFSET, TYP_NONE },
 	{ "value", FLDT_CHARNS, attr_leaf_name_local_value_offset,
 	  attr_leaf_name_local_value_count, FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ "valueblk", FLDT_UINT32X, OI(LVOFF(valueblk)),
@@ -307,6 +311,8 @@ __attr_leaf_name_local_value_count(
 
 	if (!(e->flags & XFS_ATTR_LOCAL))
 		return 0;
+	if ((e->flags & XFS_ATTR_NSP_ONDISK_MASK) == XFS_ATTR_PARENT)
+		return 0;
 
 	l = xfs_attr3_leaf_name_local(leaf, i);
 	return be16_to_cpu(l->valuelen);
@@ -514,6 +520,28 @@ attr3_remote_hdr_count(
 	return be32_to_cpu(node->rm_magic) == XFS_ATTR3_RMT_MAGIC;
 }
 
+static int
+__leaf_pptr_count(
+	struct xfs_attr_leafblock	*leaf,
+	struct xfs_attr_leaf_entry      *e,
+	int				i)
+{
+	if (!(e->flags & XFS_ATTR_LOCAL))
+		return 0;
+	if ((e->flags & XFS_ATTR_NSP_ONDISK_MASK) != XFS_ATTR_PARENT)
+		return 0;
+
+	return 1;
+}
+
+static int
+attr_leaf_value_pptr_count(
+	void				*obj,
+	int				startoff)
+{
+	return attr_leaf_entry_walk(obj, startoff, __leaf_pptr_count);
+}
+
 int
 attr_size(
 	void	*obj,
diff --git a/db/attrshort.c b/db/attrshort.c
index 978f58d67..7e5c94ca5 100644
--- a/db/attrshort.c
+++ b/db/attrshort.c
@@ -18,6 +18,8 @@ static int	attr_sf_entry_value_offset(void *obj, int startoff, int idx);
 static int	attr_shortform_list_count(void *obj, int startoff);
 static int	attr_shortform_list_offset(void *obj, int startoff, int idx);
 
+static int	attr_sf_entry_pptr_count(void *obj, int startoff);
+
 const field_t	attr_shortform_flds[] = {
 	{ "hdr", FLDT_ATTR_SF_HDR, OI(0), C1, 0, TYP_NONE },
 	{ "list", FLDT_ATTR_SF_ENTRY, attr_shortform_list_offset,
@@ -48,6 +50,8 @@ const field_t	attr_sf_entry_flds[] = {
 	  TYP_NONE },
 	{ "name", FLDT_CHARNS, OI(EOFF(nameval)), attr_sf_entry_name_count,
 	  FLD_COUNT, TYP_NONE },
+	{ "parent_dir", FLDT_PARENT_REC, attr_sf_entry_value_offset,
+	  attr_sf_entry_pptr_count, FLD_COUNT | FLD_OFFSET, TYP_NONE },
 	{ "value", FLDT_CHARNS, attr_sf_entry_value_offset,
 	  attr_sf_entry_value_count, FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ NULL }
@@ -92,6 +96,10 @@ attr_sf_entry_value_count(
 
 	ASSERT(bitoffs(startoff) == 0);
 	e = (struct xfs_attr_sf_entry *)((char *)obj + byteize(startoff));
+
+	if ((e->flags & XFS_ATTR_NSP_ONDISK_MASK) == XFS_ATTR_PARENT)
+		return 0;
+
 	return e->valuelen;
 }
 
@@ -159,3 +167,19 @@ attrshort_size(
 		e = xfs_attr_sf_nextentry(e);
 	return bitize((int)((char *)e - (char *)hdr));
 }
+
+static int
+attr_sf_entry_pptr_count(
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
+	return 1;
+}
diff --git a/db/field.c b/db/field.c
index a3e47ee81..a61ccc9ef 100644
--- a/db/field.c
+++ b/db/field.c
@@ -24,6 +24,14 @@
 #include "dir2sf.h"
 #include "symlink.h"
 
+#define	PPOFF(f)	bitize(offsetof(struct xfs_parent_rec, f))
+const field_t		parent_flds[] = {
+	{ "inumber", FLDT_INO, OI(PPOFF(p_ino)), C1, 0, TYP_INODE },
+	{ "gen", FLDT_UINT32D, OI(PPOFF(p_gen)), C1, 0, TYP_NONE },
+	{ NULL }
+};
+#undef PPOFF
+
 const ftattr_t	ftattrtab[] = {
 	{ FLDT_AGBLOCK, "agblock", fp_num, "%u", SI(bitsz(xfs_agblock_t)),
 	  FTARG_DONULL, fa_agblock, NULL },
@@ -384,6 +392,8 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_UINT8X, "uint8x", fp_num, "%#x", SI(bitsz(uint8_t)), 0, NULL,
 	  NULL },
 	{ FLDT_UUID, "uuid", fp_uuid, NULL, SI(bitsz(uuid_t)), 0, NULL, NULL },
+	{ FLDT_PARENT_REC, "parent", NULL, (char *)parent_flds,
+	  SI(bitsz(struct xfs_parent_rec)), 0, NULL, parent_flds },
 	{ FLDT_ZZZ, NULL }
 };
 
diff --git a/db/field.h b/db/field.h
index 634742a57..b1bfdbed1 100644
--- a/db/field.h
+++ b/db/field.h
@@ -187,6 +187,9 @@ typedef enum fldt	{
 	FLDT_UINT8O,
 	FLDT_UINT8X,
 	FLDT_UUID,
+
+	FLDT_PARENT_REC,
+
 	FLDT_ZZZ			/* mark last entry */
 } fldt_t;
 

