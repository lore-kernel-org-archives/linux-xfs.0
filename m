Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CAB389
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PhJjKqh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96365C433C8;
	Mon,  1 Jan 2024 00:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068269;
	bh=xy+j0v0tnp5FHLfj65daebjxmDT1w8g4dcA9OzYy/j8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PhJjKqh6XqFfH0nZfOzmNNluCy/RfKZZYyt71vwOnvhl5sTD+/ohzz7NVyrB3iAs7
	 0bHmoWkdK1n4CmRMOfsosc+mZ5rWGx9JGcAlIQxOhcPG1UvuHL+S+G5FLWhAYFrJXJ
	 zlEA6AzTkKx+aotfvn+4pFeY5s8lhkz0MdNeLvVV8K1SRjf7o4YFDu32vQKm36rbNP
	 Sunrkoi2KJWK3hJyzHN8rVE4EcdfRhTImaVTAI8Iu7krcryrm6gTyrRG23WgJR1nlb
	 Eq4MD/SxcPiDMiFRQUhrOzlMkPJbtQzCmC8tLDtkGkDvRtoOblAJlrIPKKLBrzn97G
	 qgCDQPNPxw5Sg==
Date: Sun, 31 Dec 2023 16:17:49 +9900
Subject: [PATCH 28/47] libfrog: enable scrubbng of the realtime rmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015686.1815505.2905339464987236573.stgit@frogsfrogsfrogs>
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

Add a new entry so that we can scrub the rtrmapbt.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/scrub.c |    5 +++++
 scrub/repair.c  |    1 +
 2 files changed, 6 insertions(+)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 8822fc0088c..290ba0fb8bf 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -169,6 +169,11 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 		.descr	= "realtime group bitmap",
 		.group	= XFROG_SCRUB_GROUP_RTGROUP,
 	},
+	[XFS_SCRUB_TYPE_RTRMAPBT] = {
+		.name	= "rtrmapbt",
+		.descr	= "realtime reverse mapping btree",
+		.group	= XFROG_SCRUB_GROUP_RTGROUP,
+	},
 };
 
 const struct xfrog_scrub_descr xfrog_metapaths[XFS_SCRUB_METAPATH_NR] = {
diff --git a/scrub/repair.c b/scrub/repair.c
index 43037a7c5e1..fee03f97701 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -532,6 +532,7 @@ repair_item_difficulty(
 
 		switch (scrub_type) {
 		case XFS_SCRUB_TYPE_RMAPBT:
+		case XFS_SCRUB_TYPE_RTRMAPBT:
 			ret |= REPAIR_DIFFICULTY_SECONDARY;
 			break;
 		case XFS_SCRUB_TYPE_SB:

