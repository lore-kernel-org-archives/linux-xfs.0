Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03C844781A
	for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2026 10:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789641413; cv=none; b=FOl9gFVcAiElyTgQaSOZ8cUqUJJ2Hq/N0CINZ9FpcPTnFAOLc6Ia3d4p+EuQx17L+QXw88m81NDRt6blRKmdZ7/0GP78vPPmVAdzHcGl4bEDVXh0aERG9/77CAJnxAoYGMYgHWBs6RHDrFZlPqqICBCBxcrxC4MEkTPu9/GHFZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789641413; c=relaxed/simple;
	bh=eN2ZlkgebznxWOKHLjDEjOQcBHNL29MZ8vdFD74TjxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKtafTYHT1UQjKJa2epcGL1/WpVwLsFmQAK9BrDPz675KwAdiPcYvvAPepVVoEljUhf1QEnS0KUFHsFpaQkJklT/sl2CEBWDZ1pb0v15e4opwAOl0A5fy8NVnax72+CtaXqOp4XO/yAHoiFmNHIgjEPc8I0ehu1i4RbcUns2lHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nL6KUgSQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nL6KUgSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E27D1F00898;
	Thu, 17 Sep 2026 10:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789641407;
	bh=sSt85GRInvKH3vgSt1itghuvZ6zm9tR2CV5enkuOqQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nL6KUgSQDMAXO/aNf1rbq9E41aAbhEDa95wcaByeJr6PKiu5pONeoErUXdPdyeq0p
	 B2wd5qcYkneF8cc0CCsiiSMZoJB3OEimLGYX8mZSYM02EOGDBIEtX1H0rzhMf68rYo
	 2zRH6W4jEcj8S9phQIq2PdwIcFnh1lk9pQue+mSI8uolleOoRjV6CgtSu7dFscMfLS
	 OqxujcPryhh2sZSVR0m4nkpoLKN/kVKVDPMorrFPN/KGvDqMH/9ZEmyEuEls2gjowE
	 kDMt4GXu+kPqa5V0lU9q/0mo2G35F/8HPbr10i2DE0w+oN57H2J9XKBcRLzg11cp0m
	 m8vw5Qd3P95qA==
From: cem@kernel.org
To: cem@kernel.org
Cc: djwong@kernel.org,
	hch@lst.de,
	sandeen@sandeen.net,
	linux-xfs@vger.kernel.org
Subject: [PATCH v3 3/3] xfs: make xfs_iomap_write_direct() report an error to xfs_trans_cancel
Date: Thu, 17 Sep 2026 12:35:48 +0200
Message-ID: <20260917103633.14703-4-cem@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917103633.14703-1-cem@kernel.org>
References: <20260917103633.14703-1-cem@kernel.org>
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

