Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794271776;
	b=KO4rxOM4yj+GqSe6Yo4muvbYW7L7/5/vQE82qk7WaoQpuRhTSbw4ur8bU0eQoHm1BAkW
	 8az+cMGaWwL7Hi5maya85eS3nGI9rh3K4aTwpf+RN2ZS4EsAow6QbnoT2QE6iC7+82LPe
	 bri7vwe3JabzqlkIAQKzas0iifptzYzT22ieyh7CqkSAHoNla06SO9ctTdLV2IbGTgPZ/
	 fmLqhWc9y4oARpJC3N+TleLPHlpkmouFTW3mlJtJxeTYAO7mJDmOffl2ZlQ4XrEZbU3iI
	 gTEzMYxn1NeemK58E4qT9UOc07yPQncGbhNpeQAvv3GNJg5FAmsvqqJRASLfJ+zgsbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=XJQKu4ulLyZTWocqi7xX7jankQHaEeM919F/o8KkaK0=;
	b=stt1wXLLT93Y64LocDFUpHo+0eaZcQCtBtLTEPgb+OpsNTE4PRk8z6gEJidqbMVhgHEO
	 mXv20DiLbpn4+pnL4Jee8P9KXJ9TGCoOS2KEKAcYjDqn074bgUhVdn+U8oXNcEywGzSlw
	 BCIH4Ge92b5r3C7Y9ENFcknSJL2Uwzudz0JnmrY+vCUedYlGYfn9jsR7wBaLIcJ4u8vsk
	 ZAQ/TlLqRsPNzR3/GNEmnc6pWyn+HwibC0f+pe+1hbbQkPCg2v+GtYAFwDI+C6HYNYMjN
	 sF/UC2nc0Xp2ONPQuBisZ24Fm+cJm64i82JOYTaEYCY5ZlrAtU8+NImgnGkt1gWxCxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kPbGZ5DO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88006606A31C;
	Tue, 10 Nov 2026 00:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kPbGZ5DO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF14E1F0089F;
	Tue, 10 Nov 2026 00:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794271776;
	bh=XJQKu4ulLyZTWocqi7xX7jankQHaEeM919F/o8KkaK0=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=kPbGZ5DOmC+ESimDqYtpDt/xXuMVViN8ugan413bzKNKTrzGP4pIHFGt+3h7+FB4z
	 rckarRmuhudjOvQya1PiGZK7k32JKAbTNhKLmeac2ubc55Jga9lOyYXxuzbcaYyrJR
	 E+JAtUPmwUmN6IbEp7fKCs4zUYwAELYIBJADFKYo5ncYPIpGJZiY0pcvybjxYS6ZMa
	 bGERC4n2UCatOiCKPc/+V8Gkp6/AQiuM2odZJBE2t0BcD1poPvBTJ05vsakoOcTMJB
	 9pgz9Bbws128QMUK6KnhV14nO0OiJ9VDje2OJg1H9h6K4P6iiYhY/RnLM/0kHdwlq0
	 o7Qd9JF1lCjRg==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: clamp the pNFS layout range to the maximum file size" has been added to the 6.1-stable tree
Date: Mon,  9 Nov 2026 19:49:34 -0500
Message-ID: <20261110004934.3538862-1-sashal@kernel.org>
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

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-clamp-the-pnfs-layout-range-to-the-maximum-file-.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit d832f7a1ae4b245482bdf1ecb82a827250693617
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
index 8ee7ca4201f0e..c51d29ef450d5 100644
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
