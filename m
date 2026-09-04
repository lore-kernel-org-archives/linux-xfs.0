Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25BF19049B;
	Fri,  4 Sep 2026 06:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788503164; cv=none; b=dVK2YadfbV3/RCnSDKMCAEzvS6nuksBWKkg6k0+5Tk3bP4Qvza9QiG8VZpJwPuDdd2fBU4+WPo5yaA5lR+T9Hc5FEIeFcEsR2Z/lRLGMwFE70wyuB9hBqtabcz1b+K9a4mf4oV3tBrDddnRoNudy03cy0NT8h3yM/aKqTbtYCxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788503164; c=relaxed/simple;
	bh=bh+wPd84cM+4YfwbmpUj2Hy+XBxr14WVfV/UR/Zrhtw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BQXaZs/yhW/IeuciIZCE6V8QHZjVvs3I+YvaXfPOElPeyOUJ/CXx2baeUFGISAWXhP3/6JLQ/uBsYxbyrmghe7+Y4ktAuzBAbQ/2ge1uFIXtIfDUVUo6/HQDjFQwHcZMOYZIsLBcOzgdt2bjRDWv1yxGz/ezuw3Rrd8ydUP7o9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GMh0c5aE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GMh0c5aE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 704171F00A3D;
	Fri,  4 Sep 2026 06:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788503162;
	bh=h9WxvQoUe/uD9ZykCaA/rLu4r2twAFQcR5D3Jfng//g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=GMh0c5aEzVNcoAkI8OfG3wUjPkTl/MCq33UQqYX+mpMXZQgR3cmFfWVaH8PXVhxUv
	 JLcumBW1+I4WrEXoPi6HzD2560ubHzZycLKLTGLCHuJ6Xa9Iyl1Y8tTJiQlgTiPGFb
	 N2Q218fqV0sZ+kcr2V+AGsrhNo+3v3ppYROHZpxX+xM+Td0nCsVJ8DbFK/JwlIyBVZ
	 xjzMppspRsPo5M2RTqwvYg9nCykuOFkPhLFBjIVADbZfAEM273J/YZh5IiKggUija4
	 /I5/2vLyrWGoJzK84QZMx5m9TfOih0VSVdHrxjzsx+9r4ogUIKplGPD0eWbcvRPdrf
	 YsStRrM1ws7Jg==
Date: Thu, 03 Sep 2026 23:26:02 -0700
Subject: [PATCH 1/6] xfs: snapshot scrub stats when rendering them
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178850312518.1198660.12930219318866018921.stgit@frogsfrogsfrogs>
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

LOLLM complains about concurrency problems in the scrub stats code
because xchk_stats_format doesn't synchronize in any way with updates.
These stats are only reported through debugfs so I don't think it really
matters, but I guess I exist to make bots happy now.

Cc: <stable@vger.kernel.org> # v6.6
Fixes: d7a74cad8f4513 ("xfs: track usage statistics of online fsck")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/stats.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index 76f2515188d1b1..f3f1fbfb6d9955 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -99,25 +99,31 @@ xchk_stats_format(
 	int			ret = 0;
 
 	for (i = 0; i < XFS_SCRUB_TYPE_NR; i++, css++) {
+		struct xchk_scrub_stats	fss;
+
 		if (!name_map[i])
 			continue;
 
+		spin_lock(&css->css_lock);
+		memcpy(&fss, css, offsetof(struct xchk_scrub_stats, css_lock));
+		spin_unlock(&css->css_lock);
+
 		ret = scnprintf(buf, remaining,
  "%s %u %u %u %u %u %u %u %u %u %llu %u %u %llu\n",
 				name_map[i],
-				(unsigned int)css->invocations,
-				(unsigned int)css->clean,
-				(unsigned int)css->corrupt,
-				(unsigned int)css->preen,
-				(unsigned int)css->xfail,
-				(unsigned int)css->xcorrupt,
-				(unsigned int)css->incomplete,
-				(unsigned int)css->warning,
-				(unsigned int)css->retries,
-				(unsigned long long)css->checktime_us,
-				(unsigned int)css->repair_invocations,
-				(unsigned int)css->repair_success,
-				(unsigned long long)css->repairtime_us);
+				(unsigned int)fss.invocations,
+				(unsigned int)fss.clean,
+				(unsigned int)fss.corrupt,
+				(unsigned int)fss.preen,
+				(unsigned int)fss.xfail,
+				(unsigned int)fss.xcorrupt,
+				(unsigned int)fss.incomplete,
+				(unsigned int)fss.warning,
+				(unsigned int)fss.retries,
+				(unsigned long long)fss.checktime_us,
+				(unsigned int)fss.repair_invocations,
+				(unsigned int)fss.repair_success,
+				(unsigned long long)fss.repairtime_us);
 		if (ret <= 0)
 			break;
 

