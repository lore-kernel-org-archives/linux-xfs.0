Received: from mx.swemel.ru (mx.swemel.ru [95.143.211.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6117C19C578;
	Mon, 23 Sep 2024 15:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.143.211.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727107085; cv=none; b=pdhpsk3gTae9HXsYbrtIzBW7pKhbZvO2BS3v+brAqGLSDYs1E9GeaY5b/ZdraBV5Q8FKoLpDFEpUGxcgNZAkEDYiVqNgeeUWSF8Vmlg44RZsaN/ozaHfxwY5FpKr5B6QPe2b+xsIvhg/azRoIhM4EJaoAlglfjwTYpKdF8mz1Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727107085; c=relaxed/simple;
	bh=a9BxBT1wCsc64mDbrrLB8LyO97F4nWvsqQxh7Vxni3Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tqQAufI2xp1y6yQwfrlM6ArcGW+K2ZdyG6/u15j4QpUbycbtetsbtWc4/ba0PH5j6c5s3gotgTMbFQ5GsTKSrTuJjKcJ+2zgRwKGlqY6v1heivmJdUO7riCtbwBNC1vadjIdYkOMfnRVEWaif5upZe3rriWzXWVLyKnaQpkobmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=swemel.ru; spf=pass smtp.mailfrom=swemel.ru; dkim=pass (1024-bit key) header.d=swemel.ru header.i=@swemel.ru header.b=C5pG950E; arc=none smtp.client-ip=95.143.211.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=swemel.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=swemel.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=swemel.ru header.i=@swemel.ru header.b="C5pG950E"
From: Andrey Kalachev <kalachev@swemel.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=swemel.ru; s=mail;
	t=1727107072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=a9BxBT1wCsc64mDbrrLB8LyO97F4nWvsqQxh7Vxni3Y=;
	b=C5pG950EhOtuNimW191S9KrqksQ0/MvpfhTaTBDoJr0uLHsHSTCi8Hl8VMScdHxaFsNYPY
	ICCuKeT2GfEEzhinmUQL6elTkurMC8orSLG6X9rt1C5n8tu+QEGAsEbTgZuJq2ixHwqlRi
	odT7yz5Sd7p4YQdWHF6pHULmeNz9Wa0=
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	kalachev@swemel.ru,
	lvc-project@linuxtesting.org,
	syzbot+66f256de193ab682584f@syzkaller.appspotmail.com,
	syzbot+904ffc7f25c759741787@syzkaller.appspotmail.com
Subject: RESEND. syzbot: KASAN: slab-out-of-bounds Read in xlog_pack_data
Date: Mon, 23 Sep 2024 18:57:49 +0300
Message-Id: <20240923155752.8443-1-kalachev@swemel.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

I found that the syzbot bug 'KASAN: slab-out-of-bounds Read in xlog_pack_data' [1]
has been fixed in master branch since v6.4-rc6-11-gf1e1765aad7d [2].
But, it still exist in LTS kernels: 5.4, 5.10, 5.15 [3], 6.1 [4]
Common c-reproducer code can be found here [5].

I've made backport f1e1765aad7d ("xfs: journal geometry is not properly bounds checked")
Patch for v5.15 & v6.1 is same with original upstream code.
Patches for v5.4 and v5.10 has some cosmetic variations:
`xfs_has_crc(mp)` call replaced by `xfs_sb_version_hascrc(&mp->m_sb)` at most.

I would be grateful for any assistance.

Regards,
AK

[1] https://syzkaller.appspot.com/bug?extid=b7854dc75e15ffc8c2ae
[2] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=f1e1765aad7de7a8b8102044fc6a44684bc36180
[3] https://syzkaller.appspot.com/bug?extid=66f256de193ab682584f
[4] https://syzkaller.appspot.com/bug?extid=904ffc7f25c759741787
[5] https://syzkaller.appspot.com/text?tag=ReproC&x=152f7343280000

Reported-by: syzbot+66f256de193ab682584f@syzkaller.appspotmail.com
Reported-by: syzbot+904ffc7f25c759741787@syzkaller.appspotmail.com

