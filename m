Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EDC38F624;
	Mon, 28 Sep 2026 06:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576307; cv=none; b=d0/7urD18uULuCQheUJ8v8o9rgo5PGAqu50ywBVyrijHVCTqv2p2Pvr3KjAmd4dSdRPrUt9DmqiXfEXWm6AaEtitF1wa53Xf3fGM1uHPTIYdfacGmhL3zwUbGN24rUXFbmdtUQMZf0tQvHY3HZ8jyzSRFUBbVRde1NhARqIkFBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576307; c=relaxed/simple;
	bh=Lxe++oRuWusWOlA1C57iABup/94PE5Zqhb2BwZzDyeg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aojMFsFixJtR2p3NKC6PSrXbZOA6bRgJax2Mz6dysY859KfQ1bB2R4Mj/GiwS+MAlhOCW3UghfytJlpmKecch0vnEvYMxQf8f8Im4oA7JRCwnmh4QlbwKPm7lVkVrVhifUW0OEe2GqiAntMmi+PmoCahZOHRAE+Qhu0Ka3zAhsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KVjejQUm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KVjejQUm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1E9071F000FF;
	Mon, 28 Sep 2026 06:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576306;
	bh=MElZvaMx9+YZVi0xbqvCq9HvHYZp+Cse/WCuWr7iryY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=KVjejQUmMZ0LHjb3upD5dvBCvVvqepFRPO34hwRXnXQOjaMJBgFisxPJrMk6jIpA2
	 5rWd9LJoj5ohTWSCaVnPHpxLhD9hzSqwU12mr2a/80m4H34J7U9ZFP8m6du0ZINd1H
	 O61rJcrQZ92/k/0EjvB1bMwQAl+CwYDLV+V28YIJgvn1kVNnQ0fF4mXtlTyH70C9BK
	 AhD7MOu8CRbh83IHenOoXpLncJ84EoKzRMvIQP+uXawfnhlzCuJR7DoK46PWzJZ+bC
	 WlBrLPko+IlgKlHky2MHNsWOr05KftvFLSkfLrn9jAjS8lCwCf/WM5RG15oVjFbytQ
	 sKN15D92nsxWA==
Date: Sun, 27 Sep 2026 23:18:25 -0700
Subject: [PATCH 10/12] xfs: fix skipped inode mask handling in iscan
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179057612809.479634.4326694692538999212.stgit@frogsfrogsfrogs>
In-Reply-To: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

xfs_highbit64() returns -1 if none of the bits in its argument are set.
In this particular callsite, a totally zeroed mask means that no inodes
were skipped, so executing the if-body is incorrect.  Fix that.

Cc: <stable@vger.kernel.org> # v6.9
Fixes: 82334a79c6eb1c ("xfs: iscan batching should handle unallocated inodes too")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/iscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/iscan.c b/fs/xfs/scrub/iscan.c
index 03f72ba9e7a3a0..33cfce603b5b0d 100644
--- a/fs/xfs/scrub/iscan.c
+++ b/fs/xfs/scrub/iscan.c
@@ -545,7 +545,7 @@ xchk_iscan_finish_batch(
 
 	mutex_lock(&iscan->lock);
 
-	if (iscan->__batch_ino != NULLFSINO) {
+	if (iscan->__batch_ino != NULLFSINO && iscan->__skipped_inomask) {
 		highest_skipped = iscan->__batch_ino +
 					xfs_highbit64(iscan->__skipped_inomask);
 		iscan->__visited_ino = max(iscan->__visited_ino,

