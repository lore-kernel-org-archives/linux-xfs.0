Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794269377;
	b=aMO6Qz/QYRIzEtc0oh4XU3Et3z16QoSwoZzoqMbqc+j2JtxzW3yarbP3jvFgryTV/Ev1
	 AlWF1izt3m3meBqxEWUYKZhd4Jm0lEdgk16tKxm39GgJEG3EkQyIPuiuYwMz7Rp1IfzQ8
	 2Gb6tHGnx87lEN9MHfnMgK2F6HbWDvhW1xJH7y7auNuEDy88MjRgxzFFouEqfutr99pSW
	 u8MfZk5JdSMM+7LDsJXiFx6LVmSaJLpkmGyFQEh2FzYOiR+czYktMPw9RW8ra42C0xsdV
	 59MKqJ8ulPr3YI6IlzTt/cnKPWrGd+Oq4oGVdbZu18Jlp6YBQOsSyJQQVkMY654HveQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794269377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=u/vvSUoX6aaC5pVZvZo+7G1wu8NGfi7ihPj3kLsrUrA=;
	b=Bq02SxsrJ2HpOFbcUShrjQShodHnHpqI02QfKwL62hFFREVm70nbp4iNkFAtYL5wjyfv
	 d2DQD56ykKdUfTm85Jm8Eu6YI2ZCWEN34VIrXe7JncCfNSV5JPm7J6mCTTiaOvmwngP+d
	 ijwa5/GgtbuyNWc9KbMvDYUQ4bLrZ71Um16mV8jd0tw8/s1uCmYY9dzD4zf2yHdrwSmr5
	 kWVvKiEpYmKe08gQKiAeReHaxlV2CwI1ewvjClfh1/fsBufb5KhU/EKjOi+1XgZ1NJbIR
	 C28ZI6U9Kh+xsb59WmE+jyhdph2TTnsrXaoBHh64XQcFDi/xCAkh6yf3UesgHRngCoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WkwBlzNY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A114606A321;
	Tue, 10 Nov 2026 00:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WkwBlzNY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F821F0089F;
	Tue, 10 Nov 2026 00:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794269377;
	bh=u/vvSUoX6aaC5pVZvZo+7G1wu8NGfi7ihPj3kLsrUrA=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=WkwBlzNY1Pd4Xu5E3d9NJ1acTo9Ax3P7HURCzzGfiRc+wvNg7eD9xWIxMdi5bOj39
	 EdGolZg/tp9RdlKDOJHBrmxR3/1OIbVvIxX45EUCtUVNkd8fueonGtW+2qF7RMq1q5
	 SfctjTrVpPK6qbn3zVkXYn/slj3GxmbYIhHollilLKPzjcz58a+yf23WEWqmFBYTZl
	 /pEtu2hLlFARw0NtIAC14NKPD0NEEjAtck45pcA3onTypJhbufQse7OC9txfCnU2mt
	 ltBriry6oB1euDC++pLv+9LHXyZK6jseuc02XOcXaYkquiNvjs3f9wfGy2XQOagCwD
	 AkA8UL2dVhQgg==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: cap the block count of xfs_iomap_write_direct() at one extent" has been added to the 7.3-stable tree
Date: Mon,  9 Nov 2026 19:09:35 -0500
Message-ID: <20261110000935.3488378-1-sashal@kernel.org>
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

    xfs: cap the block count of xfs_iomap_write_direct() at one extent

to the 7.3-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-cap-the-block-count-of-xfs_iomap_write_direct-at.patch
and it can be found in the queue-7.3 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit cf3aa748f2b5d10031c673cfec5f0d4e850a56c2
Author: Daejun Park <daejun7.park@samsung.com>
Date:   Thu Oct 29 11:23:02 2026 +0900

    xfs: cap the block count of xfs_iomap_write_direct() at one extent
    
    [ Upstream commit 66d1ce09ebd72709f8d739630c39f440445173fd ]
    
    xfs_iomap_write_direct() reserves blocks for the whole count in an
    unsigned int. For a pNFS layout the client chooses that count, and an
    RW LAYOUTGET for 16 TiB wraps the reservation and shuts XFS down.
    
    xfs_bmapi_write() maps at most XFS_MAX_BMBT_EXTLEN blocks here, so cap
    the count at that. nfsd asks again for the rest. The other callers get
    the same mapping as before.
    
    Suggested-by: Darrick J. Wong <djwong@kernel.org>
    Suggested-by: Christoph Hellwig <hch@lst.de>
    Suggested-by: Pankaj Raghav <p.raghav@samsung.com>
    Fixes: 527851124d10 ("xfs: implement pNFS export operations")
    Cc: stable@vger.kernel.org
    Signed-off-by: Daejun Park <daejun7.park@samsung.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Carlos Maiolino <cem@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 93826ca74b6be..373ff0e64f145 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -285,6 +285,14 @@ xfs_iomap_write_direct(
 
 	ASSERT(count_fsb > 0);
 
+	/*
+	 * xfs_bmapi_write() maps at most XFS_MAX_BMBT_EXTLEN blocks in one
+	 * mapping, so don't reserve blocks for more. A pNFS layout range
+	 * comes from a client, and its block count may not even fit the
+	 * 32-bit reservation. The caller maps the rest with a later call.
+	 */
+	count_fsb = min_t(xfs_filblks_t, count_fsb, XFS_MAX_BMBT_EXTLEN);
+
 	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb,
 					   xfs_get_extsz_hint(ip));
 	if (unlikely(XFS_IS_REALTIME_INODE(ip))) {
