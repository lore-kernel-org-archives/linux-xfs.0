Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B518C29C328;
	Thu, 27 Aug 2026 05:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787808718; cv=none; b=eyLOZaWLsX5KMbuV5Q3BBBxgH2ygkAfeE47dIYtIX8U8CliXMWHxWphz+y84jtME9hmT1VWMXvjaWExcUXZGnBzUcb45dV+sgwHIpIABUnE6UM2wETEQwFKzD8SIXWIT564rSYY5CJq5xVBfci3I5yWXzSpzNZQWOV1gLQ1W/HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787808718; c=relaxed/simple;
	bh=gbT5f3yJ8IW7gkoA4iBWhmbvWCr5aMj1OAB0kbZksD4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jyNK28xS2mVRxZjSfz7UGrujbCwQ7Glc72rsODoVO/1XMgpHLnYmxJfQIKiy2NINKGavs0mnh0LvoimWnyHr56uhJek6ge9TpAQnt0QE9YGIIh/ZKVFFqOH8A7T8XFbCKmHVE+Hgad1t5A4yJtIPhomD1MAeXioW3p1lPe2TJKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hr2slcdx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hr2slcdx"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3A1401F000E9;
	Thu, 27 Aug 2026 05:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787808717;
	bh=0cb6qrC234NhP7I6aNY49uDD1BdV2YbOpIXaXub4VAU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=hr2slcdxYU0ze9MmZpcr+XWLAON1e8yX7IMMPkSD1fh/0YLFGNUF+AnSHA5cvm5XV
	 ggjzBAn5CmH+APMR4fstUUmgSoGSgdbDCuaWHP/KZz6ng3Bz5YDNAqA9C/YFu4wNCW
	 TTAnznVmxXiBrW1b5p4NONamSHhzVUb+kCMoUrWnZl0Rx/bJDlb0VHB7lVfKq+LQDv
	 I66paMg4u09ADI+DsPREgs70JUzwSHgAG9hbcpcl8YXwSOPX2ER5gHJmXGAVc+BVWi
	 TYvBL6LMCAG4GwkUnwmn/ihRTJZnZvIatKdv+lMwdT9K2vwt/laYqJXlKd9S1L8RPI
	 CPk1DwH+yaLYA==
Date: Wed, 26 Aug 2026 22:31:56 -0700
Subject: [PATCH 4/6] xfs: fix parent rec lookup initialization in
 xrep_metapath_unlink
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178780640261.3528187.8773003755579552693.stgit@frogsfrogsfrogs>
In-Reply-To: <178780640140.3528187.6786220801490019229.stgit@frogsfrogsfrogs>
References: <178780640140.3528187.6786220801490019229.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM notices that xrep_metapath_unlink looks for a parent pointer in
the child metafile that it's removing, but initializes the parent handle
using the child.  This is obviously incorrect, so fix that.

Cc: <stable@vger.kernel.org> # v6.13
Fixes: 0d2c636e489c11 ("xfs: repair metadata directory file path connectivity")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/metapath.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index ff1ff762b3003c..9f44c82910eaef 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -397,7 +397,7 @@ xrep_metapath_unlink(
 
 	/* Figure out if we're removing a parent pointer too. */
 	if (xfs_has_parent(mp)) {
-		xfs_inode_to_parent_rec(&rec, ip);
+		xfs_inode_to_parent_rec(&rec, mpath->dp);
 		error = xfs_parent_lookup(sc->tp, ip, &mpath->xname, &rec,
 				&mpath->pptr_args);
 		switch (error) {

