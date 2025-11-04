Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69CA314B6D
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 09:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762247704; cv=none; b=GBnNKRp4LE32Q0aqRm+TwIj5kg22MRhNZUCBviy+npwXU3yzqDragO+xZaReKTnweeCaba5Fv3KX3INRK0tU0CWRj1gRx5QAiTT4QtDJ8tXR4mho662RTSl1Ghpi5Wd2D077iVQkYWhRVi6aLZz38g7lU4CT2Vsvmsy8nw98XWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762247704; c=relaxed/simple;
	bh=WCHRKJG4h/qF6rkPM/jXlEGVDcHQMW4Qmr+YBYBa01Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UBBO5FzpBQF2IUAvqaq68kdXe1l4ezJNKg1o5oNMY9lprPNlAWCgKzcCQ8/OItbvZPZ+TEXF6RNCCrYFmEU48ENiwpzRZwbKlhBr5kHsq1Xq/QSMyczv+47XSRc61MDo3BBbxPvcEJECJyhk9ho4azfzNpSW1wl/UMaLoPuglyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WeSuGgv/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WeSuGgv/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7707C4CEF7;
	Tue,  4 Nov 2025 09:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762247703;
	bh=WCHRKJG4h/qF6rkPM/jXlEGVDcHQMW4Qmr+YBYBa01Y=;
	h=From:To:Cc:Subject:Date:From;
	b=WeSuGgv/HzZVtfbXDcpMT4TU+rNjp3nqkOeS4NN1pQM83cjCpURn7dj9wWEsY/XUg
	 vD+GhzPcfRny6Gs/gM+yN0FWi83d4yidRrMwk+Ok9dU7yAHrMlcM0+HFvDnCNsQCNq
	 fdOSMo6cFUCpTUXrQQ7dpWOpmLbUZhle8Y4dAkh0Ufu2ZTf98AunKiCWgn7VblEKED
	 Ei7VwfZenlVaTBFuwt+C9rjtTT0sgPLLgMyYKXYa+Ko9+xtCUAYxP3r5f0vbfVH0jl
	 ypxjrwO6JF0AFn4N/n6HW9lu4PGy3m6M58NNY65zr2Zez1csKI033YGZcBw+x1w1By
	 LzYMpCJE5Gh8Q==
From: Chandan Babu R <chandanbabu@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	cem@kernel.org,
	djwong@kernel.org
Subject: [PATCH 1/2] libfrog: Prevent unnecessary waking of worker thread when using bounded workqueues
Date: Tue,  4 Nov 2025 14:44:36 +0530
Message-ID: <20251104091439.1276907-1-chandanbabu@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When woken up, a worker will pick a work item from the workqueue and wake up
another worker when the current workqueue is a bounded workqueue and if there
is atleast one more work item remains to be processed.

The commit 12838bda12e669 ("libfrog: fix overly sleep workqueues") prevented
single-threaded processing of work items by waking up sleeping workers when a
work item is added to the workqueue. Hence the earlier described mechanism of
waking workers is no longer required.

Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libfrog/workqueue.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
index db5b3f68b..9384270ff 100644
--- a/libfrog/workqueue.c
+++ b/libfrog/workqueue.c
@@ -51,10 +51,6 @@ workqueue_thread(void *arg)
 		wq->next_item = wi->next;
 		wq->item_count--;
 
-		if (wq->max_queued && wq->next_item) {
-			/* more work, wake up another worker */
-			pthread_cond_signal(&wq->wakeup);
-		}
 		wq->active_threads++;
 		pthread_mutex_unlock(&wq->lock);
 
-- 
2.45.2

