Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608461845
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z924TEiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6A8C433C9;
	Thu,  7 Dec 2023 02:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701915926;
	bh=jSVpRuFJXs9D6Ftf6LWg4Oao8BgXpRpaUSg544nFAoA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z924TEiJPfQTzF+CzF0ZqcI4tIcBlxzsb7gGqQKBxP0UKeSm0UTRMY66zI4zzjP1z
	 61vbLlL8iTlrVW7lzQ3NzMdwmYcdRJodarJmauf0098zhpAWbULo4ZLlcQtsMzDge/
	 5GXDtdZZtbf29A01JG2wt5TL68oTysGgUGoAwUZvlke8bRyfAeufoF/pUpbjqVOwyy
	 AV7jb8N+t4hOmfWOpI0mAKJD8lErPN7tNSFi1EMmeD11KhHtJQrFTgsuQnC+QLYAtF
	 vdV6+VGPgrokUWUg60rrSgpFh4k8v3anMDA7QC1wlprYKGcojLY9HpC+8Wq/x5kZWV
	 oZBsEz5W0iaNQ==
Date: Wed, 06 Dec 2023 18:25:25 -0800
Subject: [PATCH 1/9] xfs: don't set XFS_TRANS_HAS_INTENT_DONE when there's no
 ATTRD log item
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, hch@lst.de, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191562403.1133395.16047858858606549430.stgit@frogsfrogsfrogs>
In-Reply-To: <170191562370.1133395.5436656395520338293.stgit@frogsfrogsfrogs>
References: <170191562370.1133395.5436656395520338293.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr_item.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index bd23c9594a0d..d19a385f9289 100644
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

