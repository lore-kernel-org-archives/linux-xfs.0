Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107FE43550A;
	Wed, 23 Sep 2026 05:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143137; cv=none; b=a2LHmkmF0xK82gasCHeWY5IkqPK6plSU2ocmfGw8UidWNEg2h/NUkeo8gCrJL+6r9gj1gx6YvkE0mIVdvohTmP/+++wBqLYEvH14pR3slqFmF2VRZlbscg22QHaMddjyr4oroo8LGuP/5bo+YZNbzsxnZ1LVcvZx1cKAjYPcDX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143137; c=relaxed/simple;
	bh=DyTT6JOfxcC8j+WJyUwztUUsgtXS2xs6Nb/vTCJmV1E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=azDhWfpT86U7QxKxW0SZiFudhTvqxnBQveNnH3V6gxp3dr9XMv20SmS9LK665VJhw9XYJ6iWAsXvmNpL19aCNGS3+WfI1KXUr/DEAGJyoWMWWRt0Txm3cl/rIsPhrccHnwxHaTN2ef/tfKj1spdJrqdaD2NsckHRmdPcJZEzYz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=klLVo5zr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="klLVo5zr"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CC76C1F000FF;
	Wed, 23 Sep 2026 05:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143135;
	bh=uqymfBx4xAC/4hBDGq3baa1oRrcjWF5luhSfl4oM0W8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=klLVo5zrajwpEb3P6BeazAhcdvHy5fEHr9hH/7zPlrGSLDi1ixJPjdfkgCqIl44Sh
	 sLIpHTewLale7Xuqv4fWB/3hwEy5N2e09ioeWkOrzM6a+gP+cBxm1UKOyHPAGlSO+i
	 DKDy0TZK3ouT6CkfetANOggEOf7neSXFXXowQzQnIQHSvANWmSE+VTCbx/4nAXm4vO
	 XM6Jk8W9bb11JjficTzFv+OLyIdfdRu4JGVDYjEVCH0BOgWKb3rSLgGtnLS0PMPYDz
	 Jl+LC75JKIG2yeZhFGoAPqrbEOYEAoWsyBxhv0apHfInCIy8IVFoRsOoxuIcfqkGBH
	 AT69BmUQJsDSw==
Date: Tue, 22 Sep 2026 22:58:55 -0700
Subject: [PATCH 06/13] xfs: fix xfs_rename_space_res for non-pptr filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179014159056.1874904.9638907600469901446.stgit@frogsfrogsfrogs>
In-Reply-To: <179014158847.1874904.13591868745136552281.stgit@frogsfrogsfrogs>
References: <179014158847.1874904.13591868745136552281.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We don't need to reserve space for a parent pointer update for an
existing target if parent pointers are disabled.  Fix this regression
(which LOLLM noticed) so that rename reservations go back to what they
were before parent pointers.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 5a8338c88284df ("xfs: Add parent pointers to rename")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_trans_space.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_trans_space.c b/fs/xfs/libxfs/xfs_trans_space.c
index c4cd547033e584..7edd0d86f0bdb2 100644
--- a/fs/xfs/libxfs/xfs_trans_space.c
+++ b/fs/xfs/libxfs/xfs_trans_space.c
@@ -127,10 +127,10 @@ xfs_rename_space_res(
 		if (has_whiteout)
 			ret += xfs_parent_calc_space_res(mp, src_namelen);
 		ret += 2 * xfs_parent_calc_space_res(mp, target_namelen);
+
+		if (target_exists)
+			ret += xfs_parent_calc_space_res(mp, target_namelen);
 	}
 
-	if (target_exists)
-		ret += xfs_parent_calc_space_res(mp, target_namelen);
-
 	return ret;
 }

