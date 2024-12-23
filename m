Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E0713FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992063; cv=none; b=rTEtRV1uiOLOXdmWBFqEiyc9n3yCn1Te0pPmmE+bj8fcBMl/Ko3gB3GnJpy0vp0Yd4VGW8YayOjjEw+dGlHcBKo1bzuxOXXQsE+PK2tTumI5i04smDQL7Mm2S4Au8ExgfFoxUpNOUqIr2tfcWeejrvXIxQkdkp9d0q7Co6I6Vw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992063; c=relaxed/simple;
	bh=kT+0fhm8uY54S4zxkeWoKwrm9qZPDWgro8GGENbgi2M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ecmI4F36ZcQVceDcqr8s1u/WB8dFw7DPfCQv3Zs1EZwKPOH6D/w+38isBUvezZ2NQ8pNpXikVfiwcA6bOE0+OeCcJndTYojXhAj1CibfhDTCN2RAlQkDunAtG2AYbBbelvFzO57SLAAjw1jjrdU/zMVbHq6IQPvwBg9Od3rtKUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fAwQwLiN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fAwQwLiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70B9C4CED3;
	Mon, 23 Dec 2024 22:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992062;
	bh=kT+0fhm8uY54S4zxkeWoKwrm9qZPDWgro8GGENbgi2M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fAwQwLiNK3U+aqOAVBYASvLJwqHm+/Aok9npiMy3ZWCkWszfCgPudhnKlGH5/3Nx8
	 mUk1MaJTfHRmCbL+IVnlAGnQpAmnYlT9Hm8eKuUy9NTzJAgvEVqzgqMU/yHqp+E76U
	 +DavzNoOTsTnABxZOpDVZA0Ft3NUCDmtlTpMUxvPR9GIHVn7MqTtJoqAuDhmdGdLQv
	 gmQ5VzkgYCfZE4H6DkwYkXVXBdequVo/L4PhisHS7zlmdL+jvA0QaBIhYvHwRNKnG0
	 zwcQbVngHPxOdTDAcYVVETJbNlKnkYvtI8woT8om//WcSCoOyTsgEoRC1TQRXfhbBb
	 xQsRkKUbQrS7Q==
Date: Mon, 23 Dec 2024 14:14:22 -0800
Subject: [PATCH 10/51] libfrog: support scrubbing rtgroup metadata paths
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943957.2297565.12360582945042560643.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Support scrubbing the metadata paths of rtgroup metadata inodes.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/scrub.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index e7fb8b890bc133..66000f1ed66be4 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -172,6 +172,21 @@ const struct xfrog_scrub_descr xfrog_metapaths[XFS_SCRUB_METAPATH_NR] = {
 		.descr	= "metapath",
 		.group	= XFROG_SCRUB_GROUP_NONE,
 	},
+	[XFS_SCRUB_METAPATH_RTDIR] = {
+		.name	= "rtdir",
+		.descr	= "realtime group metadir",
+		.group	= XFROG_SCRUB_GROUP_FS,
+	},
+	[XFS_SCRUB_METAPATH_RTBITMAP] = {
+		.name	= "rtbitmap",
+		.descr	= "rtgroup bitmap",
+		.group	= XFROG_SCRUB_GROUP_RTGROUP,
+	},
+	[XFS_SCRUB_METAPATH_RTSUMMARY] = {
+		.name	= "rtsummary",
+		.descr	= "rtgroup summary",
+		.group	= XFROG_SCRUB_GROUP_RTGROUP,
+	},
 };
 
 /* Invoke the scrub ioctl.  Returns zero or negative error code. */

