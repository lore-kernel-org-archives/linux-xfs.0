Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4491E0DC3
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729192021; cv=none; b=RR866af4bbHOk+1uqr7nVTeTi6EeRpe6AbBkAdvoHXAjXe6ESW1qHKGpVp0g8YP+SPulIHTY9FwS2VGH0ZOhS/3eLzebvkAdnTS1WyODfPlJ5MKJuD0AdqPGZvdMgc2NwLyE0u4CJxVAEWJ/Bm9LGpOXEs2A2XFdLD72kA+TWqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729192021; c=relaxed/simple;
	bh=UamPD1cBLp3qwNsRbPtR7FoXqQ2uWOt20uFGHhaRtR4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q/ODuKk71m/476OkO+i4vZhwmxbS9lWFt9BBReQZd4Nkmvz7blW3MRHxc3uMpfE0WO2nZGTK7uLgDEwi7q3C0ABRVA7OSXFQ9nqTYt6Toww6cuTN2ETpfLm/TMpen3jIL/iaP5SdBVHqiAaSyP5b+Q5Qai94MBd9p3g77cX2Eio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UuHD5DD1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UuHD5DD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C883C4CEC3;
	Thu, 17 Oct 2024 19:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729192021;
	bh=UamPD1cBLp3qwNsRbPtR7FoXqQ2uWOt20uFGHhaRtR4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UuHD5DD1Ekj98iS3pTJGBiYDKBRkwzijfHErxBw50SEGVh33kAn5VXOpabWhJXTaQ
	 YeWWq+7NngQHfxvJE6RyNdZFU9IjdpsxcLktnOZfxmLpf8vzbNirANPeAMQMFXUTpd
	 YcsFE8nNJLn1ccp4lBcM82BtkZqcDCUPEsJs1dAYT3r6nbWofRjRGV1a5CXpgy0/vi
	 ZMA7XuFuzqlHElfhpKoIYp/2ptVLCaVbgDapLF1Opgs00rJe/YDcFcEDKdqtYlR+ep
	 sTsi5fLLS63QQ4pMTXViJqw+HL2AM658CdtBYodfGPirIEFFVSY+EQ6jGO3cJZTJsP
	 jZwKGIjRX/k/w==
Date: Thu, 17 Oct 2024 12:07:01 -0700
Subject: [PATCH 18/34] xfs: support error injection when freeing rt extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919071979.3453179.9098747688844513291.stgit@frogsfrogsfrogs>
In-Reply-To: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
References: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
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

