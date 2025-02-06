Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A57C1A5B94
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882247; cv=none; b=bLJEPHMmN0DmcaV4RuNkPUSWS7uoRjK5HvARtzv/rPNOP/j4XL2f3+k6jDCgCfETOaKUlkg8K29xFPJzRIsAWWv6HBo8w56Rvs+Y5C4rveF8diOhPAndOYcD130YAZoq/vfbPXqhhkzHt7TVSgNPpGHxKK59l9WI1y+PGsrF4Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882247; c=relaxed/simple;
	bh=ZKDinG5M9iION68j7zwiwKAtH030s/baXr5yJAPLWHo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jKGh6uqwktyZdO+f2CIRnunFKdYRBO41VNbGcxF1gC/k0wSSPwUgWHs36kAzMRfhmHmeyetqH+7qf/Zvr60xstnbijqziN5yKfBuaCctX8om/y0kExMD7l5tJxhO7rM2XnoruXC1D252lG7slDmuVrN0obMKgb8ypV/AR6eM32U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NtIqO3Wp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NtIqO3Wp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC2FC4CEDF;
	Thu,  6 Feb 2025 22:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882247;
	bh=ZKDinG5M9iION68j7zwiwKAtH030s/baXr5yJAPLWHo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NtIqO3Wpp5WFyWpwa3yQhqRRKNtKdjGriOQZvv7eGFjed2dY4vY8CeDIzxIBI0rXT
	 UzkfS9zikL8JGXtLgTaSvVn+WrycKobeZSDwhZfjv2EUts/9HQn3GF9q1hJ/+/p3d/
	 fKRK4ETIae8qRkOtfqGdWS2wSN501y8DH42MQ1PoJPYZqKIIMBfq8CQ9rdUTmSiRiE
	 jmUSma1JEo15d3osvxstyjBLf597tfqzwSCswhEz2FgswALCk6fyu4damGvhH9CCra
	 yGLHxNayTqk6EqQreSQrayccUPrRLy+pl/elZtt4EAqKMFMSGctPTojBvGCzTq5H63
	 nIiQv3Sx5uZ7Q==
Date: Thu, 06 Feb 2025 14:50:46 -0800
Subject: [PATCH 04/27] man: document userspace API changes due to rt rmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088157.2741033.18009447992987469682.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Update documentation to describe userspace ABI changes made for realtime
rmap support.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man2/ioctl_xfs_rtgroup_geometry.2 |    3 +++
 man/man2/ioctl_xfs_scrub_metadata.2   |   12 ++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)


diff --git a/man/man2/ioctl_xfs_rtgroup_geometry.2 b/man/man2/ioctl_xfs_rtgroup_geometry.2
index c4b0de94453558..37e229b4335459 100644
--- a/man/man2/ioctl_xfs_rtgroup_geometry.2
+++ b/man/man2/ioctl_xfs_rtgroup_geometry.2
@@ -73,6 +73,9 @@ .SH DESCRIPTION
 .TP
 .B XFS_RTGROUP_GEOM_SICK_SUMMARY
 Realtime summary for this group.
+.TP
+.B XFS_RTGROUP_GEOM_SICK_RTRMAPBT
+Reverse mapping btree for this group.
 .RE
 .SH RETURN VALUE
 On error, \-1 is returned, and
diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index 545e3fcbac320e..f06bb98de708a4 100644
--- a/man/man2/ioctl_xfs_scrub_metadata.2
+++ b/man/man2/ioctl_xfs_scrub_metadata.2
@@ -180,11 +180,12 @@ .SH DESCRIPTION
 .PP
 .nf
 .B XFS_SCRUB_TYPE_RTBITMAP
-.fi
-.TP
 .B XFS_SCRUB_TYPE_RTSUM
-Examine the realtime block bitmap and realtime summary inodes for
-corruption.
+.fi
+.TP
+.B XFS_SCRUB_TYPE_RTRMAPBT
+Examine a given realtime allocation group's free space bitmap, summary file,
+or reverse mapping btree, respectively.
 
 .PP
 .nf
@@ -246,6 +247,9 @@ .SH DESCRIPTION
 .TP
 .B XFS_SCRUB_METAPATH_PRJQUOTA
 Project quota file.
+.TP
+.B XFS_SCRUB_METAPATH_RTRMAPBT
+Realtime rmap btree file.
 .RE
 
 The values of

