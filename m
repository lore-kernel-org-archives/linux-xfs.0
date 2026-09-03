Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A02495049
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435724; cv=none; b=R4ZcrPLzn6hclG0VKjnF4K9widn+6YKfLxaUe+aaAyWH0wLMqPkyUJu53ajlasIVeLus4MedafjEGyPE51VHg9SjcJuC5IdTF/KEYQdM1IvFsCtPVsKqCDlBqC5k0eHAkNknxiALWfLc/i3ExaQplJZfSncYO1FUuxZ9DmnTYEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435724; c=relaxed/simple;
	bh=bDYkzr3JcCNvMolJpf7m3Xa2IPHXoGw56GykjEHstQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GeHaGnj7sjskLatqIHXnfosV2tQqYf8u1tQOOcdIwvqGuPfS79iPE2bpxe8RNWsxrA1MRxrBQQTDJVUWJ/FYOQsGY0fB4YCCDqhN/5Fl7mACqaPkhogR3u0/fFmCl0Fyincx+Hyv3abjU/r8Fo+YGFeHKDRTV5SK8wtrHwrJZnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TZLWbdtz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TZLWbdtz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3E81F000E9;
	Thu,  3 Sep 2026 11:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435715;
	bh=gw7RFpad3US+ljSIla99ZV+s2NtI/EO+HqX7kfE5rnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZLWbdtznAf4iIYtoWBSFcLmY5nC7IbzwZ68TRUP2yqZC1J4PbSxHej864HWS5CRC
	 EtcR2/kNqF8fUgZ6sH5b7e6jWDkbgdCM9Q02JKH1rNBb8jMn5wdT+HR03OXUI8epUc
	 vdcvTpWTOYsWjb5HcdUe236P0Be0Tfc6QArkvaaTI96ko2KAJqw7YDag5taMO+HBb1
	 ntDmxQwOH0PiFOnVKtqBQqvI661xSUqIfwIVSvkhTcW4n0pKoB8+KjUCx7VDYXytsD
	 Ew45lOCrhhOU3pSF5DDV+0tu+EDATuIrKnnxo3DQcrI/5/n+YMpy/O/4QUKcD9N8Ij
	 hnZYtl7uPSBKw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	aalbersh@kernel.org
Cc: bestswngs@gmail.com,
	brauner@kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	cmaiolino@redhat.com,
	dawei.feng@seu.edu.cn,
	djwong@kernel.org,
	gaoyingjie@uniontech.com,
	hch@lst.de,
	jiapenglin@tencent.com,
	roland.mainz@nrubsig.org,
	xmei5@asu.edu
Subject: [PATCH v2 20/23] xfs: fix null pointer dereference in tracepoint
Date: Thu,  3 Sep 2026 13:40:02 +0200
Message-ID: <20260903114022.570210-21-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903114022.570210-1-aalbersh@kernel.org>
References: <20260903114022.570210-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Source kernel commit: 9202ee546b0cd71004eed7598546efe4660097da

If dfp is not NULL we exit early here, when dfp is NULL it's allocated
in xfs_defer_alloc() but not assigned. The tracepoint tries to
dereference members of dfp struct.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Fixes: 3f3cec031099c3 ("xfs: force small EFIs for reaping btree extents")
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 3e36865fd127..eae2397fbff8 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -871,7 +871,7 @@ xfs_defer_add_barrier(
 	if (dfp)
 		return;
 
-	xfs_defer_alloc(&tp->t_dfops, &xfs_barrier_defer_type);
+	dfp = xfs_defer_alloc(&tp->t_dfops, &xfs_barrier_defer_type);
 
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, NULL);
 }
-- 
2.55.0

