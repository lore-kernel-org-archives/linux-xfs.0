Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4085AC2D4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VfUZUCpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0AAC433C8;
	Sun, 31 Dec 2023 23:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065892;
	bh=zLthbS7jPwqlBiGnSmS71nekqEWLWXiUWEe8trziTJ0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VfUZUCpuKaOgdBT6FPTZaAUtbamLzJD97YNbQ4uk6qs/zRViRghPUSJw2DAQBcYtM
	 ATlLDiOrcEvIce9K8WxlsDC5A5H0uMkEJt7GL/foW890RUc5Ej5MgRPJvJkbbhOhdO
	 HOSTk2xbpghovbkAYObqJ6zDgN3zt8Zy8LtmrzBhToA9nHda/MfD7J29TjxApX4r3A
	 PV/b1SToyqbcgM5Qw9sq+vtZRQmvK7xDfGe9YfCOKQlb46XIIOn1GYXjBhUmt1dgIy
	 UV+Q53+d8GoBaNld4n3dMR2ZLoAJp4OqgqtzDCqqKcuW0Z+fgoxeTMfySiQ3dvNsCR
	 +obrzWfhPL0dA==
Date: Sun, 31 Dec 2023 15:38:11 -0800
Subject: [PATCH 33/58] xfs_spaceman: report health of metadir inodes too
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010388.1809361.8669562355794267273.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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

If the filesystem has a metadata directory tree, we should include those
inodes in the health report.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 spaceman/health.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/spaceman/health.c b/spaceman/health.c
index 8ba78152cb6..47cf9099492 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -328,6 +328,8 @@ report_bulkstat_health(
 
 	if (agno != NULLAGNUMBER)
 		xfrog_bulkstat_set_ag(breq, agno);
+	if (file->xfd.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_METADIR)
+		breq->hdr.flags |= XFS_BULK_IREQ_METADIR;
 
 	do {
 		error = -xfrog_bulkstat(&file->xfd, breq);

