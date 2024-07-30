Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE45F7464
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302551; cv=none; b=XADJj7+v+9U2K+R6Fd6BXOP9LYKV/Fkn2uUN4PveprxuxFa9UKiQnd/lIdJjoIJGGZcNiehwEhAAShV2FGCzROqzt9uooyhqR4o1aA2cv+c+UMsw3sEFNcBeSu/n1LOGrEYRXkY3mt2RF/434bZWHpl16QU4jZFAqyTsUHT/3Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302551; c=relaxed/simple;
	bh=4k9BZabztUcnXR5Cj9hgx8QolIMp6g+41Ccsuoe2Pl4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pVCMUjjWRvY11IDhdZZ8ADJZurOAani5wjBwtD1CqJBnoVQMgWBsX7KEjfivXxa2ky7aPyFggpF5o35LLHdQLAjnl/5h9n6FLayUhw+L0GHbLxGd4+qaXDaCnyHKswzY4Jrq9CqMSwdbklj6uIfFteTl/WYCwPizkoOkRyOUpO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NA7sANbi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NA7sANbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A4DC32786;
	Tue, 30 Jul 2024 01:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302550;
	bh=4k9BZabztUcnXR5Cj9hgx8QolIMp6g+41Ccsuoe2Pl4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NA7sANbiaMn8MMMGv40bdZclA6xK1PhxxUsL6EXvK4cZYp+3zXXWwt6kcAswXK0+q
	 E+G0bCJHxNfLdAaLmA5CSGQaYFqePSamBY5pTvkjUCtQYWgSn9q3AuwqCOr0Ayeei+
	 g8ePZrhrINrMK4qYyj6+pYIE7XmuQDSMYBSB1AHtmKTEqbB8UMCkSyqHsSw1eGCF1r
	 yQUrwtyuAS440UMj1g+0jzJRvGOXguoEFKLaswbhJyabCGaGkWiMDzbHDsRLVZuGLs
	 hzAFr+3ooIAt5YdBZ5MC0RxpNZGh9M5F83H24mKSsSNrJAs0ETX8Qrd8TLd2v9BlWP
	 MTZgrO1T5JNMA==
Date: Mon, 29 Jul 2024 18:22:30 -0700
Subject: [PATCH 14/24] xfs_db: report parent bit on xattrs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229850701.1350924.1091017748557634243.stgit@frogsfrogsfrogs>
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

Display the parent bit on xattr keys

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/attr.c      |    3 +++
 db/attrshort.c |    3 +++
 2 files changed, 6 insertions(+)


diff --git a/db/attr.c b/db/attr.c
index de68d6276..3252f3886 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -82,6 +82,9 @@ const field_t	attr_leaf_entry_flds[] = {
 	{ "local", FLDT_UINT1,
 	  OI(LEOFF(flags) + bitsz(uint8_t) - XFS_ATTR_LOCAL_BIT - 1), C1, 0,
 	  TYP_NONE },
+	{ "parent", FLDT_UINT1,
+	  OI(LEOFF(flags) + bitsz(uint8_t) - XFS_ATTR_PARENT_BIT - 1), C1, 0,
+	  TYP_NONE },
 	{ "pad2", FLDT_UINT8X, OI(LEOFF(pad2)), C1, FLD_SKIPALL, TYP_NONE },
 	{ NULL }
 };
diff --git a/db/attrshort.c b/db/attrshort.c
index 7c386d46f..978f58d67 100644
--- a/db/attrshort.c
+++ b/db/attrshort.c
@@ -43,6 +43,9 @@ const field_t	attr_sf_entry_flds[] = {
 	{ "secure", FLDT_UINT1,
 	  OI(EOFF(flags) + bitsz(uint8_t) - XFS_ATTR_SECURE_BIT - 1), C1, 0,
 	  TYP_NONE },
+	{ "parent", FLDT_UINT1,
+	  OI(EOFF(flags) + bitsz(uint8_t) - XFS_ATTR_PARENT_BIT - 1), C1, 0,
+	  TYP_NONE },
 	{ "name", FLDT_CHARNS, OI(EOFF(nameval)), attr_sf_entry_name_count,
 	  FLD_COUNT, TYP_NONE },
 	{ "value", FLDT_CHARNS, attr_sf_entry_value_offset,

