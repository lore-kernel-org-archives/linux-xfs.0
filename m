Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59364296BD4;
	Mon, 13 Oct 2025 23:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760398386; cv=none; b=e4rtNIYi1K9mXSMaFIsfFMF/PVsgMAKP5P1jg1ERmiNJYabOduox9NALESZujWtDflBpjAWTs1R/G6ey0KDZcMQM3YtcnfFqLzvq+wdgyd9d6cO4/PGCNRD1E5pJfIZ/VF0tLTau0ZMHOhBVBs37u85yPJtX35uvLVAy8Vq1J7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760398386; c=relaxed/simple;
	bh=DcbZzNWAhYoBauHNBNG16BoCwbrXg/Z/+2Sp+H456ic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bvfc3EB/Bibn24G54IzLaxA1a1+whr8X+0tvAabGJrs+82AGJ1mVRSRCoAFlIOG7ojbg9xty8YV//B9m+/43qImNe/yOTj/CvR05/YVIxD1EbKM1HEOBp7RD6ZyGTunV6cZGsOFZ9WWyqgJujYqLPximMmaTnOdKx6cpuMDXuo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HUYiEtpw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HUYiEtpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81CBC4CEE7;
	Mon, 13 Oct 2025 23:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760398385;
	bh=DcbZzNWAhYoBauHNBNG16BoCwbrXg/Z/+2Sp+H456ic=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HUYiEtpwwSA8R000Ho10FCMCE+p0Gr0v+OkLwf1X7L5ATCjUZSD2K/SLnvCAHjSpC
	 WoFDmi4WVLOOobYr+ikPqdq1zwFHX9JVudcLy4TaBIfaPsdN6zcHlbKdzNs4Rv2UBI
	 prdMVOr+/C6GHscJGhm2ypNc1Ahh/YHaDhgwZSmqj0nDVgi2X5FpIcHQpTtGWBCE38
	 BLF6fXKUYQ8adw3dF6lAEsPOIRDXz6uw9xuowWcl8QicMrY99/8D2QFzUSdoy/3qxI
	 vvSU44n/szW5OAOqhA6yYwFNWoDLvB2eN6v3Kc4ZZaKZZllZ4gYcdfY2d5a8CSvxaN
	 kG4TQGGFPkkQQ==
Date: Mon, 13 Oct 2025 16:33:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, Pavel Reichl <preichl@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Thorsten Leemhuis <linux@leemhuis.info>
Subject: [PATCH 2/2] xfs: always warn about deprecated mount options
Message-ID: <20251013233305.GS6188@frogsfrogsfrogs>
References: <20251013233229.GR6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013233229.GR6188@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

The deprecation of the 'attr2' mount option in 6.18 wasn't entirely
successful because nobody noticed that the kernel never printed a
warning about attr2 being set in fstab if the only xfs filesystem is the
root fs; the initramfs mounts the root fs with no mount options; and the
init scripts only conveyed the fstab options by remounting the root fs.

Fix this by making it complain all the time.

Cc: <stable@vger.kernel.org> # v5.13
Fixes: 92cf7d36384b99 ("xfs: Skip repetitive warnings about mount options")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_super.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e1df41991fccc3..3517106159327b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1385,12 +1385,23 @@ xfs_fs_warn_deprecated(
 	uint64_t		flag,
 	bool			value)
 {
-	/* Don't print the warning if reconfiguring and current mount point
-	 * already had the flag set
+	/*
+	 * Always warn about someone passing in a deprecated mount option.
+	 * Previously we wouldn't print the warning if we were reconfiguring
+	 * and current mount point already had the flag set, but that was not
+	 * the right thing to do.
+	 *
+	 * Many distributions mount the root filesystem with no options in the
+	 * initramfs and rely on mount -a to remount the root fs with the
+	 * options in fstab.  However, the old behavior meant that there would
+	 * never be a warning about deprecated mount options for the root fs in
+	 * /etc/fstab.  On a single-fs system, that means no warning at all.
+	 *
+	 * Compounding this problem are distribution scripts that copy
+	 * /proc/mounts to fstab, which means that we can't remove mount
+	 * options unless we're 100% sure they have only ever been advertised
+	 * in /proc/mounts in response to explicitly provided mount options.
 	 */
-	if ((fc->purpose & FS_CONTEXT_FOR_RECONFIGURE) &&
-            !!(XFS_M(fc->root->d_sb)->m_features & flag) == value)
-		return;
 	xfs_warn(fc->s_fs_info, "%s mount option is deprecated.", param->key);
 }
 
