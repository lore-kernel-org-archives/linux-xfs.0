Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E98C129
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kqRqo8wN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7024C433C7;
	Sun, 31 Dec 2023 22:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062374;
	bh=CsMPM9JK6l7W6cq10lnyXmVEP0NQdu2M4EhcrPjvXcw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kqRqo8wNcdYpgr3pNA38J0psVeuC4OWMj/zSRrBdeCNC2pMCQeCSFr+oy2Q0TTTyv
	 wiFyi4uJ8mK0PkUw2kcK+JU2DX/GvYwVbOdtbpz20kqGfvz7GZNIcxluITig3e4oYj
	 TlMHix71Ubx1Ixv22xQKXHvA+BU05kbAkUkG9w0CTtG6hK4yYUBixu8/8TNNHHmpSn
	 sbSHg1fWOIHWF714bfSW+mHoFngpFuz/GB5Rp2JYqZl2dm9YQ41RCBOFrEWWaJHzpO
	 BKKGuhQrcWssU6c7tB9fbq1pBZWO5Yy/Y92FoqV9t/dLHPz3RnYJF2QCdI/ae3sfjw
	 wr8nCeeSubY5Q==
Date: Sun, 31 Dec 2023 14:39:34 -0800
Subject: [PATCH 5/8] xfs_scrub: add missing repair types to the mustfix and
 difficulty assessment
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404999101.1797544.8999383600020985389.stgit@frogsfrogsfrogs>
In-Reply-To: <170404999029.1797544.5974682335470417611.stgit@frogsfrogsfrogs>
References: <170404999029.1797544.5974682335470417611.stgit@frogsfrogsfrogs>
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

Add a few scrub types that ought to trigger a mustfix (such as AGI
corruption) and all the AG space metadata to the repair difficulty
assessment.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/scrub/repair.c b/scrub/repair.c
index 8ee9102ab58..33a8031103c 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -299,6 +299,7 @@ action_list_find_mustfix(
 		if (!(aitem->flags & XFS_SCRUB_OFLAG_CORRUPT))
 			continue;
 		switch (aitem->type) {
+		case XFS_SCRUB_TYPE_AGI:
 		case XFS_SCRUB_TYPE_FINOBT:
 		case XFS_SCRUB_TYPE_INOBT:
 			alist->nr--;
@@ -325,11 +326,17 @@ action_list_difficulty(
 		case XFS_SCRUB_TYPE_RMAPBT:
 			ret |= REPAIR_DIFFICULTY_SECONDARY;
 			break;
+		case XFS_SCRUB_TYPE_SB:
+		case XFS_SCRUB_TYPE_AGF:
+		case XFS_SCRUB_TYPE_AGFL:
+		case XFS_SCRUB_TYPE_AGI:
 		case XFS_SCRUB_TYPE_FINOBT:
 		case XFS_SCRUB_TYPE_INOBT:
 		case XFS_SCRUB_TYPE_BNOBT:
 		case XFS_SCRUB_TYPE_CNTBT:
 		case XFS_SCRUB_TYPE_REFCNTBT:
+		case XFS_SCRUB_TYPE_RTBITMAP:
+		case XFS_SCRUB_TYPE_RTSUM:
 			ret |= REPAIR_DIFFICULTY_PRIMARY;
 			break;
 		}

