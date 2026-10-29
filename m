Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275885;
	b=ICMLuAcxnl5AcIuafmAQ0/kd8O7Kpdn+oq1DL4/6sU9WbJq1eadIDRSUpdtiT7486qC7
	 3ZdN5z1kMlUnKHFdrvqNtvRm36OM9HN5Cg+/qGyD1Q6P5gdVepIrfi24SS+kDfNoYz/ZM
	 2qV/GWtw7yrZjzGyVZY0rv6WhdKe22Ygb+hhJj9oRRGx6SwEyUgAT06Krljfk/KiTX4Pm
	 iWKFXl1sJNaiLxpHMjaPJuzxBiYlg/+zo85ODNgNwWovo5kRd2/VFgXlUnt/UC8IxnSO3
	 Oj67eEhAzxOePJwFhXl2EYL9tLTPKvTPZ4XFQsSl5cJHKsdMKSaniJAOW9zt031xA9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=zB2bs7X7Bp+co5FoZB+hTRVeRe1jtroSmmfzvokRGcs=;
	b=Y6RvO+miss6+OOzGldCgJ0mXk7eJvO5AzT4/p9DxXlGEEqEoprsfcmkE7bwR9nN7Qk/Y
	 m6aJY27cb5LQpOQRwg4oqOj0lR8rD62jbuRTMxL0aGu4tK7YTmiRicBpL6xR32uZ5F/O9
	 1H9IOdm1JtwUY2S/NkM2yUQLNC1UZ9ZRbqskaBvcm3Bpx/5F9l6OnR3R6f0GTxIfNc+Qm
	 DabidMSvSfxb/wpaSLc110mkMklb956tVhbP7TXG4rVBAEGy5B4f/37Az0jhz0xEgHi5+
	 v4MK7uoV4FFxVPWo10DpyM2mYeOSbBqtiFLa2OPqVYijOcb7OVqBKwTwoGivwfC3M1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l0DjCwUc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A604C606A31C
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l0DjCwUc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E731F01828;
	Thu, 29 Oct 2026 12:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275884;
	bh=zB2bs7X7Bp+co5FoZB+hTRVeRe1jtroSmmfzvokRGcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l0DjCwUc+73frZm4jCq0GZDc/fEpbJga9jxJIyfLgjKQKwcE+Nn0pm2791JX6HuXe
	 nkYm1fAjqOHXw/cZIvOdJWgpzGbDh0LPekpqQ7g8daZmxRcflmp6jK9h5bgQxeMnD0
	 r/+/aNkCWjUTi4tUOhvmO6JdhGhzlZX+F3XEMNUM59c18RSJjdXkiTZbf1rIFJOv6P
	 WrM0mJi1edxCCbzuxAKISgd9BiA3vz29CR7GlQOzC8Zn/VNMgsucya5oRLoTpmgP86
	 J9W5TPQaOJ6NIIy1lUXEJezHyb7GkAoV2HBvZIoIDBLoINXFP16dG3zOEJRpn1Rdfc
	 m39FFyUnONQVw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	cihan.cihan@gmail.com,
	cmaiolino@redhat.com,
	dchinner@redhat.com,
	dgc@kernel.org,
	djwong@kernel.org,
	floss@jetm.me,
	hch@lst.de,
	hemanth.selam@gmail.com,
	jiapenglin@tencent.com,
	johannes.thumshirn@wdc.com,
	kees+treewide@kernel.org,
	norbert@doyensec.com,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	yijiangshan@kylinos.cn,
	yun.zhou@windriver.com,
	zenghongling@kylinos.cn
Subject: [PATCH 28/28] xfs: fix exchange-range-to-eof file size exchange
Date: Thu, 29 Oct 2026 13:06:25 +0100
Message-ID: <20261029120631.803074-29-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261029120631.803074-1-aalbersh@kernel.org>
References: <20261029120631.803074-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: 7dfb218c829c1acb626e0fe92c5fddb9a26a03e9

Norbert Szetei posted a patch containing an incomplete description of a
bug in XFS_IOC_EXCHANGE_RANGE's TO_EOF flag.  The bug tricks
exchange-range into modifying a file so that it has shared blocks
starting beyond EOF, which is never allowed because files never have
written data beyond EOF, and you can only share written data blocks.
This is key to all the incorrect behavior that follows.

Eventually I got from Norbert a description of what's going wrong:

