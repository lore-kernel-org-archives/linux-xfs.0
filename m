Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCBB3806B8;
	Wed, 27 May 2026 03:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779853212; cv=none; b=WvAJ/74OmJNskASLy6ajXv/ZE6NzN5eDwBTXc5rSUP4VuCdCF8BvUro/2nm+8o/0U2Qqa+dgzDS/lqF4cDbSnGSDmOiwyrlONCx8dYE6Mef06aSVg8b8TxVMu5b4OL3JUoLst/hlaydraIcn2PLEymYPRb+Ao7g1cf8G2QC21AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779853212; c=relaxed/simple;
	bh=rD/7smxtCWGdB63HCGffJ+lhKe+iBQENj5j6LmBUtZc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ntcx4ehsB+/NMGziMoWGSVQ/FnY5kouYgzyG541p/IXZrAs08+yVkGFlykFx7e6FWvM2+FXeLu66bxRyX639TqYB1PUzEeInxZ3Uv9IEvZ9xMbbHA6hLg64v5sDHo4QGQssDQIhaRqeOe4UXg1erCnogDVsmp/Ay/5scpufqZ/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=WrTcZLir; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="WrTcZLir"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1779853158;
	bh=6cj3NzQGuTlVF8dGDT/c5Xp7rgw7XTX7/l9MbyGp/UE=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=WrTcZLirNCdg1Fyw44j8yL/kt2fEyvsyJTCdXpL055Iu0IopGKXIraxEUNxeMyL+Q
	 jFOBjaFEGX747jbfDskDoaUgeIWKhl4wLgiwq+KApPhNW1F47BknU/z3CPp1GkHXm+
	 5fmRCHf/Tk4ecws00ZrLlikt5XJZ9z3dkAQCOSWw=
X-QQ-mid: esmtpsz10t1779853153t962e7332
X-QQ-Originating-IP: EyLCVXSnBA61i0kSP3GeAubnIVW7Cj9V7Hb2tg0MFKg=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 27 May 2026 11:39:12 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 13589331738088422060
EX-QQ-RecipientCnt: 5
From: Yingjie Gao <gaoyingjie@uniontech.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	Yingjie Gao <gaoyingjie@uniontech.com>
Subject: [PATCH v2 2/2] xfs: fix rtgroup cleanup in CoW fork repair
Date: Wed, 27 May 2026 11:39:02 +0800
Message-Id: <20260527033902.1524007-3-gaoyingjie@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260527033902.1524007-1-gaoyingjie@uniontech.com>
References: <20260526123243.1078867-1-gaoyingjie@uniontech.com>
 <20260527033902.1524007-1-gaoyingjie@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-1
X-QQ-XMAILINFO: OA34ehyuJLv3DZolSu9tdXHDQWzl83J7pqI21vrq8vEqJYRK+OodBlTK
	Iatk4CAQB39f0VSZiXjpaaGHdo/t7ERHoztAM6EuHM1hKaeG0IH4nNYHC8fPRaMaKwX9pYy
	/H9DYRZmN51TvtAVsuiPuRoHpBKWW5EmXJgrNNOkh5I1EJ7xtU52YPN+hGdIKQb6J5Jrjpt
	R6ov7N9CIRQ/Qn8IkMJKarwTNGaVisf1OuDEbjWPvqqC+sYquTVz4JcUZbj6T0l67rva6iE
	6hkleJVrCCzP755lk1T71cJN4rPDbFE2gUZ1yHROoH2IRg0eyShlKjDYVhfdCzchGiSwkwA
	cBvQQBCjXrq9Zl7NSu14N56tfzPe7lrRrOZ0rdCWUKuMj3b/QPvYx+JYV7y0JNB23+9kr6R
	+whaDz3Hline0EoLgg8PdJY+6HPpLg6qSth5K0qoVo0/KFt/zb84rQWKhEiItX/flUHwjr+
	GpqEI3C06JdVScI8xJT7YoePLwyjc2wiXFjLrsZTPp6R0/3oHAbytwqjkVljVfbEDPJ4V4f
	z69slB9+O1rw6hW9q3qo8UygqH0IhBex6MoXarXO1YKnsFC4R659lMgKQ3KlfHwdJjgO+e8
	cvWzbYB/6APCymNVRPUOu6E14oT+NJEBGlYAG3+/nMYkPLUnl9RRaf8ZJtl0RUM3It4jDcF
	/RWtL1rgw1CJGNFuFUOGr8MmpsijCQ+jl5gOfKBpkPQe2ExyCRGQxnTS7vV2NZeuo/7lQe4
	gZKdzuGLTYmG12zUOZbJaaswcGN9yryGkDBt+aNFa/37wZEzsekIqcVrfse6/FPwIHF11ko
	+l/u8Am/by8r0iXIJPUYYvBhjFsz4X5HgRwfCBXw3uqTa9bd1nrSqD/YM9zL6b8hOlXQHoY
	4J6GFn+K6WTjNZ1Hzyd51tyZcE/SMIGCC8T3EcQEDE0YfwbKCMWlz+tbkbIq5c3vKqFK3yQ
	pumZYGlur/Fq8mTEYuxApwu0/3wu+0xzqwdnaWosC1+K7TeW3gpkDJQv0m5Zj6lQlkRNBV1
	bl0b/LaeUYJKsZXcMedkLWAXBNLSJOmNmBlguBAHaZibImhuZm03SNVjretPD8kOTYJziyq
	TCloBe2K16g
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0

xrep_cow_find_bad_rt() initializes scrub rtgroup state before the
force-rebuild path calls xrep_cow_mark_file_range(). If that call
fails, the code jumps directly to out_rtg, which skips the scrub
rtgroup cleanup and only drops the local rtgroup reference.

Remove the unnecessary jump so the function falls through to out_sr,
ensuring the realtime cursors, lock state, and sr->rtg reference are
released before returning.

Fixes: fd97fe111208 ("xfs: fix CoW forks for realtime files")
Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
---
 fs/xfs/scrub/cow_repair.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index d23238830216..e4ca24623135 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -386,8 +386,6 @@ xrep_cow_find_bad_rt(
 	    XFS_TEST_ERROR(sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR)) {
 		error = xrep_cow_mark_file_range(xc, xc->irec.br_startblock,
 				xc->irec.br_blockcount);
-		if (error)
-			goto out_rtg;
 	}
 
 out_sr:
-- 
2.20.1

