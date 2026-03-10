Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4E0399007
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 03:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773113129; cv=none; b=kzWM8Kra1OXL4TWxPC4e5inGWlv7CtPAAVRPxLinyyRlMitauIixjfS8CMiT2YE7bDuzQ1I/+4dfCsjQRd3AI2wlKxLQjkEuGD8brexKDkPHSLJKtJigYtFzOtWDbfHQtOU1e/ZkwuQMzR2bUrB9hZlnHvh7DgR2GC1L1u0MMg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773113129; c=relaxed/simple;
	bh=n3qGIukWwcCQqnwjb3NYd9xAM6OQr1dJWomJrXxzNL0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RgPHSpJbO97o4xRn6Vhf+lqIp9WThkysCXabB3nYI6pTmdymRDOLb5djgosPRwrKVfh2ZLGLiESmaKIUDI6bqTe7xuRIBDXjN0/WQxdNT42kv/3nuQHjVSefyXFcWsKEWBMnjGdGwuLcoKeSAmdKxEass42Dc7CP4eHyWBfBI4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d/8IWFBg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d/8IWFBg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E881C4CEF7;
	Tue, 10 Mar 2026 03:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773113129;
	bh=n3qGIukWwcCQqnwjb3NYd9xAM6OQr1dJWomJrXxzNL0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=d/8IWFBgfIwkFecEKk1gXmQ8ir16/Uq+d8OcyDAGtNfTdYluBCF7N7WO/bhaTN3j1
	 jcvWaaAAwYlwdwKMaMj6DO77vRA/DALaty+DGImNsFSlaAghIb3hZmCjkptPEmMcdR
	 L+FA4fnK+SUZJtspjoaCbubdFp8qeexoeV2S6ZfxAVlRjXT8WBXRlKy9DxXH00LPVs
	 fc37RZGLSBCHsvBktyB6x5WqUY2raFcmNYDQ4n3QdY3NyUiLh3LqJCVE8Mc3IH5qOd
	 EVxIuxWaHTlVUDfc/Lbc+eKJjEV68APNxXd5dg0zO+DQ8syBgIuRNgvKkonbl5m0VO
	 TNBq5/eDms02g==
Date: Mon, 09 Mar 2026 20:25:28 -0700
Subject: [PATCH 3/4] mkfs: fix protofile data corruption when in/out file
 block sizes don't match
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177311301534.1161719.1020935630436344227.stgit@frogsfrogsfrogs>
In-Reply-To: <177311301461.1161719.5028507121065374411.stgit@frogsfrogsfrogs>
References: <177311301461.1161719.5028507121065374411.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

As written in 73fb78e5ee8940, if libxfs_file_write is passed an
unaligned file range to write, it will zero the unaligned regions at the
head and tail of the block.  This is what we want for a newly allocated
(and hence unwritten) block, but this is definitely not what we want
if some other part of the block has already been written.

Fix this by extending the data/hole_pos range to be aligned to the block
size of the new filesystem.  This means we read slightly more, but we
never rewrite blocks in the new filesystem, sidestepping the behavior.

Found by xfs/841 when the test filesystem has a 1k fsblock size.

Cc: <linux-xfs@vger.kernel.org> # v6.13.0
Fixes: 73fb78e5ee8940 ("mkfs: support copying in large or sparse files")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/proto.c |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 3241a066f72951..a460aebd95ae1e 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -374,6 +374,17 @@ writefile(
 			break;
 		}
 
+		/*
+		 * If we pass an unaligned range to libxfs_file_write, it will
+		 * zero the unaligned head and tail parts of each block.  If
+		 * the fd filesystem has a smaller blocksize, then we can end
+		 * up writing to the same block twice, causing unwanted zeroing
+		 * and hence data corruption.
+		 */
+		data_pos = rounddown_64(data_pos, mp->m_sb.sb_blocksize);
+		hole_pos = min(roundup_64(hole_pos, mp->m_sb.sb_blocksize),
+			       statbuf.st_size);
+
 		writefile_range(ip, fname, fd, data_pos, hole_pos - data_pos);
 		data_pos = lseek(fd, hole_pos, SEEK_DATA);
 	}

