Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABBD38385
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991485; cv=none; b=nmVzo9OsfXdJ1zLyvecxAZJLUS1sP6SxOY3ZYQ+8I2nRSZDJAhcwFtscDt4I4YD/opMyrMZlBR80rPVdW8RChCVulWTV2PxSd4YpfyD+sdHiJWUkMEc+Ymcfk4TgdGyFSLC8svHCcEgZ/mXsHbZpVwtewZRvG1SX+rQuD/FcEbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991485; c=relaxed/simple;
	bh=AIWsSQwbnOvu9kKIx20k6NzGtTywIDcsGeBzSR3apwk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Si4KsTcDILvK8k5SqaNQe0VtDqB4mTxG7jrmdF5ybQzDTIz6+a/pueYkQjtRs7BptYIQuByuJu4DQSkW7ePucl9QsKedDy3kQZo6rJunfjfqC9NCeck7etuooDht7/zcIybmcDz4DG3NrIEHeLeq8GJ2Sp5kWx37EMPjKuE+ifM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eWP/EWYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eWP/EWYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DB7C4CED3;
	Mon, 23 Dec 2024 22:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991484;
	bh=AIWsSQwbnOvu9kKIx20k6NzGtTywIDcsGeBzSR3apwk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eWP/EWYEVQMa/QBOiTB/hoOWeSh9mw6s/bPlBVDXQ9uRrOxpf09BofB7ax/8E2+9g
	 gyHeIgSMxapvdVN/+TiDr7OCqxtS8G9HKk5/seze0fVo9nNyIz3ZKlP3RT9iaYQWeg
	 8Th6X3c63Yup6HnswdiFnPE+ovZA1A4ZVRyQQGwrfuyTDvB6DkgamKspCT+FVLUyEJ
	 Avh6p1zZTfP+m2a+5XjV1Dpj/odMy05Qp+B5qHmPZclWgRcVWBRWOofAhBAg4fD0eT
	 5+rmZ/urLc/3Pipue1cTZJKMLbZECgdkfnYYDv81lpsMzSbbJCXJ7sR/a+INRmkDSS
	 rwFONudv41igQ==
Date: Mon, 23 Dec 2024 14:04:44 -0800
Subject: [PATCH 25/52] xfs: support error injection when freeing rt extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942878.2295836.121877672492161325.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: fc91d9430e5dd2008ef6c1350fa15c1a0ed17f11

A handful of fstests expect to be able to test what happens when extent
free intents fail to actually free the extent.  Now that we're
supporting EFIs for realtime extents, add to xfs_rtfree_extent the same
injection point that exists in the regular extent freeing code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtbitmap.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 580e74b7d317db..b6874885107f09 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -19,6 +19,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_health.h"
 #include "xfs_sb.h"
+#include "xfs_errortag.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
@@ -1061,6 +1062,9 @@ xfs_rtfree_extent(
 	ASSERT(rbmip->i_itemp != NULL);
 	xfs_assert_ilocked(rbmip, XFS_ILOCK_EXCL);
 
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_FREE_EXTENT))
+		return -EIO;
+
 	error = xfs_rtcheck_alloc_range(&args, start, len);
 	if (error)
 		return error;

