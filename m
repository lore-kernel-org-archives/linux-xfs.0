Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795656647;
	b=WGaSJkvzgFyWuLgA3I8uli4fuPSzmRuueCxPmDS50a8o5F8KuJz0M4bSXsuiLT2jdjLB
	 /G1PJmVtcfKK45TgRogR3KvYYB2ngeG8BV91oEUlYxLIp3lx7AbzifKoc8uVlF81TaCSx
	 ZLzwRrT5RpcZj1hHJ6IKYeyCVHQgQ51lZ9zHrf/0czYuyTjx9jZajGsZvHxzBKhv6OEn2
	 8ckIm/htuFOXhGOu7gff2Q+geVxQrabl3NavXnT3wpm0GzdQjtGrNukZWPrTW/UMR1Z/C
	 L2vwa2UK0biJ1nuU0kq5QYw25gd+E3dw05ne50070cQXfoTxvJPpeTDWzthOdKxVOKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795656647;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=B7+XUUhyxk6IXkM7wXCrImejbkh4PLopZ1JC4w6bI80=;
	b=Z9hZYgHXQmbtwSY5G5e6gwSdJY84HVkQ/DWAjxQ6OVXN8gVMcHN18RvM8+vAGoK4ywKt
	 yp0GVVPVMiuYgH5HU11pp/4JFesGhc3Mm6oHcTU391J7CkGlmuTW+FY1FVnh5XcSrzpZg
	 OdaI1nDKC5deFANGr0KDdd1DDW1rOr2xEiP0zeyT34Dg7OxKffeoCBShG6hSozBJfC0b8
	 lFpbAsaeZOppR4EfrCBvW5uSHC/gSlGVqQIO4MNiwn44K+8pFZcTmUnjA7CEZohrPw/7j
	 vs4m/LwasyFOgkqf8b6IYZnMUiynVnVSrrJvZyiNvcKYoev6gFIydhL/tOwzwlOcwkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=FWJQCWnp;
	arc=none smtp.remote-ip=220.197.31.3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D4B606A31E;
	Thu, 26 Nov 2026 01:30:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41D4B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=FWJQCWnp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=B7
	+XUUhyxk6IXkM7wXCrImejbkh4PLopZ1JC4w6bI80=; b=FWJQCWnpoqBqcjxCoO
	Nrzlbsx1zKrknYA/onErYe4ae7qVMo7Qx4rxEX+w0XDHo4ZpIeO+FCdqRmSrTKes
	Y+jupF6WhAcVaZMfGj3hGMjm6FRx5zNzQQd59x5QciolzL10R8Pn1LsIixy8XDhU
	qI7mKZJc0sBgM3EDUz6cnKv+8=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wB3VCGhiwdr3Kw5KQ--.18805S2;
	Thu, 26 Nov 2026 09:30:10 +0800 (CST)
From: zhangshida2026@163.com
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida2026@163.com,
	Shida Zhang <zhangshida@kylinos.cn>
Subject: [PATCH v2 0/2] xfs: optimize getfsmap by reusing and advancing the refcount cursor
Date: Thu, 26 Nov 2026 09:30:07 +0800
Message-Id: <20261126013009.533557-1-zhangshida2026@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261123075048.3658960-1-zhangshida@kylinos.cn>
References: <20261123075048.3658960-1-zhangshida@kylinos.cn>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wB3VCGhiwdr3Kw5KQ--.18805S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZryDCF4DZw1DGF4DJFyfXrb_yoW8tr15pr
	Z5KrW3Cw4kK3Z7Z3Z3Aw10qF1Fq3y8tw4rWr9xGrWUC347JryIvwn3KF15Za42krWrAF1Y
	qr4q93WfCF4vkFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zNjgsUUUUUU=
X-CM-SenderInfo: x2kd0wxvklvtasqslqqrwthudrp/xtbC5wKns2sHi6LxqwAA3u

From: Shida Zhang <zhangshida@kylinos.cn>

GETFSMAP walks the rmap btree in increasing startblock order and asks
the refcount btree whether each record's blocks are shared.  Every
record pays a cursor alloc/free and a root-to-leaf btree search, even
though the next query is almost always the next refcount record.

This series keeps one refcount cursor per group, positions it once, and
advances it with xfs_btree_increment() as the rmap walk moves forward.
Patch 1 factors out the cursor cleanup so patch 2 can add the cached
refcount cursor without duplicating it.

Measured with a kernel-isolated FS_IOC_GETFSMAP loop over the whole data
device (3000 reflinked 256KB files, mkfs -m rmapbt=1,reflink=1 -d
agcount=4, Kunpeng 920 + NVMe), mean of three interleaved A/B runs:

                      original    this series
  walk time           3048 us     324 us   (9.4x)
  xfs_btree_lookup    10.7%       ~0%      (% of cycles)

The full fsmap output is byte-identical before and after (6421 records).

---

v2:
 - split into a prep patch (xfs_getfsmap_del_cursors helper) and the
   optimization, per hch
 - merged the cursor alloc and initial-position branches, removed
   rc_positioned; alloc+position is now xfs_getfsmap_refcount_init()
 - EOF check moved before cursor allocation; rc_eof reset on cursor
   free so it can't leak across groups
 - fixed all lines over 80 columns and the rc_cur indentation
 - reworded the commit messages

v1: https://lore.kernel.org/linux-xfs/20261123075048.3658960-1-zhangshida@kylinos.cn/

Testing (7.3.4, Kunpeng 920 + NVMe, mkfs -m rmapbt=1,reflink=1):
 - full xfstests -g auto: 1166 tests run; the 30 failures are environmental
   (none use fsmap) and reproduce on the unpatched base kernel
 - data fsmap byte-identical base vs series (6421 records)
 - realtime reflink (rtrefcountbt) path exercised: fsmap over a reflinked
   realtime volume is byte-identical, 1000 shared records

Shida Zhang (2):
  xfs: factor out a xfs_getfsmap_del_cursors helper
  xfs: optimize getfsmap by reusing and advancing the refcount cursor

 fs/xfs/xfs_fsmap.c | 149 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 125 insertions(+), 24 deletions(-)

-- 
2.34.1

