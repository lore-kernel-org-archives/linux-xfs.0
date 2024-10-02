Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A161C1C2E
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832255; cv=none; b=aS2DpGNFVuNDwHUbMF+outsUHR7RKa4BBJ6kGCdkhmcbCdVbLTvQkFRCeZZeDiycH4OKi2lxqgBnQezXf0+80zB/KphGcajjNqdmoSjpaW2TlgSoudOO8mqlT8Bw21d13GOwQH1Qo42evvUdueFeFnaYcT8OBvitVZXRsUc+ckc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832255; c=relaxed/simple;
	bh=bj246EJFF1yqsRBtqytpnfNmK54uBC1lVEcPZOVAw5k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YAZjcOeDTz2vn45WCLtNTTYVIsBxBb88Lu1FT5N7/xeCAT0oIMCX4Bot2W1ZlrKNP55wIeNYbcEjRFz2Y9T4IRaXZASdWl72PUHI7tfznTqVoifzke9Nu7IWDQoRx02AxqPGILvuD3hsEQmJmtXb1KCiBXi+ou3KzWuQ9D9nGCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bG8OzOBM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bG8OzOBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25857C4CEC6;
	Wed,  2 Oct 2024 01:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832254;
	bh=bj246EJFF1yqsRBtqytpnfNmK54uBC1lVEcPZOVAw5k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bG8OzOBMbE9Z+LC2Y8EU0HqZyKCdGe/rWh2ML0GmR963AvtBf1iRfV32MNzqJFbin
	 vCG2G9EPd3amAcXQI76rqWSZZYPF7+/Z9aOG53nHnZXJVA3U+NiLcFcceR2Iuz7Nwn
	 YIiPOnJNf0Xr5yxsPgMXfkNU3ObvEV4Iu4bAZoH4Q94jREQ+XKfgcrn4/lQTzOcvcD
	 TJlmiEvmo2Hm5RD0jj5HxUPsx5cr+O2US3fyiyxNChVcA3Px4WFnARqH8yVUDkgAWj
	 zOCTFOjOd8LTbHGDilnQehqSAuAhAMkR0lulCt4eOWAwdgqWjFJqCtzlehxTn5Jwjd
	 FP8C9xaU4OcfQ==
Date: Tue, 01 Oct 2024 18:24:13 -0700
Subject: [PATCH 63/64] xfs: fix di_onlink checking for V1/V2 inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: kjell.m.randa@gmail.com, Christoph Hellwig <hch@lst.de>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <172783102729.4036371.17966851447524960790.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: e21fea4ac3cf12eba1921fbbf7764bf69c6d4b2c

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
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_inode_buf.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 856659cc3..5970ee705 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -511,12 +511,18 @@ xfs_dinode_verify(
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

