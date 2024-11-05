Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405E21FF7AF;
	Tue,  5 Nov 2024 22:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844405; cv=none; b=BNCYJfWCtpaQQT/J6YOBI44zH8moadZiuT7DWoykkX2bKaQm1sSDaO4fmcr3Yrgt8oj+4Hh00GPufjuGoYi4B4NFz8T/Ju8+th4JkstfC9CzWze/nlQvWm6bNp/VnllumeaXP6JqOwk8EU/6vukX9W8XuLMVOs5imfmCt2pBGIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844405; c=relaxed/simple;
	bh=dwqnO8/nIbNQ8/CW7G0lUHOeCwGPaeu58QibsucpppQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YRMOAsA3uCFDOBraBZrBHHQRTZQ+EEWUabt0TnJoIhhwcHuw7CN+EzbSz6nv27nRy3eL9TconWUgiGD6wkBzEIDItxyLa7xjlxu/3h+RrBBAvNXkfI4N+cIhPaIo3fbKB89UyTyh+PMqDEr+PkjfSft+xXXZbs+I1cTAOu/EOiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DmaRe4vD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DmaRe4vD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18063C4CECF;
	Tue,  5 Nov 2024 22:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844405;
	bh=dwqnO8/nIbNQ8/CW7G0lUHOeCwGPaeu58QibsucpppQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DmaRe4vDOMg2AgPOsjI9Emrjp8HBeLbyfNCeChJeSByJrqYgUnK7u24ixMe8IGDWf
	 hpUNZMRJ5GIpxnLaEs3DngedBxj9rJN8JUgWJgXNe/ZxyQuwJVR4waKt+kULOc+Jcc
	 DlAqfuo6A8wnOh5orNAAJYXvHcHbM5M2MaCqGtR2obEgOJqxbo3UEyGkI8nBhvNq7p
	 SJolnjyy0/taOs/1XttIKNgj0VydDMlHdFZ+YrEdyrd8MZJY70vn9m+Z1h+rYzufzq
	 MIYbRkbkcsrwgr5IRuGSApQ4ZHlBdRGjXLEjBr/5U8jHaynPMFSCEMIGU2Nv5ypiDv
	 pCcwCS98MZILA==
Date: Tue, 05 Nov 2024 14:06:44 -0800
Subject: [PATCH 01/23] xfs: fix simplify extent lookup in
 xfs_can_free_eofblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173084394467.1868694.16975664441483419125.stgit@frogsfrogsfrogs>
In-Reply-To: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
References: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In commit 11f4c3a53adde, we tried to simplify the extent lookup in
xfs_can_free_eofblocks so that it doesn't incur the overhead of all the
extra stuff that xfs_bmapi_read does around the iext lookup.

Unfortunately, this causes regressions on generic/603, xfs/108,
generic/219, xfs/173, generic/694, xfs/052, generic/230, and xfs/441
when always_cow is turned on.  In all cases, the regressions take the
form of alwayscow files consuming rather more space than the golden
output is expecting.  I observed that in all these cases, the cause of
the excess space usage was due to CoW fork delalloc reservations that go
beyond EOF.

For alwayscow files we allow posteof delalloc CoW reservations because
all writes go through the CoW fork.  Recall that all extents in the CoW
fork are accounted for via i_delayed_blks, which means that prior to
this patch, we'd invoke xfs_free_eofblocks on first close if anything
was in the CoW fork.  Now we don't do that.

Fix the problem by reverting the removal of the i_delayed_blks check.

Cc: <stable@vger.kernel.org> # v6.12-rc1
Fixes: 11f4c3a53adde ("xfs: simplify extent lookup in xfs_can_free_eofblocks")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 4719ec90029cb7..edaf193dbd5ccc 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -546,10 +546,14 @@ xfs_can_free_eofblocks(
 		return false;
 
 	/*
-	 * Check if there is an post-EOF extent to free.
+	 * Check if there is an post-EOF extent to free.  If there are any
+	 * delalloc blocks attached to the inode (data fork delalloc
+	 * reservations or CoW extents of any kind), we need to free them so
+	 * that inactivation doesn't fail to erase them.
 	 */
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	if (xfs_iext_lookup_extent(ip, &ip->i_df, end_fsb, &icur, &imap))
+	if (ip->i_delayed_blks ||
+	    xfs_iext_lookup_extent(ip, &ip->i_df, end_fsb, &icur, &imap))
 		found_blocks = true;
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	return found_blocks;

