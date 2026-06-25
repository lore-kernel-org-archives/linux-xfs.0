Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B65428504F
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 22:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782428148; cv=none; b=W1fisroIMxJgV0DSkd4Hf8HxncIeVzS81vrFK2nuYulWwONUsYr8FybnHNWAxSMBox0Qf11FmAQkvezzE1BPaEYApW8fhnLyaH78k8J7XdQjcI9Eg75Rl0+K2wuypQg6QYa/fA2uhodbnpE7nwF+6jhAGf4xf7M16AH6HrE8IQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782428148; c=relaxed/simple;
	bh=dlWmeafgE4FGXNV4F5Clz0jbsJkGANORPZXQVwtSe8E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bf/L5zMtrgql0yoagFvl98yrTvelQxD2dJ8lHipD6LgdGTTdQ77dJSygxfl5DBIRiWqKlNm6ezUB1CkJM+XZldH51M/emE3IUPWU6AHTtUnBiJKorcmNlWfNhYAOer936GnWeWsyQxpZKCmgqyR27SjCBCaVw7dX+xWIg3fdWDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HKpZrQnh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HKpZrQnh"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E79CF1F000E9;
	Thu, 25 Jun 2026 22:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782428147;
	bh=PLneEoMEcC2PE15zO3/aGBMcj57IxSQx+BTVuyzNRQA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=HKpZrQnhd2AyzrFzWDVmb8yMtTb89mYfhPkpLXIP8NrSr0ooSHUAT6naveTZ7dDCw
	 ojrn885/+ftv1JyQ1KdlN9Eokq7Lgl12TIzkdJS4OfkOGeuN4JnS5JGEaIpUYY2Eul
	 efIR9144+2c1XE8vsBev9NtCBNO74YtM5hqappc6XroLbOA9kvifz2KttPlt0wiMiA
	 f6v3Fk9fFyzzGufVXDcjxa+46AFkKhE0reNDhHob5OcbAOO/nVG0N+SI7kAvGQjpxY
	 Ce5GmTDvc/ObEjdRywaSbrQt7U+5jQwjb5382jWEvJEmmqfO+jGYyvOWFRTEHeM6wJ
	 VM3AOZ1HIuHBA==
Date: Thu, 25 Jun 2026 15:55:46 -0700
Subject: [PATCH 6/8] xfs_scrub: don't leak phase 5 scan items after a failed
 workqueue_add
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178242801415.1981574.15526143457820896308.stgit@frogsfrogsfrogs>
In-Reply-To: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs>
References: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex points out that queue_metapath_scan and queue_fs_scan fail to free
the allocated items if they are not consumed by workqueue_add().

Cc: <linux-xfs@vger.kernel.org> # v6.9.0
Fixes: 8fb4b471322e65 ("xfs_scrub: use multiple threads to run in-kernel metadata scrubs that scan inodes")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase5.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff --git a/scrub/phase5.c b/scrub/phase5.c
index 329d208d882ef1..fd1b70332deeee 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -687,8 +687,10 @@ queue_fs_scan(
 	item->abortedp = abortedp;
 
 	ret = -workqueue_add(wq, fs_scan_worker, nr, item);
-	if (ret)
+	if (ret) {
 		str_liberror(ctx, ret, _("queuing fs scan work"));
+		free(item);
+	}
 
 	return ret;
 }
@@ -764,8 +766,10 @@ queue_metapath_scan(
 	item->abortedp = abortedp;
 
 	ret = -workqueue_add(wq, fs_scan_worker, 0, item);
-	if (ret)
+	if (ret) {
 		str_liberror(ctx, ret, _("queuing metapath scan work"));
+		free(item);
+	}
 
 	return ret;
 }

