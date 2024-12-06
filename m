Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6921C548A
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528457; cv=none; b=gpxctJJr7jnS4K7R/BnSDydFDPvH2h5BK9WnXVg6IUaLGfrvRqlbnLbSv6jY/R0M6/AsU4/TkrIPOVg8FBr5AHtyayR08isLwVcg49+pqBpUxAu1XOR/3ZkRKPP+/tfLpeevgguI7lN620p4uwyCzNb+ug5uwVphKunC16xWK+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528457; c=relaxed/simple;
	bh=cxKPRn13EveFsUUnbUhi8ZGpiY72rLDG99EUL2TKQfo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l3IEyRBiGoWbINpAk17Z2Ml+EbA3gPN7HSgWKKBICT1mUzS0orSJGE3sSbBvAHUbw+ac5XO1Yv0gW7Qu/ZDV7Ft+3xf5LVX5PV6avaBXy2TFLFV+svLiKymA/9itXAsjBcfRJ0tuimlL/zj0ewws//crhzhghMRZc7S72Y9FBB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dFOQGh8i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dFOQGh8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669AEC4CED1;
	Fri,  6 Dec 2024 23:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528457;
	bh=cxKPRn13EveFsUUnbUhi8ZGpiY72rLDG99EUL2TKQfo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dFOQGh8iqWhn0NxYriIvzLHnGcBXts0pZJKU0MVX+uzX+1E/IhjIqOk65gtj2mGAI
	 fh6A2M210YGSMhmYsArvRhZmaxrZaxAI2WuTzwkz4BXdCSmz7VVBE+1Wc//hjjbBx/
	 vSbehQLiZlwYaEAih2EuduyvMulOqhn3zw9YQo4j9NczRuVkXGKjEA1Y35roF73wlP
	 lfrfIgJ+YcNOz+zihizKbrenW552cgTUIxvGQdhZ+RAoQbbnAoYxdGmraTTm2JdXEg
	 CjNpNw8eXb4UpGxJUDaj9pWQcMs30s0qTS0pJkJ5AXg4yac5Qz5FfH2QdLzkMVrivh
	 HN5LQfxI1DL9A==
Date: Fri, 06 Dec 2024 15:40:56 -0800
Subject: [PATCH 05/41] man: update scrub ioctl documentation for metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748315.122992.15391921034612434643.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Update the scrub ioctl manpage to reflect the new metadir path scrubber.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man2/ioctl_xfs_scrub_metadata.2 |   44 +++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)


diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index 44aa139b297a3b..1e7e327b37d226 100644
--- a/man/man2/ioctl_xfs_scrub_metadata.2
+++ b/man/man2/ioctl_xfs_scrub_metadata.2
@@ -200,6 +200,50 @@ .SH DESCRIPTION
 Mark everything healthy after a clean scrub run.
 This clears out all the indirect health problem markers that might remain
 in the system.
+
+.TP
+.B XFS_SCRUB_TYPE_METAPATH
+Check that a metadata directory path actually points to the active metadata
+inode.
+Metadata inodes are usually cached for the duration of the mount, so this
+scrubber ensures that the same inode will still be reachable after an unmount
+and mount cycle.
+Discrepancies can happen if the directory or parent pointer scrubbers rebuild
+a metadata directory but lose a link in the process.
+The
+.B sm_ino
+field should be passed one of the following special values to communicate which
+path to check:
+
+.RS 7
+.TP
+.B XFS_SCRUB_METAPATH_RTDIR
+Realtime metadata file subdirectory.
+.TP
+.B XFS_SCRUB_METAPATH_RTBITMAP
+Realtime bitmap file.
+.TP
+.B XFS_SCRUB_METAPATH_RTSUMMARY
+Realtime summary file.
+.TP
+.B XFS_SCRUB_METAPATH_QUOTADIR
+Quota metadata file subdirectory.
+.TP
+.B XFS_SCRUB_METAPATH_USRQUOTA
+User quota file.
+.TP
+.B XFS_SCRUB_METAPATH_GRPQUOTA
+Group quota file.
+.TP
+.B XFS_SCRUB_METAPATH_PRJQUOTA
+Project quota file.
+.RE
+
+The values of
+.I sm_agno
+and
+.I sm_gen
+must be zero.
 .RE
 
 .PD 1

