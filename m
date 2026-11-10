Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270694;
	b=5qpqKmexvZ036IcPO26CpCW0PCnP+wHiGHGzhPh3VRqs5s7PxXc/whKzZiZyxo9Qa6cB
	 fTdDUuBkwnKe5yXGSio2F4tt08kb5vnjMgxfRcjsQ2m12qeZMAlD525MNlwUPTBXpVC4j
	 baStMexyqyWz65MojIkIrNcyJ/WxCaMA9/0wHN11weD+1D9TlLin+hci3fEcEtPCZQ9il
	 JzpUyLZWt1/curpJN01rOYaXINlW36xYApZ7/4Sw09f93t+sXnPqcukejp03yZ1VGBLu2
	 nOh7sJSa9mzwo/nK2FP65nYHdZXrjd2e5Hfj82X0XMQCYpuRQ5APy3QcfoOPP2TkGpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=eaIGvEWJAfUf09A4SsRYRAh9eloONMrmsUX9HqG/tQ0=;
	b=JCSS96yJlM/LhA7yKZenDfcGse+xFcOMKe5rSwzfm7SpR1RhSL0IDcswm7XusScqn9/I
	 6eBUHFDL5uPNgqZdAtGTEh4JWz/FnG0c4lrX0GFtZZjQ/dh8mbEN03/kvr6+rmua3mwxo
	 PwFmaG4thSNLX+BYYFIZA6kURDPdm9rqp/E4LENt7iCZF0/R9Shm4Ym2wai27yWf+6VHS
	 451RHSOa26fhRVifjWzCGUswKTGNPtU0wh2BnAVH1peKZS56mrEq2RjJ9gvXwNZs/phZx
	 VAAUaPpipALcBEvSReHJzMe01xKFgoIgzXkvp/EW9GNg36pDsxFv+00Md3IX+15zVkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LzOkDTS+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8EA606A31C;
	Tue, 10 Nov 2026 00:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LzOkDTS+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47AA1F008A1;
	Tue, 10 Nov 2026 00:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794270694;
	bh=eaIGvEWJAfUf09A4SsRYRAh9eloONMrmsUX9HqG/tQ0=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=LzOkDTS+9o+uboWD4/vBH5KgN2r1iCKkB/TC3WJQPBA6eQChXtslNG/7W13Xin7KI
	 9K1V5fSaksa/A09oC7/b+jT9cdIwB8OVsYayRIL9k/6V7pIpa3+mSpxSwfowGBuayQ
	 Ogeh8ibCOaSVBawrbXU6Xx9hpMdCO5DMB6Kn0a3xVjDvrpO2W9tEhwQJYV0NfWVne1
	 QYDFzuqTLy1diBgBaYu7EoYu0A7DgEDVf6Od6ehH9eraq+iw/TUqwsk5QqiN5+RAWK
	 DrvWFAJNAdNT3EtpxK0OXKBwVjsA19w94Up4R1OnPtN8J+YL4MiARdshUKiABSfSGY
	 DchkrPdCqDf3A==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: cap the block count of xfs_iomap_write_direct() at one extent" has been added to the 6.12-stable tree
Date: Mon,  9 Nov 2026 19:31:32 -0500
Message-ID: <20261110003132.3518317-1-sashal@kernel.org>
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

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-cap-the-block-count-of-xfs_iomap_write_direct-at.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 49d784fdb5121a8e94e37f5f22413458dc0406f6
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
index 3483b3728b7be..afd655d8f2ae4 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -258,6 +258,14 @@ xfs_iomap_write_direct(
 
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
