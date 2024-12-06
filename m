Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69626148827
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529473; cv=none; b=VCK0ddh9otw2L2JjVHE1wnCoVCJWE4WCM8j+rmB7AoksIWAV8HUjVS2eJDwbW+w/5w7SRx2Sc105MqvnYm8FzvJZT938xMEmnZHstQUDF3d+0MRmbhVBXJvUxiac0uCRhZGV0Xiq6f2Vp1Pnkqx7EF6+j4EXuixxMGBJEsoiWBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529473; c=relaxed/simple;
	bh=AIWsSQwbnOvu9kKIx20k6NzGtTywIDcsGeBzSR3apwk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N3PT+S/C3uTnN3oAOpLHTwgLXc6Fu0jzlgP9UO4N/JmjHd16GnuhKWX0mh3fT+LCcUigXP+GRCl45BmYdvITz9pB23LVuqGg/a6CUxXkuPiGBl7JLy5JPNRLnaHxP9krM6l+Jn51kvoZPj1jv17OM+FpAkCIZBc4wdBijfsgCWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LrqaVe4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LrqaVe4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB5EC4CED1;
	Fri,  6 Dec 2024 23:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529472;
	bh=AIWsSQwbnOvu9kKIx20k6NzGtTywIDcsGeBzSR3apwk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LrqaVe4k4NuKDczG344uEC3my3s1QxyfOOTmnTLs/8ZGLODmcej62abQjVoONnoJT
	 ftYeP0pbKvmWB8QOWgXUd3LDZFlyf5RMFxcTCCwhFPOxXynwpLPirwtp0cc/7IKqD6
	 RRHwObjfhYvbBph/4QH9t7C9s2lNsbrCHfw7TceF7cpxJahVe1tS5fLEs1z5AVu+Zq
	 s4mDz+DuXq0Xs7Oq9cwr2M+CnYXcx9Q4Xk7S8AsNSSvG4y/RpsdXMuKPZxKb4YdLBt
	 MBOUs5Peywt1ubKvMPcH3M+9Yv1T1LqDT1QOIJu+f8ZNB/eiywBDyDb4UbbAnIPC6t
	 hGv/ApJ5TeWhw==
Date: Fri, 06 Dec 2024 15:57:52 -0800
Subject: [PATCH 25/46] xfs: support error injection when freeing rt extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750377.124560.4551235483062587434.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
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

