Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270133;
	b=GXIfq+Szw2Woxat7JaGrJCXUHrdeRothUroi/YvsUWV+WePgJrYfx/goLeSyyEFiO0+j
	 BnviGhMZL1KXxTcsiTob1A19M/hQbDar1l5BNDSQsM3WTepbulrxQmNNjWFQj1Dridqr8
	 RHjKETu1yozMfreth2EF+oDl/pMlDPmBi3TXdNErvHfsdFxT8DczoiEdxtsyBRYtUBor+
	 yIuFTK6q08azDNjGb+YmgdEmvJ9+KH7LDSWeu1fQQg6oF1S2A5ziGoyD6e9njLuJ6+Ze+
	 rXSofDz4XjRxSjTj6yjybhuOgmKpVo7TxDN7jWZIrJFlD4zpEJLv8py+Axi4QAXT6fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270133;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=NM9VnaMHASU3xEtCLsuR7M34cf07bDF6xUBDHwjPpYw=;
	b=A46aT7VEjVzE+OMp3l3uni2Yp0SCLLZO3VrH6K5cv9v8GVPHjchDY/8jtDcMlCKeo5yB
	 f8xhl3g3hhUpGbwCWeLqr+RPkMxNP8gcOBZqVLEpr4ALNWqa/vGz6pzg4TvV29f4Az33N
	 tMXHsVzDjM01UJVcDcPQPhkJBWk5/iTea4mf7ci/dW3yUxVD6WQVw2x3O1zs6V2E1CS6t
	 fZalT/q1LANkjoEFeYwuX8X7R+FKNppagQgsKbw0DPYYfJFpnWu7GhmX1pNiyrSa0VprX
	 f5g66PophPeuyqWdRTriVuMOh3PDa7UEn5xllUacDe9ZB+/KnUmyaq/QGJoAM0gTu5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GudLSNPz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04848606A325;
	Tue, 10 Nov 2026 00:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GudLSNPz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC231F0089F;
	Tue, 10 Nov 2026 00:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794270132;
	bh=NM9VnaMHASU3xEtCLsuR7M34cf07bDF6xUBDHwjPpYw=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=GudLSNPzviNQHYKtu3ngoKyBH2cN2uefR3o/WZCE2LIGl7arbG9vNESJd0kFcbtgg
	 sRJ5XiV96yE8UUlqqjWv0XnYXx5te1aPk5KJYyRl9z7fG0bt1y4WeOpeFMVHSwy0UY
	 EFw3LiL/KwI3HUjDqKLUgIldrOHl4ZVtkXE103sbnmFAfVhrUJ9FYfAhkday2f6zRF
	 bIMvExHN9hNjBtyVOkRrca4wfBWJ4Sd5MOwesvA6447D5v51Vxn+J9ISakMfd1hc84
	 lSxKy9loEb63Ng8vrlPTFJ0YZfW7wVMHN1afwkNOHSRBqiBrTekM6M6pHWhtvTH+WF
	 C1xdPHcMtNN3g==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: clamp the pNFS layout range to the maximum file size" has been added to the 6.18-stable tree
Date: Mon,  9 Nov 2026 19:22:10 -0500
Message-ID: <20261110002211.3505834-1-sashal@kernel.org>
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

to the 6.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-clamp-the-pnfs-layout-range-to-the-maximum-file-.patch
and it can be found in the queue-6.18 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 2bf2d333a7ee66866581b3636b725e4600b7b6ec
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
index b880d061ee90c..298fdc9e9f1c3 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -177,10 +177,9 @@ xfs_fs_map_blocks(
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
