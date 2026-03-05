Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD17A2AD16
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 04:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772684664; cv=none; b=T41p+fTmQwXk8Et7AwbEofwKIO2pw/gXUECaTNPL/dR0F1KaBRGCEDoCApMnPo7ElZaEdZctLXzdooUh5289Ni2BAYWMONcIwZUGisOluSs4Y2Gq6XpsK+QriTpHuPp3EkQd3u6P41rDpdeKeRyC9wThEaw9VGZsGSiAWR3PnWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772684664; c=relaxed/simple;
	bh=nZ9icwxnPvTi/guNnFokU7MoJjPg+bb6AL1HGr0Kpoo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uNpjLsm3MVVDGDJc9/rfBdUjXbla2+m/MV3SpUgmqE+6mqAH+Gvex5dyqkb8KcLhaQQLHKe+9pLAvW4OFmddbNPMlKvEyjh72N/nysnSJoWmNbX/uvhvrYho9EiLnkqymeHH/V80Q+3ietS/Z+8e47afc15gO/mBrTpgPP9QbbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WnIahIGw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WnIahIGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367D1C116C6;
	Thu,  5 Mar 2026 04:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772684664;
	bh=nZ9icwxnPvTi/guNnFokU7MoJjPg+bb6AL1HGr0Kpoo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WnIahIGw6EocvhHnP5+RNp9Y2K6oDdnBf/qq1MaDWHzsKAi39rcY04FOLrsxOS+pW
	 lbY1Im15HTKkMoyJi92PbZ9/ZT/C27etGDwPu7NbCR3xFgdq+39KsGeYCRd1Tk/nGv
	 tkObCEboNxCM38BoFjLD8z/mKGJy4ro6Yh5fETOVljagUK4Eh1zEy/sxRyVJncEe0y
	 TJVpV/4/eVMr3G9ScoE9QE6V+Y6OEBD7kjR7JHCNmqnh8h6Mt5SwvFnS9jCUcz9LUL
	 UxTDqjtkTtlQLHzRqRz32iP9l5xIkRQcuyNMc9uoL6Il5wvJdwQAN0EDfbpHyveHep
	 VoNy1dnf1P4Tw==
Date: Wed, 04 Mar 2026 20:24:23 -0800
Subject: [PATCH 2/4] libxfs: fix data corruption bug in libxfs_file_write
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177268457046.1999857.4333152615677714192.stgit@frogsfrogsfrogs>
In-Reply-To: <177268456992.1999857.6319345892309281117.stgit@frogsfrogsfrogs>
References: <177268456992.1999857.6319345892309281117.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

libxfs_file_write tries to initialize the entire file block buffer,
which includes zeroing the head portion if @pos is not aligned to the
filesystem block size.  However, @buf is the file data to copy in at
position @pos, not the position of the file block.  Therefore, block_off
should be added to b_addr, not buf.

Cc: <linux-xfs@vger.kernel.org> # v6.13.0
Fixes: 73fb78e5ee8940 ("mkfs: support copying in large or sparse files")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/util.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index 8dba3ef0c66139..2b1c32efc4709a 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -650,7 +650,8 @@ get_random_u32(void)
 
 /*
  * Write a buffer to a file on the data device.  There must not be sparse holes
- * or unwritten extents.
+ * or unwritten extents, and the blocks underneath the file range will be
+ * completely overwritten.
  */
 int
 libxfs_file_write(
@@ -697,7 +698,7 @@ libxfs_file_write(
 		if (block_off > 0)
 			memset((char *)bp->b_addr, 0, block_off);
 		count = min(len, XFS_FSB_TO_B(mp, map.br_blockcount));
-		memmove(bp->b_addr, buf + block_off, count);
+		memmove(bp->b_addr + block_off, buf, count);
 		bcount = BBTOB(bp->b_length);
 		if (count < bcount)
 			memset((char *)bp->b_addr + block_off + count, 0,

