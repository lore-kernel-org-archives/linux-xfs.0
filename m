Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DA286334
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 01:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782781407; cv=none; b=CZSmh+O0pfD+/R5JlMNGt12Stm5cHDPFUh3loZppv6FhXnKNBY3WtZs98NFF+sZui2GzrmgS508gzRl75GvActgNDcmIWedCMtyuqveCMwPl1sLH8Lof0pXeBJgwPjMxFIHfaUxzyfUrvfbtsUx6AnMDXTP7UFT80zEb344shxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782781407; c=relaxed/simple;
	bh=RY46PkTo2Dbj/hEOJBA4FwLO7TMq9Xoag+8XfIoFevw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bp4vORCz2uiKK7nTFP/o+k24Zcs2ap10+u/CxKTj2bMtDBLl0ksU+vTVMlI9PIbdzpoB9UXffO86UzINYkCD++omtIFCL15SgybDcE45Dv5FQqIpgFcl/C4sF+oZnLLsiTGDgwzHmdXYHe7PzXWuhIW/96AStkDAelXt+bAXXis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bzkK4+rv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bzkK4+rv"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8FD2B1F000E9;
	Tue, 30 Jun 2026 01:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782781406;
	bh=nNO6hU7z2dwAbWTpIeFheJKocGipZRH2bUwSzMpRXt4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=bzkK4+rvQ9qzJeZyVCs73h1ztFHo4TA/ApZGrPZkyZ8mGFqEE61HcagZ8rv5y5Rg2
	 MJzyShawGHT8wRli4vTow0UlTPbZRuzzhs/MscljpDT8pwUSw4pso6JqC+aZeZbCqe
	 lTjEwHtg7iNT4vDkRpw/OHn6R5qb8zgPyXwZ0fTGEaZicuvz7hea5CfSY2jW0F7G44
	 SXwWqLplKSqPMXOcGgxvw4eGjI/wth5QgBsr1dIPqaZ+7Gi/dn+ew2dJxQ5a6KACA1
	 4UV+0M5g2EntWC6AeNyHXl2xhj0AcRK+W5qJbkZUkySP/KDuvi/MhKQfntmfmLvo7K
	 DO6vqA34ixqTA==
Date: Mon, 29 Jun 2026 18:03:26 -0700
Subject: [PATCH 3/6] mkfs: fix symlink target length check in
 create_nondir_inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178278129861.858323.4909937638621779858.stgit@frogsfrogsfrogs>
In-Reply-To: <178278129779.858323.3184159030321473775.stgit@frogsfrogsfrogs>
References: <178278129779.858323.3184159030321473775.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex complains about the way this function tries to detect symlink
targets that are so long that the new filesystem cannot handle them.
Specifically, it complains about the confusion between
XFS_SYMLINK_MAXLEN and PATH_MAX.

To be clear, XFS cannot handle targets longer than XFS_SYMLINK_MAXLEN
bytes.  PATH_MAX is irrelevant here.  The manpage for readlink(3) says
that it returns the number of bytes copied into the buffer and does not
say that it null-terminates the buffer.  Therefore, the only way to
detect the overflow condition is to declare a buffer larger than
XFS_SYMLINK_MAXLEN and see if readink returns a value greater than
XFS_SYMLINK_MAXLEN.

Cc: <linux-xfs@vger.kernel.org> # v6.17.0
Fixes: 8a4ea72724930c ("proto: add ability to populate a filesystem from a directory")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/proto.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index e167cba1d8d3ec..e258424ae4140a 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -1542,7 +1542,7 @@ create_nondir_inode(
 	char			*src_fname)
 {
 
-	char			link_target[XFS_SYMLINK_MAXLEN];
+	char			link_target[XFS_SYMLINK_MAXLEN + 1];
 	int			error;
 	ssize_t			link_len = 0;
 	struct xfs_inode	*ip;
@@ -1563,10 +1563,10 @@ create_nondir_inode(
 	 * We need to read out our link target and act accordingly.
 	 */
 	if (xname.type == XFS_DIR3_FT_SYMLINK) {
-		link_len = readlink(src_fname, link_target, XFS_SYMLINK_MAXLEN);
+		link_len = readlink(src_fname, link_target, sizeof(link_target));
 		if (link_len < 0)
 			fail(_("could not resolve symlink"), errno);
-		if (link_len >= PATH_MAX)
+		if (link_len > XFS_SYMLINK_MAXLEN)
 			fail(_("symlink target too long"), ENAMETOOLONG);
 		tp = getres(mp, XFS_B_TO_FSB(mp, link_len));
 	} else {

