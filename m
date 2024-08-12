Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A96A199225
	for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2024 22:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502410; cv=none; b=PKCeqhNKbkncdi/Xd1Zz/Bd6J4Foyc/IyzttbvTSHX+mEvr0gy0NKYzMfLHQ1VOsu50fDkiwLrrn1drxBu6MN1cPkhDCaECpYJPLbaqXsLsOeBpKIZgnJ8I4NKQghlO2T6B+anL2VudggYAM1iZ7NVRjYdYE8/iEISi+oNGkIxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502410; c=relaxed/simple;
	bh=SlsEJdoS4lg4xYJMBKVGBBDab4wmxYydb3rLCsrfFIM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=h5Orf2fzBiLzp8pzCeBjBVaxFq/ckij1IcPJIupJ4vCCoYApglKee6yqMitCYV0NQu/ipYFS244uFsTpW7Dza4GQMyR8IOnUj18eOrZp/rdyAfLh17F/EUkpvJ1vDTYkVmsHcuD+dSDJYMVhOmbYJcv679jGgTKwyO6MBte6mNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OdJV863R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OdJV863R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76DBC4AF0D;
	Mon, 12 Aug 2024 22:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723502409;
	bh=SlsEJdoS4lg4xYJMBKVGBBDab4wmxYydb3rLCsrfFIM=;
	h=Date:From:To:Cc:Subject:From;
	b=OdJV863RdYeyzskK3Z+qVcy0cqDJYMcwEeqaFyRJuwDpgjcu9/UOKZwBD7aI0qouK
	 FkKEZ/XhMhV+L5c8NddwvxgFWGQNLE/Wes23yyLzvaSk/PElDnEztDkbtRecHJR5Kq
	 ipnVNEJXVxY9l5D0SCXPl4pKM0tlL6bB/1QJ6ziZteBwZz9g0jDZ5YwhP+2BR+vj/w
	 pXHzh9ieS06CjRbKCzvy/5wRld5L1sBcA4La0JBiQGG6ge+7cO7qjf7ntr4h/J5xxg
	 Eojp97OgE3jsCPzvv63lNr7G3wLLyy4M0elVWBDmJKQSV5cLghyeybO2h08rmNXafA
	 TdVSqiN+KVrXA==
Date: Mon, 12 Aug 2024 15:40:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: kjell.m.randa@gmail.com, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix di_onlink checking for V1/V2 inodes
Message-ID: <20240812224009.GD6051@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

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
---
 fs/xfs/libxfs/xfs_inode_buf.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 513b50da6215..79babeac9d75 100644
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
