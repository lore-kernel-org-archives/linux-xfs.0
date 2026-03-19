Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAAD318EC4
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895501; cv=none; b=qlfFaKnGR3G+UG/kbjvx+lALXX6XXmfEhNJKDGbOrwj9ILqXj8iO6bRyvKo4JyLJNgDlEUxPEL7cUGhkP4ox1NSrtXCnY3Xn+LqjpYRGWbjXwFxP4i1ecvBsA+UA/SMMzleIRbPM2SyRAjNGJqCjtvNkcS7E308tHWxwqUealqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895501; c=relaxed/simple;
	bh=tOvfvxaCKh342KHpZ8FMKGbhnvuMi7ieCFI4SwSpl2c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hC3yJ/OcYcUlWAMGrI+BZpwXoEsUqy0lxFerz/N0xRl191eWbWHZmjbdAUKW6JYid2ROpcyjjlhAcI/UXUtqoD+KJ3crOiC3ANYZa/Rof6Goy21dRrKxEHIYCxLtPP5vkKWum/VrU/Vdo5SeFeBXpl7Jb17p159WQJNyOLuruyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AzYqLXnP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AzYqLXnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2915C19425;
	Thu, 19 Mar 2026 04:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895501;
	bh=tOvfvxaCKh342KHpZ8FMKGbhnvuMi7ieCFI4SwSpl2c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AzYqLXnPkZOUvPE3ccvE6d9eWoV7/EMT7xe+tMii6eOyCNnd0xetydsaDf+ypI/qj
	 QPiiyl/Rvf2JH1LBrOIFc3wVvGkA0jBFYUj+Pwq8XQfAyLnbL+rC+KPGigv1T/uvek
	 huYgDbITzY+Z+Hd7K3FIOXYlkHfYR6TU8Anf4/ZUOc/jRPfZRcT7jyCmK4IZysNvdb
	 XEUpGYej6YvVLCgKVJlNhU4kzkjS07bhnFnlmgnc8jJcdg3brzp17aGeLj5Vpc026k
	 oOs5krjZpDApRN7dzt8b0uDCJcyl6IrPccrzmKHNPD8fQU/gk1ufc3dJPUOBrMnOtC
	 ePyiq90793TVw==
Date: Wed, 18 Mar 2026 21:45:00 -0700
Subject: [PATCH 24/26] mkfs: enable online repair if all backrefs are enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177389506587.3680139.9691466733000480970.stgit@frogsfrogsfrogs>
In-Reply-To: <177389506017.3680139.913759001427336891.stgit@frogsfrogsfrogs>
References: <177389506017.3680139.913759001427336891.stgit@frogsfrogsfrogs>
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
 

