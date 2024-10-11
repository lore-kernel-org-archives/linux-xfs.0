Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B121511187
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610562; cv=none; b=XwsiD/9qqu1+6J0weaAkKdd4bplyudMhPSm7tsu7KpU3Em2r3aYkxP6bSnBMeC3G2dCMI3atJ/HaGlBs4Gj1BJEKnN2V58JwXcDT3ldrA/qVwMW1NPsNg8WpS7LToA7orwQg4UdKJr071XhmgpgzHEa3GfAYAW22ZbBAuyKzVAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610562; c=relaxed/simple;
	bh=agBpTRCKDm2zMrbJUMGhJNC7rKWZvoeJNpljQnyjbm0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sQg/F3cRy2a9mvrobRgEfEIjH86fmBew87uRi5ckqD/hCpogARzgbQGQCnxqR+eRhJaS4GY/T635ny3eCYyjhpFU4q9wNTwaTk3/GWZ21Wl4fqrOkFXulLnuQQVfXo7+TmuAJu9u1/vZ8eU+FSzV4MzdSbKsVS3hho+k6WGltq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PUpPPRo9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PUpPPRo9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3099EC4CEC5;
	Fri, 11 Oct 2024 01:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610562;
	bh=agBpTRCKDm2zMrbJUMGhJNC7rKWZvoeJNpljQnyjbm0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PUpPPRo96Uyq8qiskws+cVAHFDh0pcgkQ3gVclODdbjfT44OMla1bpfBD49ztPX6c
	 /YMEld7gLLWrHrEqGQj5QOW7hefJ2fCa2712z3CIem0LjkxD+IjF6ZDs99EagLKB6+
	 O0USa8UiFteRpgTAgP2nEme69n1i9VCZWHTUIPoMYiqol4ckaAmJ+6lM5hqfg+ENqa
	 MjaynbifjbN0do7RjRMmT7IDbquyTZTomuI1LX7QwrP3NdnkYoHKpP0h1skZzOyakY
	 n/bIQIawh91OzLbAwqc7pdXApgfO2e69YOAXbh7iAsktlSuDpP7sR/27O+sHLc8Crh
	 tbxHKR7neMmCg==
Date: Thu, 10 Oct 2024 18:36:01 -0700
Subject: [PATCH 1/7] libfrog: scrub quota file metapaths
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860656387.4186076.3758519380219846681.stgit@frogsfrogsfrogs>
In-Reply-To: <172860656360.4186076.16173495385344323783.stgit@frogsfrogsfrogs>
References: <172860656360.4186076.16173495385344323783.stgit@frogsfrogsfrogs>
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

Support scrubbing quota file metadir paths.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/scrub.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index d40364d35ce0b4..129f592e108ae1 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -187,6 +187,26 @@ const struct xfrog_scrub_descr xfrog_metapaths[XFS_SCRUB_METAPATH_NR] = {
 		.descr	= "rtgroup summary",
 		.group	= XFROG_SCRUB_GROUP_RTGROUP,
 	},
+	[XFS_SCRUB_METAPATH_QUOTADIR] = {
+		.name	= "quotadir",
+		.descr	= "quota file metadir",
+		.group	= XFROG_SCRUB_GROUP_FS,
+	},
+	[XFS_SCRUB_METAPATH_USRQUOTA] = {
+		.name	= "usrquota",
+		.descr	= "user quota file",
+		.group	= XFROG_SCRUB_GROUP_FS,
+	},
+	[XFS_SCRUB_METAPATH_GRPQUOTA] = {
+		.name	= "grpquota",
+		.descr	= "group quota file",
+		.group	= XFROG_SCRUB_GROUP_FS,
+	},
+	[XFS_SCRUB_METAPATH_PRJQUOTA] = {
+		.name	= "prjquota",
+		.descr	= "project quota file",
+		.group	= XFROG_SCRUB_GROUP_FS,
+	},
 };
 
 /* Invoke the scrub ioctl.  Returns zero or negative error code. */

