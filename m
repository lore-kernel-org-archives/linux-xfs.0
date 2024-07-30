Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F48139D
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300373; cv=none; b=e2AR//vNC3zGMMMupcawSuzqABlD2Qh/kpoqKpKGK2Ca8quoixRcNU3xx4qyurpkyI8cObiTAbekvbRrW4zf7xhLfFrPV/MogR6lUhyWj7qrulyFdBDvIdT6l5L5SXTLOblslVS5y2W1bOg4H3Hl6kKQ3Yib6FVmuxgIF0kJKBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300373; c=relaxed/simple;
	bh=qH8EgIw8LCeh2T0eaoiEoqPsF/2Ln5OKI5T3OVDu1iU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lMFuN/JmJR7EB3tn8N6ku8zvPnMkXHgfZ/PR20Dd4L6iTjoQ0JZWQ9m2dCok0cYu3rG4Qv0TKYr+e/3YdgH9XciMXavsZyGaf8QvkmUtEtKhaImOLPQRhW2HDjJqOexi7Dpcc7lkBvX4feH7DgdFkHPp25x6sZw5fyiXvBESCQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IfSq2LbQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IfSq2LbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D5CC32786;
	Tue, 30 Jul 2024 00:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300373;
	bh=qH8EgIw8LCeh2T0eaoiEoqPsF/2Ln5OKI5T3OVDu1iU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IfSq2LbQbINLP7vIGiaR14Nw1DsfAJmylbRoBuF3CzFNNl//8/IoobMM4fnvmvD2l
	 KSOY+opTpx/Q2kIaa3f3Egj8MPtRMLms/jzrpegljKNXeV7GNOnaDsbnm2lo96j4Gt
	 ONjOZHEJbBBCUuQsK9L10tRpRMge6KHhmGtUzvSmzSeZby6YAAb8ag1Oqi8sqOE4Vo
	 sSjgr7Zwbd6CNdUsP+ZOQXvxulx/pFF2N6t649b91aeY2YyV//KsBBzqaShYWJ6ey+
	 RtwPcfb+bngmZb3B66B6OH5hToFx/IxfjSW6kvyvmQ981IPqz3uQUqvgPe3tfE8mzM
	 175dpn4wAzkMA==
Date: Mon, 29 Jul 2024 17:46:12 -0700
Subject: [PATCH 086/115] xfs: introduce vectored scrub mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843667.1338752.17925658320142397328.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: c77b37584c2d1054452853e47e42c7350b8fe687

Introduce a variant on XFS_SCRUB_METADATA that allows for a vectored
mode.  The caller specifies the principal metadata object that they want
to scrub (allocation group, inode, etc.) once, followed by an array of
scrub types they want called on that object.  The kernel runs the scrub
operations and writes the output flags and errno code to the
corresponding array element.

A new pseudo scrub type BARRIER is introduced to force the kernel to
return to userspace if any corruptions have been found when scrubbing
the previous scrub types in the array.  This enables userspace to
schedule, for example, the sequence:

1. data fork
2. barrier
3. directory

If the data fork scrub is clean, then the kernel will perform the
directory scrub.  If not, the barrier in 2 will exit back to userspace.

The alternative would have been an interface where userspace passes a
pointer to an empty buffer, and the kernel formats that with
xfs_scrub_vecs that tell userspace what it scrubbed and what the outcome
was.  With that the kernel would have to communicate that the buffer
needed to have been at least X size, even though for our cases
XFS_SCRUB_TYPE_NR + 2 would always be enough.

Compared to that, this design keeps all the dependency policy and
ordering logic in userspace where it already resides instead of
duplicating it in the kernel. The downside of that is that it needs the
barrier logic.

When running fstests in "rebuild all metadata after each test" mode, I
observed a 10% reduction in runtime due to fewer transitions across the
system call boundary.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 7ae1912cd..97996cb79 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -725,6 +725,15 @@ struct xfs_scrub_metadata {
 /* Number of scrub subcommands. */
 #define XFS_SCRUB_TYPE_NR	29
 
+/*
+ * This special type code only applies to the vectored scrub implementation.
+ *
+ * If any of the previous scrub vectors recorded runtime errors or have
+ * sv_flags bits set that match the OFLAG bits in the barrier vector's
+ * sv_flags, set the barrier's sv_ret to -ECANCELED and return to userspace.
+ */
+#define XFS_SCRUB_TYPE_BARRIER	(0xFFFFFFFF)
+
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)
 
@@ -769,6 +778,29 @@ struct xfs_scrub_metadata {
 				 XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
 #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
 
+/* Vectored scrub calls to reduce the number of kernel transitions. */
+
+struct xfs_scrub_vec {
+	__u32 sv_type;		/* XFS_SCRUB_TYPE_* */
+	__u32 sv_flags;		/* XFS_SCRUB_FLAGS_* */
+	__s32 sv_ret;		/* 0 or a negative error code */
+	__u32 sv_reserved;	/* must be zero */
+};
+
+/* Vectored metadata scrub control structure. */
+struct xfs_scrub_vec_head {
+	__u64 svh_ino;		/* inode number. */
+	__u32 svh_gen;		/* inode generation. */
+	__u32 svh_agno;		/* ag number. */
+	__u32 svh_flags;	/* XFS_SCRUB_VEC_FLAGS_* */
+	__u16 svh_rest_us;	/* wait this much time between vector items */
+	__u16 svh_nr;		/* number of svh_vectors */
+	__u64 svh_reserved;	/* must be zero */
+	__u64 svh_vectors;	/* pointer to buffer of xfs_scrub_vec */
+};
+
+#define XFS_SCRUB_VEC_FLAGS_ALL		(0)
+
 /*
  * ioctl limits
  */
@@ -928,6 +960,7 @@ struct xfs_getparents_by_handle {
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
 #define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_getparents)
 #define XFS_IOC_GETPARENTS_BY_HANDLE _IOWR('X', 63, struct xfs_getparents_by_handle)
+#define XFS_IOC_SCRUBV_METADATA	_IOWR('X', 64, struct xfs_scrub_vec_head)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s

