Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D329A38B;
	Sat,  7 Dec 2024 00:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733531467; cv=none; b=lz6Snay2Bjc9jQIgLd0ZwWkRwA9+z+U0dbV0bcODHp559qVd0Bhz3Riom8d8oRXugPmuiqbwmaye8/cBs/4T3U9RyLyYWgtows7HXoNGWWdER6Y5BnCdrpqyUkRwg1tU/V1QhJ6v9Co4e7K1byOngjTxOIfkKtTq17EAk0Z36mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733531467; c=relaxed/simple;
	bh=/xK9+B+Rp1/tA1ujHR7KeRByCf2uW4qAqYDe5JrrGv0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NofYqH1Fx1x8I2k8S3H7qNc0VnqHt8rxkjKgAFtml5/uN0zYNfSNUJmxJg+xB8bFgRWZRD0QXASCTb9LEpCh8fTJ8I6L7W8HOc3n1SznLMsg3JwIKA2lY46TPXfMPVIgprtB6LDx2U17pfDur19tTLn0HULnyLJuihSSNoahkMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ErZPZU16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ErZPZU16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EBEC4CED1;
	Sat,  7 Dec 2024 00:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733531467;
	bh=/xK9+B+Rp1/tA1ujHR7KeRByCf2uW4qAqYDe5JrrGv0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ErZPZU16QOfhSNxR7rwBAtJ5nPog3jenYliFR2tuJUUgysyoFo+WEVv/sKPyGNfcO
	 Z3eGP14wUzjEqzGJ3uSdK8jcMXE4Ma4Gi1gpIHEZ37ELlxKp9i5fDgBtxoTA5VV19I
	 7RtoA2oQ7s0195R7QhYPM6a9bzNf5y/w2NOlblB8YGJJhnVmZzv6xBfKad+Aho5uKC
	 Ph42d2vhw/jkhH++v0aKQRS5k547tTDO+h06g9Yz8L9K7kDh5Ee6OF0RQsvPFY7JSu
	 kF9GEi36u49pngCY2uYOdYzT/5x9ULppdtLlOpAplMx7GV2uKM4q9SvVAmnsVJznv/
	 NDfVFDSltnkdA==
Date: Fri, 06 Dec 2024 16:31:06 -0800
Subject: [PATCH 1/6] xfs: don't move nondir/nonreg temporary repair files to
 the metadir namespace
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173353139318.192136.14125386849342549320.stgit@frogsfrogsfrogs>
In-Reply-To: <173353139288.192136.15243674953215007178.stgit@frogsfrogsfrogs>
References: <173353139288.192136.15243674953215007178.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/scrub/tempfile.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index dc3802c7f678ce..82ecbb654fbb39 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -204,6 +204,9 @@ xrep_tempfile_adjust_directory_tree(
 
 	if (!sc->ip || !xfs_is_metadir_inode(sc->ip))
 		return 0;
+	if (!S_ISDIR(VFS_I(sc->tempip)->i_mode) &&
+	    !S_ISREG(VFS_I(sc->tempip)->i_mode))
+		return 0;
 
 	xfs_ilock(sc->tempip, XFS_IOLOCK_EXCL);
 	sc->temp_ilock_flags |= XFS_IOLOCK_EXCL;

