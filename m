Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EACDDAB
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ugy1ZNux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC08EC433C7;
	Sun, 31 Dec 2023 23:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065938;
	bh=vMLZ+LkznQWz9EJZ/wEbgjkVPEuFX0uUH5rKt9wLLcE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ugy1ZNux3EccN9bjCJ+S9qw9a+HqCIqIPdf6m3bgxHhPjO6ou3FR8AaNAq5yVmJ02
	 a30o+5rp9nUhYn7vQqE8zPejqCVV00kiB70llJ8NDUwSy1Zz7Nx1ZizyyzpB2jsoaF
	 ExunBP0wIZ9MYvPM2ulWBP9YCHSF7f0kNFwYBr34Z03l3xQBjQ32OP02FP3w45LQBn
	 v2JvzV/sigba7qgz854UbSFYzb2c/qCiA19JeMHvL/clKhtf5hXrPmCMApRin1TQdg
	 XXlc0IXsVVylc/oM6txajNRassn0fHTWiS81kj8cTVKIXn25ueRtDaCWSSYXEMxuXF
	 IsVALAf0SpQww==
Date: Sun, 31 Dec 2023 15:38:58 -0800
Subject: [PATCH 36/58] xfs_repair: don't zero the incore secondary super when
 zeroing
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010427.1809361.9818118347695597896.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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

If secondary_sb_whack detects nonzero bytes beyond the end of the ondisk
superblock, it will try to zero the end of the ondisk buffer as well as
the incore superblock prior to scan_ag using that incore super to
rewrite the ondisk super.

However, the metadata directory feature adds a sb_metadirino field to
the incore super.  On disk, this is stored in the same slot as
sb_rbmino, but we wanted to cache both inumbers incore to minimize the
churn.  Therefore, it is now only safe to zero the "end" of an xfs_dsb
buffer, and never an xfs_sb object.

Most of the XFS codebase moved off that second behavior long ago, with
the exception of this one part of repair.  The zeroing probably ought to
be turned into explicit logic to zero fields that weren't defined with
the featureset encoded in the primary superblock, but for now we'll
resort to always resetting the values from the xfs_mount's xfs_sb.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/agheader.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/repair/agheader.c b/repair/agheader.c
index 3930a0ac091..af88802ffdf 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -405,6 +405,13 @@ secondary_sb_whack(
 				mp->m_sb.sb_sectsize - size);
 			/* Preserve meta_uuid so we don't fail uuid checks */
 			memcpy(&sb->sb_meta_uuid, &tmpuuid, sizeof(uuid_t));
+
+			/*
+			 * Preserve the parts of the incore super that extend
+			 * beyond the part that's supposed to match the ondisk
+			 * super byte for byte.
+			 */
+			sb->sb_metadirino = mp->m_sb.sb_metadirino;
 		} else
 			do_warn(
 	_("would zero unused portion of %s superblock (AG #%u)\n"),

