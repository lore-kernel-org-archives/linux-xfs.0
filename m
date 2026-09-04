Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1856D346FB3
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 06:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788503195; cv=none; b=H2uctKa8REsoUrdc33qMAU47p8vWG2wNMdIDVtE3/ICzpIgjBxx6u+SpUQkVLau1wvEQfa9yA1+YozyaRgc59x8269W8oE5N0Qxo7J+ZkeEj6tLY2xDOEnSRiHd2C/LX2LUzC6StyRwaxltj3LISnBEaWlxdPWeG5zJdRkRDXOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788503195; c=relaxed/simple;
	bh=HHJdDv7QJuo+MLC9MYmTezAclhww1glC+82pXNkUaG8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZM8gfsPBEuVrltOdfiTg6AWjSALgjG3WF1uWHA29KmXUGdIdqBiAeTEWJ1aB5XOk7riMBK0Gn/aL0+mPAsgG0rMy90lHX9hSac2kc+sq7EAj+4bgMzLHyk+XE+Ui1rOz6bWbd8T+GIurqRNChgkpnSNvOvBvOVUF6qjMKtyrBR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c4Bj9DF6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c4Bj9DF6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A5B391F00A3D;
	Fri,  4 Sep 2026 06:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788503193;
	bh=PvEiDdrJ7VAuHASDJeAfaPD0OcbJJrJfcR/vSF2aGpc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=c4Bj9DF6460XT4iC1+imLtshIxbCTDEKu1B83edX4wA0nI5SPY4475nOLkLM/5wCC
	 ZAaQCAaQCxEnbDEPmtVlzsOXr/W1gaamzPu8dm/wGthlFP3d5FMQe+mVzuIbm046oO
	 sAEJ6CnQluR0pF9K6cUrlq2oYPeccJD/lp6JnJje0lipXrfiSLhSN0yWP/q6EsJWnN
	 HehZfOfhWUhYzVGCQl5bFp/fFp3x9GSuMtYhOxAMuPEsa/eMbq2SwSqSCvQ8+04BTR
	 8p0cJjjxLdfJToHJofWa3yinXrWlT3Oq9829SYZQHPqNoJpf0hItid6RnY/h9WBdgf
	 QNC7+wKp/oidg==
Date: Thu, 03 Sep 2026 23:26:33 -0700
Subject: [PATCH 3/6] xfs: report runtime failures in scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178850312561.1198660.15558855470989904766.stgit@frogsfrogsfrogs>
In-Reply-To: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs>
References: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a new counter so that we can track the number of runtime failures
encountered during scrubs.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/stats.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index da0c05ffe5cd0b..3339cae4b39d14 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -29,6 +29,7 @@ struct xchk_scrub_stats {
 	uint32_t		incomplete;
 	uint32_t		warning;
 	uint32_t		retries;
+	uint32_t		runtime_errors;
 
 	/* repair stats */
 	uint32_t		repair_invocations;
@@ -110,7 +111,7 @@ xchk_stats_format(
 		spin_unlock(&css->css_lock);
 
 		ret = scnprintf(buf, remaining,
- "%s %u %u %u %u %u %u %u %u %u %llu %u %u %llu\n",
+ "%s %u %u %u %u %u %u %u %u %u %llu %u %u %llu %u\n",
 				name_map[i],
 				(unsigned int)fss.invocations,
 				(unsigned int)fss.clean,
@@ -124,7 +125,8 @@ xchk_stats_format(
 				(unsigned long long)fss.checktime_us,
 				(unsigned int)fss.repair_invocations,
 				(unsigned int)fss.repair_success,
-				(unsigned long long)fss.repairtime_us);
+				(unsigned long long)fss.repairtime_us,
+				(unsigned int)fss.runtime_errors);
 		if (ret <= 0)
 			break;
 
@@ -207,13 +209,17 @@ xchk_stats_merge_one(
 	}
 
 	/* caller applies this same transformation after we return */
-	if (error == -EFSCORRUPTED || error == -EFSBADCRC)
+	if (error == -EFSCORRUPTED || error == -EFSBADCRC) {
 		sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+		error = 0;
+	}
 
 	css = &cs->cs_stats[sm->sm_type];
 	spin_lock(&css->css_lock);
 	css->invocations++;
-	if (!(sm_flags & XFS_SCRUB_OFLAG_UNCLEAN))
+	if (error)
+		css->runtime_errors++;
+	else if (!(sm_flags & XFS_SCRUB_OFLAG_UNCLEAN))
 		css->clean++;
 	if (sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		css->corrupt++;

