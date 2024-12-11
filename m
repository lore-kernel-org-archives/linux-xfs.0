Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28DA1DDC29;
	Wed, 11 Dec 2024 20:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733947664; cv=none; b=CThBEuokXKSxQqzf1MnB/1NFilDXQCUjBTET0y8PXFXJpGSSK4dRdxRuRlAcqzF3JeGBRGOBFafIzEFCxkn9Z5INzaClfZJrBv/41pV5f9uQ8t/t24I9ldX3/GM0wMOvZHvMxk1xie6awZ/h+s5ywzRvJKEkY5MH8lbiZdHwsKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733947664; c=relaxed/simple;
	bh=VEJ7nM2+TWjB8W7NXFVdcjyXRoYVWbKOdidDuBGcLxc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rW0UMO2Rh5egIfbe/jAtSuqfVnVhNsqy+8F9gxdHKb76dKvTYXfyaZCmqilBPK/4VYv6NMSS3ABSFbOJJO4bSFVxfHcVngskRVdcud8nydvBE/OWwI8iMrZZ+FI0paORUuLfUlv54WJyFoqCQZz8kD9f7yE1s7/gpK4UjYdFwig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CYAzxQYB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CYAzxQYB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E26C4CED2;
	Wed, 11 Dec 2024 20:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733947663;
	bh=VEJ7nM2+TWjB8W7NXFVdcjyXRoYVWbKOdidDuBGcLxc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CYAzxQYBTOuBdVpdnBjNuOnVSucS/QQa/143RL25ryqTr6y1cycRXcIl28WXOMjpO
	 liUsU9aEQHDfUVBS7v59uN6DAHfZ9gG1u/qaY55mN7ogoUjamdxdj/nEH7N3gRLtOX
	 JWaGWmq6UNIEPk+k8pmGk6cZPavoPpUC10nWWJdhRCjn765c/EBu/Chd3Qx9/EA6KH
	 hnoWcu6wDIXWFbw9fOGi9J1DOOqFMt1gjV0OuIHvOMfCnc2/uUvoKLs2CkMzvRQyPd
	 dRzXZFJdYVicU94Z+QesMcrbo3tKQ9cbgPCdDuwHr6ovIP5tJ87BBpVAzmUIl6YyuE
	 1U7cQTKLk5vOA==
Date: Wed, 11 Dec 2024 12:07:42 -0800
Subject: [PATCH 1/6] xfs: don't move nondir/nonreg temporary repair files to
 the metadir namespace
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173394758086.171676.16603584597088340131.stgit@frogsfrogsfrogs>
In-Reply-To: <173394758055.171676.7276594331259256376.stgit@frogsfrogsfrogs>
References: <173394758055.171676.7276594331259256376.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Only directories or regular files are allowed in the metadata directory
tree.  Don't move the repair tempfile to the metadir namespace if this
is not true; this will cause the inode verifiers to trip.

xrep_tempfile_adjust_directory_tree opportunistically moves sc->tempip
from the regular directory tree to the metadata directory tree if sc->ip
is part of the metadata directory tree.  However, the scrub setup
functions grab sc->ip and create sc->tempip before we actually get
around to checking if the file mode is the right type for the scrubber.

IOWs, you can invoke the symlink scrubber with the file handle of a
subdirectory in the metadir.  xrep_setup_symlink will create a temporary
symlink file, xrep_tempfile_adjust_directory_tree will foolishly try to
set the METADATA flag on the temp symlink, which trips the inode
verifier in the inode item precommit, which shuts down the filesystem
when expensive checks are turned on.  If they're /not/ turned on, then
xchk_symlink will return ENOENT when it sees that it's been passed a
symlink, but the invalid inode could still get flushed to disk.  We
don't want that.

Cc: <stable@vger.kernel.org> # v6.13-rc1
Fixes: 9dc31acb01a1c7 ("xfs: move repair temporary files to the metadata directory tree")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/tempfile.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index dc3802c7f678ce..2d7ca7e1bbca0f 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -184,11 +184,18 @@ xrep_tempfile_create(
 }
 
 /*
+ * Move sc->tempip from the regular directory tree to the metadata directory
+ * tree if sc->ip is part of the metadata directory tree and tempip has an
+ * eligible file mode.
+ *
  * Temporary files have to be created before we even know which inode we're
  * going to scrub, so we assume that they will be part of the regular directory
  * tree.  If it turns out that we're actually scrubbing a file from the
  * metadata directory tree, we have to subtract the temp file from the root
- * dquots and detach the dquots.
+ * dquots and detach the dquots prior to setting the METADATA iflag.  However,
+ * the scrub setup functions grab sc->ip and create sc->tempip before we
+ * actually get around to checking if the file mode is the right type for the
+ * scrubber.
  */
 int
 xrep_tempfile_adjust_directory_tree(
@@ -204,6 +211,9 @@ xrep_tempfile_adjust_directory_tree(
 
 	if (!sc->ip || !xfs_is_metadir_inode(sc->ip))
 		return 0;
+	if (!S_ISDIR(VFS_I(sc->tempip)->i_mode) &&
+	    !S_ISREG(VFS_I(sc->tempip)->i_mode))
+		return 0;
 
 	xfs_ilock(sc->tempip, XFS_IOLOCK_EXCL);
 	sc->temp_ilock_flags |= XFS_IOLOCK_EXCL;

