Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04CC10E9
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300342; cv=none; b=Qf9Vw+DbNXUePQjyawLjYHpFppCMfuCmBtFAIE8Jqwb29muJa5XHnsvKwtHy69NejRoP2cyGiaLRQgD/oKuvZIxMiQxT8tNC3UvPsTR5dK+d7QTNuimGfiQFOy8kLOAWCWdGaA6ZPIIXgQ9wFtYk4YYT+PNo/W/DiHnvU8Qjyic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300342; c=relaxed/simple;
	bh=dXRjIsdbYItqDORc78iq4r2C34Aa2hlCnNcb5V9PRsc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LeXYY3W4wr3UK55Bc7/pN3rlG9/4TV/ama/N0+Feh47TW6cC+wJuTg/pVvZPzNl20/XUVMBEqFGB2SY5/dX57qrlyB9u8vBNphEdN03dqb+tZrH471CDTeji3EIJ5E+LiO0HTfTiJ7BE7krVd1umyBgl/ldwGpvPZRCFDwAJGGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fRTy9SO0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fRTy9SO0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0DDC32786;
	Tue, 30 Jul 2024 00:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300341;
	bh=dXRjIsdbYItqDORc78iq4r2C34Aa2hlCnNcb5V9PRsc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fRTy9SO0PAclornCvB0z1NnlG+7qPgk/ZQ2ZAfHHk6HACIH6xBueeyXTK8VmGUagV
	 Daqxq3fM8T1HTSNv5/sCBstiwPuKqGiNsqv6SeCsPpZsTNCoM5D9KbnANfhIMVhEtl
	 KRU1RxiIILStb8XdmKxLrXxkfgCccnguVwWuR5yCJi6C1BOsnc/Zz+i+gdbPn92FGL
	 Fiinpt9yfe3v+HqhVmE+zNkO2OcNJHW/g8NKnbu7ttCS7M786o6jJxmCUzDHVGjiPS
	 f/ytmKQDQyLcjMoriMKGTfWxJf/3UcpWIF+Pisxw98NopB4emLVkF3hu3OC9AK/KWy
	 LpOE71lx0N1oQ==
Date: Mon, 29 Jul 2024 17:45:41 -0700
Subject: [PATCH 084/115] xfs: teach online scrub to find directory tree
 structure problems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843637.1338752.16678515437880585817.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 928b721a11789a9363d6d7c32a1f3166a79f3b5f

Create a new scrubber that detects corruptions within the directory tree
structure itself.  It can detect directories with multiple parents;
loops within the directory tree; and directory loops not accessible from
the root.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index dd13bfa50..85f2a7e20 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -719,9 +719,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_QUOTACHECK 25	/* quota counters */
 #define XFS_SCRUB_TYPE_NLINKS	26	/* inode link counts */
 #define XFS_SCRUB_TYPE_HEALTHY	27	/* everything checked out ok */
+#define XFS_SCRUB_TYPE_DIRTREE	28	/* directory tree structure */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	28
+#define XFS_SCRUB_TYPE_NR	29
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)

