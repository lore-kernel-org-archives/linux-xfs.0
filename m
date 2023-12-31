Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DC4C13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DX1qTj+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0DCC433C7;
	Sun, 31 Dec 2023 22:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061905;
	bh=LiPYPf6gUsjIR+DIG7G8lhKTVR6EdOPCuRSUUdBpg7o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DX1qTj+2FxbKnMSJNXEn+T1xzZmuGWN8Pe2eC9IV0AFn8ezaCGJGVJNbZS1V/ZDVF
	 lBkhsEl38Ao5585uZjGfWjK77ZQGuiIfeJ0gba7/5xqXJzcXlSWUMd4PEt0mgsjsee
	 ZPTNhWmPZ3Yxo35lWCiQAp6lTryxjFnoecCks0T8Fykkd/X50mjNJGFrQS6H2tkyWM
	 rry+w3ZXF8RZhu+P27ejEEobs2/LhaF1/V1yWv31vE5I6csSWJjtvmKQcM4QE+tAYj
	 nptSYVV7oyeaXrI5h+679orv2IJGkOjKZ6r1nljv4V8q0ImloGgeVUJmu8HqDh/ugs
	 sNILoHT3O+CdA==
Date: Sun, 31 Dec 2023 14:31:44 -0800
Subject: [PATCH 18/20] xfs_fsr: skip the xattr/forkoff levering with the newer
 swapext implementations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996515.1796128.9395428698927356944.stgit@frogsfrogsfrogs>
In-Reply-To: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
References: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
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

The newer swapext implementations in the kernel run at a high enough
level (above the bmap layer) that it's no longer required to manipulate
bs_forkoff by creating garbage xattrs to get the extent tree that we
want.  If we detect the newer algorithms, skip this error prone step.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fsr/xfs_fsr.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)


diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 37cacffa0fd..44fc46dd2b1 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -968,6 +968,22 @@ fsr_setup_attr_fork(
 	if (!(bstatp->bs_xflags & FS_XFLAG_HASATTR))
 		return 0;
 
+	/*
+	 * If the filesystem has the ability to perform atomic extent swaps or
+	 * has the reverse mapping btree enabled, the file extent swap
+	 * implementation uses a higher level algorithm that calls into the
+	 * bmap code instead of playing games with swapping the extent forks.
+	 *
+	 * The newer bmap implementation does not require specific values of
+	 * bs_forkoff, unlike the old fork swap code.  Therefore, leave the
+	 * extended attributes alone if we know we're not using the old fork
+	 * swap strategy.  This eliminates a major source of runtime errors
+	 * in fsr.
+	 */
+	if (fsgeom.flags & (XFS_FSOP_GEOM_FLAGS_ATOMIC_SWAP |
+			    XFS_FSOP_GEOM_FLAGS_RMAPBT))
+		return 0;
+
 	/*
 	 * use the old method if we have attr1 or the kernel does not yet
 	 * support passing the fork offset in the bulkstat data.

