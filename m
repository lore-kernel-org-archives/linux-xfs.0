Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.187
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793861956;
	b=AhuzLfG8PdKigcFDs0URQr6U1sGCf1nkVNi0Hq8pqD0cCAKnuVs3/uFCGPjDTbe/Jqmf
	 FgDYx5wxZGpkzaa3StpiudjdXpnzTCqNjgDzFUkYOBW5Fs3JyRqr3/2EJvBCMtdRtDpTJ
	 t2EaRX+wDPIjEdx5W7uizLXdgFcD+mlSFVKa1na+cURulC3MlrnIf6aEMmKuJI/CtFj3h
	 Kf/OfPak+rzYM0Ei1wq1W8OZmPJxsNw8JhNbC8US2DnAYtHBRhtitrm2vs6qXloYh2kfv
	 CQq35SGO9WxOJD4Eib3og/aEtXZewVsETOK45H3UT+VDsB9EYss2748sfiLCH6xKSLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793861956;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=8CTBv2FsWWNYoIFrDUziKjer08OPepQNcF8zDvYRVUM=;
	b=rsxP6h3vx2hfziviNn7WRWQmSQifhjjq510M8CGcRuXywvq782q0VoVwNjd8bwW/zzrG
	 NuZHS60TKjhuoS3Rd4W1Nxzd75BDR+00YYPUs+cmksevcPCPCaqvOxEdDKkZ5fz7IP4BR
	 etY8wv5VnSfyZonqHz7+oExAgrayu05kfi5IAXTdCj9twj9/4Q+jjaXzJl0Fb7pKONny2
	 Wxxn2/ffiiMUhk1ntb1aKZJAwPKjD0bJU5hdxBPs8abgQcWpGwqngXHGdbXXLM+eq5xwm
	 Qae5DgRUHuFxOgIqUk4Yd9DmGvXsDhMEcIMNy9/EcVX/oJbWzuGbEyAuM202LpzApJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=l+wnEHJf;
	arc=none smtp.remote-ip=95.215.58.187
Received: from mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F16A606A32D
	for <linux-xfs@vger.kernel.org>; Thu,  5 Nov 2026 06:59:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F16A606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=l+wnEHJf
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=fD7pQ7iJNJUJ2Lt+Fn/kSJBY5hEsxqJHEyhADQZ0hVw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793861952; v=1; x=1794466752;
 b=l+wnEHJf6Oiyr1JLlLvY1SuR55TOc9qTue71B8BOIDVVCSFo+lpfKq7XMsobufkA1UDFYuZg
 S/4hbx3RQyzDu0U7TxzFT70wLujr3gW8YUSoIvIo9yke829B2TSk5zIlzdtImG9Q4nyXjjfNiiI
 9RSLtJX0JrbHg4jDSxSgZSDo=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id deff676cf379e19e;
	Thu, 05 Nov 2026 06:59:12 +0000
X-Mizu-Trace-ID: deff676cf379e19e
X-Migadu-Flow: FLOW_OUT
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
To: Jens Axboe <axboe@kernel.dk>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	tytso@mit.edu,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	asml.silence@gmail.com,
	hch@lst.de,
	Anuj Gupta <anuj1072538@gmail.com>
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Li Wang <liwang@kylinos.cn>
Subject: [RFC 0/6] ext4: Add dma-buf read/write support
Date: Thu,  5 Nov 2026 14:58:41 +0800
Message-ID: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
X-Mailer: git-send-email 2.43.0
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

From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>

This series add dma-buf read/write support for ext4. The dma-buf direct
I/O infrastructure allows dma-buf to be handed to file I/O as an iov_iter,
currently it only supports raw device. To better serve the GPU-NVME direct
access through normal filesystem, prior work for XFS has been discussed
at [1]. We also are interested in this field and working on it[2]. This
patchset is based on Anuj Gupta's patchset as there are common parts at
block/iomap. The base tree is:
https://github.com/anuj7781/linux-kernel/tree/anuj/fs-dmabuf-rfc-v11-desc-v2

Patches 1-5 add dma-buf guards at several common paths at block,
mm/filemap, dax and iomap. Patches 6 add dma-buf support for ext4.

[1] https://lore.kernel.org/linux-xfs/20261016091919.971295-1-anuj1072538@gmail.com/
[2] https://lore.kernel.org/all/20260908131545.105987-1-liwang@kylinos.cn/

Mengmeng Zhao (6):
  block: refuse a dma-buf bio that carries a crypto context
  mm/filemap: refuse dmabuf iterators in the generic read/write copy
    paths
  dax: refuse dmabuf iterators in dax_iomap_rw()
  iomap: refuse dmabuf iterators in iomap_file_buffered_write()
  iomap: refuse dmabuf iterators on contents-encrypted inodes
  ext4: support dma-buf registered buffers for direct I/O

 block/blk-mq.c         |  4 +++-
 fs/dax.c               |  4 ++++
 fs/ext4/file.c         | 33 +++++++++++++++++++++++++++++++++
 fs/iomap/buffered-io.c |  7 +++++++
 fs/iomap/direct-io.c   | 10 ++++++++++
 mm/filemap.c           | 22 +++++++++++++++++++++-
 6 files changed, 78 insertions(+), 2 deletions(-)

-- 
2.43.0

