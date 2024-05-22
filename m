Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F115200B7
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347974; cv=none; b=sU8fKuizxt3c8LmeNWXy/ThoPzFzqy79XZslgmd+kWdbYjsw52AClfC8VtCZ7NvsE84qHOqg8uNi8W1yAWVy9S799kUkaTW7rP/vJtzfxLqD7oW1XFn/jm0S2sIj+UOfRwCmLI3wF91BJfRxRJ5SS/sUoB40aYOVMknKBk3HKAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347974; c=relaxed/simple;
	bh=+qqjVrjE2XhYWZkQYoMrW0JfdLnsfNGz3+1KQ5WbZ+o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J5njvuWz78IFU+gEPdDB/1KH2RF84StLRHrV5jQOTYKnC3gY8ejxeGIhYATdiLnspDVr8DEwXpYMTzHKPASTFq+CZ/ju3xtam+m7XuLQz2PAQAlAG4xFGiPOiWFahYY7E5xxRZegBEF5o0pgVAejLFJMK5dWTJ/Gy/Kar4m57Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EYDP36Xn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EYDP36Xn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C869C2BD11;
	Wed, 22 May 2024 03:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347973;
	bh=+qqjVrjE2XhYWZkQYoMrW0JfdLnsfNGz3+1KQ5WbZ+o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EYDP36Xn/YasEkB/cI5XAyZxFiDwjUwTjD+NfX3Ms2gZZS3XQc3QlOU+9xjGEe2Yi
	 JY4bHUaX30PubrmVT/QYG4o1xr9Z+qiNyPK7t9OIe2Ya5RShgcKcTy7JDxbH0rI2rB
	 1TU3yo74lGwRrVAACyBsMD408ViCkQM97JuplzY/hZFhjIUatR5Ky5ulR2uhJzX50I
	 ThGtavU7O+ZvQnkdICLKHXMDvGTg8yQaWphUBwXuivAtd9P1BRwWUvgy//pPyAa0R3
	 vaL548F02EIxypw4QQVZ6G/X1wuq7EUA/+yX4GwItXzW1OSymGravRCq/ljaAuCWnU
	 N8V7akT1KrEEA==
Date: Tue, 21 May 2024 20:19:33 -0700
Subject: [PATCH 2/2] xfs_spaceman: report health of inode link counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634534420.2482833.15149371878461172207.stgit@frogsfrogsfrogs>
In-Reply-To: <171634534389.2482833.12547453553760834310.stgit@frogsfrogsfrogs>
References: <171634534389.2482833.12547453553760834310.stgit@frogsfrogsfrogs>
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

Report on the health of the inode link counts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 spaceman/health.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/spaceman/health.c b/spaceman/health.c
index 3318f9d1a..88b12c0b0 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -76,6 +76,10 @@ static const struct flag_map fs_flags[] = {
 		.mask = XFS_FSOP_GEOM_SICK_QUOTACHECK,
 		.descr = "quota counts",
 	},
+	{
+		.mask = XFS_FSOP_GEOM_SICK_NLINKS,
+		.descr = "inode link counts",
+	},
 	{0},
 };
 

