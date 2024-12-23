Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA9019259D
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990609; cv=none; b=gCtVSTyhgpSUTXzLI4XUJVCK8a76OHvtI3S+STs5//WeiC6FlHdwNQ/ZC9YOgk7S07hzm3ZHMb0B5m52TQBQOedremaDwmi/9gz3P06NxFsLMBZlIPNGv3AqVZ6E6rI685zeACfvvuMf1E1noaBb9+PJNOHcQ3dkaySZmGKyFsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990609; c=relaxed/simple;
	bh=oh4eEtAFCG6K8IpP8LVr1KnIvGdWDS/2xeB9Fh5V5X0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=URhEXsR91GuDc+2WfSC/fasPP//iFXKzTv5Ip9BIcBg1qMK5h3vM6/PadXw9zdN4sogkKBZgY8kykqbVeoNfggihOQL1Sk80+WWABYUtGp4fZH0bHJPxf/O6LyEKItMpxH69r7+T1pYKwBnr159w6TwXXmUG5Z1mWo+9bjeWdDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eqIo97XU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eqIo97XU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43901C4CED3;
	Mon, 23 Dec 2024 21:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990609;
	bh=oh4eEtAFCG6K8IpP8LVr1KnIvGdWDS/2xeB9Fh5V5X0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eqIo97XUHrJWRbrvhyNjr8WCjBxml81lLDY8d7f5fB+LwDXHIf4mUCmTHwn6WSmqz
	 6t8cFK+dM7Mebpg8fPQKRsBQmVpk4U3F67/rGZnzD70naWja1730evY6kkMCz16AVC
	 Jt88QY3PHgFvmAv8YLFs8Auzm4GQCkWZVmOrCxhuEzgNJLKb+oLlzaeeQH45RgFHiw
	 zowO0yL8QZBTk9bNDbtwlwnTKm/JG89kqcpcIZ8IQ1Uj/dS1SyTmFN2N6xsbdfelWn
	 v28OjcLWdAXGfYkK1EX2f64m8W2g9F9wWS7UZnc12ntiCpdsHvgZ2Sdnf8YLTp/M+3
	 R1C9NQ2/Z0YuA==
Date: Mon, 23 Dec 2024 13:50:08 -0800
Subject: [PATCH 14/41] xfs_db: display di_metatype
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941183.2294268.15927941912459455353.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Print the metadata file type if available.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/field.c |    2 +
 db/field.h |    1 +
 db/inode.c |   83 +++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 db/inode.h |    2 +
 4 files changed, 78 insertions(+), 10 deletions(-)


diff --git a/db/field.c b/db/field.c
index a61ccc9ef6d072..946684415f65d3 100644
--- a/db/field.c
+++ b/db/field.c
@@ -212,6 +212,8 @@ const ftattr_t	ftattrtab[] = {
 	  SI(bitsz(struct xfs_dinode)), 0, NULL, inode_core_flds },
 	{ FLDT_DINODE_FMT, "dinode_fmt", fp_dinode_fmt, NULL,
 	  SI(bitsz(int8_t)), 0, NULL, NULL },
