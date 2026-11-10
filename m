Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270116;
	b=CETU0egL8nAoDHw4VYMIh6GfH4fuqlPYCVtVMxjT2Y4xnTYr0WTgzSTace/mLwqW4/X6
	 sTTls/w2JCgSCZPbnCmln9dSPWz3JGU6tDI/OS81XOyhw9N0t19D/UOMuVeNtZy3OarG+
	 pzkpzc7SQ9fVtVyOLZHDcFDxCk4HQek78Loagr5aJ5+xlTVcqaoqq2oi7WibnWeznPBlk
	 zYpgKzfBQ2QjMyNKvYn9hNrNWQXXhvf0PF15OUzrg+Y/waPeWZVpo8cB3Pmi7iBywjEhM
	 Tf/XvyGpZ+DsrxjA9Smsx3hng9UT2wgtgP9jqfuyxukFO7bjsYx4IcyrgHOWgvDQRbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=auephBEFa1/w7o1hdoll+7OiXNT/uPo8zcx1iMsrbxs=;
	b=sU1WbBXRUYWYo6faDJe1u2b4b5MXLdhU6Hxa7Lv8fOqDG856KOHrmN4k5skojWDB/Q7M
	 C1zLhAAWLI8+D95L33AMDcYTrOw4A6MqyT/Q13SSogtjKItzG5Iygdhz79P1Are3gUG75
	 mTpTMUP5u2MNyWAQD/dKfbkFbq8w+ITg+YZI5XaXno+cU0YQvWAPRjw2IgmZXLNryFrQf
	 IG2nrTERT96SYpxRAqzKaKJoB5Nerossg1klt9SzF3SYU9V3NdXpHLgkAyrwD6Ez7ztW3
	 TJ1+25RPjc0noWbcI+oZGhi5DkwUKHDTZsR8Rczy2bq9/uB9qRG8WLXXJ820vPCYuyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j6oeipPY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD015606A321;
	Tue, 10 Nov 2026 00:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j6oeipPY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE501F0089F;
	Tue, 10 Nov 2026 00:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794270115;
	bh=auephBEFa1/w7o1hdoll+7OiXNT/uPo8zcx1iMsrbxs=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=j6oeipPY4V3DnIT7iO1x4EzjgWHASjB0FE9dqHg8HaGrpHMs1GXhMRIclV+GslZJF
	 Eie5KK/iloSog+E2CI8Oa6hQMFxbx93KUORCUCiYx+oxAOLGcFYqejeTlRteWrKl/i
	 7FIYl6st2q2/6OFDAymtiAck6d52FM5470f4/2ddYId6eEgW8e0/FX4kH2WWWgSHk+
	 Kg2akq+LC5yKw+avqrUZx7yeenSoyL0cVm1X4Cn0GX/J1gMAY96NEXt9CrxaMVcubB
	 Mn1O9cWW5NDmyGaFp+e9ABs6cOR9zZC0OeXXo+4y6kBs8A45UcX2xY3Z7LD4QH/JLk
	 JG5hD95lshiWA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	skibletz@gmail.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()" has been added to the 6.18-stable tree
Date: Mon,  9 Nov 2026 19:21:53 -0500
Message-ID: <20261110002153.3505411-1-sashal@kernel.org>
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

to the 6.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-fix-wrong-compat-fields-in-xfs_ioctl32_bstat_cop.patch
and it can be found in the queue-6.18 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 07468355490a73fece63bf600fcd68cf3206f5f2
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
index b64785dc4354e..c2e01fcb6015d 100644
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
