Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E8C125AC
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372674; cv=none; b=Atz4jGOazFd9RhzuPy5SE4l3SQJgjwQcAhbqrd1U/4Y9RNtQXpeUEGB52KiOqtIAhtG0r7EPh3MJASlNKtIImvFQENzSa9tVv9zJ93oBYPJYb4oU19pb1i7zSZmbBQip+OH3+7QbJZb4V7LTZ5hNz3orKqAE9JFmDwOcfLnTrrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372674; c=relaxed/simple;
	bh=RN0EPSVbkpCHJZzaYLOPnBuaz/fNE93GtDMByqdH2mA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GYkvjArH2lsGxJpXyuc+1CIvFy//x/RbbWKJuRvq7BA1M92pytaTNrDRoyahnq6i1P0cywdFFhIJVsPe135zLyAa2FF1kDki4frE86/ZF9nQr8F9KeeeNn63ocuHLT6YO/HREEHiiwnbwovPofBMieVlMz7a5U0xEE1pvzkyFbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iZzTb3jz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iZzTb3jz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15231C32782;
	Fri, 23 Aug 2024 00:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372674;
	bh=RN0EPSVbkpCHJZzaYLOPnBuaz/fNE93GtDMByqdH2mA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iZzTb3jz+FT0MT463k42iGlokpeyDYyfmrbf9Ybh2KmGrdpuneI2ePBxrIPX5odj3
	 U+nBgrtGEvP7qdeITOK4guZ/2++82CUAcCxUM/A97DJM9tRWWdfOBQ3g13MGknyp2j
	 0EUF9e6hh5rEPt+pXhxWb0jBlSjLVk1wzPnj0cDYvOnLughYGyWFb8u4lxnKvcG6Ip
	 bv830EuxWfD375IDPsegaTOkJ56jFfhU19YsiQwxJRHD0r0eX34Dl6veEIhVet/IPZ
	 nhAB6rWaffIgPyovytxXYNdm0glk1w+A9Ayzb+REhkef7X21g29UydwXQxk75mU2WY
	 ItxTeddfnM+SA==
Date: Thu, 22 Aug 2024 17:24:33 -0700
Subject: [PATCH 13/26] xfs: encode the rtsummary in big endian format
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437088747.60592.2913943044668719207.stgit@frogsfrogsfrogs>
In-Reply-To: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
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

Currently, the ondisk realtime summary file counters are accessed in
units of 32-bit words.  There's no endian translation of the contents of
this file, which means that the Bad Things Happen(tm) if you go from
(say) x86 to powerpc.  Since we have a new feature flag, let's take the
opportunity to enforce an endianness on the file.  Encode the summary
information in big endian format, like most of the rest of the
filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h   |    4 +++-
 fs/xfs/libxfs/xfs_rtbitmap.h |    7 +++++++
 fs/xfs/scrub/rtsummary.c     |    5 +++++
 3 files changed, 15 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 506f5d5ee03fe..cafac42cd51ad 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -725,10 +725,12 @@ union xfs_rtword_raw {
 
 /*
  * Realtime summary counts are accessed by the word, which is currently
- * stored in host-endian format.
+ * stored in host-endian format.  Starting with the realtime groups feature,
+ * the words are stored in be32 ondisk.
  */
 union xfs_suminfo_raw {
 	__u32		old;
+	__be32		rtg;
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 148f7631d7fc2..d36fe2efc56f0 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -300,6 +300,8 @@ xfs_suminfo_get(
 {
 	union xfs_suminfo_raw	*info = xfs_rsumblock_infoptr(args, index);
 
+	if (xfs_has_rtgroups(args->mp))
+		return be32_to_cpu(info->rtg);
 	return info->old;
 }
 
@@ -312,6 +314,11 @@ xfs_suminfo_add(
 {
 	union xfs_suminfo_raw	*info = xfs_rsumblock_infoptr(args, index);
 
+	if (xfs_has_rtgroups(args->mp)) {
+		be32_add_cpu(&info->rtg, delta);
+		return be32_to_cpu(info->rtg);
+	}
+
 	info->old += delta;
 	return info->old;
 }
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 1f01ed9450388..f6779af92d57b 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -151,6 +151,11 @@ xchk_rtsum_inc(
 	struct xfs_mount	*mp,
 	union xfs_suminfo_raw	*v)
 {
+	if (xfs_has_rtgroups(mp)) {
+		be32_add_cpu(&v->rtg, 1);
+		return be32_to_cpu(v->rtg);
+	}
+
 	v->old += 1;
 	return v->old;
 }

