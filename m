Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794519988;
	b=pEbjdcoGQknNFYfqRiYttD+PP0b4RFaYxoQiL2ZVTpVWSdQWTEGAu5QklHYj23iqHEfK
	 v+uiU2mLHG4FD+2TyQKBCmkBXhrXUPDiLG6fi4ne5ttoKEUWuGNF2tvhMEpjhdHmYJ4SS
	 rQSi1lWnSYt1Sm1yO+sIkJeiXXJPb58Bfd72un8+M4d9WhRar2Z9UCdChRMDRZADvYuvY
	 cD0IYTIaAtk7Dt/rHruAMvlfmJ64ZMMBoxYil0t8hLhEbqwzsTCvJ4otOhkySML12Ssl4
	 Hi8FOqWY/ZE+ktGCiOn+21ntDdLsi5AuYDNtcw1gEhBWjSqeclYJozzCW2Ys3qUz9hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794519988;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0WgGCAQ6ZswRtz/411IeWHlnT9QPp1lpAQcb5MXSGoY=;
	b=MjoL5MiWgGtXNIb7LVW5UXBxbyxLQ4GrrOEu9qUEatrZwdSr78p4z1EoVjKNLtQfMIHD
	 ZxFRFT1THRdZ9mM0TDhj6PZv2OneeBwNK+4wk3Y7BC20L8INP0AHJKj+hM5nN5sIkBlt/
	 uDbeZzW8WytFHyCllwaH80xUVdk6T4CGmf3hVsQHLlbOQnNIJO45EM6f3Tyckt8gozMX5
	 HYd9crzXVrjPMvbuVtB1Ii/WfP0UZNLXt/8Pz9+wOMkDzqViRSjkT/WU4sl3u57gbh7bY
	 bn5JVQY55Ae6cerBkkVKw3gpkQbSf+eZlRUZCA2C9FQAnIhdR5uqfmfLDwtYXS3ZMdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MEduDbuH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EB5606A890;
	Thu, 12 Nov 2026 21:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MEduDbuH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9961F000C4;
	Thu, 12 Nov 2026 21:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794519988;
	bh=0WgGCAQ6ZswRtz/411IeWHlnT9QPp1lpAQcb5MXSGoY=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=MEduDbuH64Z1dIS5pVfbphMZsFZL8PqoTr5aJ/4cI5lxsylzIhl99rMKQk7ie2Iwq
	 WTZ2n/a6QLb2YxXxonZuwirCPpnaR5YHh3VGejGxtLoTwghev/0SIxYCxc445QoOw1
	 9QAOzDGi4qY5LqCYPFZ+kr6i+mOJx6bDX3Rv8afwqQasiPxxnNJtIkk2EV+2fg2+W4
	 P9lCUAiOJr4Pk2UdlnigfM8to+1cktVwzWZhc+YLE98KEo/VjITzeJAMEnbbI5qnRI
	 Dycwxf+y8jCV3Dpxs2Hk8nHPxpatJ3JXWYu1lmo82OOaJKn/HMMGfmQ5Gsx1tRwDw8
	 HVfU4oFAfDPbQ==
From: Chris Mason <mason@kernel.org>
To: mason@kernel.org,
	tytso@mit.edu,
	cem@kernel.org,
	david@fromorbit.com,
	jack@suse.cz,
	djwong@kernel.org,
	josef@toxicpanda.com,
	hch@lst.de,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	tz2294@columbia.edu,
	brauner@kernel.org
Subject: [PATCH v9 12/14] xfs: restart faults racing with realtime flag changes
Date: Thu, 12 Nov 2026 16:46:16 -0500
Message-ID: <20261112214604.67875-13-mason@kernel.org>
In-Reply-To: <20261112214604.67875-1-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On a zoned XFS, a store through a shared mapping can dereference a NULL
pointer if the realtime flag of the file is set as the write fault
starts.

xfs_write_fault() reserves zoned space only for a zoned inode. The
reservation can wait for garbage collection, which takes the MMAPLOCK,
so it comes ahead of that lock, and so does the test for a zoned inode.
FS_IOC_FSSETXATTR can set the flag of a file with no blocks right after
the test:

    write fault                           FS_IOC_FSSETXATTR
    ===========                           =================
    xfs_write_fault()
      sees that the inode is not zoned
                                          sets the realtime flag
      takes the MMAPLOCK
    xfs_buffered_write_iomap_begin()
      sees that the inode is zoned
      /* ac is NULL */

The fix used here is to test again under the MMAPLOCK, which keeps the
ioctl out since "xfs: take the MMAPLOCK in xfs_fileattr_set()", and to
start the fault over if the flag has changed.

Fixes: 058dd70c65ab ("xfs: implement buffered writes to zoned RT devices")
Signed-off-by: Chris Mason <mason@kernel.org>
---

Notes:
    v8->v9:
    - The flag is tested once, in __xfs_write_fault() under the MMAPLOCK.
      The four tests under the ILOCK are gone, and so is the -EINVAL for
      callers that are no faults (Christoph Hellwig).
    - Was 11/15.
    
    v7->v8:
    - Only a page fault gets -EAGAIN. Any other caller that gets to one of
      the tests fails with -EINVAL, as a write and an fallocate do. pNFS can
      get there: xfs_fs_map_blocks() tests the flag before it takes its
      locks (Christoph Hellwig).
    - The warning now says "during block mapping".
    - The helper reads the inode number with I_INO(), and its comment no
      longer says that the flag is stable once the inode has blocks.
    - Was 11/11.
    
    v6->v7:
    - xfs_direct_write_iomap_begin() tests the flag too, as soon as it holds
      the ILOCK. It could allocate blocks for a COW fork extent before it
      got to the test in xfs_iomap_write_direct().
    - The assert on the extent size hint in
      xfs_zoned_buffered_write_iomap_begin() moved below the test of the
      flag.
    - Dropped the Reviewed-by of Christoph Hellwig, since the patch changed.
    - Was 10/10.

 fs/xfs/xfs_file.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 78c9668c806b..6ff544c0934d 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -2076,11 +2076,22 @@ __xfs_write_fault(
 		lock_mode = XFS_MMAPLOCK_EXCL;
 	}
 
-	if (IS_DAX(inode))
+	/*
+	 * The caller picked the zoned or the regular path with no lock held.
+	 * The realtime flag cannot change under the MMAPLOCK, so look at it
+	 * again, and start over if it has changed.
+	 */
+	if (xfs_is_zoned_inode(ip) != !!ac) {
+		xfs_warn_ratelimited(ip->i_mount,
+			"RT flag modifying during page fault for inode 0x%llx.",
+			inode->i_ino);
+		ret = VM_FAULT_NOPAGE;
+	} else if (IS_DAX(inode)) {
 		ret = xfs_dax_fault_locked(vmf, order, true);
-	else
+	} else {
 		ret = iomap_page_mkwrite(vmf, &xfs_buffered_write_iomap_ops,
 				ac);
+	}
 	xfs_iunlock(ip, lock_mode);
 
 	sb_end_pagefault(inode->i_sb);
-- 
2.55.0

