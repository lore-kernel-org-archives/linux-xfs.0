Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270702;
	b=e//xi5+Ck7yphpDU3d+AW8+6O1gOoLtxSITHSBaS6xRSh8o6/NVeWNkiSjtAr6WUe6oi
	 bosh+UdD6DRGrfBWN4uy/cgPM+mNDOEX+XRZG7VJP1LRoAJ0GPXjE3B/D1dhvlZ+vtFG0
	 0eNtimmyNzZB/2H2W8Y8NSI6/8IAWmtxJ5Lj3Gi4f9zzGzjRKbnGd/HOw+yzD9aruYbw8
	 4Xo2tURcRr5jpr66fNN4BFMQMpku5l8FheeU8w1+xVg4pQHR64hsS+nTLaLW20urSUW9F
	 psp0eZR68YxRJ92WqNA163yKS7eI/eC42kUfwgVLBHHS710n+9JbxUXqi5Ue7Tyae4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270702;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=WV58SF/BdBk2Bc4+7ANgntpWJt3lSkglHhwzYRq6N8M=;
	b=uOGwiV8TndnEs9c85uwfwsUfkm94Jirfb41c0bTFYqYOlmpYkwAKomDO/4HXtzxTuFH4
	 5rWwrsjHFxXOqGTZs1L4KGuqRonvpwdrJqQ1ItUp79XaA5fvuOKvhDZp+8J92Uxi/KNoE
	 qvc/XxSJkvxZsBhejmISGah/TboF483JEYbr8yhYYtAdoaNp+JL/+ukxp2F/yBiXJZ3y9
	 cUnsA2MfbV7ze/6gjw2uY26x9Zs462HkBz/x8eJ8asQtQo/hw4zGxr2479RMz77TTmmek
	 E6XA9BLo6+7e/wMJ/Hnhrcd0IxOrfdY4Vz0mNHFb/ijtIcRXJapE6YqIuVtklFKacUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SpNKnzi8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52810606A325;
	Tue, 10 Nov 2026 00:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SpNKnzi8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5131F0089F;
	Tue, 10 Nov 2026 00:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794270702;
	bh=WV58SF/BdBk2Bc4+7ANgntpWJt3lSkglHhwzYRq6N8M=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=SpNKnzi8JTx0vg8uaH44Yg18nz8zuRr2z8PjE2w9pzFBVSbqOGiszIfmUkSHyrIaN
	 yoRNfrti3mXKBJMaJac3nnUsdI4cqAvnYrusgKM9kP9bDFC4N1HtiHm1waNHJLWfje
	 ISGI9kyYNwinqG36lsvNk+g9n1QSxpGFykJbUz4iE62mufLR+4luOlOpt2IlcxJ54o
	 Haddb8W+NHmScG6Fl18cs+zBt6qMah6kNPSXjzhrqcZPF/u9JoBVxJTE1FzSgEMOV8
	 APUUwU/iFWWcHitkKoenPAgPPazi1cM1UcquQUJ52ke4wCeMejvl9PxkmyGYalb21K
	 5PKUAUuPJNzDA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	hch@lst.de
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: fix recovery of partial attr removals" has been added to the 6.12-stable tree
Date: Mon,  9 Nov 2026 19:31:40 -0500
Message-ID: <20261110003140.3518492-1-sashal@kernel.org>
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

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-fix-recovery-of-partial-attr-removals.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 8a340bb93ef082f03ebb4b072e2a86002390f8ed
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
index aef8d66a016f9..b3f1eaa1ec45a 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2961,7 +2961,14 @@ xfs_attr3_leaf_setflag(
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
