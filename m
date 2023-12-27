Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AF81370
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dGDq8Ogn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7618AC433C7;
	Mon,  1 Jan 2024 00:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069411;
	bh=S4cuJxAwHa7rTzDnthDRlgpqqTRHTgY3UZhVmRW3Wbo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dGDq8OgnSM6hedgDMG2a3TAEP78EXbPVPv9sHvnJanAFxRVB1NV6olHCZ0RxZnaEJ
	 fM+TLxO9vM5K94kPgjXAMcQkbbswyV90fJQs/zDVGp4I3woJvGEmUvoRP5GaBN26y1
	 OGIWvyuT5Z8bUkWOybts4uge10U+aHdFzb7I+xuLKNiaBv73Ha3rQyY8D8IVCl7D75
	 KgKZ37/DTXJR442Z7/E9LDqCs9KdEQTGnr0ewJbnONns/ZYioJAf8aHYwc10DJwHKW
	 rMQ304Xalb+J7LdI3JJIFt8MO8Dn4MisQ8cIV0CvvEFjb/zrOPdevglrH8aD9+0ZXm
	 wnH+pw8uGGAsg==
Date: Sun, 31 Dec 2023 16:36:50 +9900
Subject: [PATCH 41/42] mkfs: validate CoW extent size hint when rtinherit is
 set
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017674.1817107.2226698699690206203.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 162546cd1e8..bcdfbf6fbf6 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2751,6 +2751,26 @@ _("illegal CoW extent size hint %lld, must be less than %u.\n"),
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

