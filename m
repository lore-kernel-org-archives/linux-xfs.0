Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E630C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pCSkAE+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2785C433C7;
	Sun, 31 Dec 2023 23:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065798;
	bh=tF7oXD00Ys8KmbxmC+AUFOlBCaIkdmk10h0iJ9sCOOc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pCSkAE+Wiu/jaWdxtkE5V0t9F/DwcM7kfju5fQMRA7AZm08dqkTrr8PsxYhCIB/+5
	 66gXincPdrlvYvPBG7sNreFF9a3fcWJbUwW+AdlreJ4e0j01tfgArMKYMutuZI+Ce2
	 UfpONVdn0V7dKl+e5Na4tJjROf7W1HiKb7Dj0GEsB69OCjG+SIY///banXc+uGR04Y
	 v+l9CT0ZFFMavt3Th3xNQu+EchoFE7qxNg1TJkTX5MKQfWNbxlysqzZqBqgxiKKbV3
	 GufoiIf6LEJqHkbfbgyt6bwZb3czzlU/M3N5qvchOKLgTmfoYJtKprZRn2eEBfsUok
	 KfOMqK9vCPqkg==
Date: Sun, 31 Dec 2023 15:36:37 -0800
Subject: [PATCH 27/58] xfs_db: report metadir support for version command
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010308.1809361.1415783380543629932.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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
index c9b506b905d..4e2be6a1156 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -207,6 +207,9 @@ const field_t	inode_v3_flds[] = {
 	{ "nrext64", FLDT_UINT1,
 	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_NREXT64_BIT - 1), C1,
 	  0, TYP_NONE },
+	{ "metadir", FLDT_UINT1,
+	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_METADIR_BIT-1), C1,
+	  0, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/db/sb.c b/db/sb.c
index e738065b5be..002736b02b7 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -708,6 +708,8 @@ version_string(
 		strcat(s, ",NREXT64");
 	if (xfs_has_parent(mp))
 		strcat(s, ",PARENT");
+	if (xfs_has_metadir(mp))
+		strcat(s, ",METADIR");
 	return s;
 }
 

