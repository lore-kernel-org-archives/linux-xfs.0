Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DF4624
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609328; cv=none; b=KfuyTJPPrcrAfseu96aKDKqkDC+p9vwRrHfBoOaVytN7Vf+ylkTFZkgulzUngVO9gpWMl/b2nRK5TBbNfnoiN2SJmia60UGquv+j4JC+NdWiPIh8c5WKOCvfCjbRmXXVp2JvFPQV5qXU1MnZ2HpJd5JdI1twR47TPZszV+g5Usw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609328; c=relaxed/simple;
	bh=4Ot1Z2cq7bdzSkT4EwbBmCtcvRymCkVv+z/OU8yKbmw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E6M0TTIGoEUyT0Gy53SbPWcAXRyQE/KqieySkizLi0p8RZ7j+TtfPaKFs6r6cYFdH7PS/4M08J2ZEofkBFahO8ULmwMUfuTmZNq5W1iUnymWX5q/gLBX3nqaXGr67v39zEUd2bvlJaoAlLIAfVcYWprfG6wf24PJS5hPnY/xZSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dilBDDTy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dilBDDTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23EFC4CEC5;
	Fri, 11 Oct 2024 01:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609328;
	bh=4Ot1Z2cq7bdzSkT4EwbBmCtcvRymCkVv+z/OU8yKbmw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dilBDDTyh50ITfbwkd2y7ppEdYRkx8wBhFzeZjPEBZf7WCV3JQgHCsATp52sq+PKF
	 kVwz931wAlcNx5Zk97A90Np3cMBQjIC+ox8eSlSpHyOl7o7/AHVjybPSm2K9R5oubx
	 c6v3RWSFKxpY20dpU758AcWjKlbIyMiEMtzGdoYq8hYz6MMtsEkR2iDXf1K8Vf6NIT
	 cuIWwpfunGTySaU8MMQlPGKUadhyQRbJi8NJ5EDcGn/p9AZ6UbBDfQ275jjZKoYrl9
	 pWmTA8l7td2KP+f70fHjf3SGWtmq5g0ErSkKPbgWax9T7mt5qlDev3QH1grOvFyrbb
	 g0zDXk0/9kypQ==
Date: Thu, 10 Oct 2024 18:15:28 -0700
Subject: [PATCH 05/38] xfs_db: report metadir support for version command
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654054.4183231.1757473704653136454.stgit@frogsfrogsfrogs>
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

Report metadir support if we have it enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/inode.c |    3 +++
 db/sb.c    |    2 ++
 2 files changed, 5 insertions(+)


diff --git a/db/inode.c b/db/inode.c
index 7a5f5a0cb987aa..74cf4958c0f7b7 100644
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
index c117bfa1e238d1..b47477631af824 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -711,6 +711,8 @@ version_string(
 		strcat(s, ",EXCHANGE");
 	if (xfs_has_parent(mp))
 		strcat(s, ",PARENT");
+	if (xfs_has_metadir(mp))
+		strcat(s, ",METADIR");
 	return s;
 }
 

