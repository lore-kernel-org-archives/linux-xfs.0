Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794271109;
	b=R4tQMAMvmFVoZF34AIcojnEy+48Uqn+Bn0QCN1azBoanAX5GUM6IwM+DmwL0plpORplt
	 IxHHkYWDNkvDDnRnG+LHVt5z5BjpwHVYW90pESOaM3vgyY9WjZrgYKjdyJCsUZ4CMTGUp
	 /cKamir7QzqKKQ+UEwPJHN/COl0uzO2Qh1cOn3hb2J7Ss13ePZRD9KEOastJRjjNwSMHx
	 crvWFrL9CDLDBdPk5DSLm/G/9qooFdG7epdrwqKzRuwqi/JgyjGDrS66gXQh/gL5QNvzU
	 9ULKFbNRJUZV1i7qHVGh3H0UUkuUQHl78pp9ID8to1N1GdWOmcB7HI8zQvTYjIYBCpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271109;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=gswLWcl24j2+7DUFzBwv7qSShJRY30gb/8ODNMWbbpg=;
	b=4PsomWr+j0lF8flfvKNDo0eQxvFepiXHpatIcg+593dGcDkSuICT84hq5hI87yXZMGKK
	 vzUv3mLnYqd4GHYKUkyKLyK4wTMzNykabVls06wgDImZZ6S9z4DjpDUyvKsHXCG9d6iBQ
	 lqnU3iVLFleg1imZFqFhJ/dvVQCgTXfQ3BGc9nvBQnD/xLsINl0G2Uik3Q7gsD/o2d6QO
	 tRxNbMBchjRMC+noYjI5YK93buxgiq8l8DPrpEk/1TwtzoiSK32eQvMqdpSwwTWPvZeQv
	 PmYVgjeww8eJh9pUE3bZe5iDjDW/vEM3bJRi7ehJPlLIPpnYzunGGtbl3Cf/9YLzc1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N+ec0Fq4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A44606A31C;
	Tue, 10 Nov 2026 00:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N+ec0Fq4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4761F0089F;
	Tue, 10 Nov 2026 00:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794271109;
	bh=gswLWcl24j2+7DUFzBwv7qSShJRY30gb/8ODNMWbbpg=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=N+ec0Fq4vlMlbYiETdHQeayuizKDzRhmHQoucKeCj7kuI/6XmHgRnzKvaSLu2P2gR
	 MSDkq8OquDuame4q6EmcoazvEXdkC6NMWG4XPkAdGu9EpncqLb2e+Q5g80kh58upwg
	 m0D6k811s5VXExFb+7K9Wv8b81RjqkP6RmLnDc48Uat3plNCRaY4ylNudfT0UJ2UDD
	 lP1kdKsAdxcFNMrLVMrZ1Hrbs9ixTlpsOCXztQgrCwMFuY4T0mZv5V5+ZZvmBdKXIh
	 fmL7m9k86Rjfh0Bj85naP+O26NApMOEqphE7WrqF5flCToDLtUl/H4amTMGMsZ2QU1
	 etijSEq04vSlg==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	skibletz@gmail.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()" has been added to the 6.6-stable tree
Date: Mon,  9 Nov 2026 19:38:27 -0500
Message-ID: <20261110003827.3527694-1-sashal@kernel.org>
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

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-fix-wrong-compat-fields-in-xfs_ioctl32_bstat_cop.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 3de1da8bcdfc4a8f5eb6767dafa938cd472ccd7d
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
index ee35eea1ecce6..7a4d6ebb97cd7 100644
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
