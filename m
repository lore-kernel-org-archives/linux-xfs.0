Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615F61DFF4;
	Mon,  1 Apr 2024 16:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990123; cv=none; b=a5kLhvYmIqFqYRHe7U7vwXDWMZtUt184FPhrQHlU3i3eUwqkSfgwZKigsHJH/X4Ka2qkXGJK8MCFqAyFp09L8H7S3ZUzO5r88b2bUBppJVDU46O/1Z8u8TBLQHF9ZpYpop+Zao5XuwzjCOv9R9YMRlCBHUUsaUUYIBBu9jGv2RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990123; c=relaxed/simple;
	bh=VE2IyDcsw1dI1AvU3FXCaOuxFVI3OwNTMTPtAiHS0sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IbfXje3THLfU05wGpS6EcflDEySnYABbMiosedS7zI+QMICxMHqwF0aRrngeLiZ3z2fbVdW/0WtVOKv3Tz/FTPoztstB0UcSpv8iqD7nYva4HTRj5HbEiBQzDKANZogvOePuSTCLhFTyBsv3ilCvSZFUP7LDaanfdyMAL3WVE7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jx+NSk8w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jx+NSk8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3BC5C433C7;
	Mon,  1 Apr 2024 16:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990123;
	bh=VE2IyDcsw1dI1AvU3FXCaOuxFVI3OwNTMTPtAiHS0sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jx+NSk8wrLC/GuC0zMok3TzKKMQGThI1Y4vRYl6ZNnQ6nM4k1TPTgiFTkqGWai3rc
	 gx7BHlDe6nEcl11T1IQIe6r0mXrtAOPso5Hk3F47UjFxLSGj6g7qF9aMi4tGRCPTt7
	 SBUWXeRYLf3BKtz8HyK+jyNa7VwVDpuHXhATl+2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 254/396] xfs: convert rt bitmap extent lengths to xfs_rtbxlen_t
Date: Mon,  1 Apr 2024 17:45:03 +0200
Message-ID: <20240401152555.481212362@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

commit f29c3e745dc253bf9d9d06ddc36af1a534ba1dd0 upstream.

XFS uses xfs_rtblock_t for many different uses, which makes it much more
difficult to perform a unit analysis on the codebase.  One of these
(ab)uses is when we need to store the length of a free space extent as
stored in the realtime bitmap.  Because there can be up to 2^64 realtime
extents in a filesystem, we need a new type that is larger than
xfs_rtxlen_t for callers that are querying the bitmap directly.  This
means scrub and growfs.

Create this type as "xfs_rtbxlen_t" and use it to store 64-bit rtx
lengths.  'b' stands for 'bitmap' or 'big'; reader's choice.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_format.h   |    2 +-
 fs/xfs/libxfs/xfs_rtbitmap.h |    2 +-
 fs/xfs/libxfs/xfs_types.h    |    1 +
 fs/xfs/scrub/trace.h         |    3 ++-
 4 files changed, 5 insertions(+), 3 deletions(-)

--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -98,7 +98,7 @@ typedef struct xfs_sb {
 	uint32_t	sb_blocksize;	/* logical block size, bytes */
 	xfs_rfsblock_t	sb_dblocks;	/* number of data blocks */
 	xfs_rfsblock_t	sb_rblocks;	/* number of realtime blocks */
-	xfs_rtblock_t	sb_rextents;	/* number of realtime extents */
+	xfs_rtbxlen_t	sb_rextents;	/* number of realtime extents */
 	uuid_t		sb_uuid;	/* user-visible file system unique id */
 	xfs_fsblock_t	sb_logstart;	/* starting block of log if internal */
 	xfs_ino_t	sb_rootino;	/* root inode number */
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -13,7 +13,7 @@
  */
 struct xfs_rtalloc_rec {
 	xfs_rtblock_t		ar_startext;
-	xfs_rtblock_t		ar_extcount;
+	xfs_rtbxlen_t		ar_extcount;
 };
 
 typedef int (*xfs_rtalloc_query_range_fn)(
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -31,6 +31,7 @@ typedef uint64_t	xfs_rfsblock_t;	/* bloc
 typedef uint64_t	xfs_rtblock_t;	/* extent (block) in realtime area */
 typedef uint64_t	xfs_fileoff_t;	/* block number in a file */
 typedef uint64_t	xfs_filblks_t;	/* number of blocks in a file */
+typedef uint64_t	xfs_rtbxlen_t;	/* rtbitmap extent length in rtextents */
 
 typedef int64_t		xfs_srtblock_t;	/* signed version of xfs_rtblock_t */
 
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1037,7 +1037,8 @@ TRACE_EVENT(xfarray_sort_stats,
 #ifdef CONFIG_XFS_RT
 TRACE_EVENT(xchk_rtsum_record_free,
 	TP_PROTO(struct xfs_mount *mp, xfs_rtblock_t start,
-		 uint64_t len, unsigned int log, loff_t pos, xfs_suminfo_t v),
+		 xfs_rtbxlen_t len, unsigned int log, loff_t pos,
+		 xfs_suminfo_t v),
 	TP_ARGS(mp, start, len, log, pos, v),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)


