Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0412931579B
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 09:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762247712; cv=none; b=A+rwc/UcluBoczRLY7Q6MhcCTgc3p43e/bEZKn32kbl6uY5rtE/kt9s/OGHx6d9YEXxpAo8J85oCJktv7NiS5QeeqLr1t27t5Yu6se39HOiA3pSS7O3stLviO/vDdeyp+za7hCg9uK8bbNHn46JPfSUkbzruNRaXwlJRzd+2d5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762247712; c=relaxed/simple;
	bh=e4s3VvuBQ2pnWlWSJUk7XK2mG4q18yaNAD5ALZL5ozo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sj3Csio/8ZkVfqM4V5UcOCjg4lXGrZn6BuMatvp/G/1nt3ubBvkmraeVTS4eYPWVr2EtL1ptXTfI2P7hCn61OBY2MnU07sCOupOegHZ5m0d0iMkV25EF4oKq7Osaqs/9lI8N6o9pfHM6LyiVsPcAlklLSvPtfx4g1F5yhwVEpW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oszyRlfp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oszyRlfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04171C4CEF8;
	Tue,  4 Nov 2025 09:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762247711;
	bh=e4s3VvuBQ2pnWlWSJUk7XK2mG4q18yaNAD5ALZL5ozo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oszyRlfp+/AxtrBWis7Dx265McS5jbkPen877D1PlVKSJe29s/WqNMIfTxwXMKAm8
	 PN25zku1E2eDrkckHjpLuiXR9sYHiNpov+jvug3Z4erJwpHDeF+xUYpr7akyEE7i14
	 D9c+PpJ0ATfVboASxvwIjyHvNpxAr6PXSjAavXgTsTuHEmpXFgQplCP5kHdDfUt616
	 kYcXVC6zr0fQqTfNd0YvMlZvXTTpwqJSlL+g/rZXb5YKLLYwURbhXcBG0vz4cXuTNr
	 5/ARAbubZUOTkv9oxT2KgETCLK0Jn3ukUVYNrfsdnlTGDrl9sBhOC4PnBm+krA6iTd
	 SBHWrzj6fE3Ew==
From: Chandan Babu R <chandanbabu@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	cem@kernel.org,
	djwong@kernel.org
Subject: [PATCH 2/2] repair/prefetch.c: Create one workqueue with multiple workers
Date: Tue,  4 Nov 2025 14:44:37 +0530
Message-ID: <20251104091439.1276907-2-chandanbabu@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251104091439.1276907-1-chandanbabu@kernel.org>
References: <20251104091439.1276907-1-chandanbabu@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When xfs_repair is executed with a non-zero value for ag_stride,
do_inode_prefetch() create multiple workqueues with each of them having just
one worker thread.

Since commit 12838bda12e669 ("libfrog: fix overly sleep workqueues"), a
workqueue can process multiple work items concurrently. Hence, this commit
replaces the above logic with just one workqueue having multiple workers.

Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 repair/prefetch.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/repair/prefetch.c b/repair/prefetch.c
index 5ecf19ae9..8cd3416fa 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -1024,7 +1024,6 @@ do_inode_prefetch(
 {
 	int			i;
 	struct workqueue	queue;
-	struct workqueue	*queues;
 	int			queues_started = 0;
 
 	/*
@@ -1056,7 +1055,7 @@ do_inode_prefetch(
 	/*
 	 * create one worker thread for each segment of the volume
 	 */
-	queues = malloc(thread_count * sizeof(struct workqueue));
+	create_work_queue(&queue, mp, thread_count);
 	for (i = 0; i < thread_count; i++) {
 		struct pf_work_args *wargs;
 
@@ -1067,8 +1066,7 @@ do_inode_prefetch(
 		wargs->dirs_only = dirs_only;
 		wargs->func = func;
 
-		create_work_queue(&queues[i], mp, 1);
-		queue_work(&queues[i], prefetch_ag_range_work, 0, wargs);
+		queue_work(&queue, prefetch_ag_range_work, 0, wargs);
 		queues_started++;
 
 		if (wargs->end_ag >= mp->m_sb.sb_agcount)
@@ -1078,9 +1076,7 @@ do_inode_prefetch(
 	/*
 	 * wait for workers to complete
 	 */
-	for (i = 0; i < queues_started; i++)
-		destroy_work_queue(&queues[i]);
-	free(queues);
+	destroy_work_queue(&queue);
 }
 
 void
-- 
2.45.2

