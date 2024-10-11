Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F03D4A06
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608048; cv=none; b=hYHg34WF1tKdJvJEB9vXxc+G9IEH/IzXuAykukRXR+Rdjy9JmkT4B3r/fk/s3L11vr5SnrKU3G5h4YAfOCnKWiDvgfD3mGwmIqfXusegecwNvs4sfcvUdVFgtuvsH+1QtuUTrSE42TuxVRyAF3CY48uxPrBEFWRcr7y1HWpyX74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608048; c=relaxed/simple;
	bh=lbURMy/FbWkRPt8jnTgH29kZ63UJQ5lcPDVQ7b9f3Rc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YDF2MW5hrkUCJ8ZWkNbOc2xbtNS5kF2bVHqRoHPr3qXiFYyTDEApu92UXrFeWtT5yMV8iETS9kj2Gu0nEhhb+UKzqn+V8tYPy7QZ+ew7S8CUAxMXnQy9JAimiGohcnpUw5zvr75rau5zyHm3u81qoCyqpcFb6mXU+T0+PTdK00o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i6vrMA9y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i6vrMA9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1231AC4CEC5;
	Fri, 11 Oct 2024 00:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608048;
	bh=lbURMy/FbWkRPt8jnTgH29kZ63UJQ5lcPDVQ7b9f3Rc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=i6vrMA9yCg2E6YRNsUvxZm+2X0abK1r2dYhYwH0kvJN62VwMyp5Dvp9PSWQNzphoa
	 8KWPFVE8C8Ff3qaotNQzDniSEt1YbXnGmym/QL76gtaLm63aIGimBYxVZggF66J8OX
	 pBF5lQTKIqrJ7oDX5ya09T5bPLypZFQtRBeZ2s4ugFcEkKeAaFBxeMpRGAr8VmsIE3
	 9bRGv4qO1WIGhTIVdL/geE+S+Q7qi9WS40g8f+UTC5bcjSqMEV/FxAm7h9PBQOktt2
	 5WvxLk7Qtn3/lgBzXFC/Jmj8zOjTvmw/gnTOojyTJGZtluJYtw5tDMgQn4bPDDs9SP
	 Squ6cCTDCEKJA==
Date: Thu, 10 Oct 2024 17:54:07 -0700
Subject: [PATCH 22/28] xfs: fix di_metatype field of inodes that won't load
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860642396.4176876.17543625218590151849.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
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

Make sure that the di_metatype field is at least set plausibly so that
later scrubbers could set the real type.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/inode.c        |   10 +++++++---
 fs/xfs/scrub/inode_repair.c |    6 +++++-
 2 files changed, 12 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 45222552a51ccb..07987a6569c43a 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -443,9 +443,13 @@ xchk_dinode(
 		break;
 	case 2:
 	case 3:
-		if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)) &&
-		    dip->di_onlink != 0)
-			xchk_ino_set_corrupt(sc, ino);
+		if (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)) {
+			if (be16_to_cpu(dip->di_metatype) >= XFS_METAFILE_MAX)
+				xchk_ino_set_corrupt(sc, ino);
+		} else {
+			if (dip->di_onlink != 0)
+				xchk_ino_set_corrupt(sc, ino);
+		}
 
 		if (dip->di_mode == 0 && sc->ip)
 			xchk_ino_set_corrupt(sc, ino);
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 7700fcd8170448..b0808b54a51285 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -526,8 +526,12 @@ xrep_dinode_nlinks(
 		return;
 	}
 
-	if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)))
+	if (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)) {
+		if (be16_to_cpu(dip->di_metatype) >= XFS_METAFILE_MAX)
+			dip->di_metatype = cpu_to_be16(XFS_METAFILE_UNKNOWN);
+	} else {
 		dip->di_onlink = 0;
+	}
 }
 
 /* Fix any conflicting flags that the verifiers complain about. */

