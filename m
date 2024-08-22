Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB3C187345
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 23:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371142; cv=none; b=dvRldN5M5QWg0F1FQgoMmNl5q64SiQJHld917JgY2abwwhO0R/YKElC+W1DoNNBirxVZibGCuBqgd+N7n8ABO2Z1mj/tB+VJpTHu+eWbfu523sacg/j4lV04Z+7PUBumwHrK/MzHSMsGZYT6h1mXUp/MRoSpaJZTDOXhEVMLwJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371142; c=relaxed/simple;
	bh=+BQri2zCpb77r8VeZq+Qu9Ub0vgDI8VIZ4sZd0FKb0A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G0AemMPjbC+bpO8d6wX4HZ5omtCvNNdwe355MdMIBn5KCO8tIYAYTbggWnpUD7VF6hGqdSb02E90ybr1pNHooWYZ9cinSTrmcZ+lH4vEhttb7//14ycMFOJ5CreQuRkAvwS4zXnQcfkY9OAgn8MlKqTy6LWlt4d3pr9iWAZ9AOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JSBiJ9MB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JSBiJ9MB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC65C4AF0B;
	Thu, 22 Aug 2024 23:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371142;
	bh=+BQri2zCpb77r8VeZq+Qu9Ub0vgDI8VIZ4sZd0FKb0A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JSBiJ9MB+753SOdXPc4sHZwYAe4BdIPOISyvD9sT+utmSIyFZGT2kCYaLWWyobAPi
	 9MzXEm68LQT/WCpJraHmR2gR2bG9uChCj5Vo08inoCKXaOXEO6G+MOkmzv4G4+x9i4
	 WMw/rifMvvz2EWHjHI/u54vQZ7SpWDi1Zp8swzCXzTRQNaSGuHkQTOrT1QDvBOU+3P
	 IjyO/9BcKkaGFVfOfrqbE3KEJi/YONAliu6a5sekYJ9CvXNp37qxjOdNVdjomBxJX8
	 T9MW/2VpjMsVWx9sKmdYJT9ofQztvHNjhEc1ssCMkCSYdNR42tqK9hX4joItMmjlHb
	 bO0lghlfpFp1A==
Date: Thu, 22 Aug 2024 16:59:01 -0700
Subject: [PATCH 1/9] xfs: fix di_onlink checking for V1/V2 inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: kjell.m.randa@gmail.com, Christoph Hellwig <hch@lst.de>, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <172437083768.56860.15670987236466728044.stgit@frogsfrogsfrogs>
In-Reply-To: <172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs>
References: <172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs>
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

"KjellR" complained on IRC that an old V4 filesystem suddenly stopped
mounting after upgrading from 6.9.11 to 6.10.3, with the following splat
when trying to read the rt bitmap inode:

00000000: 49 4e 80 00 01 02 00 01 00 00 00 00 00 00 00 00  IN..............
00000010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000020: 00 00 00 00 00 00 00 00 43 d2 a9 da 21 0f d6 30  ........C...!..0
00000030: 43 d2 a9 da 21 0f d6 30 00 00 00 00 00 00 00 00  C...!..0........
00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000050: 00 00 00 02 00 00 00 00 00 00 00 04 00 00 00 00  ................
00000060: ff ff ff ff 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

As Dave Chinner points out, this is a V1 inode with both di_onlink and
di_nlink set to 1 and di_flushiter == 0.  In other words, this inode was
formatted this way by mkfs and hasn't been touched since then.

Back in the old days of xfsprogs 3.2.3, I observed that libxfs_ialloc
would set di_nlink, but if the filesystem didn't have NLINK, it would
then set di_version = 1.  libxfs_iflush_int later sees the V1 inode and
copies the value of di_nlink to di_onlink without zeroing di_onlink.

Eventually this filesystem must have been upgraded to support NLINK
because 6.10 doesn't support !NLINK filesystems, which is how we tripped
over this old behavior.  The filesystem doesn't have a realtime section,
so that's why the rtbitmap inode has never been touched.

Fix this by removing the di_onlink/di_nlink checking for all V1/V2
inodes because this is a muddy mess.  The V3 inode handling code has
always supported NLINK and written di_onlink==0 so keep that check.
The removal of the V1 inode handling code when we dropped support for
!NLINK obscured this old behavior.

Reported-by: kjell.m.randa@gmail.com
Fixes: 40cb8613d612 ("xfs: check unused nlink fields in the ondisk inode")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 513b50da6215f..79babeac9d754 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -514,12 +514,18 @@ xfs_dinode_verify(
 			return __this_address;
 	}
 
-	if (dip->di_version > 1) {
+	/*
+	 * Historical note: xfsprogs in the 3.2 era set up its incore inodes to
+	 * have di_nlink track the link count, even if the actual filesystem
+	 * only supported V1 inodes (i.e. di_onlink).  When writing out the
+	 * ondisk inode, it would set both the ondisk di_nlink and di_onlink to
+	 * the the incore di_nlink value, which is why we cannot check for
+	 * di_nlink==0 on a V1 inode.  V2/3 inodes would get written out with
+	 * di_onlink==0, so we can check that.
+	 */
+	if (dip->di_version >= 2) {
 		if (dip->di_onlink)
 			return __this_address;
-	} else {
-		if (dip->di_nlink)
-			return __this_address;
 	}
 
 	/* don't allow invalid i_size */

