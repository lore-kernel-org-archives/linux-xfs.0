Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052544C7D
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608783; cv=none; b=b5TGyjaCuNGCCaSARLFxbLjnrePWV+ysaJ0XI9aazlAJCyRqIWISzjHMKvv8oP18nF6LjP5+q5P+eu4CvgzS5/7C+fNdvwJU37WUUvvF9XHMcjf3ZMmP0jevlvAZ0AJ1f5mabblqpmxmOdJ+LsbnBXQifRR+5OAuOHsCFMp0HnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608783; c=relaxed/simple;
	bh=UamPD1cBLp3qwNsRbPtR7FoXqQ2uWOt20uFGHhaRtR4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tr3mANyomvYiLACLFOJCn8TwkkcfwgTnG2Hmzpxjmhq7gcu5RP4gezHKYdr/GqbBWHOLZaUZ/PNW7Ky+c2I2k076eEsxW7KkbOB82C9Mm/hv3pNtg/tvfv7Tl6CPbAyfWW5T0qeKEIMDAZ8e42O/HyVF5JbT4h0KHq+F477jp/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=invRgBdK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="invRgBdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08BAC4CEC5;
	Fri, 11 Oct 2024 01:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608782;
	bh=UamPD1cBLp3qwNsRbPtR7FoXqQ2uWOt20uFGHhaRtR4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=invRgBdK2tAM+zdvrhhAeAGM1AkBaSREvyDLS40BV8qGSW0RYkvPesNKy/oLZMejJ
	 nAlCE6WEmpb2lV9aOIssEf9od31422WaxnLgHEHcR7Gx/9sNezeoPpT0LL41AmBHqI
	 zFsPe4JUv1bLOjwKLj6c3CSQWKJzTr1OxsuPYx2EEQTGHVwlItra6IuFUT8QF3+GsG
	 gd/BBwiOD8Bg1P6KAG7gOwkDketM5vaAG03sIzKdUp0vqbkc456TpEHZh8LNjd5au6
	 a5iaRX8smyIdz2FUibEyJCUanT/TxglDQtmsbGUCyIkAOD+nT6AiVK/sfJBD/scury
	 lJR6bVIk6khxQ==
Date: Thu, 10 Oct 2024 18:06:22 -0700
Subject: [PATCH 18/36] xfs: support error injection when freeing rt extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644553.4178701.9077639317148463059.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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

A handful of fstests expect to be able to test what happens when extent
free intents fail to actually free the extent.  Now that we're
supporting EFIs for realtime extents, add to xfs_rtfree_extent the same
injection point that exists in the regular extent freeing code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index cae0b22397d007..c73826aa4425af 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -21,6 +21,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_health.h"
 #include "xfs_sb.h"
+#include "xfs_errortag.h"
 #include "xfs_log.h"
 #include "xfs_buf_item.h"
 
@@ -1065,6 +1066,9 @@ xfs_rtfree_extent(
 	ASSERT(rbmip->i_itemp != NULL);
 	xfs_assert_ilocked(rbmip, XFS_ILOCK_EXCL);
 
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_FREE_EXTENT))
+		return -EIO;
+
 	error = xfs_rtcheck_alloc_range(&args, start, len);
 	if (error)
 		return error;

