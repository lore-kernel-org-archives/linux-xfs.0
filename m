Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411CBC2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="reAw1QLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E75C433C7;
	Sun, 31 Dec 2023 23:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064282;
	bh=6fLNIenh/+izzgOksenA4UfhR4GURe07oqoTTNmox+c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=reAw1QLwrDz3js2H8BFz2jYwk6weuM2R2aAxVOz7YRdtO6nn6U9PiI44zPeCS2ZN2
	 C1y6Q0bBsRlGnLuZSnmE3Y5X5OyojaMQdKbUloY4L/GaZKMbXV7IoUJMgoZ8nIneb6
	 /ppngYvMuPh3kEiyRmdFMez2BdcgT/o3z63xvpoT/8UKdgajvrllG92bmmJ0KSWpu+
	 P6wysbg/USI4MfjhRZWXb0E2a1bvIW1PQBfNPjFeLeEanLX1jASOFBJpc1OZUAXwRY
	 JzhUKOdT8xnq5rzfx0wlvVFL3bLYocb3BYnk8wFSKKhjUiLlLdj6VXwoq4FxTeMqPx
	 tMuwqRYb4QR5A==
Date: Sun, 31 Dec 2023 15:11:21 -0800
Subject: [PATCH 24/32] xfs_db: report parent bit on xattrs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006421.1804688.16782016668028500385.stgit@frogsfrogsfrogs>
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

Display the parent bit on xattr keys

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 db/attr.c      |    3 +++
 db/attrshort.c |    3 +++
 2 files changed, 6 insertions(+)


diff --git a/db/attr.c b/db/attr.c
index ba722e146e2..f29e4a54454 100644
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
index e234fbd8365..872d771d5ed 100644
--- a/db/attrshort.c
+++ b/db/attrshort.c
@@ -44,6 +44,9 @@ const field_t	attr_sf_entry_flds[] = {
 	{ "secure", FLDT_UINT1,
 	  OI(EOFF(flags) + bitsz(uint8_t) - XFS_ATTR_SECURE_BIT - 1), C1, 0,
 	  TYP_NONE },
+	{ "parent", FLDT_UINT1,
+	  OI(EOFF(flags) + bitsz(uint8_t) - XFS_ATTR_PARENT_BIT - 1), C1, 0,
+	  TYP_NONE },
 	{ "name", FLDT_CHARNS, OI(EOFF(nameval)), attr_sf_entry_name_count,
 	  FLD_COUNT, TYP_NONE },
 	{ "value", FLDT_CHARNS, attr_sf_entry_value_offset,

