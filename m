Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8751422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990531; cv=none; b=ExZROAKRCKgkBQP7KgD8t8/p0lTt5/ogG5tvZtZ217x2dHu0LLfWC4KNEPluDeq2FFJWoDWzYE+XTeHLHamauXozvNKkV8AUWrq2QOJsOL4Xx1fTuzSrL9LEJM0SFEY/1/aWaMrW02UwuIcHk2mUzZLYlyhw8bRfQnhYBI5boSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990531; c=relaxed/simple;
	bh=voXgngq/bwGPPRW3vqkvRgXGV+PFRu/J9E94Egb20yw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VP+I4ZGQ8usLxn7j7v7EtwMCLWEMIdqTHQcjqB+fRV6Z0BZorCq8/OiVm+UyINGoul+4mzqKI98wXHqzo0/yV8rk2PfEZVGfvnTYqSoiMf1HrXGTkIr9lpgDnWoiFgHgxnKXGGxf7oI6ulUhd3CHHUwKW/aCGfL0GPiXOtWzEvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H+PsOsL0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H+PsOsL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C61C4CED3;
	Mon, 23 Dec 2024 21:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990531;
	bh=voXgngq/bwGPPRW3vqkvRgXGV+PFRu/J9E94Egb20yw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=H+PsOsL0fav/Pa49ABndHNypNOTzwsy6mPPyhSfHLAMTFAVeh4YHDskUAyd69rcxf
	 gH/n54C+gmMIiE7HHK7qT7/+vIMU38pdXZIiKOTvI0XnPIWHqVI/KEV2wB0D9KuSs+
	 LAne4DDBvk0TIVPd5auSSQ5AvxXYFTvJgfxfFt6M/5jbHTyL6bEIK28cG5kaXsuf30
	 Ej1VArzTBJ0xRc0/UuSK9reoJc+bekHB/3S/korgqX4SLVc9VHlQQOl8o3YDcLpX+h
	 Ob9GHbqAhAIpmTI59If97ZNlU8Kj2TBCUNyIe3AQ9HRwQRoFXtRNiGaI/Wkcam24Er
	 P7NN/E71qLw+A==
Date: Mon, 23 Dec 2024 13:48:50 -0800
Subject: [PATCH 09/41] xfs_db: disable xfs_check when metadir is enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941106.2294268.4061755876736342352.stgit@frogsfrogsfrogs>
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

As of July 2024, xfs_repair can detect more types of corruptions than
xfs_check does.  I don't think it makes sense to maintain the xfs_check
code anymore, so let's just turn it off for any filesystem that has
metadata directory trees.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/check.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/db/check.c b/db/check.c
index fb7b6cb41a3fbf..37306bd7a6ac2d 100644
--- a/db/check.c
+++ b/db/check.c
@@ -831,6 +831,12 @@ blockget_f(
 		dbprefix = oldprefix;
 		return 0;
 	}
+
+	if (xfs_has_metadir(mp)) {
+		dbprefix = oldprefix;
+		return 0;
+	}
+
 	check_rootdir();
 	/*
 	 * Check that there are no blocks either

