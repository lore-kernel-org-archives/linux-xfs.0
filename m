Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2773E52ED2C
	for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2026 14:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788879287; cv=none; b=NdRPvrI/mOGmvaoN58yZOMebUP2UaKGNQIUes8URpmY8U0m5UcSuhIjRPsBktaLNiBoagktYeTySnWu4o/cFQiKDxvkZQmMLbhYLN5hKlilOa2Zi/bn6lDph0kGDYbkyFDMVQIeQ8bRBRJ5iwIP3vZELzl+dxQI6e0NWWfyU0eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788879287; c=relaxed/simple;
	bh=wIZU9sLY5DTZg/des4muWXPvrGZ9zxtVWVtk+ZDUr5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCDRO7X+zthEdAXNDbOHwsKsTz/kfrCpiczw8kwQq7ZizS9dg3tF2hdErBdOied/llK4O5E3uVTcAX4PLUwjvkd6ulLut3KJuUAMUcHv8vOMqRDZWGDTvCJUWJku22uP76wh6s3UfVl+ZrUdLnddvGvMLoKCFjkOEmmC0rSRwnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gssBZ3xP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gssBZ3xP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E931F00A3A;
	Tue,  8 Sep 2026 14:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788879276;
	bh=A6bdfyquyO3DbOTjLlV8aqmn4Ism5M1SiLPsVmFDpzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gssBZ3xPXnP8Z/1Ovbyr1fXQBp3IjLXZ5PHv9OCtv7UFDNEsMp3vbJEZOpv3Uk1SU
	 YUqgFMCFssBHKK6RTZ0zafdAl4rOlHQ86Dmn1lVLGxCDv/dp3ddYaXLzLuMooIippS
	 F9XQqVSQVK6siWh/uoIXgGUcyKlDJ0jifTxUMjJxGZD06G65HCFdCLSIt2gcTNQRrT
	 d3kfy1DwQyvSyW4XhWZNNKoMazhNIM3noPSr0sgKy6j69rUK0Hg31OyfLzAUbcuqUw
	 QDsmzQNF80oxAhH2+YTHj4us/l8IGa/5zDL0ClAzrJd34ID9OatOsF2hCNrKfGwd2O
	 00anuOLEkaMqA==
From: cem@kernel.org
To: cem@kernel.org
Cc: hch@lst.de,
	djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: make xfs_iomap_write_direct() report an error to xfs_trans_cancel
Date: Tue,  8 Sep 2026 16:54:16 +0200
Message-ID: <20260908145422.232985-4-cem@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908145422.232985-1-cem@kernel.org>
References: <20260908145422.232985-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

I've been in the situation a few times where the transaction got
cancelled by some reason. Most of time because bmapi_write failed and I
start a guessing game trying to understand why.

So if xfs_iomap_write_direct fails and it causes the transaction to be
cancelled, send the error to xfs_trans_cancel so the error gets logged
into the kernel log buffer.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_iomap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index ff05e6b1b0bb..9fed19a34bd0 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -344,7 +344,7 @@ xfs_iomap_write_direct(
 	return error;
 
 out_trans_cancel:
-	xfs_trans_cancel(tp);
+	xfs_trans_cancel_error(tp, error);
 	goto out_unlock;
 }
 
-- 
2.55.0

