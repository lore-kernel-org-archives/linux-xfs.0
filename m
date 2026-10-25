Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792932154;
	b=VXrDVUhmpbw7iCCTMbrOKy+VN8gIfzloVeAk1qWJfGaj/ETZ3wrIJyk3yJ/OJLf+YxIn
	 uwpdi2Rz5tnFLVtppw7JZv7yeZ9+EF/zIW0vn3PeUW0zcZRPtweYrx9U1m6iuqSjo8Q4S
	 rkp2XkCcwwVpo+ZFrMgJqGbWe5Qii2qszUQtqeCj8x6YA2JBU4bSJYaPj5NiLMrJ3hzmX
	 8FNoLIrWxyOyiaiITeC/CiYzsfmWFxeKe4Y2hsP+2ARBRj85kcaD6F2YAPAXCNIzusEN+
	 pRvIlj3Ud4+mbxcWGJeZqnczrdjmenKhOwiYcOK0XGh3zm7b7pNKb7T2jz22ytbBjsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792932154;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=jzdJu2icUPc9CnDzC7FIAa4FNFGtvGnsVmr7zsS0YHg=;
	b=RWU/dAZ+JBiogPlxAcXcQtr1ws3gRb38nd0IU49foG37kyxYHBVqRK1U8ANukg4FoHzR
	 7vRJFrZakpdPSYxXzovxKXQFL3MBN8Wnn49Php0Q7bR+a7wXeXUNB752fdByl5hTkAr5K
	 bYW0djVtOjUxs1QD8HwbpJ87t4WjhaVOGSBBQB0iPEXit4PV8IyKHM7RtvzokbV/31Sjl
	 oR0cZvZ1I3rdA25z/qYIFBu4X2qZ3rOncoQq0VFHOvyxDwZqqBIK17wVN1V69Y7fJt4MH
	 U5JUxDLfwOCdeISGnyqyTBw3DvU9fF3wBE/kRxZttfklh+EPTyoB9SgH0hQq7TxNmJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=lUTZwNHb;
	arc=none smtp.remote-ip=220.197.31.5
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBE3606A31A;
	Sun, 25 Oct 2026 12:42:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDBE3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=lUTZwNHb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=jz
	dJu2icUPc9CnDzC7FIAa4FNFGtvGnsVmr7zsS0YHg=; b=lUTZwNHbPI14KMm28l
	kFus1ccG7pVSpymo2FLeHADG3bdl8pom70kUMdFmR9oa5IWB3tZbJYATR6WBE53Y
	BeQREfn7/H8gMBGnFQt36lH+uVtwtu7OKrvTikQXNhr8QXxKYQLe50QQeJ8QAIn/
	/isepYwN7a0Il7LmFprXk0FBM=
Received: from pc.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgDnvTzs+N1qxJALCA--.54355S2;
	Sun, 25 Oct 2026 20:41:18 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Eric Biggers <ebiggers@google.com>,
	Dave Chinner <david@fromorbit.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/5] fs: drain in-flight DIO before buffered writes
Date: Sun, 25 Oct 2026 20:41:09 +0800
Message-Id: <20261025124115.3178287-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
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
X-CM-TRANSID:PigvCgDnvTzs+N1qxJALCA--.54355S2
X-Coremail-Antispam: 1Uf129KBjvJXoWrZFWktF1DWrWUXrW8tFy8uFg_yoW8Jr48pF
	98Kr4YyrnFyrZ7urn3u3W7Xw1rKr4rZ343ua17W34DKrWDXr4UXw48tF1Uuw1rAw47Xr13
	tw4FvFykWryjy3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jerWrUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8A+LxWrd+O8PLgAA3w

An asynchronous direct write can remain in flight after its submitting
thread releases the filesystem's I/O submission lock. If a buffered write
dirties page cache before that direct write completes, post-I/O page-cache
invalidation can find dirty pages, report possible data corruption, and
record -EIO in the mapping error sequence.

Drain in-flight DIO before buffered writes in the generic filemap path,
F2FS, XFS, and zonefs. The filemap change also protects UDF and other
users of __generic_file_write_iter(). Keep IOCB_NOWAIT requests
nonblocking by returning -EAGAIN when a drain would be required.

The patches are separated by common code or filesystem and remain
independently buildable in series order.

Jiale Yao (5):
  filemap: drain in-flight DIO before buffered writes
  f2fs: drain in-flight DIO before buffered writes
  xfs: drain in-flight DIO before buffered writes
  xfs: drain in-flight DIO before zoned buffered writes
  zonefs: drain in-flight DIO before buffered writes

 fs/f2fs/file.c    | 13 +++++++++++--
 fs/xfs/xfs_file.c | 22 ++++++++++++++++++++++
 fs/zonefs/file.c  |  8 ++++++++
 mm/filemap.c      |  9 +++++++++
 4 files changed, 50 insertions(+), 2 deletions(-)

-- 
2.34.1

