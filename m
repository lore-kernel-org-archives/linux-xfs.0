Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C859641C72;
	Wed, 15 Oct 2025 05:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760504623; cv=none; b=kmQqoGmQF4L/WYmotIZga+ogAC5PdB5extvnCgNF//7xa++Eegtg9xS2qL9+cBEZ1iRconiLEVsXURtGunC3wM7tMaKV2Xc6eKOEjt7vSTJWSi+E24TWXdUzH24bgrDkXklNvQqDkKOc6lOMgaiet1bIyhKVRPp5cycncT7YDkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760504623; c=relaxed/simple;
	bh=LaBvlQFWYVbJb0fHt4n4VS8ox54z/DshykGzwHUE9Ds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mrp7Zh7r7RAGje08aFv8smWDNfvvr8/QjWJCfZwMjONB4Wvcwn5/Yi4hYeEmdLJULiepKxlLTAMftr7cSqrdZ0Al5z+OQ2HKJCySIdvV0uWEkHEbK8ds72aLshCdyXghP+KQIGP6jF03puZES0k+EQ0UDxvSdQvu5EWTFNM/Gg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sLasnQPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sLasnQPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38190C4CEF8;
	Wed, 15 Oct 2025 05:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760504623;
	bh=LaBvlQFWYVbJb0fHt4n4VS8ox54z/DshykGzwHUE9Ds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sLasnQPwfetLfPzTFeUO7B0qbLIRlir/3MtS2hh/+xHcdeM1uhRHvs8knbs1mvSpK
	 6WYXAW22GlxqMq5qaSNO3iOjhl9JaCQ9bOWGKLmmk5SoKsW2CXs1qzYJ8vVdeXAobc
	 71Eqs8qwBY/VkTov3XcLD0OPARwD2/RlLPhXCkOl9Ab84AwwJ659Xq2y0D7BcgvfhE
	 eaOKWgycLoOO/XLDWHANZo/K30OQMIPCTjjWtqt6FZbyfEwuEMLimuVCIqJViq41St
	 G0jhgzfCBrIp9msStEkAfqCc1q8DEa6YgwvdMzX9zeALpouv932stVjthHxhqFTBC8
	 0Ug5EftAG+vMA==
Date: Tue, 14 Oct 2025 22:03:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	Pavel Reichl <preichl@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
	Thorsten Leemhuis <linux@leemhuis.info>
Subject: [PATCH v2 2/3] xfs: always warn about deprecated mount options
Message-ID: <20251015050342.GW6188@frogsfrogsfrogs>
References: <20251015050133.GV6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015050133.GV6188@frogsfrogsfrogs>

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e85a156dc17d16..ae9b17730eaf41 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1373,16 +1373,25 @@ suffix_kstrtoull(
 static inline void
 xfs_fs_warn_deprecated(
 	struct fs_context	*fc,
-	struct fs_parameter	*param,
-	uint64_t		flag,
-	bool			value)
+	struct fs_parameter	*param)
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
 
