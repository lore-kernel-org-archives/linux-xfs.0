Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9E82F46
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882329; cv=none; b=OyhG65gkXrY510HpBdUFjvIjQ8aQop0nq5o6tfimiqG2Dwb2rToNPdR+HL51A+U5MVGERXij/G8Dz8o3Xv9Jvc8YrhKAYpbDTNHC+AfKpBOaGB4m1Uq/0pdydsAxiCWY0L3F1x5hz5S7SEGEORj3KgO8VRYMszmKG3jKamJauPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882329; c=relaxed/simple;
	bh=Of3j2r1F36e+kiPZYoRGazJvgseSIVUWoE6TO8uS1qs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KT/+3xoAnYxXjJNIR8oL7czV2adiLGlpE4UJl6FPXHIVJnh2d7jp0Lc0zS/ZiV+MqYs7Qo2BVQvWH3afptHfAN9HO858bb238rKQRzkx1y4OV+GWa67nlpapFJIs0yUdefocZJpg+l7BGxvWY4xwo+1UqulCobVf1oRN590/G2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J2RV6fv1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J2RV6fv1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBC4C116B1;
	Tue,  2 Jul 2024 01:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882329;
	bh=Of3j2r1F36e+kiPZYoRGazJvgseSIVUWoE6TO8uS1qs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=J2RV6fv1X+KWjGUSk+GVOjqahaqmCG92qz7mcw07UmxFW2U5WBtl9SqgCBhddbs+A
	 uLDSp25saoRYjEN+Q77g911gj8PfBqNYpjrAfm00/wIXV6vwR2wSk/jCmf/4wU67HO
	 5cixw5frlPC/QgyV2ipjE9OEAZZtxALaCIrM7yHeYqI4fZc3AuGkhu/pAGq4TadbO7
	 xsgI7bNo7kM7IF/Mnp3khY4rAGSepsFNWZsgb2BslACqqD7EZ70wfSmZfuilraKgzw
	 zvY4YszHZwcDWwCZxKtw3KP+V8ZWNLFHAcGkdAIWJu5Zgj4W7OITfeF2Pkj0kHAdg+
	 6Tz8Ofouhg2Dg==
Date: Mon, 01 Jul 2024 18:05:28 -0700
Subject: [PATCH 3/6] xfs_scrub: use dynamic users when running as a systemd
 service
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Helle Vaanzinn <glitsj16@riseup.net>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988119051.2008208.10956893253250060106.stgit@frogsfrogsfrogs>
In-Reply-To: <171988118996.2008208.13502268616736256245.stgit@frogsfrogsfrogs>
References: <171988118996.2008208.13502268616736256245.stgit@frogsfrogsfrogs>
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

Five years ago, systemd introduced the DynamicUser directive that
allocates a new unique user/group id, runs a service with those ids, and
deletes them after the service exits.  This is a good replacement for
User=nobody, since it eliminates the threat of nobody-services messing
with each other.

Make this transition ahead of all the other security tightenings that
will land in the next few patches, and add credits for the people who
suggested the change and reviewed it.

Link: https://0pointer.net/blog/dynamic-users-with-systemd.html
Suggested-by: Helle Vaanzinn <glitsj16@riseup.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub@.service.in |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub@.service.in b/scrub/xfs_scrub@.service.in
index 855fe4de4dcf..52068add834d 100644
--- a/scrub/xfs_scrub@.service.in
+++ b/scrub/xfs_scrub@.service.in
@@ -17,7 +17,6 @@ ProtectHome=read-only
 PrivateTmp=no
 AmbientCapabilities=CAP_SYS_ADMIN CAP_FOWNER CAP_DAC_OVERRIDE CAP_DAC_READ_SEARCH CAP_SYS_RAWIO
 NoNewPrivileges=yes
-User=nobody
 Environment=SERVICE_MODE=1
 ExecStart=@sbindir@/xfs_scrub @scrub_args@ %f
 SyslogIdentifier=%N
@@ -31,3 +30,6 @@ Nice=19
 # Create the service underneath the scrub background service slice so that we
 # can control resource usage.
 Slice=system-xfs_scrub.slice
+
+# Dynamically create a user that isn't root
+DynamicUser=true

