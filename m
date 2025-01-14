Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDB3209F4C
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 21:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736890854; cv=none; b=ne1u+pt7baPIlWlvOocV4RuvoF8s6WQ6DY+dBDW0Ey8iWS/51fw+Pjavkg7cVOJKJdDZuZJfFfWBHQTjYMRDfJKwXraiuH9b8Wljx1VNA8dB7brC6HWpKyXD/JVRhCwzFpWGNYlr0G8KMicP5gx+TO4/XQfOO4p8IAKXUdq4uX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736890854; c=relaxed/simple;
	bh=/PFYCQPoSzWSiyKoSq952MkoCdedEyMzfiyWq5CdKBo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i8Jv9Dt8PiEqoTy0lbmMcDvsdbRKuBg1A+rlnHqOl9krCnBzrETNFA4OLA2H2SV3gXn4SZ7BOg+BLTRLyYKvr1+Z7wZdFEAFKhKgDopGjsCkSUQXbfB1rdooqWS/pwK2mZQWyCzu/hO+am/hqH6Io4NXqi2P7vF4LfVHvdMzK0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XiwdqT3J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XiwdqT3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463A2C4CEDD;
	Tue, 14 Jan 2025 21:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736890854;
	bh=/PFYCQPoSzWSiyKoSq952MkoCdedEyMzfiyWq5CdKBo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XiwdqT3JykveRA2319LyMmVcTY8zD5Oq14DhGlaOX3bpZhZ8qK+AyGW1fJeOtHmYg
	 dUN54e6QAFDWZWtmfNfOw5ZAWFh4TulAA4P2M2/herr802pSSQttqlOFSR09yXOW2E
	 xe/sdEcdf/BlaiqdXdlvmz7y5p46UhjarGwU9NANmlB269RiE7CxZ98zkjB6H0XWD/
	 IOTEO3yBKnzI7V+ioAYTwi9XqBK3cqkvE8oCgvQuE/8JTzJMQdlRbOeIQ8aC31P0Ep
	 yaC0d02s5I7KJWMytDrjHrS/UCWkCR7cASg/GKTHTOJZY7H5MUd7fBhhT1QILngH67
	 KN0w+p9/CL//w==
Date: Tue, 14 Jan 2025 13:40:53 -0800
Subject: [PATCH 2/5] mkfs: fix parsing of value-less -d/-l concurrency cli
 option
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173689081910.3476119.11332577729920649286.stgit@frogsfrogsfrogs>
In-Reply-To: <173689081879.3476119.15344563789813181160.stgit@frogsfrogsfrogs>
References: <173689081879.3476119.15344563789813181160.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

It's supposed to be possible to specify the -d concurrency option with
no value in order to get mkfs calculate the agcount from the number of
CPUs.  Unfortunately I forgot to handle that case (optarg is null) so
mkfs crashes instead.  Fix that.

Fixes: 9338bc8b1bf073 ("mkfs: allow sizing allocation groups for concurrency")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 956cc295489342..deaac2044b94dd 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1722,7 +1722,7 @@ set_data_concurrency(
 	 * "nr_cpus" or "1" means set the concurrency level to the CPU count.
 	 * If this cannot be determined, fall back to the default AG geometry.
 	 */
-	if (!strcmp(value, "nr_cpus"))
+	if (!value || !strcmp(value, "nr_cpus"))
 		optnum = 1;
 	else
 		optnum = getnum(value, opts, subopt);
@@ -1867,7 +1867,7 @@ set_log_concurrency(
 	 * "nr_cpus" or 1 means set the concurrency level to the CPU count.  If
 	 * this cannot be determined, fall back to the default computation.
 	 */
-	if (!strcmp(value, "nr_cpus"))
+	if (!value || !strcmp(value, "nr_cpus"))
 		optnum = 1;
 	else
 		optnum = getnum(value, opts, subopt);

