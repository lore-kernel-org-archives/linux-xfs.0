Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D8117992
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 19:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G/JziQ+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389C7C433C7;
	Sun,  3 Dec 2023 19:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701630178;
	bh=b70j6dzFjQ2Rw57yuuE0IfoZoT+ZWCR0IoaWOUbZ3Uo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G/JziQ+1+VYSfbKDSaFptxFXDt7EIY9GfVDHcnRhkVTdvkkK47kfdc7upn/MrBTx3
	 yS5c48HctJAzD0cpaKmdF/Q3j0B93TEYI6JbuFjdDWa/ZRI/u+6sTFuvX7GmGXvl1p
	 evwHYFg/Ra+cEe/03ftdbFr7G+4G2cv6+AVYFER3U1Gz9ixwr9/ktZK3MDXGgYPaA0
	 ET9o/+/Bn3BFSngxZcgzDbwgLLa70vy/kYWR/eeZ46MAsYQpkJB9f508FGtirnHOF5
	 v9q5Kjoec1ifNglMW1SPi99jFqIzpvdYUWb+DF84Mu9/JgHeZ7Ts6y44DXi+09tNpZ
	 NtGeI06nk+Cyg==
Date: Sun, 03 Dec 2023 11:02:57 -0800
Subject: [PATCH 1/9] xfs: don't set XFS_TRANS_HAS_INTENT_DONE when there's no
 ATTRD log item
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <170162990183.3037772.16569536668272771929.stgit@frogsfrogsfrogs>
In-Reply-To: <170162990150.3037772.1562521806690622168.stgit@frogsfrogsfrogs>
References: <170162990150.3037772.1562521806690622168.stgit@frogsfrogsfrogs>
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

XFS_TRANS_HAS_INTENT_DONE is a flag to the CIL that we've added a log
intent done item to the transaction.  This enables an optimization
wherein we avoid writing out log intent and log intent done items if
they would have ended up in the same checkpoint.  This reduces writes to
the ondisk log and speeds up recovery as a result.

However, callers can use the defer ops machinery to modify xattrs
without using the log items.  In this situation, there won't be an
intent done item, so we do not need to set the flag.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 5f7d8e8d87dc..1b7f1313f51e 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -347,13 +347,15 @@ xfs_xattri_finish_update(
 	 * 1.) releases the ATTRI and frees the ATTRD
 	 * 2.) shuts down the filesystem
 	 */
-	args->trans->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
+	args->trans->t_flags |= XFS_TRANS_DIRTY;
 
 	/*
 	 * attr intent/done items are null when logged attributes are disabled
 	 */
-	if (attrdp)
+	if (attrdp) {
+		args->trans->t_flags |= XFS_TRANS_HAS_INTENT_DONE;
 		set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
+	}
 
 	return error;
 }

