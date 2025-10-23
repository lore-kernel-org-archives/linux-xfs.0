Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F71810942
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178059; cv=none; b=jM253Zd4RQ8ChtpOXC6QLXaRgBKZtKQnbDFgjsnWzlW7c9OLYjc/P+ES99g5SJU9yT3LHFXdhthm/SZzeBEuFNesqHibsplsHFJ27t7KwAKrD/0MpmZ0ITHXAuprhpyvJWzTXJ0Pyk+XGLYlBujx/DuMRyDAOGXYerDxvv50Pyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178059; c=relaxed/simple;
	bh=mI9DiY6MsNJaHLDZu8xmzUrbUlYFFkld4P3IQTT2GCI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JJpeMWDuqbZJf1DKUforuRRsjB+BxZaOli4wS/NhfugjPnonCdQ7QNBSVgHl/rSohVgtbMIAF+xYvwqxBtoMCrX4Z7fwHG9IsQ0CkAATre3MIDB8u2rM18cpMUXc1OFnXK56YwnQTvV36L3baWsKcx+Lpx4qX1J9xJDQ7luO+rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sBXh1n6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sBXh1n6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B648C4CEE7;
	Thu, 23 Oct 2025 00:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178059;
	bh=mI9DiY6MsNJaHLDZu8xmzUrbUlYFFkld4P3IQTT2GCI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sBXh1n6B2xcay8AnYJL+on9iFHJ0fdvU8orreo6ZXyhvE5lzegmVus1L131zyKFjI
	 rzPKTx1PF/HQOM3Stxy1HmtwicUtk3adLJ/YK1C5mfFaoDBnaI8yylda2+DoRNf3kJ
	 rLk1KyTnxb54etXHPGHtHIANRocK7S8V/AjgRA+441wheJJGLnD3Gc/6RBOApAgyD7
	 AV7DKDcQrCfjZIS/Dfbyenc3ANTlyuErmPJNTbkqRv5Qp4GcPI/rwSy/UeCRNzbZiV
	 Fp0A0rQ7/pizBsIbROuT1DO1NFsgHR3LhELOatqjKBc6dtBj9nLQDW8bi5KF+5yj9U
	 1eTXs9gzf6AVg==
Date: Wed, 22 Oct 2025 17:07:38 -0700
Subject: [PATCH 08/26] xfs: validate fds against running healthmon
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747618.1028044.14310363250875499399.stgit@frogsfrogsfrogs>
In-Reply-To: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
References: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a new ioctl for the healthmon file that checks that a given fd
points to the same filesystem that the healthmon file is monitoring.
This allows xfs_healer to check that when it reopens a mountpoint to
perform repairs, the file that it gets matches the filesystem that
generated the corruption report.

(Note that xfs_healer doesn't maintain an open fd to a filesystem that
it's monitoring so that it doesn't pin the mount.)

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_fs.h |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 87e915baa875d6..b5a00ef6ce5fb9 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -1149,6 +1149,15 @@ struct xfs_health_monitor {
 /* Return events in JSON format */
 #define XFS_HEALTH_MONITOR_FMT_JSON	(1)
 
+/*
+ * Check that a given fd points to the same filesystem that the health monitor
+ * is monitoring.
+ */
+struct xfs_health_samefs {
+	__s32		fd;
+	__u32		flags;	/* zero for now */
+};
+
 /*
  * ioctl commands that are used by Linux filesystems
  */
@@ -1189,6 +1198,7 @@ struct xfs_health_monitor {
 #define XFS_IOC_SCRUBV_METADATA	_IOWR('X', 64, struct xfs_scrub_vec_head)
 #define XFS_IOC_RTGROUP_GEOMETRY _IOWR('X', 65, struct xfs_rtgroup_geometry)
 #define XFS_IOC_HEALTH_MONITOR	_IOW ('X', 68, struct xfs_health_monitor)
+#define XFS_IOC_HEALTH_SAMEFS	_IOW ('X', 69, struct xfs_health_samefs)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s