+	{ FLDT_DINODE_METATYPE, "metatype", fp_metatype, NULL,
+	  SI(bitsz(uint16_t)), 0, NULL, NULL },
 	{ FLDT_DINODE_U, "dinode_u", NULL, (char *)inode_u_flds, inode_u_size,
 	  FTARG_SIZE|FTARG_OKEMPTY, NULL, inode_u_flds },
 	{ FLDT_DINODE_V3, "dinode_v3", NULL, (char *)inode_v3_flds,
diff --git a/db/field.h b/db/field.h
index b1bfdbed19cea3..9746676a6c7ac9 100644
--- a/db/field.h
+++ b/db/field.h
@@ -95,6 +95,7 @@ typedef enum fldt	{
 	FLDT_DINODE_A,
 	FLDT_DINODE_CORE,
 	FLDT_DINODE_FMT,
+	FLDT_DINODE_METATYPE,
 	FLDT_DINODE_U,
 	FLDT_DINODE_V3,
 
diff --git a/db/inode.c b/db/inode.c
index 0aff68083508cb..07efbb4902be08 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -25,6 +25,7 @@ static int	inode_a_offset(void *obj, int startoff, int idx);
 static int	inode_a_sfattr_count(void *obj, int startoff);
 static int	inode_core_nlinkv2_count(void *obj, int startoff);
 static int	inode_core_onlink_count(void *obj, int startoff);
+static int	inode_core_metatype_count(void *obj, int startoff);
 static int	inode_core_projid_count(void *obj, int startoff);
 static int	inode_core_nlinkv1_count(void *obj, int startoff);
 static int	inode_core_v3_pad_count(void *obj, int startoff);
@@ -94,6 +95,8 @@ const field_t	inode_core_flds[] = {
 	  FLD_COUNT, TYP_NONE },
 	{ "onlink", FLDT_UINT16D, OI(COFF(metatype)), inode_core_onlink_count,
 	  FLD_COUNT, TYP_NONE },
+	{ "metatype", FLDT_DINODE_METATYPE, OI(COFF(metatype)),
+	  inode_core_metatype_count, FLD_COUNT, TYP_NONE },
 	{ "uid", FLDT_UINT32D, OI(COFF(uid)), C1, 0, TYP_NONE },
 	{ "gid", FLDT_UINT32D, OI(COFF(gid)), C1, 0, TYP_NONE },
 	{ "nlinkv2", FLDT_UINT32D, OI(COFF(nlink)), inode_core_nlinkv2_count,
@@ -247,9 +250,8 @@ static const char	*dinode_fmt_name[] =
 static const int	dinode_fmt_name_size =
 	sizeof(dinode_fmt_name) / sizeof(dinode_fmt_name[0]);
 
-/*ARGSUSED*/
-int
-fp_dinode_fmt(
+static int
+fp_enum_fmt(
 	void			*obj,
 	int			bit,
 	int			count,
@@ -257,26 +259,65 @@ fp_dinode_fmt(
 	int			size,
 	int			arg,
 	int			base,
-	int			array)
+	int			array,
+	const char		**names,
+	unsigned int		nr_names)
 {
 	int			bitpos;
-	enum xfs_dinode_fmt	f;
+	int			f;
 	int			i;
 
 	for (i = 0, bitpos = bit; i < count; i++, bitpos += size) {
-		f = (enum xfs_dinode_fmt)getbitval(obj, bitpos, size, BVUNSIGNED);
+		f = getbitval(obj, bitpos, size, BVUNSIGNED);
 		if (array)
 			dbprintf("%d:", i + base);
-		if (f < 0 || f >= dinode_fmt_name_size)
-			dbprintf("%d", (int)f);
+		if (f < 0 || f >= nr_names)
+			dbprintf("%d", f);
 		else
-			dbprintf("%d (%s)", (int)f, dinode_fmt_name[(int)f]);
+			dbprintf("%d (%s)", f, names[f]);
 		if (i < count - 1)
 			dbprintf(" ");
 	}
 	return 1;
 }
 
+/*ARGSUSED*/
+int
+fp_dinode_fmt(
+	void			*obj,
+	int			bit,
+	int			count,
+	char			*fmtstr,
+	int			size,
+	int			arg,
+	int			base,
+	int			array)
+{
+	return fp_enum_fmt(obj, bit, count, fmtstr, size, arg, base, array,
+			dinode_fmt_name, dinode_fmt_name_size);
+}
+
+static const char	*metatype_name[] =
+	{ "unknown", "dir", "usrquota", "grpquota", "prjquota", "rtbitmap",
+	  "rtsummary"
+	};
+static const int	metatype_name_size = ARRAY_SIZE(metatype_name);
+
+int
+fp_metatype(
+	void			*obj,
+	int			bit,
+	int			count,
+	char			*fmtstr,
+	int			size,
+	int			arg,
+	int			base,
+	int			array)
+{
+	return fp_enum_fmt(obj, bit, count, fmtstr, size, arg, base, array,
+			metatype_name, metatype_name_size);
+}
+
 static int
 inode_a_bmbt_count(
 	void			*obj,
@@ -414,7 +455,29 @@ inode_core_onlink_count(
 	ASSERT(startoff == 0);
 	ASSERT(obj == iocur_top->data);
 	dic = obj;
-	return dic->di_version >= 2;
+	if (dic->di_version < 2)
+		return 0;
+	if (dic->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA))
+		return 0;
+	return 1;
+}
+
+static int
+inode_core_metatype_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+
+	if (dic->di_version < 3)
+		return 0;
+	if (dic->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA))
+		return 1;
+	return 0;
 }
 
 static int
diff --git a/db/inode.h b/db/inode.h
index 31a2ebbba6a175..9e4ec1b3833716 100644
--- a/db/inode.h
+++ b/db/inode.h
@@ -16,6 +16,8 @@ extern const struct field	timestamp_flds[];
 
 extern int	fp_dinode_fmt(void *obj, int bit, int count, char *fmtstr,
 			      int size, int arg, int base, int array);
+int		fp_metatype(void *obj, int bit, int count, char *fmtstr,
+			      int size, int arg, int base, int array);
 extern int	inode_a_size(void *obj, int startoff, int idx);
 extern void	inode_init(void);
 extern typnm_t	inode_next_type(void);

