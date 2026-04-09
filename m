Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8623DDDAF;
	Thu,  9 Apr 2026 16:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775750623; cv=none; b=RWQg7+xFM8iCdCLjA10NHvbdAE3L8LoUqis5yyi1THxUsQoRzC857b0IrrE5oEVuaMb/2QUwJ0X9qOF0xPVLy/By2+Vo2Mwuxg2h6TozcMaOZpRL615C226LIpx3JzWQYJ+4RrLhtABeqzAnA7WGVJnQr6+zhnJzYmcuabXcWPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775750623; c=relaxed/simple;
	bh=SshC0lc0VlQjgja9lRHdE38Fie9EaVMjGtDQ2yDsqZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8+ce5kQSu7qBcl13lc2IwAT8jegNZuM7s4WJeGqCY5eSP4ok5kKwp2LrXcTTsnAk0Afwlio2h1l/gF9b0TL8HRtdJoxc/kugavf3C7H31Gg3DPa2jwygzUmobE0O20rjTFJIwsE1L+0ozNgRrSgdjeNqF1EGIpi4I6plQnWTec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=foBFWmHy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="foBFWmHy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aZPfOCtOPWHY9/SgV/wgHngzoQ9jPLQrp7zmaF4Sty0=; b=foBFWmHyhmvVqdBAhKUjiLfFlc
	TNRntGXjsR9Y+xNRMC4FB1ZItRiJiNWZJFZcypXaNQ71bGWE7SXJm//2xT6RHrnCe+557Ul2Y2kHe
	1u8skjRrYaShEZUDPBTG0sSYwH2bCTW1/lc6nInQgj7StcBc/iqbW8u3INWkRjaQ+S7oryfHkQsx+
	GEkoxOpMH3Rlhijj2EjZHQwOSuzIjBy7Itq6bdNvEWyOgnACHJwhj3/3o4ATonmIVyoGEoPmrk+v9
	xyXof+/zLRdap/xo3V3/xOwJXa5dWyFWOjGJjJkz4PslGaiHX0B8IEqiJ9q+y+5viLIZ7ZyhUoP9D
	RszNWLEw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wArr0-0000000At63-3g29;
	Thu, 09 Apr 2026 16:03:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/8] FOLD: don't use in_task() to decide for offloading
Date: Thu,  9 Apr 2026 18:02:18 +0200
Message-ID: <20260409160243.1008358-6-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409160243.1008358-1-hch@lst.de>
References: <20260409160243.1008358-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

As described in commit c99fab6e80b76, some block drivers might call
into ->bi_end_io from non-preemptible context.  Copy and past the
logic from that commit, although having a core helper for it would
be nicer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/bio.h | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 45c311e5ff71..72664807c757 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -375,6 +375,16 @@ static inline struct bio *bio_alloc(struct block_device *bdev,
 
 void submit_bio(struct bio *bio);
 
+/* Offload from atomic contexts to minimize scheduling overhead */
+static inline bool bio_in_atomic(void)
+{
+	if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
+		return true;
+	if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
+		return true;
+	return !preemptible();
+}
+
 void __bio_complete_in_task(struct bio *bio);
 
 /**
@@ -386,10 +396,11 @@ void __bio_complete_in_task(struct bio *bio);
  */
 static inline bool bio_complete_in_task(struct bio *bio)
 {
-	if (in_task())
-		return false;
-	__bio_complete_in_task(bio);
-	return true;
+	if (bio_in_atomic()) {
+		__bio_complete_in_task(bio);
+		return true;
+	}
+	return false;
 }
 
 extern void bio_endio(struct bio *);
-- 
2.47.3

