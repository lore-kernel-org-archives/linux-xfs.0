Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A472417F2
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882685; cv=none; b=hrR6bXsjDBiIONx/aYmNWhDkFshCExCWAByo2qAi2yIb7XrN99GxXwyUTdArjCj3fWdjjctpjySdz9GT/HcD10O3NjzOtm9LZplrDTMx4ZOcGbbOngXhSDmkDDBeel4gX0Mi/GrnsOXheN35EGoVlhNAjJUa7afvf3IKbpPjylc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882685; c=relaxed/simple;
	bh=NK3w8bCzybL5p4FIajuycmJd6W1SvtTb9a7pRLkuqr8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aL/3z9B+xpz1hlY4zfK4bjCo8ri3vAaNST+ITjXLlpk+q1ihpNQ98zAV4Z5OLmDlZrEpw06DFtCOwke/IAAClqGg0Hkzflq/Lxi/F0ZjsYYiylB2kixtyAdDuDs3CL2qeNL7QdB6+HUOP266rvGMA71LrKjad1So+SapFnGCW10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d/M2imEO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d/M2imEO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2936C4CEE2;
	Thu,  6 Feb 2025 22:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882684;
	bh=NK3w8bCzybL5p4FIajuycmJd6W1SvtTb9a7pRLkuqr8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=d/M2imEOPCmm3uHqAP/NH+ayadMUkGAw5s0N9rGLTloljE46jRzuPmww325320Lfi
	 3fhPdBIGoEQNnYFps+VS3Aae2uioDZtL/muNO8iU91qW19Br59RS+KQ1bnfqkyL1l5
	 zo/C2/QwZA2NQVqLtMoqLXuvhm/eW2CbSynff8xHe6WZdXCgmwe5W2zU7Gaa/Uc/Dd
	 Hq4uabkMJcQRrd3vfJv30wTeKhQlMryFlz2JUPftd41xagfnTSrM9DdobTCy3obdr5
	 iEh4Yby4U91ZI4CQuK+B+d1HiRPh8K5llxWRSKrzp3FeeDa8QDw9Gehfp9ghMXs75a
	 6HpRQDVCFFTxA==
Date: Thu, 06 Feb 2025 14:58:04 -0800
Subject: [PATCH 05/22] man: document userspace API changes due to rt reflink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888089011.2741962.7359133860691988618.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Update documentation to describe userspace ABI changes made for realtime
reflink support.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man2/ioctl_xfs_scrub_metadata.2 |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)


diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index f06bb98de708a4..c72f1c5c568b01 100644
--- a/man/man2/ioctl_xfs_scrub_metadata.2
+++ b/man/man2/ioctl_xfs_scrub_metadata.2
@@ -181,11 +181,12 @@ .SH DESCRIPTION
 .nf
 .B XFS_SCRUB_TYPE_RTBITMAP
 .B XFS_SCRUB_TYPE_RTSUM
-.fi
-.TP
 .B XFS_SCRUB_TYPE_RTRMAPBT
+.fi
+.TP
+.B XFS_SCRUB_TYPE_RTREFCBT
 Examine a given realtime allocation group's free space bitmap, summary file,
-or reverse mapping btree, respectively.
+reverse mapping btree, or reference count btree, respectively.
 
 .PP
 .nf
@@ -250,6 +251,9 @@ .SH DESCRIPTION
 .TP
 .B XFS_SCRUB_METAPATH_RTRMAPBT
 Realtime rmap btree file.
+.TP
+.B XFS_SCRUB_METAPATH_RTREFCOUNTBT
+Realtime reference count btree file.
 .RE
 
 The values of

