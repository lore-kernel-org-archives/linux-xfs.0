Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FCE2116E8
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 22:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738622425; cv=none; b=qvOVAHRkHzEs3A3qqetww2j3uRiS994sKuzKbRGF39kgfSCqK9P7N98ejfIGz0lCZWlF20cH/SfvFv4aFpfTIovBbBKMap+sTanP0/0dd0lxF403uo47gdpxkcAFNt3W5O2OBVUPft0JHegd+Z/vWU4trKU3vEj/m419dNB/hnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738622425; c=relaxed/simple;
	bh=cCWqeusjE2sVCW2yHkWOxRVFjv73AbPpY32W1CxgDJc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cQOjtslKsD5C8S/Uylh7qY7DzeEa3G2mbxriGxI++cpWFY1PgYAWOuLRiPHC96tJMIt/fJiqGRMPctWRf29X8YDVRNfXGd4Y0AgCQgXTo2stx9ZqON8Lrel0vpIAaJSX2Vx7/pfgGToFg8UyWx23KkqM/oVl6LiuG3gOU8Xc3CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hldpCeOF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hldpCeOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B200C4CED2;
	Mon,  3 Feb 2025 22:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738622424;
	bh=cCWqeusjE2sVCW2yHkWOxRVFjv73AbPpY32W1CxgDJc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hldpCeOFYicOHWXc/7N0BxOCJp15c1Y6okEX1DHl1fUODOvfluMmjC112+4RwCMHC
	 F66nVV5Cgjo/KOQTWlC1Iu7ovgVjZ3JVO2cntYD0Zxpgg/MJITGFzsfcW9QexTw2+3
	 7MjlmcyzpKIKtaOT4s1UL5u0TAJcOIZo70LlmaGuxloApHBjU1kHNdqrmPEfrBm7kj
	 0JVvqL+Y3C9ZUbwCFqxM13+0yexzTxf4vPDuUxl1c2qtkawBr4FigpR2hPcTGOoxOP
	 eJhEato/sOOSaCStYKUQdVhzDfz/7hOveMvI01/Fyv1okTwvvsxM7HZjOgzFxVyEF1
	 3GxIei2mCg4CQ==
Date: Mon, 03 Feb 2025 14:40:24 -0800
Subject: [PATCH 1/3] mkfs: fix file size setting when interpreting a protofile
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173862239048.2460098.9569795439422233357.stgit@frogsfrogsfrogs>
In-Reply-To: <173862239029.2460098.9677559939449638172.stgit@frogsfrogsfrogs>
References: <173862239029.2460098.9677559939449638172.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we're copying a regular file into the filesystem, we should set the
size of the new file to the size indicated by the stat data, not the
highest offset written, because we now use SEEK_DATA/HOLE to ignore
sparse regions.

Fixes: 73fb78e5ee8940 ("mkfs: support copying in large or sparse files")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/proto.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 4e9e28d4eea1ca..6dd3a2005b15b3 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -313,7 +313,6 @@ writefile(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct stat		statbuf;
 	off_t			data_pos;
-	off_t			eof = 0;
 	int			error;
 
 	/* do not try to read from non-regular files */
@@ -340,8 +339,6 @@ writefile(
 		}
 
 		writefile_range(ip, fname, fd, data_pos, hole_pos - data_pos);
-		eof = hole_pos;
-
 		data_pos = lseek(fd, hole_pos, SEEK_DATA);
 	}
 	if (data_pos < 0 && errno != ENXIO)
@@ -354,7 +351,7 @@ writefile(
 		fail(_("error creating isize transaction"), error);
 
 	libxfs_trans_ijoin(tp, ip, 0);
-	ip->i_disk_size = eof;
+	ip->i_disk_size = statbuf.st_size;
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = -libxfs_trans_commit(tp);
 	if (error)

