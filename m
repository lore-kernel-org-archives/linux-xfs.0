Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794271120;
	b=KJ2Ksvc9v+M7Zboo5j7TuuqjEe0YM1RNRUsYQ02hb+lAz4xO5s78kgUQ5EPSwieu39LN
	 Ptbq7XDbxKQvzbn+gYdbNkiLiAci3ogOEkU/YXEOqPbuaqGSVvdaAKMuh9dnUwDDD5n9a
	 4YVe9UZwloLyEVwmpBu7EXPqRve/uQ4VFUb4ckqp+vFcl2LQ1wvzEcEF0+THGDYcIqSC4
	 1wavdEdFr6ymvusWzN8Eq/sPrV1p5jYAK0nDNuxD08vPviJnifV7cECnVhLmh6oIpG+/u
	 N3GNEO0z3EHexfPoIo4yeLns0Xm5LB/8oppZX0PyVh9BAwi3i/h9ilTFgUjgVR1ZBJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271120;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=HdDnG39B5NtBRr7ojeHQS4CHEWo0uBP7n176dJAzEx0=;
	b=Vho8O0Fp6XEmH5RvkXcKV3+EuoSuVWli5TJxSrmTL/8jlFWfVS4QQRAzTJVYgAKRUPpa
	 6Mpnxhbv2Rkk1Sk/swbLAH2ykZHpEmIgAKJAGuO30cUlDB64J85nUAyObfMXAyMxpp2C4
	 RnvDV4ZhNeFp6ksUk9eih6qhXm6WSw8knpayOLw+1aC/xssQxC/YBJRai+z+zbls0u7U5
	 no4rCT9aWNO/vOjvswjMsvfN8vLpWfKFaIEEYg6f4oGCjoQ02KEEAoZNK5WrfhmMQPsNI
	 a98xRpDtuetAmOOpokThZPWvWUEaW0vbpRbvUW1ObeJNb9vnF1eHlaqFz4Jw7iOa8Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=czbno6I5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357D5606A31C;
	Tue, 10 Nov 2026 00:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=czbno6I5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD6F1F008A3;
	Tue, 10 Nov 2026 00:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794271120;
	bh=HdDnG39B5NtBRr7ojeHQS4CHEWo0uBP7n176dJAzEx0=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=czbno6I5H4Zu+YonjSseTm9gmkzcg626q8J284cYopwdnfhJR/S7tOQIQfXW5VsKr
	 X/eFNUNbSdC8z6jSK9ii369EF9tCTGzXvx6LTGPJ8x2TonnUGN5CBHsTMucijM/SjP
	 r0yavl0awrOWX2xQ5jmxVwEmTIN73MvP9g/EM06OS9wXLo5gkHhxImpT8u5n6jUqJq
	 30DDbotxjl+hQTzI/3W4I1Jxeo1m+8/cT7BalMC87GvmXjGP1hkf39Fpfu6/x+9nRv
	 I93DBS6kmjYZwnLZpr//TVm4Bq/Adirik4j4HQc0xvZ6303eA2fqYqPz5MXsOJSi98
	 DyYpXyz1fGvJg==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: clamp the pNFS layout range to the maximum file size" has been added to the 6.6-stable tree
Date: Mon,  9 Nov 2026 19:38:38 -0500
Message-ID: <20261110003838.3527902-1-sashal@kernel.org>
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

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-clamp-the-pnfs-layout-range-to-the-maximum-file-.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit a23afe6ffd4749a565fac89f2ce5968a83c9a6f2
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
index a222410812ac4..fa027574d6de1 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -168,10 +168,9 @@ xfs_fs_map_blocks(
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