> Fair. Here it is with physical block numbers, 4k blocks. peer is the file
> that gets rewritten and file1 is the one that ends up with the flag
> cleared.
>
> Start, nothing shared:
>
>       peer size 4096   -> [100]
>       file1 size 12288 -> [200] [201] [202]
>       donor1 size 4096 -> [300]
>       donor2 size 4096 -> [400]
>
> 1. FICLONERANGE peer's block into file1's middle slot:
>
>       peer size 4096   -> [100]
>       file1 size 12288 -> [200] [100] [202] reflink flag set
>                             ^^^^^ both files own block 100
>
> 2. XFS_IOC_EXCHANGE_RANGE file1 against donor1, file1_offset 0,
> file2_offset 8192, length 0, TO_EOF. One block is exchanged, and the sizes
> are exchanged with it:
>
>       file1 size 4096   -> [200] [100] [300] reflink flag set
>                              ^^^^^^^^^^^ still owned, now past the size
>       donor1 size 12288 -> [202]
>
> file1 says it is one block long while it still owns three. Nothing was
> unmapped. file2_offset is block 2, so this exchange cannot clear a flag.
>
> 3. XFS_IOC_EXCHANGE_RANGE file1 against donor2, both offsets 0, length 4096.
> By i_disk_size this is two one-block files exchanging everything, so
> xmi_can_exchange_reflink_flags() agrees and the flag is cleared:
>
>       file1 size 4096   -> [400] [100] [300] reflink flag CLEARED
>       donor2 size 4096  -> [200]
>
> Block 100 is still shared with peer.
>
> 4. pwrite(file1, 4096, 4096), which is file1's second slot, block 100.
> xfs_is_cow_inode(file1) is false, so no CoW:
>
>       peer size 4096 -> [100] same block, new contents
>
> Block 100 is the only one that matters here. PoC below, it reads a file
> called peer in the current directory. The filesystem needs reflink and
> exchange-range, which mkfs.xfs 7.x turns on by default.

So yes, TO_EOF is screwing up the file size even if it's actually
exchanging the data block correctly.  The following is the intended
behavior of XFS_EXCHANGE_RANGE_TO_EOF, as described by its manpage:

"Ignore the length parameter.  All bytes in file1_fd from file1_offset
to EOF are moved to file2_fd, and file2's size is set to
(file2_offset+(file1_length-file1_offset)).  Meanwhile, all bytes in
file2 from file2_offset to EOF are moved to file1 and file1's size is
set to (file1_offset+(file2_length-file2_offset))."

In other words, if we only exchange a portion of the file data, then we
should only exchange the portion of the file size that relates to the
exchanged data.  Unfortunately, the code swaps the ondisk file size and
the incore file sizes, which is incorrect if the caller passes in a
nonzero offset.

Having confused the file sizes, the PoC uses a second exchange-range
call on what looks like a non-reflinked single-block file.  Because the
file size is set incorrectly, exchange-range thinks it's exchanging the
full contents of two files and clears the reflink flag on the broken
file.  That enables an extending write of the broken file to rewrite the
shared block that's just past EOF.  This has become known colloquially
as refluxfs.

Once the file sizes are set correctly, the second exchange-range no
longer thinks that it's doing a full-contents swap, so it won't clear
the reflink flag on either of its file arguments.

Norbert followed up to an earlier version of this patch with a second
complaint about us not handling the i_disk_size state correctly:

> The offsets are bounded against the incore i_size but subtracted from
> the ondisk i_disk_size, so a file that has not been written back gives
> xmi_isize1 = 0 + (0 - 12288).
>
> For instance, you can do:
>
> $ xfs_io -f -c "pwrite -q 0 4096" -c fsync file1
> $ xfs_io -f -c "pwrite -q 0 12288" \
>   -c "exchangerange -s 0 -d 12288 file1" dirty
> $ stat -c %s file1
> 0
> $ stat -c %i file1
> 131
> $ sudo xfs_io -r -c "bulkstat_single 131" . | grep bs_size
> bs_size = 18446744073709539328

That's wrong, and the new file size update logic depends on the ondisk
i_disk_size matching the incore i_size, so flush the pagecache as needed
to push it upwards.

Link: https://lore.kernel.org/linux-xfs/1E196589-DEBE-40AC-AFEA-D420DAAB067F@doyensec.com/
Reported-by: Norbert Szetei <norbert@doyensec.com>
Fixes: 966ceafc7a4371 ("xfs: create deferred log items for file mapping exchanges")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_exchmaps.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 204d06ed091e..99bf3e956108 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -930,6 +930,7 @@ xfs_exchmaps_init_intent(
 	const struct xfs_exchmaps_req	*req)
 {
 	struct xfs_exchmaps_intent	*xmi;
+	struct xfs_mount		*mp = req->ip1->i_mount;
 
 	xmi = kmem_cache_zalloc(xfs_exchmaps_intent_cache,
 			GFP_NOFS | __GFP_NOFAIL);
@@ -947,10 +948,18 @@ xfs_exchmaps_init_intent(
 		return xmi;
 	}
 
+	/*
+	 * If the caller wanted, set each file's size to that file's exchange
+	 * offset + length exchanged from the other file because the ranges in
+	 * each file might be different lengths.
+	 */
 	if (req->flags & XFS_EXCHMAPS_SET_SIZES) {
+		loff_t	off1 = XFS_FSB_TO_B(mp, xmi->xmi_startoff1);
+		loff_t	off2 = XFS_FSB_TO_B(mp, xmi->xmi_startoff2);
+
 		xmi->xmi_flags |= XFS_EXCHMAPS_SET_SIZES;
-		xmi->xmi_isize1 = req->ip2->i_disk_size;
-		xmi->xmi_isize2 = req->ip1->i_disk_size;
+		xmi->xmi_isize1 = off1 + (req->ip2->i_disk_size - off2);
+		xmi->xmi_isize2 = off2 + (req->ip1->i_disk_size - off1);
 	}
 
 	if (S_ISDIR(VFS_I(xmi->xmi_ip2)->i_mode) ||
-- 
2.54.0

