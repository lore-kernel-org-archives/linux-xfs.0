Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B355BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jreWLFSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219F4C433C7;
	Sun, 31 Dec 2023 20:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054177;
	bh=knDl6xdBeETqOX0DdudIxei9by2QxOZnxFF4aPRwDA0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jreWLFSFhfFSVngvuekCZGteftVO2lcykIO+cWJGU8gYKHukoVL7wh9A4rJ2Ic/iW
	 eM0Plg//Cb982jFBgX1awM+fwwDaoSzWj06Pxjg6WxOJZrFRN+PgvwfNvTLdMae14d
	 bexgi5hTiupq+gdMrlup+A5jGX1PKHjzIxDjMcpiztn5R9ZKNBcTJfC5JxCDalP7ja
	 pLvIPjdmwCn96143GZ8svgYWsLwSGqHQUQZqXJtJ6AmpUnYn6soXxLk965k/dOA0OU
	 h/Qe+TgyExzKAHBWcp+E3fckgqfhROjOA7ohhH1xT6X2IIKI6iksygU/7xEa7AlUcm
	 9w027d41QF8Ew==
Date: Sun, 31 Dec 2023 12:22:56 -0800
Subject: [PATCH 3/3] xfs: support recovering bmap intent items targetting
 realtime extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404831924.1749931.14835443792114657795.stgit@frogsfrogsfrogs>
In-Reply-To: <170404831869.1749931.14460733843503552627.stgit@frogsfrogsfrogs>
References: <170404831869.1749931.14460733843503552627.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we have reflink on the realtime device, bmap intent items have
to support remapping extents on the realtime volume.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_item.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index d19f82c367f2b..02b872a133104 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -435,6 +435,9 @@ xfs_bui_validate(
 	if (!xfs_verify_fileext(mp, map->me_startoff, map->me_len))
 		return false;
 
+	if (map->me_flags & XFS_BMAP_EXTENT_REALTIME)
+		return xfs_verify_rtbext(mp, map->me_startblock, map->me_len);
+
 	return xfs_verify_fsbext(mp, map->me_startblock, map->me_len);
 }
 
@@ -509,6 +512,12 @@ xfs_bmap_recover_work(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
+	if (!!(map->me_flags & XFS_BMAP_EXTENT_REALTIME) !=
+	    xfs_ifork_is_realtime(ip, work->bi_whichfork)) {
+		error = -EFSCORRUPTED;
+		goto err_cancel;
+	}
+
 	if (work->bi_type == XFS_BMAP_MAP)
 		iext_delta = XFS_IEXT_ADD_NOSPLIT_CNT;
 	else

