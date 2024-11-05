Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECA91DD0D2
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845233; cv=none; b=uyT3BsolSByw3JvljSEnEhhmLo/Veg61QBdavqQM4+WCAjDPPB+SoXpT7+8mcBjJriDOk2jESCYLlI/whNujVKbWez8zPG3DpBUz8XoH4L7M4YDIVs8UB9FVs0T3yvTDkfiasZpMexwl2eIs1VexCQjn3iBFvQPJsvRvgwxSel8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845233; c=relaxed/simple;
	bh=wCcqib4BZHcOY+pFwj4bKL8jYHfIgqr20aFnyroDLoA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JHyXkllPlMsyEr4V2WNqiZRGC0e2Mdfp7sK+RC6+aUHnDpLtRvppE0LydfMUjE7gnKR87GpfzoutxLxaT1ge9uIFdD48gSYhIpt+7XuKatdYNOl1m+vvhV1Lme4MGJRA3COVhbk8U2wa6dsmAsrBi6o/angpc6opzIObJrfAdYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fcWHxwUG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fcWHxwUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDC9C4CECF;
	Tue,  5 Nov 2024 22:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845232;
	bh=wCcqib4BZHcOY+pFwj4bKL8jYHfIgqr20aFnyroDLoA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fcWHxwUGSTf8gPIm22OpfAuyiYxhI7gtI0VKRLBYvqIhzp82bLs2C3dMAHCvSNzMO
	 ixae5gc03Q22VgevJVjhuLTldvw+q8UMPb5gNuI5fKC0LQXxym0QLJpyeVxNYbYyQ5
	 UisKxFWDg24jbucZqPmikqI4P3rYHfna1GHitJgNwVnxq96kdflmY+2bH5HFvalDZL
	 SrLfbUvz2xASVgZVm5zOYMeKz7G5P2KgERFHgdbArSCR8pIYvBEEpHUTvBsdaHb4Xg
	 66xKe0Cj9aCn75WjLkS0eW8GZYygOtjFZQzB8aSr1Zt/CRveHJ1Vy+kLo8NcSnjAj4
	 0QHdFfGuR3W5g==
Date: Tue, 05 Nov 2024 14:20:32 -0800
Subject: [PATCH 15/28] xfs: mark quota inodes as metadata files
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084396277.1870066.7525248802720413889.stgit@frogsfrogsfrogs>
In-Reply-To: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
References: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we're creating quota files at mount time, make sure to mark them as
metadir inodes if appropriate.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index ec983cca9adaed..b94d6f192e7258 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -824,6 +824,8 @@ xfs_qm_qino_alloc(
 			xfs_trans_cancel(tp);
 			return error;
 		}
+		if (xfs_has_metadir(mp))
+			xfs_metafile_set_iflag(tp, *ipp, metafile_type);
 	}
 
 	/*

