Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39D81422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990672; cv=none; b=O3XnEGYfuhZ2J9O1u9ppYUTHmXAmZOjB1aPAOwOhSClOLqUkt81d1qyi9HRq8+H3+QU4r7oFbUmhYvwy/UBHC0lQL7FFZlnGtnY3KLvmaPgVVeWKNagb2gPHLSHIUqCkbER/kDl9ST7srYTX2XR0bnGPMViw3Kf3xOFerscJI1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990672; c=relaxed/simple;
	bh=yZFjOm1lE6ybdMQsEpXqpGqL/tUAsmWxE1ewC+nR35w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ArIMPUwgV18QGzP3kU1vj0LhPLCsmidgo2HmyNvLADY1gfa4p1DedydtSJZayZVYJY2ra38mAJGJHHxftgbHLBv2UxmNw3xmXp4xZH1WlfC+2M1ovNxp5RgueYycqjPfAiIDVbKnwFYxG8Swf/bqGy3vjbLwzuB0sRJdDZwsCwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=frs47lf1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="frs47lf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81E2C4CED3;
	Mon, 23 Dec 2024 21:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990671;
	bh=yZFjOm1lE6ybdMQsEpXqpGqL/tUAsmWxE1ewC+nR35w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=frs47lf1q47GTzZCBbh3YG4G5Spj6B2mxJ5Aj2jOQSJBNcpmiywIGeA0+YkD6XuEW
	 UIJtSCrMgp1IVM5w1WWnDbFowoNSYtq4W1dV3LVsAmq65wsg4qgmV58D5STOnuDJf4
	 MJaWrkc6WHEjzSRfgZF3J9DIDMU7TOWfx37ZVt2m+VElHjN2du+wnmkMUY7bMOwDhr
	 Xz3er5UtuiO9/0LSGFjyB4PEN+SDmSCbZtv/xiy0N+x6CrGq75ob78FAW9bQBtIH6i
	 hTrzxj/HDHtGdi9Rb8icSGizfMjrXJRukyx3j1n1fan/mIVf9hE89sGvfsHpW+z5wv
	 CPWngwscYQGFA==
Date: Mon, 23 Dec 2024 13:51:11 -0800
Subject: [PATCH 18/41] xfs_spaceman: report health of metadir inodes too
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941244.2294268.3005435014722968067.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 spaceman/health.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/spaceman/health.c b/spaceman/health.c
index d88a7f6c6e53f2..c4d570363fbbf1 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -324,6 +324,8 @@ report_bulkstat_health(
 
 	if (agno != NULLAGNUMBER)
 		xfrog_bulkstat_set_ag(breq, agno);
+	if (file->xfd.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_METADIR)
+		breq->hdr.flags |= XFS_BULK_IREQ_METADIR;
 
 	do {
 		error = -xfrog_bulkstat(&file->xfd, breq);

