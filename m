Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794271779;
	b=AwMIpOQeDT4CHICGlurAvZ0GpZfatANE7BnycXjDO2pIGj9hs5/Lgaur7iPrkrjIiy9S
	 lRRLd9efwV7n1kyeRsGU7IAfsDuq0/yULbzH4O1DUPbaTRRcpjyQruzYFrSJA94YBSvWJ
	 iySh5g4GAwM9A0LFubNvNOLGxCGqFCYQtk3uS+zQiVLDvMFDmlD72zjOZUACm8I8GsyBD
	 FpJy3qzEVNGqvT9k/H3s/kXgimg5FfOGRGtvLKAGCgAtL0Z/s6Qd0qljlM9kMVWtV5tug
	 IgOvSbHDjhecHgku59khpIlFBW9saw6+AuSns8/008GLAbsmrIeXfVVkR6sSHVGuAdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=fiyeA4r1YH7vDQMqVyF4EzYIXYuSuaTTLcXUjNhAzhU=;
	b=Gi/sVhwCcR1jfx/vP7vhuy0bhO9pGo1gQGxS2kl7p0Hp80AclTBiXpC/IrquH7jFn5S7
	 aK3IaVSSVS3s6+o7Tax07km29lsCdUhiZ1UPNaA5Kzlg20sU5tthAjyB7POBC4gZxB81j
	 b0mTTAErs1rtQEQ/p8ge3Bu6W6011LwGGEjlTBG2DW7swftJVCC0dNkC4fw/KvQ48+bTy
	 mpqv29pRLJvjNxgo5+vNpVlFcPvBqOD4I6P+ISOpn3SdxdsdNvub8VPB+uJ3te5cK9+MD
	 s8FGni8RdOxEYW9w/QN1TFzQHvJhPMJEe8GErQPRvU4cv641w+Vz7YpIQ1vGIojUlZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Bc/LBC+S";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5346606A326;
	Tue, 10 Nov 2026 00:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bc/LBC+S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05A51F008A4;
	Tue, 10 Nov 2026 00:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794271778;
	bh=fiyeA4r1YH7vDQMqVyF4EzYIXYuSuaTTLcXUjNhAzhU=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=Bc/LBC+S+nflf3QTyOak4MuWYFWa+GTqEwG/yjaMlhex1jq6tdxuAp909mvKATqjG
	 gccCoekVxfQtITlf+KusQjjXYqxXVMPnu/2biX6AF+pueb/mIhqTkyLcRktaRfAnCG
	 tG2NcuXME3g0g27WCz4XS32X2djMk9xWiT2U5JKRfppf/Vt1sDBIEpv1YG2ODk5w6n
	 FuhoLT/Eone56GoEmVGYANwyoxhOTVf/GKfy5ZXdkPySo84WH+5XMzsp1f271jVWSS
	 4CZmlRdwi/s8I/7PHdiDMIIMSUFzecYjbO9kjDkY95YKdfeziiXMWav14oGOpzwaj6
	 Mug2UtB7TZn6w==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	hch@lst.de
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: fix recovery of partial attr removals" has been added to the 6.1-stable tree
Date: Mon,  9 Nov 2026 19:49:36 -0500
Message-ID: <20261110004936.3538903-1-sashal@kernel.org>
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

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-fix-recovery-of-partial-attr-removals.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit fddbce0709c7243997903abf3fb2220ecd833a91
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
index bdf4fe0146b7b..344e166cbf7ca 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2931,7 +2931,14 @@ xfs_attr3_leaf_setflag(
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
