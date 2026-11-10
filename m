Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794272013;
	b=c0p+Addbi94w3aSkNhpjt+fWDgfTsDJu2a2yX2cMjTZZ3+2tq/bKStjiOdzHKrQNE4cs
	 FHONMe38IS9qGT0tBkl2PPxFabbaumeurUP/CTjabU7PKa5slgIpFQbGmWRZLzWhY5oAt
	 Mi41oa8tx3jcvsA4siRTRQxAz1tsdmzukbCDjcT0GkotmtnBKEAKuKvCGUVhJ4+nEgPvE
	 DFDvGzn+VByKuPFs39AEiAmI+LI/ZKmIXOw7LgSnI9Nt/0sIy6D5A3cNjyNtBNqC+M0Ea
	 h1CJ6WkQkYknRJAjZP2lKVdTVtzTHrMc18QqRF5772C8qS2pjUM6lpAH2cE2iaw0hFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794272013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=LdWNqZaFEvKYBGLP9K/kwpXVUpOIz7Iinq1uPGQ/f+0=;
	b=cw2C+e/munf7qa+MI5oE/pQcAe8+Bn4PU/8olXHHVGV0J6PWb5qgNcp2Rbb8rSlxwXEn
	 vqgzpZWAcKD5xQtRKtCne7ULK0krmidK784lXPHKZAf8CzWm8CkrFxhCJwCD5vmzVi+7B
	 /xxfRLr8i6NoW9rtLxd05YqV3s12rnIpu5pD7OG0hm1Nq3ShIz42M1E9FUnVQNyVaRGLU
	 aSAhTMQO7FKnIlfTSLhb+liafBpoP6RKU8X9VUbI/SGF+Tu596pjqfsH+PXE1jEtJI1/z
	 P688mKeL0oxx7WrwzlnLXdfCS6Ob3LQH/8yZKZWhnD9KY+thBjck2sr1kEWyBk+SAfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xf5Mqdcn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4D1606A31C;
	Tue, 10 Nov 2026 00:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xf5Mqdcn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3EE1F0089F;
	Tue, 10 Nov 2026 00:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794272013;
	bh=LdWNqZaFEvKYBGLP9K/kwpXVUpOIz7Iinq1uPGQ/f+0=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=Xf5Mqdcnqc8RaW0Cei6912zcZ28YHIpAz5+BvzIT7aLNf+LR5+s2KZgHtnKRWj6+X
	 Q4SXJLRWwfw59xyQaS7VNMQRsJ2zDJdWSyObVHovYfzClJ44Iy7UQpEgBLD09u83D8
	 Cu+h/TU+fdTKQ41E394lLijcJyAjxjXfMgg4WtTd0sab/X7jd5JnrH7yMgj32VelfN
	 VJUFQ83JHbz+LbtXVheoB2MuOlGDSgfmE7i5dlTRYzW+AqYDxMfNMkazADGxUeoGEo
	 gk+740Uz82AWMS0exHoHk0OtcPmuBzZjmOz1EgCUoHTxJI25AY1wC3ljzEfRRNAFF5
	 B/tJnBMS5p9pA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	skibletz@gmail.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()" has been added to the 5.15-stable tree
Date: Mon,  9 Nov 2026 19:53:31 -0500
Message-ID: <20261110005331.3544506-1-sashal@kernel.org>
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

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-fix-wrong-compat-fields-in-xfs_ioctl32_bstat_cop.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 57cf062177f0d2686be8a25cf6c0de6a0d386430
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
index 8783af203cfce..1270fe0f5f24c 100644
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
