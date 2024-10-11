Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B47EAFA
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609501; cv=none; b=C1v4Gt3pUTQStT+OUbo8v1AkNGR91Qmjjs6mASMVzLW6/Nf4piP3g+mJvjoxyZUO/4H96s/cL/AsB8Y5TaAKfp8WqPGx9QqLKWb/UL0hK5rUi/IjdTaLuM6UDBIMfErfgdfs0kAo8ih+8cMcCSllaCJlOLtZRGX8QSE+nG7DDtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609501; c=relaxed/simple;
	bh=tHszRFLsXcc/DJFBcVxrt70dfH5S8gHBQDRK5wfMQmA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f1lA/MJE7uYYYmV7v4N37DACykVnvMfF+z78Z/R/ndgs2RbrsmQ22R0+ieurQ1NgpE+6aG7HDAaw2MfNtIt5/9V9w7DO/UQoVLymmwZ6gDKESbx5jFdzLuEFW3NMVtWIJPWYIKeJcPq9SmqZ7gLN2qcwXEhn+gP5WwgP7p4DGSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LvKC+nDq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LvKC+nDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FA7C4CEC5;
	Fri, 11 Oct 2024 01:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609500;
	bh=tHszRFLsXcc/DJFBcVxrt70dfH5S8gHBQDRK5wfMQmA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LvKC+nDqn0aWEtEgDqpA63yWioc86nfLdJV2wgQOIyQU48ZDIjRyTPl3MI0TLgotj
	 koDTWFVoak/pa4p6eP1VOK2P3PU7j0qL548PhoPkSsap0SDbHoKr5DYGGpHvZSS0XT
	 9u6EFcN80jf5KZsrdtOGXr+Akged0rROi+oUJS3pF3e/HnnU1p7YZBk2Pp4o4RiAJ6
	 UEykUEYO7aqkpYcxMW/tXwFnW4SdRhMWE0y8krQvrzktaGqM+B+/jLt1I6h/6uZQr9
	 iMEpUkovdplfYA6wh8jujn30z1SxuMcaTWbnI/TuVldeHYWpjlhceNiUtVB2eJRQ5d
	 6hJwovbF3oqIw==
Date: Thu, 10 Oct 2024 18:18:20 -0700
Subject: [PATCH 16/38] xfs_repair: preserve the metadirino field when zeroing
 supers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654222.4183231.9045150758158670303.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
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

The metadata directory root inumber is now the last field in the
superblock, so extend the zeroing code to know about that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/agheader.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/repair/agheader.c b/repair/agheader.c
index 3930a0ac0919b4..5d4ca26cfb6155 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -357,7 +357,10 @@ secondary_sb_whack(
 	 *
 	 * size is the size of data which is valid for this sb.
 	 */
-	if (xfs_sb_version_hasmetauuid(sb))
+	if (xfs_sb_version_hasmetadir(sb))
+		size = offsetof(struct xfs_dsb, sb_metadirino)
+			+ sizeof(sb->sb_metadirino);
+	else if (xfs_sb_version_hasmetauuid(sb))
 		size = offsetof(struct xfs_dsb, sb_meta_uuid)
 			+ sizeof(sb->sb_meta_uuid);
 	else if (xfs_sb_version_hascrc(sb))

