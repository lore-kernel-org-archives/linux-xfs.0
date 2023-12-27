Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C312A38B
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LMX/g06H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E303C433C7;
	Mon,  1 Jan 2024 00:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068316;
	bh=qoPrNcY/Y8tDjeYo59d3N546x8LRL7q6kuNi2ZWazS8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LMX/g06He6BBtdEez4ppApm+Be/Hjf0gqJv9JmTl74B6rVCSFMLC3fYGbK0gtwHUv
	 1ng4TQSfqpdW2XvbFeM7diQgGqbcPrE03k5tJgX8PfNSrh9jb3wdDJGlRcCHWmN5JY
	 RgIojbA8bDhjuLDHsFig3/vK6fFclDdZcI1MpEhWp1uSaMACSYLBpaHiQr3SuxX9Nj
	 mxcrdvM9NiT/KTToRGUbs9KVw0kuv2Woev4FFG80AgWdY0EJ/givjR2YsuA6OoyybD
	 CgUdmRNcqBah8CqVCP+wkc2lEPnWP8/b5nnHNaYZZetYWKBFD3DRKo6IeHV8dn0iiF
	 K2+50hEk2u9hQ==
Date: Sun, 31 Dec 2023 16:18:35 +9900
Subject: [PATCH 31/47] xfs_spaceman: report health status of the realtime rmap
 btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015726.1815505.17216241299242693670.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

Add reporting of the rt rmap btree health to spaceman.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 spaceman/health.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/spaceman/health.c b/spaceman/health.c
index d9a18fcc3b4..fac81f4eda5 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -41,6 +41,11 @@ static bool has_reflink(const struct xfs_fsop_geom *g)
 	return g->flags & XFS_FSOP_GEOM_FLAGS_REFLINK;
 }
 
+static bool has_rtrmapbt(const struct xfs_fsop_geom *g)
+{
+	return g->rtblocks > 0 && (g->flags & XFS_FSOP_GEOM_FLAGS_RMAPBT);
+}
+
 struct flag_map {
 	unsigned int		mask;
 	bool			(*has_fn)(const struct xfs_fsop_geom *g);
@@ -145,6 +150,11 @@ static const struct flag_map rtgroup_flags[] = {
 		.mask = XFS_RTGROUP_GEOM_SICK_BITMAP,
 		.descr = "realtime bitmap",
 	},
+	{
+		.mask = XFS_RTGROUP_GEOM_SICK_RMAPBT,
+		.descr = "realtime reverse mappings btree",
+		.has_fn = has_rtrmapbt,
+	},
 	{0},
 };
 

