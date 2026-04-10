Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E79344D88
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775801812; cv=none; b=WiJtV9N4QnbA7JDqbgPEHfv/p9zNGSoQX33CoLHQ5Vggh1nYiqwBZwbF25XbHNW1HktOKLjz69N+LcxX1DZsqcJd8E5m4lrGpfASOsOi8K5rhjVY7xKlEj5IhrrVH4YyWkwfELoTSVOFWhlV6mJFasMPiIDCTmNAswtTGehqmHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775801812; c=relaxed/simple;
	bh=tOvfvxaCKh342KHpZ8FMKGbhnvuMi7ieCFI4SwSpl2c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W8HZfBiRemD+mZuBwv6p62p65xBWEoQ5NkmwzHazvgQdTP2azzSiHRpPMrSCAObs37DtiirxBVVDdwYj4hDPKg8OOvfDH7zaBjfv5y3BWd8gyXPKvpDZne0x+pHTFpj+1UYY2kn6cQHFR2xLo7k3rA8FI9sd1ibTYq9Qtr/5H5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F0rcP8NX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F0rcP8NX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F31C19421;
	Fri, 10 Apr 2026 06:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775801812;
	bh=tOvfvxaCKh342KHpZ8FMKGbhnvuMi7ieCFI4SwSpl2c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=F0rcP8NXrgQRB4t10iLCYwtTjwFrdCICk/P1C0fnnpCgk8tQEY5rmEtGprgVIbM/3
	 sCbDT807lNmCdLbwVJfKy+ttOBCMQa78endkidxBq2wcNK3bd79b4QO2OUnjix7kpj
	 UYIzYoNl5Na3pRg8ToDtfKI8uUUHE5iU1NeCl1zTuJCAlNnc9DachBf6flMZ+bvXs4
	 saXBVF101yEZw07S7VU1W60VkPMeM2KmxBMhKO896o3UNyiisFscOdMeyMyM7wFjN5
	 8PoF8JUExZHJ7soBJk+7AUG4gkpoLxcIdP79+DXR8qjPUvXhT18Nvgolu/n5gk58cI
	 k3gKykLE7UGJg==
Date: Thu, 09 Apr 2026 23:16:51 -0700
Subject: [PATCH 24/26] mkfs: enable online repair if all backrefs are enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577384671.2089237.10971557961766990540.stgit@frogsfrogsfrogs>
In-Reply-To: <177577384104.2089237.6309276904931285911.stgit@frogsfrogsfrogs>
References: <177577384104.2089237.6309276904931285911.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If all backreferences are enabled in the filesystem, then enable online
repair by default if the user didn't supply any other autofsck setting.
Users might as well get full self-repair capability if they're paying
for the extra metadata.

Note that it's up to each distro to enable the systemd services
according to their own service activation policies.  Debian policy is to
enable all systemd services at package installation but they don't
enable online fsck in their Kconfig so the services won't activate.
RHEL and SUSE policy requires sysadmins to enable them explicitly unless
the OS vendor also ships a systemd preset file enabling the services.
Distros without systemd won't get any of the systemd services,
obviously.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 527a662f3ac858..f859626afdda36 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -6296,6 +6296,15 @@ main(
 	if (mp->m_sb.sb_agcount > 1)
 		rewrite_secondary_superblocks(mp);
 
+	/*
+	 * If the filesystem has full backreferences and the user didn't
+	 * express an autofsck preference, enable online repair because they
+	 * might as well get some useful functionality from the extra metadata.
+	 */
+	if (cli.autofsck == FSPROP_AUTOFSCK_UNSET &&
+	    cli.sb_feat.rmapbt && cli.sb_feat.parent_pointers)
+		cli.autofsck = FSPROP_AUTOFSCK_REPAIR;
+
 	if (cli.autofsck != FSPROP_AUTOFSCK_UNSET)
 		set_autofsck(mp, &cli);
 

