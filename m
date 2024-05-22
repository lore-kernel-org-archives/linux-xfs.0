Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA555221
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 06:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716357706; cv=none; b=rOylU+O9dhDEHY4l4WZ/LJSRyppuIvRlbiw3+KnimubR+6WKLelfemzFsw9CD3jkCC8VYDCffc7/OJ5HyGUdwZRkK3u9XxLtgVIybfZo8fux9DJYSUr6pr4Rv+8TKu6XsEO+gzNMurAHiGdTssSuW3hRKDvFpkJeU1WkEw2/e/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716357706; c=relaxed/simple;
	bh=lamjiOdMSc1c4l6TdLyUBxzaTEMTZByTgH/gJvqxIpQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MnTUwIF9CT8JAn/eDz4MZFDCZUy3POzgrMq6RCo4hfBjHBu+48XeL99QauNbgodA/iB/T95LtRidKS5Zi8rW/4e/KiVlDx9SYBiT1oLx8V0H34ESRguRvDOtK8XjCcvt4vTG/PwHmc2CelkAbQRCj5GxXnERFlrXmIs2cIFOgTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n9xY1LNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n9xY1LNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F060C2BD11;
	Wed, 22 May 2024 06:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716357706;
	bh=lamjiOdMSc1c4l6TdLyUBxzaTEMTZByTgH/gJvqxIpQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=n9xY1LNyK6TLAjOOpmnyqBlPouh3Kr7alTN6am5JoOujtCnn4V6prtjk1vtXruDPv
	 ZrPD4DQepDdo0LIP/Axdmpli5v5dNCBsTqkzEw01gW2M9I3GxH0KKc2iAK17ILtjSq
	 VO03r5qRxwjt0Su4FBSmI0Z8nedlmlMMlCkNxD5X60YirkZc9m9AkwnvDkCZokc+KY
	 vdbAntRI4dF0i97Y+QMf2TemAKOtTiiLrcI84phBbyx9k5v/w8e6I9l+zew7XQIXa9
	 fgVtCYrID6XJLAJcPquFGlpJNFFIUiBfNXRJOi9c3q1T92GG7RjDIwcjRubIo3F4xd
	 niDwmyMhVE3zg==
Date: Tue, 21 May 2024 23:01:45 -0700
Subject: [PATCH 1/4] xfs: drop xfarray sortinfo folio on error
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171635763387.2619960.8422112844689648321.stgit@frogsfrogsfrogs>
In-Reply-To: <171635763360.2619960.2969937208358016010.stgit@frogsfrogsfrogs>
References: <171635763360.2619960.2969937208358016010.stgit@frogsfrogsfrogs>
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

Chandan Babu reports the following livelock in xfs/708:

 run fstests xfs/708 at 2024-05-04 15:35:29
 XFS (loop16): EXPERIMENTAL online scrub feature in use. Use at your own risk!
 XFS (loop5): Mounting V5 Filesystem e96086f0-a2f9-4424-a1d5-c75d53d823be
 XFS (loop5): Ending clean mount
 XFS (loop5): Quotacheck needed: Please wait.
 XFS (loop5): Quotacheck: Done.
 XFS (loop5): EXPERIMENTAL online scrub feature in use. Use at your own risk!
 INFO: task xfs_io:143725 blocked for more than 122 seconds.
       Not tainted 6.9.0-rc4+ #1
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 task:xfs_io          state:D stack:0     pid:143725 tgid:143725 ppid:117661 flags:0x00004006
 Call Trace:
  <TASK>
  __schedule+0x69c/0x17a0
  schedule+0x74/0x1b0
  io_schedule+0xc4/0x140
  folio_wait_bit_common+0x254/0x650
  shmem_undo_range+0x9d5/0xb40
  shmem_evict_inode+0x322/0x8f0
  evict+0x24e/0x560
  __dentry_kill+0x17d/0x4d0
  dput+0x263/0x430
  __fput+0x2fc/0xaa0
  task_work_run+0x132/0x210
  get_signal+0x1a8/0x1910
  arch_do_signal_or_restart+0x7b/0x2f0
  syscall_exit_to_user_mode+0x1c2/0x200
  do_syscall_64+0x72/0x170
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

The shmem code is trying to drop all the folios attached to a shmem
file and gets stuck on a locked folio after a bnobt repair.  It looks
like the process has a signal pending, so I started looking for places
where we lock an xfile folio and then deal with a fatal signal.

I found a bug in xfarray_sort_scan via code inspection.  This function
is called to set up the scanning phase of a quicksort operation, which
may involve grabbing a locked xfile folio.  If we exit the function with
an error code, the caller does not call xfarray_sort_scan_done to put
the xfile folio.  If _sort_scan returns an error code while si->folio is
set, we leak the reference and never unlock the folio.

Therefore, change xfarray_sort to call _scan_done on exit.  This is safe
to call multiple times because it sets si->folio to NULL and ignores a
NULL si->folio.  Also change _sort_scan to use an intermediate variable
so that we never pollute si->folio with an errptr.

Fixes: 232ea052775f9 ("xfs: enable sorting of xfile-backed arrays")
Reported-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/xfarray.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index 9185ae7088d4..cdd13ed9c569 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -822,12 +822,14 @@ xfarray_sort_scan(
 
 	/* Grab the first folio that backs this array element. */
 	if (!si->folio) {
+		struct folio	*folio;
 		loff_t		next_pos;
 
-		si->folio = xfile_get_folio(si->array->xfile, idx_pos,
+		folio = xfile_get_folio(si->array->xfile, idx_pos,
 				si->array->obj_size, XFILE_ALLOC);
-		if (IS_ERR(si->folio))
-			return PTR_ERR(si->folio);
+		if (IS_ERR(folio))
+			return PTR_ERR(folio);
+		si->folio = folio;
 
 		si->first_folio_idx = xfarray_idx(si->array,
 				folio_pos(si->folio) + si->array->obj_size - 1);
@@ -1048,6 +1050,7 @@ xfarray_sort(
 
 out_free:
 	trace_xfarray_sort_stats(si, error);
+	xfarray_sort_scan_done(si);
 	kvfree(si);
 	return error;
 }

