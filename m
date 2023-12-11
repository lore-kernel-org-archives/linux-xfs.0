Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BoBgNooh"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC4FB4
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 08:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HRhz5/OA/u2+PLRXu/sMPsTt5ftcQ/uheBlsos48KeI=; b=BoBgNooh5Dafqobs30RyWxMEFs
	0EPdIOnOUNZcx6xhyk2CjSOrdwTc1/9mq2exH+ast/fmDdKzUskEtPoBh21Rrn2Rvpvcn5cU8SOII
	A4i/DZs97u2SCCj9x3oieRMVkiUQGGoy8A7K1z31nf/BW70DIomXAsRP6dcD1wLqg9js6OAzCSpND
	2TSFYgSFITJvdIMDDUysZVOZ57b/fjIKgV/tQfMAkmhFzRJhBGIXiXegLaJeXsMZhCGlUk42bQKCd
	MqtLxnqw8qprNkxS+bcUe/CKyHNLSwInkFtweozpluD+ajXuHHGfk6hMJxK8ijD3rIbyKefOal+i9
	zA0s9hyw==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rCjIh-005tJK-0Z;
	Mon, 11 Dec 2023 16:38:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 17/23] libxfs: remove dead size < 0 checks in libxfs_init
Date: Mon, 11 Dec 2023 17:37:36 +0100
Message-Id: <20231211163742.837427-18-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231211163742.837427-1-hch@lst.de>
References: <20231211163742.837427-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

libxfs_init initializes the device size to 0 at the start of the function
and libxfs_open_device never sets the size to a negativ value.  Remove
these checks as they are dead code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/init.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index 5be6f8cf1..87193c3a6 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -329,21 +329,6 @@ libxfs_init(struct libxfs_init *a)
 		platform_findsizes(dname, a->rtfd, &a->rtsize, &a->rtbsize);
 	}
 
-	if (a->dsize < 0) {
-		fprintf(stderr, _("%s: can't get size for data subvolume\n"),
-			progname);
-		goto done;
-	}
-	if (a->logBBsize < 0) {
-		fprintf(stderr, _("%s: can't get size for log subvolume\n"),
-			progname);
-		goto done;
-	}
-	if (a->rtsize < 0) {
-		fprintf(stderr, _("%s: can't get size for realtime subvolume\n"),
-			progname);
-		goto done;
-	}
 	if (!libxfs_bhash_size)
 		libxfs_bhash_size = LIBXFS_BHASHSIZE(sbp);
 	libxfs_bcache = cache_init(a->bcache_flags, libxfs_bhash_size,
-- 
2.39.2

