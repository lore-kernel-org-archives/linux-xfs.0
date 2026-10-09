Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A05F35C6B8
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589930; cv=none; b=bJGb/2Jrs69NOSDbu09OfWwiBTt0KbtRQFmDuZOqTTJQEAQrKdW51DPe4wPRn3eqX3julnrpgQnbNvSR9lbQGEKvfKTu68Ft75OtBanE0H2Ks5W15pMX0lFFPJ4rmBZki6nIOoV4zFtBsqrjDsSoi2IM5OFw+6USHrEWgPLN0Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589930; c=relaxed/simple;
	bh=VefxTVd9sSu93P0QOjNoSed+Svyut5X1YhYXuhRVNRE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n1EOgtJf6Tuf0nfowrHsAP2uYWtE/HqVPeWMbZubuZZKE8DQ9aSxIv0sRSC0ygcnRvez7xon/l9OlfsKGiQvIRSoJWxT7YRFfdoEbXJ+pANk2evi51F+5KvJz5Tx/h07AGHmXiWTKhbj0dZqNxIiUnSXrMXa6fMYUxOypi7/3KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oiYUGrNL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oiYUGrNL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DD14B1F000FF;
	Fri,  9 Oct 2026 23:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589929;
	bh=ZWBxFKJFJMaURIOppuNEwbrjxa6/urTFUjOl43n6VrI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=oiYUGrNL+P0t9+bwLaY/q7T4sHjmSeckRXjB10S1Vt+Pz7lh1ktTpOJ/OE32c5IVS
	 zNXuxq9J+R4AlYoLG5sKxKDCNr2lLL2jdmNfWhr8qtaJ2w3A9S9+ZAhUxDsNihenV6
	 y0vxAjoo3293qZpClCQefHdQ9YtAyLB2Xv8CbqBMabSS+SrhI2nZm/Hd/uTDWWOm9d
	 74ZYX4r0mzDZCinZXsVoheHcCo6vIKP5kI9iNfAD9RO1q8gmaNnq+d/+u8MuhWMkg8
	 WaRer/XQz7JCHnZKOeD6ns1tjnoYTCn6hqAgVywMdJWOM3y0ZPLB4LyWRAPJVFFRs/
	 X4fYVONQZyD1Q==
Date: Fri, 09 Oct 2026 16:52:08 -0700
Subject: [PATCH 25/26] xfs: don't let hidden_space go negative in
 xfs_metafile_resv_init
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <179158947827.3719791.11673973131039119534.stgit@frogsfrogsfrogs>
In-Reply-To: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 476582d754cdc5110f806001417fea6c77824c13

LOLLM points out that if the amount of fdblocks that we can reserve for
a metadata btree file goes below the space already used by that file,
then the hidden_space subtraction can underflow, causing
xfs_dec_fdblocks to subtract a huge amount of space.  We never want the
target to be less than the used sapce, so fix the logic that adjusts
dblocks_avail downwards.

Also fix an error in the adjacent comment.

Fixes: 1df8d75030b787 ("xfs: make metabtree reservations global")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_metafile.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_metafile.c b/libxfs/xfs_metafile.c
index 71f004e9dc6451..1f54d39003c27c 100644
--- a/libxfs/xfs_metafile.c
+++ b/libxfs/xfs_metafile.c
@@ -297,14 +297,14 @@ xfs_metafile_resv_init(
 		goto out_unlock;
 
 	/*
-	 * Space taken by the per-AG metadata btrees are accounted on-disk as
-	 * used space.  We therefore only hide the space that is reserved but
-	 * not used by the trees.
+	 * Space taken by metadata btrees are accounted on-disk as used space.
+	 * We therefore only hide the space that is reserved but not used by
+	 * the trees.
 	 */
 	if (used > target)
 		target = used;
 	else if (target > dblocks_avail)
-		target = dblocks_avail;
+		target = max(dblocks_avail, used);
 	hidden_space = target - used;
 
 	error = xfs_dec_fdblocks(mp, hidden_space, true);

