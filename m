Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA561DBB2E
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529551; cv=none; b=ULgn4FILOeWd0PD8rhOzvbB7KhkpoynYSxESX0nULJGASwiTswemNBpHteQQDvDW64w02ODmcD+LiD45XvQ7Wpj3ypi5ZN8swQgEhyXZprH3KwdCZXiELlFKqEgK9iAnnhB7DxuprPejIt8o1mXDJmvL4sB7F+O08s6j6lzEUhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529551; c=relaxed/simple;
	bh=HOGNMadU+0OCkTnfj3ObVaBQYXdLcCWhwkhIx1r5Z6Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lYiiGlRQLeRSzZYLARMsLhAzCgEuXiVxE0/oDMCv0npKu+ExibHUTskbg5VUOfYqz26EM4mnsn4NWpdPcOfxf8GZ4kvFZvJFpGcMMSb/BkhMTvdXHsiYnRmCEftA4UtKx0SrmcS6nOIXhzNEnD8r3CX/7VZsqOSxLpSZr/rJwCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=twMh0vPK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="twMh0vPK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB62C4CED1;
	Fri,  6 Dec 2024 23:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529551;
	bh=HOGNMadU+0OCkTnfj3ObVaBQYXdLcCWhwkhIx1r5Z6Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=twMh0vPK7/3d4sj9Ou0qyKHRJjJvulCgrw7glmrhYRzqXcPW1pA6JFl7GCF2YkzNJ
	 S+JUlT72E3UIQ+gyZL7NXR9VAustkwgM0bnXYFvMVPuDycy8/bKafUcYRHbpoWkMND
	 KvMZPTmBX+dkWMrZHRSk54IRx6/C8AL+G03QNM3/qph5sPOWOZHFyg6+mksPe77ZBF
	 lm7G+s/hFsDnBwplXk9dfxXMromdph9bbB+ww23/6yQtIFrT9YKMjJSbmICy/0RSh/
	 ZjthM0cbDR1GOXhbqWqAechaJbEGYxspFKVR7bm/BIQFCs276OmCs/Trnb8X/K6vw6
	 +bbuR2UcCLnvA==
Date: Fri, 06 Dec 2024 15:59:10 -0800
Subject: [PATCH 30/46] xfs: scrub metadir paths for rtgroup metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750453.124560.6031319372218943581.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: a74923333d9c3bc7cae3f8820d5e80535dca1457

Add the code we need to scan the metadata directory paths of rt group
metadata files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 50de6ad88dbe45..96f7d3c95fb4bc 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -822,9 +822,12 @@ struct xfs_scrub_vec_head {
  * path checking.
  */
 #define XFS_SCRUB_METAPATH_PROBE	(0)  /* do we have a metapath scrubber? */
+#define XFS_SCRUB_METAPATH_RTDIR	(1)  /* rtrgroups metadir */
+#define XFS_SCRUB_METAPATH_RTBITMAP	(2)  /* per-rtg bitmap */
+#define XFS_SCRUB_METAPATH_RTSUMMARY	(3)  /* per-rtg summary */
 
 /* Number of metapath sm_ino values */
-#define XFS_SCRUB_METAPATH_NR		(1)
+#define XFS_SCRUB_METAPATH_NR		(4)
 
 /*
  * ioctl limits

