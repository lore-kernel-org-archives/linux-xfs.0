Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA4C14D717
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528645; cv=none; b=YzYS9XofZsLolITdC4aOAuzf2dRjjqIZW1Ezm24Dzqu3BJBPk409IKogCgdurO0BKuazoPLPL/eRMwkzLWsMRUiJn+ugsugG2Bf56t5xCTfMzpiEom9p06AZ/YfuTG2/r5nkxc/LEFmKyGLdsb0qLUHrIKptL09Tn4pHSFo6nOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528645; c=relaxed/simple;
	bh=4BfYSFcHhxL4EXCnY+b/qe1UNcmeXlhiH2BmsnM2Dns=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d0x4OkiNHaB1tVbRCZnueCSvs1ezzACH0L0GfiKAhNYzGqO/sfMQ8yT+GdROyVQS9c7vf0v9OuO6O4+pTEOEw6hg7yfvKGnnk6BfD5ImpbYLBjqYLZ+L5JasGfDfy4bxXG/Q4MtFqjqOx4zGcgADVv1/6626zqMHjFEeGxJ98Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ALw3A1Ng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ALw3A1Ng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484B7C4CED1;
	Fri,  6 Dec 2024 23:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528645;
	bh=4BfYSFcHhxL4EXCnY+b/qe1UNcmeXlhiH2BmsnM2Dns=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ALw3A1NgZATzonSUMUw878COTNIon3JJ3PmIwuIT/fw6d699WdWCPGkYJfPEFydUt
	 rrFFOuW7RwjnGgERNePS8CqaqEgHCELpLpe70CqFSHfVAZmYZV896AeIncEOwYs9UN
	 wJ4gfEi9lVm73X94YkUdb07NCPaueXcyuBftvTkmCKJFArQ3S2ruSmbmR9GcL1Sqeu
	 TYdd4y6kA2bcA9Hi8u3SLNiRrswWp8TP14WceK7yL4tjASf/VXQ0oV7nOzmqssF5Ff
	 /XWkH7d/X6OglZ97LSs8iAIIXEYiILUuM3kZOLq59FU42RiQAjz6ETI1NQqgk1bJk7
	 S2GTtnhC2UDTQ==
Date: Fri, 06 Dec 2024 15:44:04 -0800
Subject: [PATCH 17/41] xfs_spaceman: report health of metadir inodes too
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748498.122992.14830696708287221369.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
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

