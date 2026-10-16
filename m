Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F121244687;
	Fri, 16 Oct 2026 03:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792121695; cv=none; b=L2Y7hmwWahK+fhLYnqAHexEhCzJUhO55l2znIr2EFxJ95sGblJ0MXGkBTebDcCuX/OQB1hmhKuoiknHmCz3azb1onUrqE9O5g9ezrStN+/RgbcgHrDLB6UAODcE2nNx0uyV1k61ky5mkUEWMHn8MWuh31YuJpJVo1eIC+DWoh8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792121695; c=relaxed/simple;
	bh=w+HmgR+FzM3Xng+O06JYSypDP9o6wQJ1lFzX3cw+xrM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BWZMn8ghuD1W0De6dibCPR1gV05bJFE/qWDTH5hGJSkQPJX4bHhrOvBsOjk8DFp0acSKqZ9ta+7mZdAbTpwQ3GQzm3vR0JabnnG8lemO0xDyg7NUx2M9tDnSU/TGhBjwckguy3t0Y1vTk+4q92enWXN9BCl5Na8ieG11BUvHCjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=LCbk61V2; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="LCbk61V2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Wz
	o25/XHKaH0nys57dNkcIv8VwTwQepKBQzTuPm/eDE=; b=LCbk61V2JAWM7x6C6G
	R586OmSNxW5eONqOxt+b1Pm2aRAtL171DO/x98mqzSO36uoKWzg4r+4PfKdpIwXj
	vQAB2M7+/4mOI4o0vMXfCsmCZjcgOd0cCXdiXTe4QmOE4OHWF1GZnYb27DZ3ppci
	t6eBsJsBGqBowuGgOUp6VTvxc=
Received: from czl-pc (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgDnU5c7m9Fqw1V+AA--.15038S2;
	Fri, 16 Oct 2026 11:34:21 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	exfat@lists.linux.dev
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH v3 0/8] exfat: fix valid_size update races
Date: Fri, 16 Oct 2026 11:33:41 +0800
Message-ID: <20261016033349.3104509-1-chizhiling@163.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgDnU5c7m9Fqw1V+AA--.15038S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Aw1kGFy8Wry5Ww4kGrW5GFg_yoW8Cr1kpr
	ZIk3WfWr1Dt3yxtr13Cw1rAa4Fv3yrXF1fWrnxGw15ArsI9F1jva10kF109ryUJ3s2gr10
	qw4qqry8Cr1UA3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U6rWwUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC3B0FomrRmz0mewAA3m

From: Chi Zhiling <chizhiling@kylinos.cn>

exFAT uses valid_size (ValidDataLength) as the on-disk boundary of
initialised data, but the current code advances it too late or without
proper serialisation.  As a result, buffered writes can silently lose
data reclaimed before valid_size covers it, page faults and direct I/O
can race with writes, and a failed direct write still grows the file
on disk.

This series advances valid_size under the folio lock for buffered
writes, revalidates cached iomaps, drops i_rwsem from
exfat_page_mkwrite(), and publishes i_size/valid_size only on
successful direct I/O completion.

V3:
- Add Fixes: tags to some patches
- Fix two issues since v2 (p2, p6)

V2: https://lore.kernel.org/exfat/20261013033837.2748258-1-chizhiling@163.com/
V1: https://lore.kernel.org/exfat/59056131-e3bd-4003-8c30-0a356cf0bd82@163.com/
Link: https://lore.kernel.org/exfat/10029d6f-13cc-4d17-a2f9-b093a8339dde/T/#t


Chi Zhiling (8):
  iomap: export iomap_bio_read_folio_range_sync()
  exfat: zero the invalid tail of the straddle block under the folio
    lock
  exfat: advance valid_size under the folio lock for buffered writes
  exfat: advance valid_size while zeroing new ranges
  exfat: validate cached iomaps during buffered writes
  exfat: drop i_rwsem from exfat_page_mkwrite
  exfat: complete direct writes synchronously when they update metadata
  exfat: publish i_size and valid_size on direct I/O completion

 fs/exfat/file.c       | 111 +++++++++++++++++----------------
 fs/exfat/inode.c      |   9 +--
 fs/exfat/iomap.c      | 139 +++++++++++++++++++++++++++++++-----------
 fs/exfat/iomap.h      |   1 +
 fs/iomap/bio.c        |   1 +
 fs/iomap/internal.h   |  12 ----
 include/linux/iomap.h |   9 +++
 7 files changed, 176 insertions(+), 106 deletions(-)

-- 
2.53.0

