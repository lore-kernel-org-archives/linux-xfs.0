Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D555013FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991922; cv=none; b=cQ1Ehz4UbYyVH1UYLbd+zFJjWz1YPLg5d5u7thHHii8OwAw0UmhhjBdzIW/2qsFSW/9cyA/8tbw1PywYNbmDPpdO3b8GGl0UsAflkgnw1FtO53wR8RJAlsh5fwZbu1lu9yAQz/xenTBQthiwvS58aU433bEUzgb98lR+lgR1ID0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991922; c=relaxed/simple;
	bh=Av/VOQdsA7QOQsWUD36EIwCE2gr5dwxG1IaXdqKJeqE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=egg+l71YwANrW0QJegSFFdaeM5myK7g74YEvIFDtY/5CsrJE4nDyrR6fA5sde38DIbVHM8X0wIn24Ei1xs+xzonkYDypP6UBHAjz7jyhuHQDj3lmzx3tT20qhiW/tXwOP66J70ITCyL3ay37y/ANlEZucrzy0t+rOUrYSIx5JNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kisAoHpT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kisAoHpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFD9C4CED3;
	Mon, 23 Dec 2024 22:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991922;
	bh=Av/VOQdsA7QOQsWUD36EIwCE2gr5dwxG1IaXdqKJeqE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kisAoHpTw5XBXX4aUx7V0JKEoHUAe1/p0IpEGUqi87UbzpPUcI5ANL1oPbfub1CeC
	 TSUyIXdrUKvrcu7TRYVKl5Mr+hNFc2VoUxc16kDoltxAgDF4LeN/NPtqTrKHuw8BQR
	 mo/ZdT0XuvKFDwKZcTOW7EV6I4TwoBJE2GWMcfa62M9wQhzxntjFH4jx+HXvOYXHIM
	 XOizyz4U9q9nhh6dMT8JgjziRBjphZII/YMuZER+FOJN75bYxndq6jOuw0OB8rjJwz
	 E1pYNd7Ac5Mv9RMRi6BtjstLPyBosKffX2UAUyfxGyhT8TA2Bv66bRfGTR4fudl4xz
	 01N+69gekOHtg==
Date: Mon, 23 Dec 2024 14:12:01 -0800
Subject: [PATCH 01/51] libxfs: remove XFS_ILOCK_RT*
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943818.2297565.622589230063864691.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we've centralized the realtime metadata locking routines, get
rid of the ILOCK subclasses since we now use explicit lockdep classes.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_priv.h |    2 --
 1 file changed, 2 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 1fc9c784b05054..dd24bdc2d169d9 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -180,8 +180,6 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #define XFS_ERRLEVEL_LOW		1
 #define XFS_ILOCK_EXCL			0
 #define XFS_ILOCK_SHARED		0
-#define XFS_ILOCK_RTBITMAP		0
-#define XFS_ILOCK_RTSUM			0
 #define XFS_IOLOCK_EXCL			0
 #define XFS_STATS_INC(mp, count)	do { (mp) = (mp); } while (0)
 #define XFS_STATS_DEC(mp, count, x)	do { (mp) = (mp); } while (0)

