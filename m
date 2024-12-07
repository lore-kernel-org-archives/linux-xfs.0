Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79385196
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530036; cv=none; b=qJAUfOh20u+H4ifcGUHF1woU8EJ7zjEgitS7dkbmrUc+ON8GpSSSKA7lG3OFrAXq23fTNXXs3iyU9baNa2Bk966cqXySxNNc9JHt1BUpuwS8Xn8CeVBcivzc3YH+ZE/z6tnoDuwwdBc2Oq3EykqKO3Yi3tSkdlWsK7/TQ+IOYzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530036; c=relaxed/simple;
	bh=PWww1QqPQMO8KJnh9zqSLHVKmDGmu8K/1XOFTWKZLpM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DyPuS0+lxbqCRD0bW+yd8kuzjjCyQwH8AiTG2kAr/dphhyquNTCokLHWutUNAxAnVRemQ6WCHndh7nIGqTyV+Gx81Sj7gRSIBODn+aB1xQamSt9DQF2cSqnJzAY9NKLuRoznGCyLeD6rT4gkz4MD2hfFOtdg5pWJ/sbp8lk/imQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oe9XS3gZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oe9XS3gZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4BDC4CED1;
	Sat,  7 Dec 2024 00:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530036;
	bh=PWww1QqPQMO8KJnh9zqSLHVKmDGmu8K/1XOFTWKZLpM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oe9XS3gZrZxOghhbz0ylaTYMxiqd07s87K+4rhOqZQfU5BmaeptZNqecWPRXfptaP
	 FkNmQm5JUJB7cM1HtmuPkV1sbwrxrCoeER7cHhhXoTqlMhMGnKktAhtGzYaOclkLfH
	 jP+OmkagRvjynke/GXfOTKzkGfScwGHC7cJJcNTs3z4P1yyAoAPvDCLDH1owtPTjrO
	 c95XztJQK8LXX8IiHGXnjdHf/IjRggGM73pisVisTW/CRq/mGAXRHJON+LF55gyRoM
	 32FP4oROjM+G1G0tR3tynIkWyH+SX9vHYsPkRdqz0tP35hDGp+V4KUf2ivZeD1E7NB
	 2X4AGB03pxV9Q==
Date: Fri, 06 Dec 2024 16:07:15 -0800
Subject: [PATCH 09/50] libfrog: support scrubbing rtgroup metadata paths
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752083.126362.5682773152874800985.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
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

