Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B06EEB3;
	Tue, 25 Aug 2026 05:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787636081; cv=none; b=NvfoL1+Mzt5jzowO5u5FPJs6WMl+/niwFemEZvA3YCycoA1X4N7x1AHyqcq27qcT0LImJC9pv4Ii9WoY0AD6lmGjxwuvveWMgipy9XBJdktL+ZSv0w+pDgeuqPhA1AJH1oVd1DBzlYNb0/XrbhOj+Mz6HB30R+rhrXIgqYM0iqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787636081; c=relaxed/simple;
	bh=bH7QDBlZrXj8Ox4kfKAIb1NlcEypsY2CDA8zjWGRJzE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qJPca38estYdluaNtMoqv1cE9bctYDq3Yf3p3l/raKVK5mRR3lFWlXvOVwK/sKFt9vb+kdZq9nm3U84caQfY7h5MjTJ9cdWd7AfyGsT05IzrSjUlerGzSgC/V1P2QCau7ScIPZt8I3jGIGISqJ7rQy+W5HMCt2xuL+4lCBRgjjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zag9B2+O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zag9B2+O"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B87B31F000E9;
	Tue, 25 Aug 2026 05:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787636079;
	bh=MDOJ6HNRE1EFxggpR+CxcpiI6zBCAX1R+bRc8VEffjI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Zag9B2+O4JULssxGDmkRmfghSA6TFjRjWP6694lkrVbBw901RCdtcsKqnPzNVDLa2
	 0eG2many+TbrfXiSV9mfz22idKLVcc+uJr1DHVd6gzcahiXxxs+RB7FsXKLv8IDhL0
	 H2vhhiaTJbXWAwo+VHxiVtN32piR+WIIrjGhEVi2BjGe87ibLzq0OFyiD6/Zu5ueL2
	 qb+X48cMAy9GKZNv1mSAnpzIf1Ghzcn9e8JiuMzAF62eMoIhDes/oOHakXXCi+yCUq
	 +udhIdlfWpovTtdJ95XPghbrxC4ONXDx7NFAVISzf5WutwpOKJex441fFo4mB290GZ
	 bH+3eQB2IH7fg==
Date: Mon, 24 Aug 2026 22:34:39 -0700
Subject: [PATCH 1/6] xfs: don't spin forever on zero-length dirents when
 salvaging them
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178760940700.944084.17154290942223549187.stgit@frogsfrogsfrogs>
In-Reply-To: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs>
References: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that xrep_dir_recover_data can spin forever if it
encounters an unused dirent that claims to have length zero.  Fix that,
and prevent the same thing from happening with a zero-length entry.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: b1991ee3e7cf85 ("xfs: online repair of directories")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/dir_repair.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 1c088cfba10ea9..0c1224d05d579a 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -484,18 +484,24 @@ xrep_dir_recover_data(
 	while (offset < end) {
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
 		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
+		unsigned int			advance;
 
 		if (xchk_should_terminate(rd->sc, &error))
 			return error;
 
 		/* Skip unused entries. */
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
+			if (!dup->length)
+				break;
 			offset += be16_to_cpu(dup->length);
 			continue;
 		}
 
 		/* Don't walk off the end of the block. */
-		offset += xfs_dir2_data_entsize(rd->sc->mp, dep->namelen);
+		advance = xfs_dir2_data_entsize(rd->sc->mp, dep->namelen);
+		if (!advance)
+			break;
+		offset += advance;
 		if (offset > end)
 			break;
 

