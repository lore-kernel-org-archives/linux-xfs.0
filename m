Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VzpvznPW"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC84595
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 08:38:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=OZQTyqpNEYI4oQp6uQPEW/4EW3KEGPTdOqnlYfzKLi0=; b=VzpvznPW5yJ9JUy7SbMcYQPu45
	gTGb1yklOFfGepPHcXH4o1K2wUq3h9RE2SRnOXTVQWQRv2jL8rqvS+9MefhVkbW80y0SEv6bEj1ji
	30T7tMiCJJgf7qQu8RgzCL80VyjJ3v/lmUrrqjZaT9/mJnqWMSLvdEU4jieu/f+OAOo60ymGQYXPp
	ziJdRuONYn7rtFt88YA8WaIzZA171hnC2iN/dcJEkT6OJAjkCIqYZKtn1mTTNXIKgQ16W9G7ovTCe
	pVvUq/0LmOmosjSXeGrXpnbBScntJt3CSuB0YW0qLM5oCFIb7vtGH77p1jMrrY1K7/9nJVhejFk8y
	q6Z3g8vw==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rCjIm-005tMF-1F;
	Mon, 11 Dec 2023 16:38:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 19/23] libxfs: return the opened fd from libxfs_device_open
Date: Mon, 11 Dec 2023 17:37:38 +0100
Message-Id: <20231211163742.837427-20-hch@lst.de>
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

So that the caller can stash it away without having to call
xfs_device_to_fd.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/init.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index 13ad7899c..866e5f425 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -93,7 +93,7 @@ libxfs_device_to_fd(dev_t device)
  *     open a device and return its device number
  */
 static dev_t
-libxfs_device_open(char *path, int creat, int xflags, int setblksize)
+libxfs_device_open(char *path, int creat, int xflags, int setblksize, int *fdp)
 {
 	dev_t		dev;
 	int		fd, d, flags;
@@ -151,6 +151,7 @@ retry:
 		if (!dev_map[d].dev) {
 			dev_map[d].dev = dev;
 			dev_map[d].fd = fd;
+			*fdp = fd;
 
 			return dev;
 		}
@@ -307,16 +308,14 @@ libxfs_init(struct libxfs_init *a)
 		if (!a->disfile && !check_open(dname, a->flags))
 			goto done;
 		a->ddev = libxfs_device_open(dname, a->dcreat, a->flags,
-				a->setblksize);
-		a->dfd = libxfs_device_to_fd(a->ddev);
+				a->setblksize, &a->dfd);
 		platform_findsizes(dname, a->dfd, &a->dsize, &a->dbsize);
 	}
 	if (logname) {
 		if (!a->lisfile && !check_open(logname, a->flags))
 			goto done;
 		a->logdev = libxfs_device_open(logname, a->lcreat, a->flags,
-				a->setblksize);
-		a->logfd = libxfs_device_to_fd(a->logdev);
+				a->setblksize, &a->logfd);
 		platform_findsizes(logname, a->logfd, &a->logBBsize,
 				&a->lbsize);
 	}
@@ -324,8 +323,7 @@ libxfs_init(struct libxfs_init *a)
 		if (a->risfile && !check_open(rtname, a->flags))
 			goto done;
 		a->rtdev = libxfs_device_open(rtname, a->rcreat, a->flags,
-				a->setblksize);
-		a->rtfd = libxfs_device_to_fd(a->rtdev);
+				a->setblksize, &a->rtfd);
 		platform_findsizes(dname, a->rtfd, &a->rtsize, &a->rtbsize);
 	}
 
-- 
2.39.2

