Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BBA348C77
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 11:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789387080; cv=none; b=iSdTuzyeHLabg32JRDyjI8IKwyyu8+g9jOYS2ltG67nOFO0Rgh7urXL0gaN/mwinjvcGdPc4y1XUcaGBC2bmqZGX/PYtu99sFd63n02K4GRN7S8GPiQW9a0E+dBEEALiPI7kcFOQDwG8XT1OScNDp2FD5E0srFtw4kVet/QH1To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789387080; c=relaxed/simple;
	bh=eN2ZlkgebznxWOKHLjDEjOQcBHNL29MZ8vdFD74TjxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqik6E7cnppLrSqOFY6LwFP78fKO92pci3ZZFr0STuiTE4NFncov0HOuky0XhgjXs3RDIdrY/tzcWHcyhkr1PdxlJvFemlbfkOuOZrrZoi1l0cO5UlE3fG3IJKDxJIAOflg81jrOHSS4lqXTVFClfz+klcHOP5+SkIkPt5q+s7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ee+2f7IS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ee+2f7IS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F3D1F000FF;
	Mon, 14 Sep 2026 11:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789387078;
	bh=sSt85GRInvKH3vgSt1itghuvZ6zm9tR2CV5enkuOqQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ee+2f7IS0mZDa5x9zWY9keIiE+AO09uyazpzIlA5j2ThcLgIASSTr0NFoFM7XJUYD
	 PwNzIzrFlSiSYXavi12ZaHpiODtEx7q5IWCLOI0vaCFPYmwCKSOaI5aBMUJZQHgeNH
	 NwPX2sQtTownlbE5EtNtw0A90RASH92udhpq8hCKf3kWB7iii6w98OzT3KBWOfpCJi
	 PUuDIYyvn7IojePlsOmbmdRMOm8tQ9V0Sa5yjwD3HA1QEpCmWvgBzD7tD6bCVQ7EnV
	 KoGqUYcsc0/0qmGiDjnpZPUz1gQpnX6OkYMRUYgyzDuWYdhLv8OF6DKT7Y5k2H8XB5
	 hYDZzYZGVrXiA==
From: cem@kernel.org
To: cem@kernel.org
Cc: djwong@kernel.org,
	hchc@last.de,
	sandeen@sandeen.net,
	linux-xfs@vger.kernel.org
Subject: [PATCH v2 3/3] xfs: make xfs_iomap_write_direct() report an error to xfs_trans_cancel
Date: Mon, 14 Sep 2026 13:57:41 +0200
Message-ID: <20260914115746.82122-4-cem@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914115746.82122-1-cem@kernel.org>
References: <20260914115746.82122-1-cem@kernel.org>
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
index 7c6238fed61e..4906a4828d11 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -358,7 +358,7 @@ xfs_iomap_write_direct(
 	return error;
 
 out_trans_cancel:
-	xfs_trans_cancel(tp);
+	xfs_trans_cancel_error(tp, error);
 	goto out_unlock;
 }
 
-- 
2.55.0

