Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C598912838F
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425522; cv=none; b=FaSY6UPqTN5k8gVwJw3+h9rDyuPMJ1lbl3pGmyaPu403ywlAnr9JUQp8K0gbEmwhV7vPWfGaZuxDOLzBOUg8BbK7G6AX2Ki9Hlf18Ay84gFI6dEJlAnEXf6jW9rI2h8B4DTgzkx7Kmq6zGkyfxyMtZtt62VZNTa6eUJIKGXXKJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425522; c=relaxed/simple;
	bh=4hqAiu0RcKjERdtqAGwFevKWZh7DCgvibK8B2Wa0nek=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XrQG/8JoGhCZZvwuAAlGDZIiq5B/ZOJruk4FEbLX1itWyZ33X9D4HHxDImNXC66ZvMXCO2zM+8IlWuIVDomWOhm0V2KQmndoc2E8egPJervDy17dOUtbnrN1x3KgswXDFpqZn3rxdK0PP/e1Ac0vDIdM6wP2or8h0/cyUlZQq7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NsKi8hc4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NsKi8hc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98107C433C7;
	Tue, 26 Mar 2024 03:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425522;
	bh=4hqAiu0RcKjERdtqAGwFevKWZh7DCgvibK8B2Wa0nek=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NsKi8hc4DHowDednyizcm6OLMBooaCWaXUES+LDRkdlKRMQUO0kVs2/px7Tkh6PLM
	 1dzmIOGEiKOFAkc7SlH9WUU6Yqs2fw9IiYCxeLgA1xsL/9zDn0dd/1vBguBYkRFyZm
	 vckbuSQsdsyfcDApP3oPUfUyk9fqJBzEawGzPQOVGBZ3MsCOxYTvae73hPcIuXX1RR
	 mrosuuvFE1vu8PSkU/09+Z9F5OoaHo8ifQUI5b0TM6u2iW8usz4Pm9EFEN7vVpxrEq
	 2oFunQ1mcFC+fQRKZ5X7sAa/b8ZRwHhGWyLfiQnFYgwtxMCCfO2fLBPm2jQIb5PGf8
	 V5hbyLOy2P7iw==
Date: Mon, 25 Mar 2024 20:58:42 -0700
Subject: [PATCH 1/2] xfs_spaceman: report the health of quota counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171142133994.2218093.3554558564414039858.stgit@frogsfrogsfrogs>
In-Reply-To: <171142133977.2218093.3413240563781218051.stgit@frogsfrogsfrogs>
References: <171142133977.2218093.3413240563781218051.stgit@frogsfrogsfrogs>
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

Report the health of quota counts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man2/ioctl_xfs_fsgeometry.2 |    3 +++
 spaceman/health.c               |    4 ++++
 2 files changed, 7 insertions(+)


diff --git a/man/man2/ioctl_xfs_fsgeometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
index 6b7c83da7583..f59a6e8a6a20 100644
--- a/man/man2/ioctl_xfs_fsgeometry.2
+++ b/man/man2/ioctl_xfs_fsgeometry.2
@@ -256,6 +256,9 @@ Free space bitmap for the realtime device.
 .TP
 .B XFS_FSOP_GEOM_SICK_RT_SUMMARY
 Free space summary for the realtime device.
+.TP
+.B XFS_FSOP_GEOM_SICK_QUOTACHECK
+Quota resource usage counters.
 .RE
 
 .SH RETURN VALUE
diff --git a/spaceman/health.c b/spaceman/health.c
index d83c5ccd90d5..3318f9d1a7f4 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -72,6 +72,10 @@ static const struct flag_map fs_flags[] = {
 		.descr = "realtime summary",
 		.has_fn = has_realtime,
 	},
+	{
+		.mask = XFS_FSOP_GEOM_SICK_QUOTACHECK,
+		.descr = "quota counts",
+	},
 	{0},
 };
 

