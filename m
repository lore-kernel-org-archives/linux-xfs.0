Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93AE14D717
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528582; cv=none; b=RIWRlBcsjuvODNNHh6GfYaFn3itwz/uaiK8ESDXr7eFMh0dQ404VeCyQV0eZmbEYooWYDqnoLVUc2Xz+gkqUX58aFzp7TQYJzkcxENmQU2UHszoB7CQAIxaFUzvRbk/pjFAO6hwbL4D7CX4c9Wq4ZpdUHA2VBzVcD/yGmnH3TTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528582; c=relaxed/simple;
	bh=4BN6NzPu0ZmOQ67d+OGfqEp+oz/twWCzPMRjsduOfg0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YAGoANqqqU+sN5DzC0LE5OApbuY4qoxx7ugvWGDUOGqKkK67Vak8gKiAQZYrgtcqzNSlOaII41bJDMGaA+A3HAELxD8j8b5cm5JqA1L3sLBu8RP78BLsUTPz+187s7FzDHhVAy927T5kH2B4nId3p/ZAgasXkiOxO13keuripzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=phAJKrdI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="phAJKrdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBA9C4CED1;
	Fri,  6 Dec 2024 23:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528582;
	bh=4BN6NzPu0ZmOQ67d+OGfqEp+oz/twWCzPMRjsduOfg0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=phAJKrdIM8mWsD6smP0FVyAbZn2v2I1RtjEBxQbYFU3RvSWPbaz3y+vaEVrNH1YZf
	 vqNrmXESabjQ4qoEjHn3ZOOESVv6YLx8EQvDkMGtBUVAFwwCFnrxsyihU85i+XCE22
	 mInnRHq0p1k32/H/Ru7uBMKcFxG0MndeQYVgeA4XSi2uHmFF8DYbSEutBcoar4Nnje
	 RWT4QBXpuWpb1CElJO4OMH7P4qywoihijr10uZm1LCyD0HEPM38eE05MZ9UL18TL0Y
	 4bueKLyweZfqhDHkNNyvJix3kryxZBxuIP9cACUU199TSgnFEzSEBzWYet+pJZ0mV/
	 gqBNdpiZkqNuQ==
Date: Fri, 06 Dec 2024 15:43:01 -0800
Subject: [PATCH 13/41] xfs_db: show the metadata root directory when dumping
 superblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748437.122992.17222124628944235085.stgit@frogsfrogsfrogs>
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

Show the metadirino field when appropriate.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/sb.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/db/sb.c b/db/sb.c
index 4f115650e1283f..fa15b429ecbefa 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -50,6 +50,18 @@ sb_init(void)
 	add_command(&version_cmd);
 }
 
+/*
+ * Counts superblock fields that only exist when the metadata directory feature
+ * is enabled.
+ */
+static int
+metadirfld_count(
+	void		*obj,
+	int		startoff)
+{
+	return xfs_has_metadir(mp) ? 1 : 0;
+}
+
 #define	OFF(f)	bitize(offsetof(struct xfs_dsb, sb_ ## f))
 #define	SZC(f)	szcount(struct xfs_dsb, sb_ ## f)
 const field_t	sb_flds[] = {
@@ -113,6 +125,8 @@ const field_t	sb_flds[] = {
 	{ "pquotino", FLDT_INO, OI(OFF(pquotino)), C1, 0, TYP_INODE },
 	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
 	{ "meta_uuid", FLDT_UUID, OI(OFF(meta_uuid)), C1, 0, TYP_NONE },
+	{ "metadirino", FLDT_INO, OI(OFF(metadirino)), metadirfld_count,
+		FLD_COUNT, TYP_INODE },
 	{ NULL }
 };
 

