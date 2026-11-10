Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794272221;
	b=ud1gEL1v6REzGbwuohkbrvnpeKGMSCkU8Ynliwd1KHx9kvk6nBjOrviQp1fbC7nNfxQH
	 fZUmJg59vb/RLsSGuVIHhvZbe0hSI5Wda6mPyziBk33E37mUeLiNcihIWQG3B/g6J/+W2
	 5B2KKxUx5y1OqHTHDUmPvm5SMbXL917fTlaBrSdBvNqGulXbyfpETi2B9wWx9uzahXEfK
	 mkP1Nmw/GX3Rzx14w4eFfiFFqqoAysVNP7fkFVYSUy/cK1r/0nMCBELnVNf4q6trc4wED
	 McWmjPwlcKubixFF9Yw2WNec3vz9/YuGwuWv4vbZZvwwOAK/BrVuk2KXPotJoEdQsnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794272221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=FdkwsRqMBlQ3UHAxOUJUruWWkoEH+0K+hgPgpwyEvcs=;
	b=L1b4yiSV9RH/zylMd5pdAC3RwyHf0qyzVCmlypM2CCCNAWIRYc74ZbKhqntDOdxNuxUD
	 ABZv3DObHui09q2Y4+vIZQ2BuPAxNkC0XDFqJZtJdomZB2Br4mKpYndGYkRel8mhywIkT
	 RgOarmXKhbdkGo5ayEerwi5jev/rVuIo5roXcX2CZXcvL9nOouhqjVcGs7+N2dRu4Dwgn
	 r2XiK4286L0etUtfShDHdj0jOmzkdQ+UNMyg2znIBvE+jopiBv8guU0vTs72nSVZXqPbP
	 wEEjPl6ycKZXEm3kRY99AwaMFhA7Xj8Aa/+Qf9PD+zolInMHvvbWENqCLvj991O2otA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xap3Idbk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02CF606A31C;
	Tue, 10 Nov 2026 00:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xap3Idbk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16051F008A1;
	Tue, 10 Nov 2026 00:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794272220;
	bh=FdkwsRqMBlQ3UHAxOUJUruWWkoEH+0K+hgPgpwyEvcs=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=Xap3IdbkzvUyb/ETysEwJZrF9n1SWvExJoyV6ertSRvTId99PmeXbb5SmnjbdQ+CE
	 5JtPz5DQqSnUK50bBr6dYz4JSQrAEhKe8iFTtnaEZx7ltZ7HJCJot4ffrdfMsKHXoA
	 TIRH05GSeH787K8T8nZQZ2pIAi5kO12q3wIfx7BSjl6iuuCgLr+iCA84O/uAUcJgYO
	 Q9pzRrsB0G/OpY8icLd5aRKQ9HbHKQVhQ7czEUcktvCbfz/Q0vzbKCvrmR34x2aXjM
	 OcK/CWx2KhXb11rzhF+q1mPrKkEtIH4BvfXMKoZe8vL2s4l1hTXVDbWrykaW3/Vc8x
	 aBWQq4s7DOnGA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	skibletz@gmail.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()" has been added to the 5.10-stable tree
Date: Mon,  9 Nov 2026 19:56:58 -0500
Message-ID: <20261110005658.3549108-1-sashal@kernel.org>
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

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-fix-wrong-compat-fields-in-xfs_ioctl32_bstat_cop.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit f8f935ff5cbbcb5b5a451ec172f0c085fa24d62c
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
index c1771e7281177..62d62c2a9fc07 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -136,8 +136,8 @@ xfs_ioctl32_bstat_copyin(
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
