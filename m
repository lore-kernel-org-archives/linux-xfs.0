Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FD418E023
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846076; cv=none; b=ZmJtLW7UC8+vmoluoggCE4A4ji7XKDvuWwsmhzKNycX1q2jzYuC3tVRl+kB/8ZEX3WH5CHsmbq6ubWu3hnkkKOvpBIUIkXzsB46Wyr2wJxWT83s2xKTkbT8dnryXqIxLrLUVEsScDd8Y9ttBMv0sVj5XSp7tkkV98DhRWCbepgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846076; c=relaxed/simple;
	bh=UamPD1cBLp3qwNsRbPtR7FoXqQ2uWOt20uFGHhaRtR4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n9DqSI8AmliJK1EDS/bJIbkYDL3eiPjJXXmrANpVmOZTFQayso3GRAIQe9LCusRaOxRypwQl8ipONGV4KlgiLNQ00lRZLF8CItwZGmnsUCZWTxLvs2RMqrHXgbO1OzkJoR0SuFW1hVr1mgEdMuKl1isNa8ykgiVswrho8RFF6iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iuwb/V/R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iuwb/V/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01A4C4CECF;
	Tue,  5 Nov 2024 22:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846075;
	bh=UamPD1cBLp3qwNsRbPtR7FoXqQ2uWOt20uFGHhaRtR4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iuwb/V/RoQkRhO1yqtXQ1OwlV6oF2j2SV/4TRimtL87F90zUgQnumGjyJc0FUu+as
	 p1tAshDyz4mZZwIXGdzSoekTKMRaQr/C/SlXictTfbLxrkSUP9Newi1Dcfazv2Ur7p
	 BZ/6Zmy1j6O+H2xOCFzpneM+14tr7LU73wlh2wlJY3NgmqATy44jQQLTpM0Gid3fzb
	 SHES0BE73cJsjGaz1RHcejV734mnf+UTdjZCgYJu/fqFD9vx8KHIB0Gqlwe5VezOa4
	 eXrF/A8UbuLPiBJpGNrkOaS4UyR142Y796u8otwn5hs0n7/Bl/Wsz5Z16YuyXVdEoh
	 7uc1GSN8P0XDQ==
Date: Tue, 05 Nov 2024 14:34:35 -0800
Subject: [PATCH 18/34] xfs: support error injection when freeing rt extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084398492.1871887.7462090207112849816.stgit@frogsfrogsfrogs>
In-Reply-To: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
References: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
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

