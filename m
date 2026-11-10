Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794269385;
	b=COxUJ9akMkBTBaDKoJtq6ZRfmYKguJoFbFP/Fdts/xcP0i7oJ9Dqymd4XJ7FgGUoGe/E
	 pac4Q2w5tFZD25jgFLdzK+AP7GxSSKvwDe+tQrnFCCGM31NX4nON1t2CMV8b1FRhJ5tJ9
	 xSibR3BK/eNi41anjQ/AWXoRo2Mqbyh89wfKsmY/PhjIW9MGkMMW4JQpTTHIYN90ZcvOF
	 W0NVrrrpFpOhBZJuBvhAeKHmiJYPZ1ef5Nn1dQrT1TB9ECOFLcwDBxC7us37X1by7XhPp
	 K4A+oWqWYPIFRz30B19WNorwK7KTFNnt9KlaIKHH0WYnLNIXbXEno0a1NTj2SBwwhLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794269385;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=htA4teSdzj07DF8bLbD3CVTxNu6BBp2/gbp8nW+sqYA=;
	b=qGaeDUxL4xxY8qMyJLdeP7Gh/0y/5ZSNm6Z8Sij4Tnl+8wZxuLm8eyrCgNjAgzDCW9iy
	 DIlW+1PHqoFgkh0dSFeVG9HLqgCYllXzAtteX0ptFLrs/cR5iQZQvZiRXdm9BUiTfE2wL
	 oNl5JaG+lWKp6JO95uM11H/sl0otfiYmUxuYAN02/2477pmthdPx5q6PUHOgmGQZZ7a66
	 f9cCIPJJJkv14687RhAKZh9X+zxL68GaRqj0ZuA5p4hpL9vXqyUjXfXfCdNRzd3flpFg3
	 /GdNuUmsTaAm1zuRtDtmjGKarWM3vOabHq8+1wdzYHSElQLwvp3yQ8R0EsaCd92bOPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ds98yjGo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243DE606A33B;
	Tue, 10 Nov 2026 00:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ds98yjGo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BB01F0089F;
	Tue, 10 Nov 2026 00:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794269385;
	bh=htA4teSdzj07DF8bLbD3CVTxNu6BBp2/gbp8nW+sqYA=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=ds98yjGoynFNR9DKNkU8moGzumw41oEAa1DiJeFeoR1yfdHBAzwVIfu3ufXv3XfKl
	 UefyDk1PqNkS6Ze92tQsgqwNG9iT4dYVev2DDKk5mbID+6G38ndMMmqCb5ngFLP+p2
	 zHyLhu+qCGQOQy2wTsWjCrH3v84ALul0xhXoztfqbG5PlyAxi8serEnvghnwq5XhpC
	 6AxdKLon9LnToccuyrCFy74TE0gRvRoDKyV38txXipG3FEoMawK060ez2/hMYlVlNj
	 UG52XkZNbyhY8bnppL3zSJSDUwOi3s6v+Go1rBmghcj4zjTVXilMMhpqMW9acPbw4O
	 xGjolSQ1DCMzA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	hch@lst.de
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: fix recovery of partial attr removals" has been added to the 7.3-stable tree
Date: Mon,  9 Nov 2026 19:09:43 -0500
Message-ID: <20261110000943.3488532-1-sashal@kernel.org>
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

to the 7.3-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-fix-recovery-of-partial-attr-removals.patch
and it can be found in the queue-7.3 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit ee067ecb28110088a13ee363a13eb78f69dd8db0
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
index 02ca50442b466..5b1fd62714205 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -3042,7 +3042,14 @@ xfs_attr3_leaf_setflag(
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
