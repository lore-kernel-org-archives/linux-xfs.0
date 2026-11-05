Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.239
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793861995;
	b=pw6KFfKerzY2EWtlT37oGnap80zdtVMYN5KPwt8R8NHzhVvtaVK7kc8d+/tDJS1X+oLN
	 l2SrYWGeW/6b9KpCPmpIX1uWJwP+Wmk4TCbvlTtnBckPbVgzJ+M1aNnvh4W4VUQraEyPY
	 rVXoY8XDWQgjiSNfX8jkkRN2h6ECbl8HfajFuwzvnKfmH/MeohK1Z9uyCNPiZCSKQW3Dx
	 C2gOefJRphgm7qHj9JrSRy4MSW+hK3B7B5F/a6Q6alMiCJVJmQGF0L10Cb1dwa6+Q8gLX
	 bldiQzTyjWbVi8vvilL8JEsXHhe0QMogUTMmuLyQ/t7IxzLVBGsjNDMAiu1HObyxANQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793861995;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=giKD9GBB7SqWcODKYmNlG0gh8SE1gt/R19vK2YjohsA=;
	b=IC4GimCYQnbqDQCUj1Fh6qrDwI8aj6ahWEwHsPv/LBU2eSpwCzDEpd1sIci1TCfi2Pau
	 EMXEAqOx+UwDtDM24hplnBqXGTSBaHMTeMdLedNXpzBiPepJMim9tAzTw25MBH6dWeheZ
	 qIx4AV/Tvq5ilNxvIM6HQ4mo7EyYMULVmqIB7dQv8G9rdhtIDIZKJIE4gyMDYlDioAH1V
	 n3k7lta4pT0gIHaXcXSnw8sucWee8ei8rrrys73UpMXHu24VCPeCsaUua0Einyb1oCBaO
	 aoOz9nD6DFbxBU+wGpjVw0bC3BYcvFOjwPDpbx2pSmpqoSE3X9ijrDh7aa9BMYxOdbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UJkINKzK;
	arc=none smtp.remote-ip=95.215.58.239
Received: from mta1.migadu.com (out-239.mta1.migadu.com [95.215.58.239])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CC5606A32D
	for <linux-xfs@vger.kernel.org>; Thu,  5 Nov 2026 06:59:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10CC5606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UJkINKzK
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Ht9W8rG1bvFhZOOVFyVUZBS1JBc1APtNoV+i3qOiW1c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793861993; v=1; x=1794466793;
 b=UJkINKzKdtLYR8KtpZuaFU8oFOUGl8oRWRJRBWewSilr+ADj9oA9XTq+T9+x9L2sd0LBRZ6i
 Z/2TgFvG+kvx8D/3Hx3IU7wQqdyh+09q4ppm9LSPVLNI+LaQrJFS/qWfkiLqiLjqQ0vCkhMYn3y
 KBzd3Uw2/VTZ5LBroZQj6YH4=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 770e8c686bfb0362;
	Thu, 05 Nov 2026 06:59:52 +0000
X-Mizu-Trace-ID: 770e8c686bfb0362
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
Subject: [RFC 3/6] dax: refuse dmabuf iterators in dax_iomap_rw()
Date: Thu,  5 Nov 2026 14:58:44 +0800
Message-ID: <20261105065847.196540-4-mengmeng.zhao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
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

A dax access copies through the CPU linear address, which a device
mapping cannot provide.  A dmabuf iterator reaching dax_iomap_rw()
splats a WARN_ON_ONCE from iterate_and_advance2() and fails the I/O
with EFAULT.  Refuse it up front with -EOPNOTSUPP, as the generic
buffered copy paths already do.

Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Signed-off-by: Li Wang <liwang@kylinos.cn>
---
 fs/dax.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index 6ba50142eeb2..6ec08316aa6c 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1759,6 +1759,10 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (!iomi.len)
 		return 0;
 
+	/* dax copies through the CPU, which a device mapping bypasses */
+	if (iov_iter_is_dmabuf_map(iter))
+		return -EOPNOTSUPP;
+
 	if (iov_iter_rw(iter) == WRITE) {
 		lockdep_assert_held_write(&iomi.inode->i_rwsem);
 		iomi.flags |= IOMAP_WRITE;
-- 
2.43.0

