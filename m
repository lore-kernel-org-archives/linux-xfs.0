Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE311547C0
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 03:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114561; cv=none; b=S3o42/x17EXrCr7765ThxyWQoaeRCTGJicWgtMVTip3WmYNGk6ZNN2AHF9GrWeIPzoIeGIjS3dtil9fi8Hri9DzRZJRi1/mwH96LmmyLLbMp4qjLoI+hXprcOKpyakMAo5vgUXYr+4vuIZbWaiYv/HPUWyn5gMaM+jYKZuEMOTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114561; c=relaxed/simple;
	bh=2cxrpAckN6kurr7u7Rnxo8eaHxl6J1CR4vbCVT89ljk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qMgsV2rBHGZcXcrPDYkwVczfpVp1EE4rz847sza/w0okweqROMZiWIuRsYvlm5owOv7dZKSSCrtUmtwnhO3yEsQKjCzF8zcyYh4P/cVilr4L5Jf8IPtWk9u+gzhm1D7BMnTdF15EExn4OlTlyv4PFuM55r2Ivvsjgp6yfJWcGFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E7m9iVmL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E7m9iVmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB28C19423;
	Tue, 10 Mar 2026 03:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114561;
	bh=2cxrpAckN6kurr7u7Rnxo8eaHxl6J1CR4vbCVT89ljk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=E7m9iVmLHxSsNqiNq45FlmtUidqM4IJTieobVQcnX/cTWQWiX3RnEUyzwiz6p/5BV
	 cz0H6kVQqxflSK2l39I00ZQ1KYz+1uJkRHaUatrI99GbwXZjuJ4XRnr0QiDTXhajeN
	 sB8tsqsAr2BpbiHas36xBghEJ4rfJu4lh0lJsM30ZMyHvQwLrbQyCXVRfLsxvLprAF
	 Y0RvUEICELC0IuskJht9lWFbszpeR6sicQgHfvqNt3h9Y/DfFo7ke2mFh1hC3DBGVX
	 7g8LmMNsy1t7qgPe41B7kouPvZLPPWtM4ihCpfMDA2Ig0zirHDM+xOPdbj4hGcp0o8
	 KtTV0nkV41DGA==
Date: Mon, 09 Mar 2026 20:49:21 -0700
Subject: [PATCH 26/28] mkfs: enable online repair if all backrefs are enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177311401930.1183235.5546361742527693533.stgit@frogsfrogsfrogs>
In-Reply-To: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
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
 

