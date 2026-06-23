Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9506723BD06;
	Tue, 23 Jun 2026 02:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782182577; cv=none; b=ct5X9k2lqkLAfAeTtfrr8DdDhOE5FlGrPg+iJdCy+766+7PNNWlsgy2l8s/2hjG7BoMeZ3AI+bfLZ6teNBFEpGWtsT4e0gNOuPnrtCM1UNWaZzwd4Kx0jqfVTFTKrnZPkBuk7M3I3Z+tF/PSZia89OyjRLSNe90rz54j2qNiBLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782182577; c=relaxed/simple;
	bh=u0doYcIZNkBG4PjKgaPAzTDjk/ocN4wKiGTjGHKWLAA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gGs/8Bgrci1CYMPmkSQMe0F8pKJQTQku2jSb/On5NJKwqLdIfOgHh2rtwA9lnE6vYKw+ZMJ0wwCgxXkwOHJPF6F1yDGxkwrtru7io41IVOYSK8h5IuPdFFMUGcif6cS5SE8NVaD4tLioiEbYYc1j39yOmdnHMulXOYETSpSZNBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=A91+Tuha; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="A91+Tuha"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1782182523;
	bh=vQCqQSA+ScYdaDt+wzTyrK9zjDcuYXy/rZe8ZEHoor8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=A91+Tuha0zOy4IZKRlrO/7PhtSsf1/1FSjVnVQEwXsb6lWJdQDWoMlMENXzSCAzfA
	 ORO/NJOJzE4d225soXfJallm8X5F4At9S88fmjAg78NeSn5UDbJZHdSGtDf6s3z7JQ
	 9l8ffidbGqyeWWshPixba9jjzeybYLuanXUdD1Wo=
X-QQ-mid: esmtpgz15t1782182518taa0e8291
X-QQ-Originating-IP: dXb8rWpHSu6sETcRM8DFy/6ta9BIwUSrjdvirYg9nOk=
Received: from localhost.localdomain ( [1.85.7.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 23 Jun 2026 10:41:56 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4461836420273492138
EX-QQ-RecipientCnt: 7
From: jiazhenyuan <jiazhenyuan@uniontech.com>
To: cem@kernel.org,
	djwong@kernel.org,
	kees@kernel.org,
	linux-xfs@vger.kernel.org,
	hch@infradead.org
Cc: linux-kernel@vger.kernel.org,
	kernel@uniontech.com
Subject: [PATCH] xfs: fix AGFL extent count calculation in xrep_agfl_fill
Date: Tue, 23 Jun 2026 10:41:53 +0800
Message-Id: <20260623024153.835431-1-jiazhenyuan@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-0
X-QQ-XMAILINFO: NvZv44yBVOfed0ulvMLkJAK+EITz7XoImrdQ44rEUldBn9KSvXF8dlUl
	qqgBAHL6XPuqpyA7Eau9o6xukkIXDDUnwY2TgutSU7d9ENJDAIUOpnnhYxhAoUZsiItfxNu
	mdb2kyrVuOlQyMITe3qiCAGOer2zVKJwZWytmfKO/mi+vVmu3NQStTb244jGingKHIU2Z6z
	OFoBsf9AxMgeexmLDv0zRirYRFfE3rdYjm2BSV0m9bso7bq9ZnuM8+YBcCatqIXk/aclwqA
	z/RZ046+zzBj61cHb3nmconPYd4ixwzCTTSqALiqzfZ/e2PkwTKhh+2818wlcLuKNgm4tku
	m4BnW+OjKyG5Bz8N40q1lCFAhup8GUO8d7erfvs5gNqQVvXJuBSwcpOlttYNTkBtwv6Uh3J
	P0ICdLRAbvkTo4Bci33mlrCyIJ4vCNUxhN4mM9iR2ZLA2Y3vJrZcykwcRsM/2eyCGL2tOkK
	10sPOVFPIvWNFaXNkVbw5/T712e3zgW/sQS0R/WlZOFS8U98v7nO5tKhP7soIikMOyEXcnZ
	rBDfhBKsyQBX3w7RWhInC3TV4WQgyHthQWfSEX6oApWt8dHcUZw71nmMGbnVm/rzqwGS8CV
	sbDZ0VVemOcTUKoRBWMLwcdoRms8axLteYkwDECSZ06xY9nuBhPYcO6wxAJcGF4HvGeIMAj
	93YhGagJ9cfNDMH2LLOB0M2vhQi9zbEChIdTvbSlv/WoV/ZzRdW0t4ZLRfUNaxjoAZY63HY
	L1IrfoylbzxoEu81G7qnVNsMSSRqdF0V5ZH5O8B8opwcQQgWsG7XQpQYrRK5j+vfeQwOTP0
	07jgPl6HXFtVQlyjLaF4UE39WhMG46a5DkeFEcfj+zsWn16Ntz7tiK/YVIDK77SMCQJVeqU
	Hz3UXw6hH+oihVz7y4jq+5A4gDVHMGeUOjdkTaH4sWT++IR2SWTiXhAtzWz2Wl5UG1hZsRi
	gDihOgiAMA0rwOdeQ7RYNaPIMp1a9z6N1+SSmIEFW7+pOiqscPWeo+wGQxkcnXCIOOORH3I
	cE3AeKQKKTEyXDcutgKL7buQc0pcI4eyDLirNibBdVpl1F98B/Z7KxHxBx+mejhYf2CRjip
	11LSXs8X1g4bCixeDZLWEzQ27nvQHkoKA==
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0

In xrep_agfl_fill(), the call to xagb_bitmap_set() passes
'agbno - 1' as the length argument. However, xagb_bitmap_set()
expects a length (number of blocks), not an end block number.
Passing 'agbno - 1' causes used_extents to record an incorrect
range.

Fix this by calculating the correct length as 'agbno - start',
which represents the actual number of blocks filled into the AGFL.

Signed-off-by: jiazhenyuan <jiazhenyuan@uniontech.com>
---
 fs/xfs/scrub/agheader_repair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index ae9ed5f280d0..b0ffd37afb45 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -652,7 +652,7 @@ xrep_agfl_fill(
 	while (agbno < start + len && af->fl_off < af->flcount)
 		af->agfl_bno[af->fl_off++] = cpu_to_be32(agbno++);
 
-	error = xagb_bitmap_set(&af->used_extents, start, agbno - 1);
+	error = xagb_bitmap_set(&af->used_extents, start, agbno - start);
 	if (error)
 		return error;
 
-- 
2.20.1

