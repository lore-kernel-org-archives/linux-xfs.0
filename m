Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270138;
	b=wOT/hQP1p91+DInpk8mrDG0QKsL91JTuPDTq6wdLNQg1kVrumzLD3CG9nb8d7sy/EyN4
	 U3bXJsBzCZjg4+HLgtdQDK1+S37dqMfUwENqFzo+JCpl8f6T6xkiMrM6rGHCbfL76XtR7
	 fhRVtNKDE+BDmCXtY65V46Egde7vHl1F8dZ12t+OFFwKso3DPoocW0rKY+wuDDpS94a+d
	 Na1JzJX6c8tjlN5KHr1UMv54nF6EuEoif+L1whpmMiFCdHs+4ilxwG7beewWBgZW3EoWg
	 BUt8sEt37/FWV7ADQqXtfiv8fjcjKaaATIV3eftvCqpZ4q3hRGVkoLCWHRmas6b+c/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=5Pfmi/oyelBH8ax5UuwsjqgZONObekDoc5+sahFWCHk=;
	b=NyhZG8lBEU/pFGc+7+ZW8/z08IOTSn9RRcqvoQRUsWia/Y6hqZk1kC4nIr2EPnO/+tsh
	 jdXqGuGuvFQPCoUtQhls4Wi2r9EV0uPRQ6AyH1OqtiOcJT8RyW8tWPdlbxkVWAuwFDKAi
	 nDIRRqRlrwc5AVYYvXBCSgIoWi4gLHjz8YzgDxGbdHNkRVdIcHe05iVkZkDgFOkWBcBlx
	 1LQDQvEPNh38Bq2LhNvicqwO2dpbSBnOyzJ8zBHKfpjgQ2ffo49KEl5iJYVZmDOKEnzFb
	 Lb6719FoQ97hbNWy3hVmH8zm4r/rZ2DDRP5kK08n/BYca/2ypWpMb4H2iX/ZOmfFALA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gotvOGOz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A80606A31C;
	Tue, 10 Nov 2026 00:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gotvOGOz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF061F0089F;
	Tue, 10 Nov 2026 00:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794270138;
	bh=5Pfmi/oyelBH8ax5UuwsjqgZONObekDoc5+sahFWCHk=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=gotvOGOzVtys9FuzmWxVIkZLLjNZ87+nhwpBj5yusBf5daZcy+FRNzE/fjoiAgQyX
	 euz6C52knq6AXSyx1T3JDhx/59U7ylP7DnhTl0z1DXAhIj6P/QLokjdsVNcUXhVv5+
	 GPfdmjPR+e02El7hXY7Ml+X3htHllMjpjtEQN/CiCpY2xrMpYLOgWslWWxUgAENlw4
	 ZqSPbrzNhJYByl/dSw+rjdwcW+Wac1BwIPYYj5snGx9/jMF1FJPgsAMNPJ8D8wcDTq
	 MUoM3l8qU05rCgP23ZYTD9jNFhnV90uxAD6p0RC9f91kaivBcRjjRY8L612+F3dCSA
	 kPO+1d2weBVnw==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	hch@lst.de
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: fix recovery of partial attr removals" has been added to the 6.18-stable tree
Date: Mon,  9 Nov 2026 19:22:16 -0500
Message-ID: <20261110002216.3505950-1-sashal@kernel.org>
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

to the 6.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-fix-recovery-of-partial-attr-removals.patch
and it can be found in the queue-6.18 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 2dc3eff9bd101959068498d475771fd9b8a86437
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
index 914f5dfb6463a..a6fe8a845079c 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2948,7 +2948,14 @@ xfs_attr3_leaf_setflag(
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
