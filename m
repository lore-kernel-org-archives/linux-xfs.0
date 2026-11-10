Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794271122;
	b=rt48/t1rR7gSQezPz4DjQ/1RQNtuXcgufl+C2pnIlXJjEy2eqcVMKpXLey4C+T+P0/Kx
	 gGz6KYmfOhlkEHtnWgEiL1DFQNdS/9a339xtxvnMj5o4mkQheA6BbVhJtwQ+ODDhpUU/o
	 4aWf1QfgRMKCT9MB/J2C7l2b4Xh7vjbS/4uEwWzPpuWCOnYLmvBqOXa8edg9fpH7Q9XZ5
	 1URWoBR8sWkaG2CEdkwp4FDijzrlodDcZewLYk2tVaxYX8xNH11vnmxVgVeIYr67H8DKe
	 7vpwMc1bePRTxD/cEgpzwsVRwqqpmCVChBogOgOttH+/I8pGVEvdsj1KAQLZz40xZMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=+z4gEdrh9ikBiVCeL3UXTzikWg6XyrrEOwdHqb1mQsg=;
	b=jPgDobqt1g5AQphb+RFDRynfuWBYLjdL8I5Y1hpiren06B5a0Gw3NoyOSl5KdWbysD3m
	 QUyv+/8uH4095bIld0ZCOL1PwY1KodNkvWFlgFAEBAgsxT5/m3sKQ9OojUe3/j77l8PYs
	 t5TyWSkIKvj95saV3u9GooeXySbTW/+W2x2YJiW8YJtc+lOFH7BgrtlkcXo/AuplG0tkL
	 8Wdqdf6iL6FOKs5xZIhXY30Sr4LC5R3N8P82oWzVmlbv7hmTHbdvKgKL0YtbLAaYRLdVx
	 fpEs9OVtKPaSXEEdDLAyx8XhWRGZiypYy+FbS1Funm0mPVo5UTiIIt+l+nIRfbT0WBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hEm1KFxT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D5F606A31C;
	Tue, 10 Nov 2026 00:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hEm1KFxT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902C11F0089F;
	Tue, 10 Nov 2026 00:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794271122;
	bh=+z4gEdrh9ikBiVCeL3UXTzikWg6XyrrEOwdHqb1mQsg=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=hEm1KFxTvUZHT2KS2fzf5Tqd3ge9ytvQRBzoEJsk+0u617AwVc8r/OMa2LMlHznWb
	 i99e9xXw49YbUv+NDoudoApVl71bOAfWmmYuvnpoU/ihfvIggADQODvsH65Y7SMTmM
	 sqqREX8wh1EZq0XDv6TnWdK7R9cWJzIHhM2CZK3q2DKqnGRyjUkJ5PCTe+zq2XkriZ
	 JpNXducbKp9iDp7ah8ZptN5r43cZjoGXjrIeO4V8agBGeK4WtHBnfdSLekMr/xPmb/
	 Wef3Xc1alT0YJ/fdx1HYPn46ijHQaUK3d51hcoPtRbe+VSQNpRNFIMg8LEoc+4non+
	 p0QH8MZvGNVCg==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	hch@lst.de
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: fix recovery of partial attr removals" has been added to the 6.6-stable tree
Date: Mon,  9 Nov 2026 19:38:40 -0500
Message-ID: <20261110003840.3527943-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Reply-To: stable@vger.kernel.org
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

This is a note to let you know that I've just added the patch titled

    xfs: fix recovery of partial attr removals

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-fix-recovery-of-partial-attr-removals.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 897ef7202b53bfff3fedff00517cfe5d19d45729
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed Oct 28 09:09:39 2026 +0100

    xfs: fix recovery of partial attr removals
    
    [ Upstream commit 30bb61651d2da5a502cf504bcdad16c093c1bb08 ]
    
    When running xfs/753 on parent pointer-enabled file systems with DEBUG
    enabled, log recovery will eventually crash after a few dozen iterations
    due to an ASSERT that XFS_ATTR_INCOMPLETE is not already set when
    xfs_attr3_leaf_setflag is called:
    
    XFS: Assertion failed: (entry->flags & XFS_ATTR_INCOMPLETE) == 0, file: fs/xfs/libxfs/xfs_attr_leaf.c, line: 3045
    
    This is because parent pointer use logged attributes, and the attribute
    intents do not track the work that has been done as the transaction
    rolls, and the recovery mechanism is to run the operation from scratch.
    Because of this various places check for XFS_DA_OP_RECOVERY skip work
    already done.  But while recovery tolerates an attribute already fully
    removed, it currently trips the above assert for an attribute that
    already has the INCOMPLETE bit set, but still exists.  Fix this by
    handling the case like all the others.
    
    Fixes: 1d08e11d04d2 ("xfs: Implement attr logging and replay")
    Cc: stable@vger.kernel.org # v5.19
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
    Signed-off-by: Carlos Maiolino <cem@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 5969840b8b454..b327ea0eb5c35 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2937,7 +2937,14 @@ xfs_attr3_leaf_setflag(
 #endif
 	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
 
-	ASSERT((entry->flags & XFS_ATTR_INCOMPLETE) == 0);
+	if (entry->flags & XFS_ATTR_INCOMPLETE) {
+		if (!(args->op_flags & XFS_DA_OP_RECOVERY)) {
+			ASSERT(args->op_flags & XFS_DA_OP_RECOVERY);
+			return -EFSCORRUPTED;
+		}
+		return 0;
+	}
+
 	entry->flags |= XFS_ATTR_INCOMPLETE;
 	xfs_trans_log_buf(args->trans, bp,
 			XFS_DA_LOGRANGE(leaf, entry, sizeof(*entry)));
