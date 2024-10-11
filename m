Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A129450
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609391; cv=none; b=cB1a/NoOjhqSYUDWjX5z3bk92Nbd7EX8BLsu1NqP+goWem7gtwzcMs4a5I+4Um8/Huiu4QTw+ku2AejJjT3XXGATMK2bdEeAbbe/f+tnvPLEkYb6W8SGnR7uvaxG3U3dJoQUldhYi/BnXwvGL4KQGE9YKm5R9gd4CHT19ChnZIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609391; c=relaxed/simple;
	bh=0Xkx1wEl6LF5N5X8XFPryObYW9N1j6DthOBPReL/P4Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b/UFzgowzYcjbvqxrLhuJM1ZpJIfLisNMimH6ao9mB/HqJiznST/F93hz9vZT/Xqjv9oc7jApwMhOhPydGMKLSn8DZsbCcUzCOLoLXTrccQptI5/2sjQe5QDtpunhIiuFjFwxHFqK+mTFYMB5DK1vof+1oVOdE0aq6qFg45TkSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UI1MdKHl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UI1MdKHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5315BC4CEC5;
	Fri, 11 Oct 2024 01:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609391;
	bh=0Xkx1wEl6LF5N5X8XFPryObYW9N1j6DthOBPReL/P4Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UI1MdKHlznbZa5NULQck9CAm+LfAlIxsgCTB99Fbm3FWigc4c0Rly5WEvENBOOddQ
	 FOhvBgtwnnaKnShRPkYVtjyqI+2eUBm5mR3rhmB5+h3sCJVxZxbL7hzMO717cQtci/
	 LzZ/LRM9j9wfHgeU8bGltinxZswhmJCYQDhyvcn+HGAzjRmEmjf3jYlLHIgihFWY/v
	 c4r2pjIv5HcW2AIPPir6UbeGjzGH1Vs/s3yDC45aQiaREm6KFvN0WAPbXLyPwyq+JJ
	 2emsxwAZ3yTNJ14DbjlfCsX4jz18UdploqkDJEeobP4jua8yKu3FQ+uuKRF5w99ErV
	 skC0lwhqtUmlw==
Date: Thu, 10 Oct 2024 18:16:30 -0700
Subject: [PATCH 09/38] xfs_db: display di_metatype
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654115.4183231.8861218890099262.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
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

Print the metadata file type if available.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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
index 74cf4958c0f7b7..8a7c665bdb54f3 100644
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
 	{ "onlink", FLDT_UINT16D, OI(COFF(onlink)), inode_core_onlink_count,
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
index 31a2ebbba6a175..e281cdff15c096 100644
--- a/db/inode.h
+++ b/db/inode.h
@@ -16,6 +16,8 @@ extern const struct field	timestamp_flds[];
 
 extern int	fp_dinode_fmt(void *obj, int bit, int count, char *fmtstr,
 			      int size, int arg, int base, int array);
+extern int	fp_metatype(void *obj, int bit, int count, char *fmtstr,
+			      int size, int arg, int base, int array);
 extern int	inode_a_size(void *obj, int startoff, int idx);
 extern void	inode_init(void);
 extern typnm_t	inode_next_type(void);

