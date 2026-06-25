Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770EB38B149
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 22:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782428179; cv=none; b=WQL51Tg4QixvCu/bSbMcA1LDK4WpHMQktXmP5ZeLApiFEA9E/DFS7SAhrve1tkILKtkN/08NwNmoG/QZpXjDFKhOBUgzgSuR3udoUcXWoEgfnRZwynTWSx3JJ5GzpZODaLDf1lKztlqiMeFeVHuVUeNQYaFK0Q+7ZvnnJX68kaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782428179; c=relaxed/simple;
	bh=MKrBbsCXn12d7bCCxj5HhVSHJn7n8MzVwdpB28ja5dY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U4EMN2tHF/eFNQ2pwXnkD+zCaW8QRALHtY1ebqdfdLg27YSO8jxnJIb0aJpJwOhrhJR+zTt2IgBLE5NVl/0k5YcxXpe6S6qY/SEXbvmxo7v15+A0yqTKkIITNiA2kbU0QqcajUywtaKXUauccjYLKgmKIeH/m6RVWer0mXB+T1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kNmE7qVx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kNmE7qVx"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 07AF91F000E9;
	Thu, 25 Jun 2026 22:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782428178;
	bh=0V/q5te6xVbtazsbQMQ8EX1iDtdAUFFrr0cokIwjK9o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=kNmE7qVxRuiTd2KNkiKJPQbGQyhZP/MAnV1PJ8542vKE40oCM+4ZnLhx9y8XkufMe
	 InXMIeUxdObSYFvOpNHm37ikpz5edhvpyfgxVzuaVG24P3JVvai7VPhbD0VGd3z3vX
	 0534jWlewnJcrL1aYQJOmJ22LeekTRmge3KLy9eEi1Asuh6A7b2iQAO/tzTiT4aPV2
	 l3seA5oh5wEDPyz6cYbrzT0lMb4h+e0yHL5veGpJLPXJI3hrYd/PrzsjYA8Rr8Sf8y
	 Blja0asLmJSO4xeIxmSkCWMItkv5ZvnNSdr0nCimDc2ngZ60ik/ol0ejznrD6mCVAX
	 s3YCVHifJ53YQ==
Date: Thu, 25 Jun 2026 15:56:17 -0700
Subject: [PATCH 8/8] xfs_scrub: always finish cleanup,
 even if reporting healthy state fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178242801452.1981574.2570766392535494985.stgit@frogsfrogsfrogs>
In-Reply-To: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs>
References: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex points out here that we should always release resources used by
the program, even if reporting healthy state to the kernel itself fails.
We're exiting soon anyway so this probably doesn't make much of a
difference.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase1.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 620a12393b3658..f1c9247e68a084 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -86,11 +86,9 @@ int
 scrub_cleanup(
 	struct scrub_ctx	*ctx)
 {
-	int			error;
+	int			error, error2;
 
 	error = report_to_kernel(ctx);
-	if (error)
-		return error;
 
 	action_list_free(&ctx->file_repair_list);
 	action_list_free(&ctx->fs_repair_list);
@@ -105,9 +103,12 @@ scrub_cleanup(
 	    ctx->verify_disks[XFS_DEV_RT] != ctx->verify_disks[XFS_DEV_DATA])
 		disk_close(ctx->verify_disks[XFS_DEV_RT]);
 	fshandle_destroy();
-	error = -xfd_close(&ctx->mnt);
-	if (error)
+	error2 = -xfd_close(&ctx->mnt);
+	if (error2) {
+		if (!error)
+			error = error2;
 		str_liberror(ctx, error, _("closing mountpoint fd"));
+	}
 	fs_table_destroy();
 
 	return error;

