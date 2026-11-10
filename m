Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794271765;
	b=qCdoJuwStGU84nZDo7cqMsFwhT8lL8pnRn6ebn33V2DVNE/ETuXFp5duQTuhIg7+2iki
	 FQx8ADranTnnqb06kjn3sO+DfgH34enSk71+DPkKtd2Uor49y0ggsJ+60uLkdeI1QeDOP
	 3V0SghxauoW47FuZH0DtU6gKc5Kz/PkClXbV0uMni6Q1MeR28c51UIy0508kvOx2kSbSR
	 N+ir2zqDkp1jaQosskk/48HbHv5zrBXLnAvNBrCo/nmFQmrj0zj+FIA7Es6cFYuzsmyiR
	 syTtpTgJs5u57QXetJGfm6JRnQhpdvNdXHkMn67bReaN9LkHlBa46cA/zqsHIVJ8J8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=37W+FQL2oNTR9CSQkLtYcU37OSrepIZzSqzT98YNi+U=;
	b=Za9opZZrXAebWZi/BIJVORQBjPas+gXatxAoK4Pzsow1BKbmsK6s1yC/tJzPX+xwAWj6
	 YulzzsM1kZNLueDnH2o6VN4tYXqeCm4NxfeoyoGXBvx2qp22kTkCdzIJhK0eoSfiVGN0V
	 7aNsdj28BtgIB6BoSuKufXUm/B8fZ5bjVGTVg9zUTi4Oih66yczC47JGxcNKM5EOfKtOS
	 3SREFWsr53/0aHiuF+mgNoP3W2Lv7N2h1DlGLdEKeGcXVkbB6NeFR6QAu2hVJ/ZJF3pSC
	 dhBn+xg7Bp17VAZzgsxGBx4GqQ1gjtxlSB1D2rGEyrN6U1z01hm4NjS07CsqPak3qGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QEWQYZxB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB57606A31C;
	Tue, 10 Nov 2026 00:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QEWQYZxB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E7E1F0089F;
	Tue, 10 Nov 2026 00:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794271764;
	bh=37W+FQL2oNTR9CSQkLtYcU37OSrepIZzSqzT98YNi+U=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=QEWQYZxB+ptCSLZfdpA6zPFU25xs1K2kZaYCuAdRRRHQTe9zUWIFbc7+3tv3sqE30
	 51skIOjDtimoX0Qj2U94kzr7/Q4MA+MSrrLbQO0JFZAhAnfnRuJkMK0ncWBrLBu2lh
	 f/Kn0cvXLG8h/81Uk+uUSYgLgV67JVQiYUQKEfvjGF9oYgbGoMG0/AFc5u6BqR1qLx
	 d/BbzPXwQyLRqxeW6CGaUsrgopjSlfqACNnzqXWMo/QY1INB4suJV/m/Vl+6Jeykgk
	 Xs6Ydccbb02LSpkeOuN2V5NifDC1NGoOxD19OPhD5i/Lqg9MK3I8MZ777UgKrDt/Ty
	 yS2bAG8A2TDQw==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	skibletz@gmail.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()" has been added to the 6.1-stable tree
Date: Mon,  9 Nov 2026 19:49:22 -0500
Message-ID: <20261110004923.3538601-1-sashal@kernel.org>
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

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-fix-wrong-compat-fields-in-xfs_ioctl32_bstat_cop.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 21b26b7d5013d0f7aeec7d233ed916a5317e4a58
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
index 2f54b701eeadd..54fb3de1fbcc1 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -122,8 +122,8 @@ xfs_ioctl32_bstat_copyin(
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
