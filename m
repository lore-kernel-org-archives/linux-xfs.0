Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3905A18E35D
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992720; cv=none; b=T/srY6J6F7iiQIL8fk8xGytSLuQ9kuJvXBXdsyNilUxBIqp4LZsvMi5lfcP+HMPtcFWpbHa9kyvpS/RSpzsmH5DnpTSoi5eIjI5yqTToP1X0hOAwVPgylo+emrFw79k1RvP1WdVvCcwcQwQHgJDNEyJJYNP1Rhxe7GgxnLiTPzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992720; c=relaxed/simple;
	bh=sHdcCzUSTJxIQxsLvKw3htxZcYbSzttyMF0khf7XcaM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZUpRGbyiHegrnN/QYZTUG1LN18BSIY2XocVNAtfpYk3QhxMUD3GRw4ZfvJlJ5H2Inb9+HtL8UdcehTAPF2hr8TUPRMM3P87z12M/vM4IAiAd/plINmaIJA/jMvQHBQNKJOIgYbKaQi7bMIWUrKRh8SybcoyNcuzjas0yBqhSPwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fASLKN9z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fASLKN9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E51EC4CED3;
	Mon, 23 Dec 2024 22:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992720;
	bh=sHdcCzUSTJxIQxsLvKw3htxZcYbSzttyMF0khf7XcaM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fASLKN9zxMFMxk8wcz+kpZf2XUnPLK9LWqVbTgvZi5UX95fOp4qcgzM7mYN6ZKpWk
	 0WucYHBut73SPdpkClqtnq9lJ+qoCCeRG+zWCMBuLiqvR46hMcqQSnwRB4st/HLXjB
	 cqxnFuMiLnzhIVjZTchsbtjiAOqUj3wpZjvvtoNja3kw0Hr/a5p34zxdyM1a+j7F/d
	 nXS0w+rnB+7bJwAhBNNpeBeEUxP8prjUv0SxVqMQz5woIBcIdFUNWZLchrHklGL/qa
	 8bT5Zl4xIJnkFaNvpVCtGJCiGfrt6GzDH7aKFUEQVCn5lqxW9vvvYu4mQVBD6U7d7b
	 UryAEg7NC0G7g==
Date: Mon, 23 Dec 2024 14:25:19 -0800
Subject: [PATCH 1/7] libfrog: scrub quota file metapaths
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944983.2299261.5570475562041386399.stgit@frogsfrogsfrogs>
In-Reply-To: <173498944956.2299261.16768993427453132101.stgit@frogsfrogsfrogs>
References: <173498944956.2299261.16768993427453132101.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Support scrubbing quota file metadir paths.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/scrub.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index d40364d35ce0b4..129f592e108ae1 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -187,6 +187,26 @@ const struct xfrog_scrub_descr xfrog_metapaths[XFS_SCRUB_METAPATH_NR] = {
 		.descr	= "rtgroup summary",
 		.group	= XFROG_SCRUB_GROUP_RTGROUP,
 	},
+	[XFS_SCRUB_METAPATH_QUOTADIR] = {
+		.name	= "quotadir",
+		.descr	= "quota file metadir",
+		.group	= XFROG_SCRUB_GROUP_FS,
+	},
+	[XFS_SCRUB_METAPATH_USRQUOTA] = {
+		.name	= "usrquota",
+		.descr	= "user quota file",
+		.group	= XFROG_SCRUB_GROUP_FS,
+	},
+	[XFS_SCRUB_METAPATH_GRPQUOTA] = {
+		.name	= "grpquota",
+		.descr	= "group quota file",
+		.group	= XFROG_SCRUB_GROUP_FS,
+	},
+	[XFS_SCRUB_METAPATH_PRJQUOTA] = {
+		.name	= "prjquota",
+		.descr	= "project quota file",
+		.group	= XFROG_SCRUB_GROUP_FS,
+	},
 };
 
 /* Invoke the scrub ioctl.  Returns zero or negative error code. */

