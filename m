Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Db2aiJlc"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0FBCF
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 08:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5PVY1I2hotnkWKbUEL/b1azxlOVkSSqKyoz8RpZpaDg=; b=Db2aiJlc/GOo240yo8YYkXuZv+
	T4LscxIRFEpgneI1uSwz0G9j+CtsYsjqDGSK7SzT26SGNnh03ETrgAt7ph8EWmlx28M9vzrThsDWB
	3l1Pv4iHmpG+U4rOSSqeeEyrfNgZkrN40Tjc+78QYtoWfN0Mst31SnL+ssDNJNdgOHnLSxlBv9U6h
	F/nY4F3UIPwhBHPcF6ENPFnpNP0vW+WlP8sXXFiY6lttPzDyo97dHO7RpR5v3sTniJaoYdIPXVV5a
	YriCOTMG9eSKEx6S7VaF8Pwa+97CzqjAGbutCs8aS0aZtObLAMZ+J40Bka9/EH4TKpF0H5z/uYY8z
	ulLCpVrg==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rCjIj-005tKf-2u;
	Mon, 11 Dec 2023 16:38:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 18/23] libxfs: mark libxfs_device_{open,close} static
Date: Mon, 11 Dec 2023 17:37:37 +0100
Message-Id: <20231211163742.837427-19-hch@lst.de>
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

libxfs_device_open and libxfs_device_close are only used in init.c.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/libxfs.h | 2 --
 libxfs/init.c    | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index 9ee3dd979..68efe9caa 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -148,8 +148,6 @@ int		libxfs_init(struct libxfs_init *);
 void		libxfs_destroy(struct libxfs_init *li);
 
 extern int	libxfs_device_to_fd (dev_t);
-extern dev_t	libxfs_device_open (char *, int, int, int);
-extern void	libxfs_device_close (dev_t);
 extern int	libxfs_device_alignment (void);
 extern void	libxfs_report(FILE *);
 
diff --git a/libxfs/init.c b/libxfs/init.c
index 87193c3a6..13ad7899c 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -92,7 +92,7 @@ libxfs_device_to_fd(dev_t device)
 /* libxfs_device_open:
  *     open a device and return its device number
  */
-dev_t
+static dev_t
 libxfs_device_open(char *path, int creat, int xflags, int setblksize)
 {
 	dev_t		dev;
@@ -161,7 +161,7 @@ retry:
 	/* NOTREACHED */
 }
 
-void
+static void
 libxfs_device_close(dev_t dev)
 {
 	int	d;
-- 
2.39.2

