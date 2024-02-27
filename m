Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81129F4F1
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000562; cv=none; b=lS48cQ62ObTSCYzvaprcMzmA0TXhozutnmDpJVrKcL+zWCG/hAF6omTHUSGzYrWyf3C/s+NbaQNTVtqRyuGXver++gfu83uRyXuQ5BrL4ePUX++1QhygJ44byMg5ws61Z4wIgRYA0vMy+Pae9k2Mmkwe5MfVl3lv7/zrPStPWM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000562; c=relaxed/simple;
	bh=rXJEIBihuxs+buvrESMPc3fe4Jel0GpqagXDmAQy0Ng=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BHZqZoS2tMkVGSAWZ82K+JfFnrR05AjEQMuX0z7fZNsd8kZfRyH1hTAgMKfzVAGFwgRzmJTMY5G+1eWJMpFPQdyWwIvWdJxWHNVkohI4xk+Ie2YerVI6/Qa1RtfBusiMNZMKrYRahvc61EaDvOqn11cg3uSKWhyC3ZfTzvrj70M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mLDsZPZj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mLDsZPZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A650C433C7;
	Tue, 27 Feb 2024 02:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000562;
	bh=rXJEIBihuxs+buvrESMPc3fe4Jel0GpqagXDmAQy0Ng=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mLDsZPZjSxmuEWBw5pZbvdmYaC8BLM7M89XhaKPuFbKhCzTA+BekHOlJN7aUM97RR
	 Kg6ofef7KiRwdtYIxyjrEHGSvJSPRCvQAiVxn7gGuoYm/nufRWRgmF6u5EhIHjkOW8
	 AaGSZbP165Oh8O3yfSPheCGcmuSrIkaa+PAWnFni5DSrG0cWx72UjhHj/8uQz3BxX8
	 kpl/x0TL33/IEdyBIAvdsCaGEouPpbdi5gESxbKp7yKPMhrBZhH1SM2kRVwr77oCk0
	 2CFbiV1zs4/xBHymQaxfZrHYIo7afZBvXS/Xvb1QPwvjl13qxekpkUAQlJ2gqDEn0G
	 tLQXKozLLTh1A==
Date: Mon, 26 Feb 2024 18:22:41 -0800
Subject: [PATCH 07/14] xfs: add error injection to test file mapping exchange
 recovery
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900011758.938268.1094556064125267882.stgit@frogsfrogsfrogs>
In-Reply-To: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
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

Add an errortag so that we can test recovery of exchmaps log items.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_errortag.h |    4 +++-
 fs/xfs/libxfs/xfs_exchmaps.c |    3 +++
 fs/xfs/xfs_error.c           |    3 +++
 3 files changed, 9 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 01a9e86b30379..7002d7676a788 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -63,7 +63,8 @@
 #define XFS_ERRTAG_ATTR_LEAF_TO_NODE			41
 #define XFS_ERRTAG_WB_DELAY_MS				42
 #define XFS_ERRTAG_WRITE_DELAY_MS			43
-#define XFS_ERRTAG_MAX					44
+#define XFS_ERRTAG_EXCHMAPS_FINISH_ONE			44
+#define XFS_ERRTAG_MAX					45
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -111,5 +112,6 @@
 #define XFS_RANDOM_ATTR_LEAF_TO_NODE			1
 #define XFS_RANDOM_WB_DELAY_MS				3000
 #define XFS_RANDOM_WRITE_DELAY_MS			3000
+#define XFS_RANDOM_EXCHMAPS_FINISH_ONE			1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index eddb0972e344e..228eb15fce212 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -437,6 +437,9 @@ xfs_exchmaps_finish_one(
 			return error;
 	}
 
+	if (XFS_TEST_ERROR(false, tp->t_mountp, XFS_ERRTAG_EXCHMAPS_FINISH_ONE))
+		return -EIO;
+
 	/* If we still have work to do, ask for a new transaction. */
 	if (xmi_has_more_exchange_work(xmi) || xmi_has_postop_work(xmi)) {
 		trace_xfs_exchmaps_defer(tp->t_mountp, xmi);
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index b2cbbba3e15a5..b23e22222f804 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -62,6 +62,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_ATTR_LEAF_TO_NODE,
 	XFS_RANDOM_WB_DELAY_MS,
 	XFS_RANDOM_WRITE_DELAY_MS,
+	XFS_RANDOM_EXCHMAPS_FINISH_ONE,
 };
 
 struct xfs_errortag_attr {
@@ -179,6 +180,7 @@ XFS_ERRORTAG_ATTR_RW(da_leaf_split,	XFS_ERRTAG_DA_LEAF_SPLIT);
 XFS_ERRORTAG_ATTR_RW(attr_leaf_to_node,	XFS_ERRTAG_ATTR_LEAF_TO_NODE);
 XFS_ERRORTAG_ATTR_RW(wb_delay_ms,	XFS_ERRTAG_WB_DELAY_MS);
 XFS_ERRORTAG_ATTR_RW(write_delay_ms,	XFS_ERRTAG_WRITE_DELAY_MS);
+XFS_ERRORTAG_ATTR_RW(exchmaps_finish_one, XFS_ERRTAG_EXCHMAPS_FINISH_ONE);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -224,6 +226,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(attr_leaf_to_node),
 	XFS_ERRORTAG_ATTR_LIST(wb_delay_ms),
 	XFS_ERRORTAG_ATTR_LIST(write_delay_ms),
+	XFS_ERRORTAG_ATTR_LIST(exchmaps_finish_one),
 	NULL,
 };
 ATTRIBUTE_GROUPS(xfs_errortag);

