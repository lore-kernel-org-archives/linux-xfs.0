Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366A8C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lZkC9H91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C74C433C8;
	Sun, 31 Dec 2023 23:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066236;
	bh=PqFLHJZw0n12ubY0klFraY7iT/nxAHjnQWbfUiY00Y8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lZkC9H91/G1+3GXqx1RGzUrjHXtSShV2X4ndGe/rDQlmD0cWSSmgAC4TS/ULhKh8B
	 nBuVm6yT8+uvxpwhqD5GbSbLKyJtHTvcqZH5dqIM1eBENkMIonwbMgA46eng2pMbhT
	 wa+5cpcLgBvy7vweSTX+QwuUS96Ky+KkvB/sUwyWk02WWxwiimzzKnin5eGPiWws30
	 5eO2dV1gRkqZ2oWRzx50CeqVwYKZYywpIc5nKbcs2UaNFCrosuCW5jaVPMXnYm0Nqm
	 vSEc0qDocMztLr7AcCHYI3jnTNwezkeFXi9dkaJmJdUA7U7hDeXPGlAKles15YsJjI
	 gfTWJEYUkQIsA==
Date: Sun, 31 Dec 2023 15:43:55 -0800
Subject: [PATCH 55/58] xfs_repair: do not count metadata directory files when
 doing quotacheck
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010680.1809361.14560654946710868594.stgit@frogsfrogsfrogs>
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

Previously, we stated that files in the metadata directory tree are not
counted in the dquot information.  Fix the offline quotacheck code in
xfs_repair and xfs_check to reflect this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c          |    4 ++++
 repair/quotacheck.c |    5 +++++
 2 files changed, 9 insertions(+)


diff --git a/db/check.c b/db/check.c
index ae527471161..190565074b6 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3018,6 +3018,10 @@ process_inode(
 		default:
 			break;
 		}
+		/* Metadata directory files are not counted in quotas. */
+		if (dip->di_version >= 3 &&
+		    (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADIR)))
+			ic = 0;
 		if (ic)
 			quota_add(&prid, &gid, &uid, 0, bc, ic, rc);
 	}
diff --git a/repair/quotacheck.c b/repair/quotacheck.c
index 4cb38db3ddd..3abcd8ae9a0 100644
--- a/repair/quotacheck.c
+++ b/repair/quotacheck.c
@@ -217,6 +217,10 @@ quotacheck_adjust(
 		return;
 	}
 
+	/* Metadata directory files aren't counted in quota. */
+	if (xfs_is_metadir_inode(ip))
+		goto out_rele;
+
 	/* Count the file's blocks. */
 	if (XFS_IS_REALTIME_INODE(ip))
 		rtblks = qc_count_rtblocks(ip);
@@ -229,6 +233,7 @@ quotacheck_adjust(
 	if (proj_dquots)
 		qc_adjust(proj_dquots, ip->i_projid, blocks, rtblks);
 
+out_rele:
 	libxfs_irele(ip);
 }
 

