Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0rlMRxEc"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E0CD1
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 08:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Fs2pjrjhW1UMDIEnb7TwVY2M1OqT5gAG+jZ6jMUQtlo=; b=0rlMRxEclcyhoN2tPtbo6PQGgg
	6aU6HCf4zcFIfNzsw2EFlwzVmXD2Zb05k7k4yCVPA9vWKifGnFCwMTcynhaDza3RR8XJY38JVFLUp
	FyVNXfhG5kYumDQ8PO0Dh6+ikMhw8V5JIufzc5awEsSzCKXyyxuxcZ/y3z3TOq2hGI3tFJdCLBmPD
	b2dCm/hh37AGg1hQAc+uHa26JLPYWAcOVYMY9JHFpS0Y9Ac5vaMRrhd6seDE5us11Ql2BXcwhEB2K
	gx65TP/3kNry2qYeFILe0T+xoiR0yw3sUOdh0Kcgwrdi8MJP41azVksrqvXvA5XEOY+GV017ZyfXD
	fi/16EHg==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rCjIc-005tGV-0E;
	Mon, 11 Dec 2023 16:38:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 15/23] libxfs: remove the setblksize == 1 case in libxfs_device_open
Date: Mon, 11 Dec 2023 17:37:34 +0100
Message-Id: <20231211163742.837427-16-hch@lst.de>
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

All callers of libxfs_init always pass an actual sector size or zero in
the setblksize member.  Remove the unreachable setblksize == 1 case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/init.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index de1e588f1..6570c595a 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -125,10 +125,7 @@ retry:
 	}
 
 	if (!readonly && setblksize && (statb.st_mode & S_IFMT) == S_IFBLK) {
-		if (setblksize == 1) {
-			/* use the default blocksize */
-			(void)platform_set_blocksize(fd, path, statb.st_rdev, XFS_MIN_SECTORSIZE, 0);
-		} else if (dio) {
+		if (dio) {
 			/* try to use the given explicit blocksize */
 			(void)platform_set_blocksize(fd, path, statb.st_rdev,
 					setblksize, 0);
-- 
2.39.2

