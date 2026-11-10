Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794269360;
	b=0jIN61Ft+irPzNF1CN/imGkIY4XB4c5N9aiSfXCm+UlKOTSzlOXwJw0UBs5Vk4uURL1L
	 xs6Txq1gO22IEbayJDx1K7ViUafIQULOThM2GKk0CI7gub19xHX5yOLl63qCpAxGz8O9X
	 7sRo6VqJn2Iqfgo0yq50iQQiUuOaXruNzKvnD8ucrI+4O06iZzbMJuZ5E5Bq8oWoUAV2S
	 HRlzvKyXr/iQf1IT/ktWNcvaGwBSWPHbqm6xL7GAxSn5gZhoQJVR71IK2vTQnxXRUDUpQ
	 G5WLPsWb43IA1um/6Gm7S8DFP2JVxPxPVpEaNjurSveCt7521YEh1HgmB00v3AlvReQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794269360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=+LqedAnJFWbrmtqzD1sxx1W1OemNwO9BBhuLHSzT+Lo=;
	b=ZqZD10jxfhwtmdfN8xt0cnTdHrinhYXuD55mcDbZP74SM9UhxjySco4GJ2e2gNmYNO+B
	 e+MUlM9Anl/W6Gh9yAY9IPD80NbN3hp6r2HGaTDfcQjjUTMPdDMJwrHZ8d/Tb/QXC1vzM
	 XaZkdTCgmOR4YccouZthECvMpkENFdtbEFVXgdV7NYwZeXt0LIelvXyjVQ97d8qUj5cUu
	 LXu4UQDCzj3IrSVJbgegGZnNRa6PguxXLTtEgWsurXnaV/9e0WNiXt66hugXMGMeZMubK
	 p+a8sqvb20NF7TxyIgyFpEVSeHi13UxU0eRpZpga+u8AleIcLWf6w9drEnFntqC+fGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S28yapsw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CAA606A326;
	Tue, 10 Nov 2026 00:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S28yapsw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DEF1F0089F;
	Tue, 10 Nov 2026 00:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794269359;
	bh=+LqedAnJFWbrmtqzD1sxx1W1OemNwO9BBhuLHSzT+Lo=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=S28yapsw0870r6kAqsV8zBOuy6ciWF31O5eL+jrWzjS0UhS19Pn2i8TiKTfz0BISd
	 IIx0OfNmu69R0c4k+cWohZKeYTB/Iw37McIsxoKD+2d57TQ6fuzlXN/p6/dK6D0RJc
	 nBogzPq+clKuohzRggaR9anFYd/8QOidp2kab/aYicMVEwQFQgtB/jPESx+22fOEUg
	 C4v1p246OSyBrHyUfMdTy2QShqm6k13m4dsDCZXutnCpDFNjPqq8snm1lT5gnIdqF+
	 zGVwG0pR+ssofLJA2w5JAnmk7NnRr/GZnH19s0rXLSctmCtVlHaKhmqBjUNjyhI8hA
	 79fz6fdyz7DTw==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	skibletz@gmail.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()" has been added to the 7.3-stable tree
Date: Mon,  9 Nov 2026 19:09:17 -0500
Message-ID: <20261110000918.3487941-1-sashal@kernel.org>
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

    xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()

to the 7.3-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-fix-wrong-compat-fields-in-xfs_ioctl32_bstat_cop.patch
and it can be found in the queue-7.3 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 8102cfc88d3ec0af8ae6aed8e7b1642275db200e
Author: Reid Downing <skibletz@gmail.com>
Date:   Tue Oct 27 12:17:48 2026 -0400

    xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()
    
    [ Upstream commit b7eb276a39b14e685c2fe578f8ac22fc48ff9e6c ]
    
    bs_blocks and bs_xflags were both read from bstat32->bs_size.
    Read each one from its own field instead.
    
    Fixes: e94fc4a43e5c39 ("[XFS] Add compat handlers for swapext ioctl")
    Cc: stable@vger.kernel.org # v2.6.29
    Signed-off-by: Reid Downing <skibletz@gmail.com>
    Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
    Signed-off-by: Carlos Maiolino <cem@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index c66e192448a89..e411f9453bfba 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -123,8 +123,8 @@ xfs_ioctl32_bstat_copyin(
 	    xfs_ioctl32_bstime_copyin(&bstat->bs_atime, &bstat32->bs_atime) ||
 	    xfs_ioctl32_bstime_copyin(&bstat->bs_mtime, &bstat32->bs_mtime) ||
 	    xfs_ioctl32_bstime_copyin(&bstat->bs_ctime, &bstat32->bs_ctime) ||
-	    get_user(bstat->bs_blocks,	&bstat32->bs_size)	||
-	    get_user(bstat->bs_xflags,	&bstat32->bs_size)	||
+	    get_user(bstat->bs_blocks,	&bstat32->bs_blocks)	||
+	    get_user(bstat->bs_xflags,	&bstat32->bs_xflags)	||
 	    get_user(bstat->bs_extsize,	&bstat32->bs_extsize)	||
 	    get_user(bstat->bs_extents,	&bstat32->bs_extents)	||
 	    get_user(bstat->bs_gen,	&bstat32->bs_gen)	||
