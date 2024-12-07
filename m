Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B039196
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529833; cv=none; b=FhEbgwE/ADYkTnxnfo0hZ4NsbIfB1k5A+v+XF0WP8lusDxYXpmnsZB7YapMw6cDH9QueE5+W5zrzLbxJPRWWJfUzyzlNdHAEKXZIXA06JUIpY6r6hjh8WtAEpzLI9ir+C5wmVTHezRdjsgZWpo/9ydvM0we4IsnsIsBSCDoGkUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529833; c=relaxed/simple;
	bh=n6LwDZlESYIlO/JutBqcqmz2/VNgCaQ3r7l4pr5XZ2o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VgE6vd2kOYvnPXqJ3gAd7EULx+bQq/S2SgvSDEs64KccaKM3BQvXCv9kXhxkj24noCVS42fo1KdaiCpIoUDnX12J06Mk97WVQ6pIXFVM0HlTldpAebrOtV2W5L30dSqz6I6AyfZ74oo7A7ew+H/yHXQ8dlu2PkttEx4e+HfaZoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qDqTERLF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qDqTERLF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37EFAC4CED2;
	Sat,  7 Dec 2024 00:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529833;
	bh=n6LwDZlESYIlO/JutBqcqmz2/VNgCaQ3r7l4pr5XZ2o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qDqTERLFo12MwOmxiS0P8IEwoaJ3IRhOgho73r3O1nMLecnmfj2aEQ5mKPl75Fy7P
	 MytblSEv+gI1aY+aQG6UxoVIgiyCjBLi9A0P1G5U34Yqtp96lVTPQwlFsc/Z28kKVH
	 jdX56uC1AZZkv4xe125Am/xbZjg0TVCwN3f7mIWZraHYPgzDpK7nhrK40CCr6A19d1
	 97slt1vWK8OTgt2uRJa32V+hET+8Ca9k6m1T38zvPSpx6TluPCPQJ4ARpiD3qJrmIk
	 ViFy/iUidHqSAYtkwAbHBGptKs2T7l0pS8gJiFlKJCabG/o+5WjCRRy5wU08NwomQk
	 YSx9bocP99tRA==
Date: Fri, 06 Dec 2024 16:03:52 -0800
Subject: [PATCH 2/6] xfs: fix error bailout in xfs_rtginode_create
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: dan.carpenter@linaro.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352751229.126106.6830567491969634308.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751190.126106.5258055486306925523.stgit@frogsfrogsfrogs>
References: <173352751190.126106.5258055486306925523.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

smatch reported that we screwed up the error cleanup in this function.
Fix it.

Fixes: ae897e0bed0f54 ("xfs: support creating per-RTG files in growfs")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_rtgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 8189b83d0f184a..aaaec2a1cef9e5 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -493,7 +493,7 @@ xfs_rtginode_create(
 
 	error = xfs_metadir_create(&upd, S_IFREG);
 	if (error)
-		return error;
+		goto out_cancel;
 
 	xfs_rtginode_lockdep_setup(upd.ip, rtg_rgno(rtg), type);
 

