Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4289D39B
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301218; cv=none; b=DPBHmZlLrXJJVnvufWRDh3/AWQrjj3WJ1GZ6XyV7rvtl1eC27rnkhe9PfXy2vQkWgAv34LGvsakESrmfUXzPVF9bUHaxomPsAWMqdNzAwLOlMw1cmw7beCwoFE7QZ3raAd8d1MlqOC9qhHs+cDuD4J4xyUf9GGbwwuWTuwycLWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301218; c=relaxed/simple;
	bh=vNDQ8mpMziVkJVUYsFyPNNJTcYmOG9oSG+CJyvWvWjY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WdZ2xqvxLQQl/hIFimXVxfnakdy9xdaWUjXpYrrsxrY5gpbChWBKEOumbyVnPL7jFbBUwNPTzHxyYIIUYzKHjhlW8iWj7lbaCVTg3C5PxJVavYD8NVbMj30QrS3xGqfWN91Q/vU5q+kBp99STJAeY5hV2aNLMWp7qfV+YJzxvNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HHP4Oy3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HHP4Oy3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A9DC32786;
	Tue, 30 Jul 2024 01:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301218;
	bh=vNDQ8mpMziVkJVUYsFyPNNJTcYmOG9oSG+CJyvWvWjY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HHP4Oy3POwwzmOpP3VyBvOjL4lzaVq6evszV8/HGKnM3mebC6u6qMF76fBrkI3Xpk
	 c5rjFRKYsh2l3oTn0ruNHWSKk/K4SsdiKxvjkceIo35yskiuqAF4WqwaIEaIIunFbV
	 GxjVGnxpJ4MtqqZIgM5jsuWwo6nDYDOVfg3EhpmKFfh44KXV/rnnvsQbxXmbeC1f+f
	 CMGEHzS/0P/jhxZiu+V9Ats2v/mZPBTXjD1bVRVd6194VlrXSlo1jBXkyoUS9sF+zR
	 +UkAVXN3m02YOhgS8HcHyOvUNf6vlEueLnyx2vAg5wPpnX/9RcKVVvqSUn9ZPKwMXw
	 Tp78muscg79hA==
Date: Mon, 29 Jul 2024 18:00:17 -0700
Subject: [PATCH 5/8] xfs_scrub: add missing repair types to the mustfix and
 difficulty assessment
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229846006.1345965.2213135088155876021.stgit@frogsfrogsfrogs>
In-Reply-To: <172229845921.1345965.6707043699978988202.stgit@frogsfrogsfrogs>
References: <172229845921.1345965.6707043699978988202.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/repair.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/scrub/repair.c b/scrub/repair.c
index 8ee9102ab..33a803110 100644
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

