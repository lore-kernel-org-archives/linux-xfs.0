Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C2E21353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425429; cv=none; b=G1sCJYllgrbJ+yKt64e0/mC2h1jaSeWsseveI/o4dD59aU9A6oVhZ81W0frNkYUl7rbwdySpxy6lDEkluq+202UeKAufdnWUrbKXOQXGCW8ASvL/E+Fr5DedSeX4yXxwjW7/Qlt1pTRVC1UNk+509QVN4a7pzh20y7R61LyRW3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425429; c=relaxed/simple;
	bh=8O031Tv35PzSuvnUm9KeFBCTQnMu+s7WqX0mbfvPAUg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SE9t4eOR3K6eSMe22VHGBJoyMLpyeQZ9tStDGX7BbplF/SotR/JVcOaj2FEYR+LI2riXy4PWWTo8o0dwPUvOAD8LXFfkknUN4xHq/TDnPRD/EMQtFWId1PB2GSRzSO8hjOy6yDPcIqWZywTA5EMdoFBPc5sn2hyYxxUVqPlUXYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IoJQLBeo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IoJQLBeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9B8C433C7;
	Tue, 26 Mar 2024 03:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425428;
	bh=8O031Tv35PzSuvnUm9KeFBCTQnMu+s7WqX0mbfvPAUg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IoJQLBeoYQziP5X4LPEvJE80d7VFjwsbAEo80rYn5N3PKQeOF6mUNNAJKpB55IcqP
	 6qW+Q5tg8LjByFejJewMKAAAcZUSnEqeUyWDvkynCX0A+29Eg7ewU53b6+epw3eF/7
	 CjldRIaLXMzDrjPzPb0ZUBIP0je66Jt7FjUyHWMqsRL39HABCWxVDmPc5MLVva8FXv
	 LnZh+tnhKkucXBBuB7VREf0w7y4A+AzktsctrHFqBxSSWqxVwppyNYZ2B05tedXVRN
	 Nvvbn6h9Pe9IZBE1evQ3j8/W3RbbQHUnYhppEpTrGVkPj8XxvefPc1AJoZPfMyvKm7
	 C+4WrrgnAtMxA==
Date: Mon, 25 Mar 2024 20:57:08 -0700
Subject: [PATCH 110/110] xfs: shrink failure needs to hold AGI buffer
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Chandan Babu R <chandanbabu@kernel.org>,
 Dave Chinner <dchinner@redhat.com>, Gao Xiang <hsiangkao@linux.alibaba.com>,
 Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <171142132962.2215168.9592594282196819345.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 75bcffbb9e7563259b7aed0fa77459d6a3a35627

Chandan reported a AGI/AGF lock order hang on xfs/168 during recent
testing. The cause of the problem was the task running xfs_growfs
to shrink the filesystem. A failure occurred trying to remove the
free space from the btrees that the shrink would make disappear,
and that meant it ran the error handling for a partial failure.

This error path involves restoring the per-ag block reservations,
and that requires calculating the amount of space needed to be
reserved for the free inode btree. The growfs operation hung here:

[18679.536829]  down+0x71/0xa0
[18679.537657]  xfs_buf_lock+0xa4/0x290 [xfs]
[18679.538731]  xfs_buf_find_lock+0xf7/0x4d0 [xfs]
[18679.539920]  xfs_buf_lookup.constprop.0+0x289/0x500 [xfs]
[18679.542628]  xfs_buf_get_map+0x2b3/0xe40 [xfs]
[18679.547076]  xfs_buf_read_map+0xbb/0x900 [xfs]
[18679.562616]  xfs_trans_read_buf_map+0x449/0xb10 [xfs]
[18679.569778]  xfs_read_agi+0x1cd/0x500 [xfs]
[18679.573126]  xfs_ialloc_read_agi+0xc2/0x5b0 [xfs]
[18679.578708]  xfs_finobt_calc_reserves+0xe7/0x4d0 [xfs]
[18679.582480]  xfs_ag_resv_init+0x2c5/0x490 [xfs]
[18679.586023]  xfs_ag_shrink_space+0x736/0xd30 [xfs]
[18679.590730]  xfs_growfs_data_private.isra.0+0x55e/0x990 [xfs]
[18679.599764]  xfs_growfs_data+0x2f1/0x410 [xfs]
[18679.602212]  xfs_file_ioctl+0xd1e/0x1370 [xfs]

trying to get the AGI lock. The AGI lock was held by a fstress task
trying to do an inode allocation, and it was waiting on the AGF
lock to allocate a new inode chunk on disk. Hence deadlock.

The fix for this is for the growfs code to hold the AGI over the
transaction roll it does in the error path. It already holds the AGF
locked across this, and that is what causes the lock order inversion
in the xfs_ag_resv_init() call.

Reported-by: Chandan Babu R <chandanbabu@kernel.org>
Fixes: 46141dc891f7 ("xfs: introduce xfs_ag_shrink_space()")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_ag.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index e2fc3e88244f..a9aae0990d93 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -973,14 +973,23 @@ xfs_ag_shrink_space(
 
 	if (error) {
 		/*
-		 * if extent allocation fails, need to roll the transaction to
+		 * If extent allocation fails, need to roll the transaction to
 		 * ensure that the AGFL fixup has been committed anyway.
+		 *
+		 * We need to hold the AGF across the roll to ensure nothing can
+		 * access the AG for allocation until the shrink is fully
+		 * cleaned up. And due to the resetting of the AG block
+		 * reservation space needing to lock the AGI, we also have to
+		 * hold that so we don't get AGI/AGF lock order inversions in
+		 * the error handling path.
 		 */
 		xfs_trans_bhold(*tpp, agfbp);
+		xfs_trans_bhold(*tpp, agibp);
 		err2 = xfs_trans_roll(tpp);
 		if (err2)
 			return err2;
 		xfs_trans_bjoin(*tpp, agfbp);
+		xfs_trans_bjoin(*tpp, agibp);
 		goto resv_init_out;
 	}
 

