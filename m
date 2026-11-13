Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.233
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794553691;
	b=Ri7MWcvnsBXspyZ7C8ZD+czmq/tjz51x0cqzFikxwt1QyeP9RiKNGnnUSsVJcFA7TjkW
	 3l2mYG8KcU2IoqLRROWVhzKioyW3K9qVw+KCJD25f5Bfp1HctV8ci8+miNr36/LgyU3hV
	 +6XQKLbNqj07RN8oC1rPNju6SqUmYNx5kLSo9Ykd35fnF25D9okWrK0Bf58mXj2YsqOMz
	 HxWMh5obggo6M7mZ9Ps6TZgSKm0DGoXOgplxcyzmvTfYKHPN1yfMnuLY2U3hz8HRAVnRl
	 A7OhUAv2TucOO7FJ5sZZwE165kTvLo6oJa0mArccPPnEg1ThfmqAXWOFSNtrP/xPBFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794553691;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=oE2P4TXXbwbeZXnmaDd39X4I7W+VRQ8H2a+gqtaKE6M=;
	b=WDRCPKf/NHpggP8UQDHeazCcr6MVC5JhtENLyjvCaZFr6qZLsYnbDlshWHewEOlmYrzx
	 0jKcK/C28p5yJHqBhPllDCOGib2ntGY1K822i0ZhChlSvUlWIuDZTE299Uvb20b8sF48O
	 yozUFn4GXuQ2jJVPeDDUYzMHIR7MrzA8ahzXopCmCOtx5XYE7yK2LT2USc99okufKUm6O
	 wPoNE0IO2Fj98yVoIiD6N2rTpy9MpBSxP16oxZEkDhxGD0PHP40+tjd+Wn66by/V+O/tO
	 U+mYHnHPrj2k/w1i4Z365dSy48Qf/rI1G+LZhf22m7zWHN7Tz4a5ROajvO5UWyU50sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nKxRPFkc;
	arc=none smtp.remote-ip=95.215.58.233
Received: from mta1.migadu.com (out-233.mta1.migadu.com [95.215.58.233])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8E6606A890
	for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2026 07:08:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED8E6606A890
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nKxRPFkc
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=TGEyrdi/pv1jc6teZ+wM/XGPkjaMpK/OOKnCVbRJDcg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794553689; v=1; x=1795158489;
 b=nKxRPFkcrzPC7ZgkWruNcPuZqp1vlKz1pSass6D1zhpeWU/BBB78IxjJXoYSiRXWR3S/RBIh
 pTYcDSfp7qwzJP6QdsnXUceKvQPByHKrDddl4aN+Hy4zIc6Mi84vxB4uw2NZLDSf1+dwOPop5Pp
 0EP0xibP82F/nsdxwbJaCiDw=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 32332e07033e4feb;
	Fri, 13 Nov 2026 07:08:08 +0000
X-Mizu-Trace-ID: 32332e07033e4feb
X-Migadu-Flow: FLOW_OUT
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
To: Christoph Hellwig <hch@lst.de>,
	Anuj Gupta <anuj1072538@gmail.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	christian.koenig@amd.com,
	Philipp Stanner <phasta@kernel.org>,
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
	asml.silence@gmail.com,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	Li Wang <liwang@kylinos.cn>,
	Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Subject: [RFC PATCH v2 5/8] blk-crypto: refuse dma-buf bios in the fallback path
Date: Fri, 13 Nov 2026 15:06:18 +0800
Message-ID: <20261113070621.273953-6-mengmeng.zhao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
References: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
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

The inline encryption fallback encrypts through the data pages of a bio,
which a dma-buf bio does not have: its vec pointer holds the
driver-private dma_buf_io_map.  A crypt context the device supports
natively is programmed from the request instead, so refuse only where
the fallback is about to run.

blk_mq_submit_bio() is too late for this: submit_bio_noacct() has already
rejected a context the device does not support natively, while submitters
reach the fallback before the bio is queued.  No in-tree submitter builds
such a bio today.

Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Signed-off-by: Li Wang <liwang@kylinos.cn>
---
 block/blk-crypto.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index bc3a9f59574b..01b8d26040dc 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -271,6 +271,14 @@ bool __blk_crypto_submit_bio(struct bio *bio)
 			bio_endio_status(bio, BLK_STS_NOTSUPP);
 			return false;
 		}
+		/*
+		 * The fallback encrypts from the data pages, which a dma-buf
+		 * bio does not have.
+		 */
+		if (op_is_dmabuf(bio->bi_opf)) {
+			bio_endio_status(bio, BLK_STS_NOTSUPP);
+			return false;
+		}
 		return blk_crypto_fallback_bio_prep(bio);
 	}
 
-- 
2.43.0

