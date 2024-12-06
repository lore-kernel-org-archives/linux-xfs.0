Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E275D14D717
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528536; cv=none; b=CaKshU3DjIB25btkJvaCz7/uC6cc3TpOymoS26RcdtbJPfBBkIqqrgmY1UNgXmhC/Hdd6sr+io9/mvN178Ro3bKHdtztZa0rIBOhktFXlhAhggwuuv5DnNO4tWMIrQ60Ei1P5QGumw/joJWmUa4VphBW2NCay8o7+iewAMt4MYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528536; c=relaxed/simple;
	bh=jb8UvljoGP6cOWSgCbMJefL56hzRAFEcMckPiFmqk/g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=drSHl+9uFM9/FGzh7a4xvic/f0Unwvb7M9+DM88Qi3yeEA+6VOhq4a6uFzsbU0J9Us/m5+T5Hy3P6E8IZZI2ZNUvC1YK570r3Wan42Ld+wtwM4hDzwBAzkmghcyPB99MCOgfN+GD/mOT9DHzXzTEuzdiMscj6VlkwFEKpBJm1pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OfuzAi9n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OfuzAi9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641C8C4CED1;
	Fri,  6 Dec 2024 23:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528535;
	bh=jb8UvljoGP6cOWSgCbMJefL56hzRAFEcMckPiFmqk/g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OfuzAi9n5IzT8iRpHquNH5Y2Qn94kvOEcH+PZ8QmPkPMpEwv+qS4S1mwYlf4v+3KL
	 LeBhRJ9to5QuJTO7b75ynvIpDba3Z/eX6piJNxW7q6aJcBjXhnNPuYM2CgWzWdMKGh
	 L+MaF5aa9WFjde3dnijIQkZ0EgcsQ7f0YsOxitnrXnbcY5a2YZ4tzJIvOX1CanPQn9
	 4wELQuP/WLDMsiAhh0al009jntnE3Udn2rVP8L5s9U7DULpx3hh64UUr7wje4no9kL
	 Xqa6xgBhqL0W0lOX/8jUDR1Dj7aXoEQClsXyZNO4oo7G0bOFX46f+6Jjr7G5gRkYL7
	 5EbBYfB/JB/9Q==
Date: Fri, 06 Dec 2024 15:42:15 -0800
Subject: [PATCH 10/41] xfs_db: report metadir support for version command
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748392.122992.217997535481983808.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Report metadir support if we have it enabled.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/inode.c |    3 +++
 db/sb.c    |    2 ++
 2 files changed, 5 insertions(+)


diff --git a/db/inode.c b/db/inode.c
index 246febb5929aa1..0aff68083508cb 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -207,6 +207,9 @@ const field_t	inode_v3_flds[] = {
 	{ "nrext64", FLDT_UINT1,
 	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_NREXT64_BIT - 1), C1,
 	  0, TYP_NONE },
+	{ "metadata", FLDT_UINT1,
+	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_METADATA_BIT-1), C1,
+	  0, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/db/sb.c b/db/sb.c
index 9fcb7340f8b02f..4f115650e1283f 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -710,6 +710,8 @@ version_string(
 		strcat(s, ",EXCHANGE");
 	if (xfs_has_parent(mp))
 		strcat(s, ",PARENT");
+	if (xfs_has_metadir(mp))
+		strcat(s, ",METADIR");
 	return s;
 }
 

