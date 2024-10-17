Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304CB21D2DB
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191958; cv=none; b=lQ5q+9tilWYGk6TVtKC0jlduK44W52C+aW+QI4/ekNQTi5SxhRrGFMs9ml4m9oIDMsvOSEjfbhp7Kfa/8Qiv0YdSJ8aXbpknIEOkS/zwBpSo7oBeiTC8huiqJI/0tDnwJfuLvTVUqHFEbq3KYyPikvH2/HOxnLa05F3zTOOZdPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191958; c=relaxed/simple;
	bh=1KcQYzdVtkJ9svKDfS2aqKgKHzDiW6R2lCj79SY1ZVE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MSxd8Fo3CMogMEpi+cTFgKlcEvwMDoCUBfYe3j+jtuDyNRWHDMVbUG2Ev7CvINFVfHQwIAuNY82Y+i+zSZMDtZKvAki0mIz/AmKOWmdsoNQEMoOS2qBoY7coUAuzUk5bcstYtXrWXfE+Ji2Ish0zTjuyelStDlta1Y8ZPfVh9Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KK2xiLcX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KK2xiLcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFEEC4CEC3;
	Thu, 17 Oct 2024 19:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191958;
	bh=1KcQYzdVtkJ9svKDfS2aqKgKHzDiW6R2lCj79SY1ZVE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KK2xiLcXAqonEAX8t58KpBiT+LMlo1tGTOg2cGNB3yGdEZwiFzD+axrBlyKkhxiNQ
	 w87xARxx+6ia1WgG8V7fhGHtRR4I1UHjNnfKPcDTbStESIBkWXt5ACSkcoJ7dgjrii
	 jIRlxRDR0YgGw++0YM0LYHxbI/28cRF6qWrmi+JcrDGGowfFQaR5bYsN8xCghrPV8r
	 7r1HSTe81FRIj2nTfeZOQWa57uzVXyMPkr2Z0g7A5imYL8icQeg8QefC6uErk7cQ2j
	 eCJWC3GA+3l+K67ebHRbuaxjvv+iNkNHMLD1z6nNODfh+MYCmsypIsCRuVcHzhScMH
	 NL0f3WhlZhyoQ==
Date: Thu, 17 Oct 2024 12:05:57 -0700
Subject: [PATCH 12/34] xfs: encode the rtbitmap in big endian format
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919071875.3453179.13224711857139394467.stgit@frogsfrogsfrogs>
In-Reply-To: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
References: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Currently, the ondisk realtime bitmap file is accessed in units of
32-bit words.  There's no endian translation of the contents of this
file, which means that the Bad Things Happen(tm) if you go from (say)
x86 to powerpc.  Since we have a new feature flag, let's take the
opportunity to enforce an endianness on the file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h   |    4 +++-
 fs/xfs/libxfs/xfs_rtbitmap.h |    7 ++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 016ee4ff537440..cd9457ed5873fe 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -709,10 +709,12 @@ struct xfs_agfl {
 
 /*
  * Realtime bitmap information is accessed by the word, which is currently
- * stored in host-endian format.
+ * stored in host-endian format.  Starting with the realtime groups feature,
+ * the words are stored in be32 ondisk.
  */
 union xfs_rtword_raw {
 	__u32		old;
+	__be32		rtg;
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 2286a98ecb32bb..f9c0d241590104 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -210,6 +210,8 @@ xfs_rtbitmap_getword(
 {
 	union xfs_rtword_raw	*word = xfs_rbmblock_wordptr(args, index);
 
+	if (xfs_has_rtgroups(args->mp))
+		return be32_to_cpu(word->rtg);
 	return word->old;
 }
 
@@ -222,7 +224,10 @@ xfs_rtbitmap_setword(
 {
 	union xfs_rtword_raw	*word = xfs_rbmblock_wordptr(args, index);
 
-	word->old = value;
+	if (xfs_has_rtgroups(args->mp))
+		word->rtg = cpu_to_be32(value);
+	else
+		word->old = value;
 }
 
 /*

