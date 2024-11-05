Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDBF1DD0D2
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845186; cv=none; b=FGZrCdgqI0jxZUmNdHCW5gDfqYllanlyvi6sRcLLvPe+8NKm82W5jyb+qO5K+0Zg1JjwrHqtTcwhzEJrqjU99ekhwqhW50F8YcT8CcuuURrpl6tsxCCWdnVrj6g9dTT+7iaN74HYjcH0Ct2zqdfBY1EG0j6qaMpzGvsCXFaqbg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845186; c=relaxed/simple;
	bh=i82DjwBy5wpzgDm79r27NZwe37NgTKHcyFQ9oWcOwVw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z/a/R4xQNuNyh/1p5q70HkipEeKe3Ky2zkX44Xk5xkNtEa3uEXk9OvOvppTG+vVpncwfD5zlfbm4KSJvXrzT7laLIFAojtOLO7pp9vN6tJ6a6mjoY9iUo79zKO4DRjwv5l1Q3MamgaHwBn/hXCd3XA4r5Dxm8Q9PwbrYwDL/T8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LEVnvklm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LEVnvklm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134F9C4CECF;
	Tue,  5 Nov 2024 22:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845186;
	bh=i82DjwBy5wpzgDm79r27NZwe37NgTKHcyFQ9oWcOwVw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LEVnvklmNPMkg0c5huj2F0Brh2qOPG4Zxh0pwmZMd7hBugKzLl/v8uv478f7GV89c
	 EJBwevwAuY8POPk7MUNORJvvGPfc4IGl485PnHVIeAaPVCZ6EjbWEeAnuJqW48buxm
	 /D//4koI53+2fBqioCLa7KeRieOCm136LGOtjb9ih2tkLFJsrmKewCcYI5xgfSW1Tm
	 1IXmjKSpv9mG62y3GPZa+Xq3n61AXSfQlo3Ay5sDmu80l6nUZ1ikA7P5557mpKls1K
	 EfN2m4eH8q+MYCYQZy1a/KIR5X8aHVl3wKQ1i4cfbeVtCRwxnn8oPNEr2F/oIFs5Nt
	 RR0lTwEzmzvGA==
Date: Tue, 05 Nov 2024 14:19:45 -0800
Subject: [PATCH 12/28] xfs: advertise metadata directory feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084396226.1870066.767109488382898420.stgit@frogsfrogsfrogs>
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

Advertise the existence of the metadata directory feature; this will be
used by scrub to decide if it needs to scan the metadir too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h |    1 +
 fs/xfs/libxfs/xfs_sb.c |    2 ++
 2 files changed, 3 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 860284064c5aa9..a42c1a33691c0f 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -242,6 +242,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
 #define XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE (1 << 24) /* exchange range */
 #define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 25) /* linux parent pointers */
+#define XFS_FSOP_GEOM_FLAGS_METADIR	(1 << 26) /* metadata directories */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 19fa999b4032c8..4516824e3b9994 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1295,6 +1295,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
 	if (xfs_has_exchange_range(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE;
+	if (xfs_has_metadir(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 

