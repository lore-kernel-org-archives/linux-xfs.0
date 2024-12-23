Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6473918FC89
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991516; cv=none; b=rVUeZeSYuZFmS/cpiATld2/QDJj8r6XE9IvLMFxJpS4s0rvKKjmlHYbuEjnm7oumGm3IeXtLUJDoUFzTyICWAnGSy0pedKLCAJhL6WOelMfbsQ6oWG4Dqf9iCdRfJGE1lN0DUUJ7Ih70eql86KHPLzOxV6glzzfuu+PMzbKu3AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991516; c=relaxed/simple;
	bh=roGio/KzWUs7FMQnz/YwqKrfa10jb7uw4KuJ+3UswoQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SB+mqqFS8Q0OH7UtLubI/AiUB5oycvSS/XU1F1ZYoFWxGYlPuebiEapNpWHmrdxh/VdeHsrfq0P0dF9oTDSgsajlV2eZxYMe0ReJee+TovDKIrBJ21WwjcNLbE2RDLGL5d4y/CXsMRMPmvMN+ApOmZ+/qfWOYN9e7TVTY6KrB8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h86xZL6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h86xZL6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143CAC4CED3;
	Mon, 23 Dec 2024 22:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991516;
	bh=roGio/KzWUs7FMQnz/YwqKrfa10jb7uw4KuJ+3UswoQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=h86xZL6pxI+m/hDjJRlzhgjvmtwPr945H7K0R6MfPt3MJa1kLl2ODzrEPHldo2kpL
	 kqXeouyNp/gPqq+BuAoQy/FaN3Yzirbr6M3lYLfpb5L4yVbEk+ff5geQ+CFRvvxW73
	 sb0ak9dHy1ep+0azaTFdQnvQMO7yeg/G8AcQfOjY+YN9I1AotIttFzbIKrBUnynly0
	 Uh47iGlRA/0NbzwgtzxCniIuMU1xrcd3UkruRGfY7ey80eHMmP/nixFNU4YAqIjMIJ
	 EuY54QJ51NlloSbROIqw4+D9+GT/0fj5JC018exCfsZkWAHFZ/In3XtfRKCDuukltH
	 4tNSphL7dfXQA==
Date: Mon, 23 Dec 2024 14:05:15 -0800
Subject: [PATCH 27/52] xfs: don't merge ioends across RTGs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942908.2295836.15492752431407620148.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: b91afef724710e3dc7d65a28105ffd7a4e861d69

Unlike AGs, RTGs don't always have metadata in their first blocks, and
thus we don't get automatic protection from merging I/O completions
across RTG boundaries.  Add code to set the IOMAP_F_BOUNDARY flag for
ioends that start at the first block of a RTG so that they never get
merged into the previous ioend.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtgroup.h |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 026f34f984b32f..2ddfac9a0182f9 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -188,6 +188,15 @@ xfs_rtb_to_rgbno(
 	return __xfs_rtb_to_rgbno(mp, rtbno);
 }
 
+/* Is rtbno the start of a RT group? */
+static inline bool
+xfs_rtbno_is_group_start(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	return (rtbno & mp->m_rgblkmask) == 0;
+}
+
 static inline xfs_daddr_t
 xfs_rtb_to_daddr(
 	struct xfs_mount	*mp,

