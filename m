Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FDA12838F
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425569; cv=none; b=H67fpGvwnZZbk8Skyy3vp8WDiW0snIfwx46tkqes99hQfoC1ROYk8RaqwNaWfMLX0uCvlA/lukmF3phFajYVnXSKgLDOmaWsXRRgnBKhQt29tdJhgjU5f5NKcupyG15i6Zfjs/MZ3BT2/04l6P29ns44V4S0BRiSpl7yV+6W+TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425569; c=relaxed/simple;
	bh=Enn4l5pXdZ+9gsqm7oPnIVo7tcEocMz5z75xeEDw5J4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lgrkHXAO2L1i2c7/mCBeeHJPYZ+leuNDbYIx6wCSG3Km3EwG95I9DUxmE8pMyJHWZO1W4XB+QpX3wDOxYfLBxf/yRhM++goe6yy+3gADz3LgxhjHzEaIZdZTuKs1y/KGXtrSZPeI9nRfzCWmJbKYc/LTAawc8eoDE4IcNtlZUaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KOZd/8Fg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KOZd/8Fg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F000C433F1;
	Tue, 26 Mar 2024 03:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425569;
	bh=Enn4l5pXdZ+9gsqm7oPnIVo7tcEocMz5z75xeEDw5J4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KOZd/8FgMKG+PU61sqLHD2MfqiqNwMvqSH9OSvl+1AG4fuB9nFdUm/PLSDJL3o5sh
	 bsuJaNDs/6auPA15TEoi6YA+grDKun61VoBxOO3taZIJKtarllwAJ1/RoFj4W/t7yl
	 EsYzZT/xd7nLG6NnfeXYDXcszWZOg4xh/amclvSIPDA5PxzhzPdUcuCP05G2YO3zXh
	 jJOTyxOCUNptCD6oDj//uRE8rSG6dI3FnKuR6DfDCn6pzmojSQ9aAxJeM4GQV5PTwy
	 an7qOcM/EtTNCeHVYccJjmAO711bjQwJnJ67R7QeOmPT8PqS+AQMpnpaJfTRuTX9Ah
	 ahy7bdmnZ87Zg==
Date: Mon, 25 Mar 2024 20:59:29 -0700
Subject: [PATCH 2/5] xfs_scrub: check file link counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171142134338.2218196.12906003001405825233.stgit@frogsfrogsfrogs>
In-Reply-To: <171142134302.2218196.4456442187285422971.stgit@frogsfrogsfrogs>
References: <171142134302.2218196.4456442187285422971.stgit@frogsfrogsfrogs>
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

Check file link counts as part of checking a filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/scrub.c                     |    5 +++++
 man/man2/ioctl_xfs_scrub_metadata.2 |    4 ++++
 2 files changed, 9 insertions(+)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 53c47bc2b5dc..b6b8ae042c44 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -139,6 +139,11 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 		.descr	= "quota counters",
 		.group	= XFROG_SCRUB_GROUP_ISCAN,
 	},
+	[XFS_SCRUB_TYPE_NLINKS] = {
+		.name	= "nlinks",
+		.descr	= "inode link counts",
+		.group	= XFROG_SCRUB_GROUP_ISCAN,
+	},
 };
 
 /* Invoke the scrub ioctl.  Returns zero or negative error code. */
diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index 046e3e3657bb..8e8bb72fb3bf 100644
--- a/man/man2/ioctl_xfs_scrub_metadata.2
+++ b/man/man2/ioctl_xfs_scrub_metadata.2
@@ -164,6 +164,10 @@ Examine all user, group, or project quota records for corruption.
 .B XFS_SCRUB_TYPE_FSCOUNTERS
 Examine all filesystem summary counters (free blocks, inode count, free inode
 count) for errors.
+
+.TP
+.B XFS_SCRUB_TYPE_NLINKS
+Scan all inodes in the filesystem to verify each file's link count.
 .RE
 
 .PD 1

