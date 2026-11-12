Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794519987;
	b=WFPQILHX15DBXdUapAYIMHtIkxeWruduEtRoSUXwXX1XHzNVwvUVxV9XC/BIw51hkSpl
	 PQFobo+bbzVJycQSk9qA9BTw1eWFXZguRLAlah55iKWm2526muon/pKrOcsaWvA9zssGp
	 ogowb6RnsKDPYuCIIB+o+Yba9QQXjbHieoIobjm4NOTZa6rBelkiP1UDIkcn/hYz0jGAe
	 hs1Jtt8J4Zdk92VTqhOs98z7pxk3ewp7/Yl8nTOpcmzSo9XvoENUzTmHZlQ+gTat0YXC5
	 MajmCftKRmxAwqkMe/6EVnCqukfyFQvQbooZ5uv2L7OamQFVKQETSvUf2BZ6aFqwSjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794519987;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=FwSZ6EZwDbjC6g0eYcq1DfB8oiXV4dgLC1WiPq1Ih5s=;
	b=vpH/C+Mw2V4Aq78kUqrQAIqw4VGtMZxchURTJn6+7I89h7x79BGYvAFddaKqbtOs66wj
	 v+JiIa+4XUTmZ6pdGm3m4IZkfEDLQpjaJWPIxAbGGtZGZfVGb/ZQckETu8d7Wh235wG84
	 hQLWKLG5tCYeVqJfKsjUTJdZAQ8FX35QQpGPRAI6Xs3U4Hlaubtc2NocjK2DRx+9o438W
	 MP++bp2w3AmXgfidIC4cm6Cp46mwnA5IIexgVEqJ0M/h3gb3lBQ6FK9SxPXTn82hYuQAa
	 e01pqCZG2xndouQy5ZpZiZfcL5KYsoJlxuVPccFNnB/vk7GVYlaqCUPupxoecliVdfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XNSgWH97;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BD1606A88F;
	Thu, 12 Nov 2026 21:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XNSgWH97
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC551F000D1;
	Thu, 12 Nov 2026 21:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794519986;
	bh=FwSZ6EZwDbjC6g0eYcq1DfB8oiXV4dgLC1WiPq1Ih5s=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=XNSgWH97i2S7lg0p1jJ1yoBnSlxDofVGjxTQisr8j6iQ3LtJebLrsMnZFLPi/pwjU
	 4zycl6f+Q4PPxFdRBWOMT6Wfogz+EYhQF992jeIhWYJeN8kGgz6DLJbddejqJkwFB6
	 KkHmelTxpVDn020STuGNU/xaej5+fIZCv9t6BqcGtPgXgHRzY5OYLwRxbjPnDrTMHy
	 iQQQntu02hKYcNAiU8hhl7f06WhZLtaDUWXYOCi+r4WbROjxcuBo3IhVRnyyLZpGBd
	 bTs3V6pdJLV437GeSvYkVBR78thqKBVSs08I9QpVXwrEh7oeTuyw3ZPIqCqHUnKbYj
	 ONO9ubkBxmNiw==
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
Subject: [PATCH v9 11/14] xfs: take the MMAPLOCK in xfs_fileattr_set()
Date: Thu, 12 Nov 2026 16:46:15 -0500
Message-ID: <20261112214604.67875-12-mason@kernel.org>
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

A store through a shared mapping can corrupt a realtime file system on
disk, or shut a file system down, if FS_IOC_FSSETXATTR changes the
realtime flag or an extent size hint of the file during the write fault.

A write fault reads the flag and the hints more than once: to choose
delayed allocation, to size the block reservation, and again in the
allocator. All of these have to see the same values. System calls that
write do the same, but they hold the IOLOCK, which keeps the ioctl out.
A fault only holds the MMAPLOCK, which the ioctl does not take:

    write fault                         FS_IOC_FSSETXATTR
    ===========                         =================
    takes the MMAPLOCK
    xfs_iomap_write_direct()
      reserves blocks for the old hint
                                        takes the ILOCK
                                        raises the hint
                                        drops the ILOCK
      takes the ILOCK
      xfs_bmapi_write()
        allocates for the new hint
        /* more than was reserved */

The fix used here is to make the ioctl take the MMAPLOCK of a regular
file as well.

Signed-off-by: Chris Mason <mason@kernel.org>
---

Notes:
    v8->v9:
    - New patch.

 fs/xfs/xfs_inode.c |  3 ++-
 fs/xfs/xfs_ioctl.c | 17 +++++++++++++++--
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index cb61305e4b80..0584ad11f92b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -134,7 +134,8 @@ xfs_lock_flags_assert(
  * take both the i_rwsem and the invalidate_lock. These locks should *only* be
  * both taken in places where we need to invalidate the page cache in a race
  * free manner (e.g. truncate, hole punch and other extent manipulation
- * functions).
+ * functions), or where we change inode attributes that both kinds of IO rely
+ * on (xfs_fileattr_set).
  */
 void
 xfs_ilock(
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f81b6e52ac40..af13ad6784b7 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -757,6 +757,7 @@ xfs_fileattr_set(
 	struct xfs_trans	*tp;
 	struct xfs_dquot	*pdqp = NULL;
 	struct xfs_dquot	*olddquot = NULL;
+	bool			isreg = S_ISREG(VFS_I(ip)->i_mode);
 	int			error;
 
 	trace_xfs_ioctl_setattr(ip);
@@ -804,10 +805,18 @@ xfs_fileattr_set(
 
 	xfs_ioctl_setattr_prepare_dax(ip, fa);
 
+	/*
+	 * A write fault only holds the MMAPLOCK, and it looks at the realtime
+	 * flag and at the extent size hints more than once.  Only regular files
+	 * have write faults.
+	 */
+	if (isreg)
+		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
+
 	tp = xfs_ioctl_setattr_get_trans(ip, pdqp);
 	if (IS_ERR(tp)) {
 		error = PTR_ERR(tp);
-		goto error_free_dquots;
+		goto error_unlock;
 	}
 
 	error = xfs_ioctl_setattr_check_extsize(ip, fa);
@@ -864,6 +873,8 @@ xfs_fileattr_set(
 
 skip_xattr:
 	error = xfs_trans_commit(tp);
+	if (isreg)
+		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
 
 	/*
 	 * Release any dquot(s) the inode had kept before chown.
@@ -875,7 +886,9 @@ xfs_fileattr_set(
 
 error_trans_cancel:
 	xfs_trans_cancel(tp);
-error_free_dquots:
+error_unlock:
+	if (isreg)
+		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
 	xfs_qm_dqrele(pdqp);
 	return error;
 }
-- 
2.55.0

