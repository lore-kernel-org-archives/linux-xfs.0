Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794269380;
	b=alom1xXAOCLWjBaZ7cmd6nDXCkXLZe9EwddzaUer9/k1Wn+SZfznurY3vuT9C9h7j8Jb
	 HVnfmYFVRSO1Ch4QCIPd1Ssy188TxVRFUtrlzVLtpkkHSJwhEboBvE2QHzXxiiGWuVAB/
	 BvyHcD2hgyIG2yFMkiIQdmjHRmuv5hjepKb4iZZzHlNOKdnNseH+EOHEJu4uMjU1C1k8x
	 y4WVVxZii0/9SVZn6Gw/5HWBamN2gNJBGXF4PzC41RMVGKa7vi4BNGtMrGrh8yTfxHDsW
	 Z4UOL5xQcE5h2CoDJKpEl1AM5iaAbYmXTTjst9ZEzQ3iOP0FkaXGXGsQ+AtR8H7Z2Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794269380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=RGbOjXYL8sznSHBOM73fN+YJzFsFhlOhR4LZCHPukG4=;
	b=NWsBEN/EB7SdALZjik6UlEMQ4U+GLeMOLrc/ggjY4P1bhQSnE8065/RfpLgcHllyvLA2
	 ovi9T32bOctTRVg6DMSQLfLazRGcUjIjHx1bm8cTqANSJED3k6ZT4tj1mAFWFAWC6RDk5
	 04EXjq4wR2Ok7Wf7YtmajjzqWKBe6oTeWvau4v1oFIKGuK+FzGpIZV58WYNHGx8XYBRjo
	 fGkMyf5VeTRlC1oZHugj/hmtmOmD6eHn1RyIHIZQfqfdC2ImiqY3Vg7he/tyAV6UfAHls
	 c8HCNFusiBZtU02wcOaTyxha223/Fr2fbbGr+bnQSLMBDr4DTK/cgezVnKEv+CCm0YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S7AKWdaK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2E0606A32A;
	Tue, 10 Nov 2026 00:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S7AKWdaK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83701F0089F;
	Tue, 10 Nov 2026 00:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794269379;
	bh=RGbOjXYL8sznSHBOM73fN+YJzFsFhlOhR4LZCHPukG4=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=S7AKWdaKWBM+MWJ78oh5IxjAzB8fpbDcnvTMWDZlY7xwil9d54B0AXy/bzsfT/mzQ
	 hgp0OZoZGXcwW179R+xHpqGoGYJ/JCDlligTEtXb91XTwtvacB4U0b7zeNuS9uYnoZ
	 FTduAMM+aeAdyLKQ4l54qVYoQ5854Fv8T7BpNh1RIn7CpERcrFDgZcwFFk5q9fv7mF
	 JW+JDo15g938DzKJw55nJIYdoZAxp26qPOi+JZScm5Yn7KPCogSjHk+ueGFcPYQfXx
	 hfq6edzOYEjmSzkCbXbRKSI3TVV+meoiu5Jatq+N0viLzLlX7khQmTdKb0bI1QkuUe
	 mNKzU6BpHt4CQ==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: clamp the pNFS layout range to the maximum file size" has been added to the 7.3-stable tree
Date: Mon,  9 Nov 2026 19:09:37 -0500
Message-ID: <20261110000937.3488432-1-sashal@kernel.org>
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

    xfs: clamp the pNFS layout range to the maximum file size

to the 7.3-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-clamp-the-pnfs-layout-range-to-the-maximum-file-.patch
and it can be found in the queue-7.3 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit b7dfc2860d38dd5427a8911546647187df46ef33
Author: Daejun Park <daejun7.park@samsung.com>
Date:   Thu Oct 29 11:23:03 2026 +0900

    xfs: clamp the pNFS layout range to the maximum file size
    
    [ Upstream commit 29f3c1be4e554c9dbc66e13333034e0947477cb6 ]
    
    xfs_fs_map_blocks() lets two bad layout ranges through. An offset of
    2^63 or more is negative and passes "offset > limit". A length above
    the limit, such as NFS4_UINT64_MAX, wraps "offset > limit - length"
    and stays unclamped. With NFS4_UINT64_MAX, a read layout is built from
    an uninitialized mapping.
    
    Reject a negative offset and one at the limit, and clamp the length.
    This needs "xfs: cap the block count of xfs_iomap_write_direct() at one
    extent".
    
    Fixes: 527851124d10 ("xfs: implement pNFS export operations")
    Cc: stable@vger.kernel.org
    Signed-off-by: Daejun Park <daejun7.park@samsung.com>
    Reviewed-by: Darrick J. Wong <djwong@kernel.org>
    Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Carlos Maiolino <cem@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 19eb18e1290cf..7153e7a1e1de6 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -176,10 +176,9 @@ xfs_fs_map_blocks(
 	if (!write)
 		limit = max(limit, round_up(i_size_read(inode),
 				     inode->i_sb->s_blocksize));
-	if (offset > limit)
+	if (offset < 0 || offset >= limit)
 		goto out_unlock;
-	if (offset > limit - length)
-		length = limit - offset;
+	length = min_t(u64, length, limit - offset);
 
 	error = filemap_write_and_wait(inode->i_mapping);
 	if (error)
