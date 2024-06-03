Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D3723A0
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442602; cv=none; b=cJxv3r6k4VgRlZ9XOqbx5xXjmKzmbOxA7N1Lr85hwTxLKLwUCodWaZX2SQrEgTFK/q1aqxocVh+qSoH2BnJhpDHxKb4av6a1PCX4dNLkUpR1RcTJRZ5+dbLieM4NMG4lvc/rD/uavd0yAfDSgNNQDlgyC8+LGhsG9fuOpgzik50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442602; c=relaxed/simple;
	bh=7Wm/xrBnHEkX0WwBgWywLm727BoZhI45CyPSn9OSAgg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kDElJ9a5eOe7skf9/lcRYvWLzMAA6WhEHNUhA8R6rWkkR9zPOezD8tIfICUPPoZNIyvajp+OrwjfhtOlVLUjULOx4gCscjQ0PdfuNMuOQyJHRba88flEtNOl7Ohtz2pTKW6oXFZDRUGKO/sSCfxw63lg8A5iZfW7mzkvLCazxCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=igdUV9ek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="igdUV9ek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F209BC32782;
	Mon,  3 Jun 2024 19:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442602;
	bh=7Wm/xrBnHEkX0WwBgWywLm727BoZhI45CyPSn9OSAgg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=igdUV9ekaGjd1bkQgi2e9vWPXx+3Umb9oDNpQHUGv1ZJpEEJilsTDRc5QCBvUKVnO
	 PEUPYKJ843DVMnyR7C6hlgFVhjw7oIryJZpS8Co7AZINSdkOAqZWqlDVFXTowdqTol
	 /hzKaiEmc51/FsFmRMM2VtSuVNLUZU11brgnY4PCjHfDzsw8wq3IEdzs8Ox9oaNJjf
	 v22XlbUvm3ayjaPjvYvIt9y0vLqNX16LGeCtZjPZbUrVySOyJh3Ys1nVSHOFPEnmcu
	 g+i5HoqhjITt6bcUoF/2s2m+5u7jubyLyxAr9Ct0mnXnVNpIxIj/+AKIbLRmX6459G
	 nD60PdmVoyS3Q==
Date: Mon, 03 Jun 2024 12:23:21 -0700
Subject: [PATCH 2/5] xfs_scrub: check file link counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744042404.1449803.11388107555397436481.stgit@frogsfrogsfrogs>
In-Reply-To: <171744042368.1449803.3300792972803173625.stgit@frogsfrogsfrogs>
References: <171744042368.1449803.3300792972803173625.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/scrub.c                     |    5 +++++
 man/man2/ioctl_xfs_scrub_metadata.2 |    4 ++++
 2 files changed, 9 insertions(+)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 53c47bc2b..b6b8ae042 100644
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
index 046e3e365..8e8bb72fb 100644
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

