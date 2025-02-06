Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E4B2417C0
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 23:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882938; cv=none; b=ZC4A4VgPVKmPgpbMgcgAXJcBWaZO2UBQQpILE3JvoLkDR3vfKjgrpCdLXzBfhoTfmzMsel5U7KGjxkYJLIfw60P71rwlavfxXM9QC82dmK5swyD2gNOOyCq9cKdzZXrss+mW7CPERj4wsOOikCHFAVyfD2h/gZzCC9VcDB8zg50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882938; c=relaxed/simple;
	bh=MnFSh/sNeWPOgNrthk8YXp1LwOhPjso8VqYSVcIuUCA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cHnzmZVSUHFVvV2Q3d41slnC3kFe2EscBpfMext6/Tq5sGyKDBWbH6lkxkD5xv20otmJfeuZEklyShQ/7sZ7/ib0GjLydsAyxmziVkcNdC+B1/OQ+rJNZq5sS+wH55RIvexN/e62j5goVzrsrzJppOW3W2Ba6W+Sw+b6Wl4Is9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SIY6Vfwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SIY6Vfwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B73C4CEDD;
	Thu,  6 Feb 2025 23:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882935;
	bh=MnFSh/sNeWPOgNrthk8YXp1LwOhPjso8VqYSVcIuUCA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SIY6Vfwtoum0H2Z75FH+NAlSa5Hbqym+LzQ4Vs8OB3fbjuPsvj5OLHUx4hEQg5Txc
	 iccZfBQtalWma0RBEmrFpDJMTAVF8RM2tmxx5EUqCe4+OimzxPHtqpOagvihChSifC
	 PzepVi93ISslbiQ/u8FO36zO7kmCq3h93Og77SkPie+qz3garrAGogNTq2ryrVyjMq
	 gcASZksDpBLlGY5vWNh5mZl4FPL5wem+qECadpbZwEj7WpRLfFCveDrVJpQVFP5121
	 1XjlMl/Q3t92s5De1r1xqxvodzrynbZZE5xzevrHiBr1YoCCpxNc9284EUDpch8OZa
	 mhrgtxtQkMlkg==
Date: Thu, 06 Feb 2025 15:02:14 -0800
Subject: [PATCH 21/22] mkfs: validate CoW extent size hint when rtinherit is
 set
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888089253.2741962.7311263148977317330.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Extent size hints exist to nudge the behavior of the file data block
allocator towards trying to make aligned allocations.  Therefore, it
doesn't make sense to allow a hint that isn't a multiple of the
fundamental allocation unit for a given file.

This means that if the sysadmin is formatting with rtinherit set on the
root dir, validate_cowextsize_hint needs to check the hint value on a
simulated realtime file to make sure that it's correct.  This hasn't
been necessary in the past since one cannot have a CoW hint without a
reflink filesystem, and we previously didn't allow rt reflink
filesystems.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index c8042261328171..9239109434d748 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2985,6 +2985,26 @@ _("illegal CoW extent size hint %lld, must be less than %u.\n"),
 				min(XFS_MAX_BMBT_EXTLEN, mp->m_sb.sb_agblocks / 2));
 		usage();
 	}
+
+	/*
+	 * If the value is to be passed on to realtime files, revalidate with
+	 * a realtime file so that we know the hint and flag that get passed on
+	 * to realtime files will be correct.
+	 */
+	if (!(cli->fsx.fsx_xflags & FS_XFLAG_RTINHERIT))
+		return;
+
+	fa = libxfs_inode_validate_cowextsize(mp, cli->fsx.fsx_cowextsize,
+			S_IFREG, XFS_DIFLAG_REALTIME, flags2);
+
+	if (fa) {
+		fprintf(stderr,
+_("illegal CoW extent size hint %lld, must be less than %u and a multiple of %u. %p\n"),
+				(long long)cli->fsx.fsx_cowextsize,
+				min(XFS_MAX_BMBT_EXTLEN, mp->m_sb.sb_agblocks / 2),
+				mp->m_sb.sb_rextsize, fa);
+		usage();
+	}
 }
 
 /* Complain if this filesystem is not a supported configuration. */

