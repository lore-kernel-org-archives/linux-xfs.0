Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C54513F426;
	Wed, 19 Jun 2024 13:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802544; cv=none; b=mXOJNY9r5E9wbqh8iY1iJ2Rey4JdXGLsppO2uJou104pg9L3Eq6O+p90b1h+BFnAto0LNWAz/BzBZoIFsheLloNOzJN6LF1mGcAiS8Ak592N5Sfp9cogJfRsLrJvsNQipj/9496kj5AQkhTnpsqe+DeeKooII9NfY0fCnKIEKGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802544; c=relaxed/simple;
	bh=UM+/6Zmk6L7AyyhKwP/dTL3iV+ggR8L0ar4wJ/0DGnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHtjlTWc9sjUX2EpO/gvPUbIuwzseFcTZRlUE5UZ2sZ/dSNGSCcdcWl9E3AsJytj0oK9vE1pNzzKdkujQmHDCqF1ZLQdnUodN8HC4lKAt/mY+g6HhZM2+nZ+Is/auFcNXYZHLPaQjcWOrbMXI0yuMOR+fRR2p8UDROlQ2qS2eNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OOE0Rw7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OOE0Rw7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C5EC2BBFC;
	Wed, 19 Jun 2024 13:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802544;
	bh=UM+/6Zmk6L7AyyhKwP/dTL3iV+ggR8L0ar4wJ/0DGnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OOE0Rw7+bUR6icGD46DSEZvR9GHOcnGEKoi1Q6DUkN1pSLZPUYcTDlau8i2SuAdu/
	 ndvOETA671MTqIQtsFF7W4Jjojszs5xIccZxcBjonKrUrIWffZ3kpQwmb5BrGSCxWk
	 b3VEajXHfyVOAM3zc5gLV8aZ7Qk4Cv3iR5NXgj60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	Chandan Babu R <chandanbabu@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 6.6 233/267] xfs: shrink failure needs to hold AGI buffer
Date: Wed, 19 Jun 2024 14:56:24 +0200
Message-ID: <20240619125615.267123185@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit 75bcffbb9e7563259b7aed0fa77459d6a3a35627 upstream.

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
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_ag.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -979,14 +979,23 @@ xfs_ag_shrink_space(
 
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
 


