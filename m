Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D481B86CF
	for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 21:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731361419; cv=none; b=hNIPo0xPH8PPiTW7sqlnSySF6iwpKYrShaxAhhLF9W2kc+a3KOSgSF9JAmJj5dX1G5W0i0JCHMyTUXc9e29BEuHouWUNrG7ZEzNdE+JW0/wru+90zOi9z/7AIoYoyk5Gs1eBn4cQErH+7eSOw3qrqMxUBBOecb3t6VXy9W5EIy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731361419; c=relaxed/simple;
	bh=0OZU7oM93D8LzWHLPz0+anAKcyw/fTxWUbhv7+5xgMA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=qezTTy0rrBF8Q4QOAUPDXgV5CoWtU19dpZ6gy2TD2CJxoH/fkGfxFAH+DGHEBvcNyJHccV6mG5HCy+JJ3hk/qI02mCf4K9efsXoz/5BTUjXnfeZ7VPrzYbx/1FXELyRmXVAiS5Shn+Hb2Vyfm5Q3kZmcu9sQhpo77uHBzqbmyMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JcKudWiu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JcKudWiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4292C4CECF;
	Mon, 11 Nov 2024 21:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731361419;
	bh=0OZU7oM93D8LzWHLPz0+anAKcyw/fTxWUbhv7+5xgMA=;
	h=Date:From:To:Cc:Subject:From;
	b=JcKudWius79OUcTct2aK3FefW+nXLEZDusmaX6aemTvZnWOnAkKsnzRxcEFmxc1cW
	 6EdisPCNicQGne35zzSM/OwHW26W1ZmnYUZ4wkuZ2oyuUOcOjrsJ96JHaUeyrdu3kk
	 4k619XSPxn/Wd0fHS2duux/t+mGi3qmooYajimWSNDs7VmT9hKXsfQ8wggX7PS/Xiw
	 00kZF8u/C7x7LFY3eg9OmAgaWuehLHljWktCRG/e+0abDzjB01eOukxPCyu63GRFiU
	 dyRZCUbHvvTpP8LVKp41qntDd72eeJ80Gmou7rod4eDVv3WPvqSmErng8VSd3u4NeI
	 WlpxA9Zs25C5g==
Date: Mon, 11 Nov 2024 13:43:38 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: Reduce unnecessary searches when searching for the best
 extents
Message-ID: <20241111214338.GE9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Chi Zhiling <chizhiling@kylinos.cn>

Source kernel commit: 3ef22684038aa577c10972ee9c6a2455f5fac941

Recently, we found that the CPU spent a lot of time in
xfs_alloc_ag_vextent_size when the filesystem has millions of fragmented
spaces.

The reason is that we conducted much extra searching for extents that
could not yield a better result, and these searches would cost a lot of
time when there were millions of extents to search through. Even if we
get the same result length, we don't switch our choice to the new one,
so we can definitely terminate the search early.

Since the result length cannot exceed the found length, when the found
length equals the best result length we already have, we can conclude
the search.

We did a test in that filesystem:
[root@localhost ~]# xfs_db -c freesp /dev/vdb
from      to extents  blocks    pct
1       1     215     215   0.01
2       3  994476 1988952  99.99

Before this patch:
0)               |  xfs_alloc_ag_vextent_size [xfs]() {
0) * 15597.94 us |  }

After this patch:
0)               |  xfs_alloc_ag_vextent_size [xfs]() {
0)   19.176 us    |  }

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 61453709ae515c..f0635b17f18548 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -1919,7 +1919,7 @@ xfs_alloc_ag_vextent_size(
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
-			if (flen < bestrlen)
+			if (flen <= bestrlen)
 				break;
 			busy = xfs_alloc_compute_aligned(args, fbno, flen,
 					&rbno, &rlen, &busy_gen);
