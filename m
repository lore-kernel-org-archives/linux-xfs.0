Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="h/0+39pT"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D338E
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 08:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+L/DwvnuIBCgDCK0ttwLb4zY2PjwmhZBQ3ZSNM1sfIg=; b=h/0+39pT6xpKJVuad7iO+g4yra
	nyow5ssi3/yE0TN0rrgnGdcnAWNg5nLxhMQn0L8P0DjdP1plWR3Z0g7iKEnw4xm+px0kbb5aKvSjl
	jb5jg/mYmD60tQuCP30MTZoGaYjB8epz6BdHZqpuaQeHCmjSIlWCuSNOWyfe7//TyPyzSxIdyYdtl
	JpHP2fLNt7bHJRe0cgtiqF+M7YQz66/SzrfxcguziUVzV5g74jfSOuwYI1JgVBll3KV1KmUsvM7bM
	KC6aQ3HxCF/OANZpDsMS+tQS9bS5qv9mdCRpILGUWiDRwdSeX55hjv4d03/1db896bVdNyhC+hUbj
	zMngTZiw==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rCjI3-005sto-0T;
	Mon, 11 Dec 2023 16:37:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 03/23] libxfs/frog: remove latform_find{raw,block}path
Date: Mon, 11 Dec 2023 17:37:22 +0100
Message-Id: <20231211163742.837427-4-hch@lst.de>
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

Stop pretending we try to distinguish between the legacy Unix raw and
block devices nodes.  Linux as the only currently support platform never
had them, but other modern Unix variants like FreeBSD also got rid of
this distinction years ago.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/linux.c    | 12 ------------
 libfrog/platform.h |  2 --
 libxfs/init.c      | 42 ++++++++++++++----------------------------
 3 files changed, 14 insertions(+), 42 deletions(-)

diff --git a/libfrog/linux.c b/libfrog/linux.c
index 0d9bd355f..2e4fd316e 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -232,18 +232,6 @@ platform_findsizes(char *path, int fd, long long *sz, int *bsz)
 		max_block_alignment = *bsz;
 }
 
-char *
-platform_findrawpath(char *path)
-{
-	return path;
-}
-
-char *
-platform_findblockpath(char *path)
-{
-	return path;
-}
-
 int
 platform_direct_blockdev(void)
 {
diff --git a/libfrog/platform.h b/libfrog/platform.h
index 0aef318a8..e3e6b7c71 100644
--- a/libfrog/platform.h
+++ b/libfrog/platform.h
@@ -13,8 +13,6 @@ int platform_check_iswritable(char *path, char *block, struct stat *sptr);
 int platform_set_blocksize(int fd, char *path, dev_t device, int bsz,
 		int fatal);
 int platform_flush_device(int fd, dev_t device);
-char *platform_findrawpath(char *path);
-char *platform_findblockpath(char *path);
 int platform_direct_blockdev(void);
 int platform_align_blockdev(void);
 unsigned long platform_physmem(void);	/* in kilobytes */
diff --git a/libxfs/init.c b/libxfs/init.c
index a8603e2fb..9cfd20e3f 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -197,7 +197,7 @@ libxfs_device_close(dev_t dev)
 }
 
 static int
-check_open(char *path, int flags, char **rawfile, char **blockfile)
+check_open(char *path, int flags)
 {
 	int readonly = (flags & LIBXFS_ISREADONLY);
 	int inactive = (flags & LIBXFS_ISINACTIVE);
@@ -208,22 +208,10 @@ check_open(char *path, int flags, char **rawfile, char **blockfile)
 		perror(path);
 		return 0;
 	}
-	if (!(*rawfile = platform_findrawpath(path))) {
-		fprintf(stderr, _("%s: "
-				  "can't find a character device matching %s\n"),
-			progname, path);
-		return 0;
-	}
-	if (!(*blockfile = platform_findblockpath(path))) {
-		fprintf(stderr, _("%s: "
-				  "can't find a block device matching %s\n"),
-			progname, path);
-		return 0;
-	}
-	if (!readonly && !inactive && platform_check_ismounted(path, *blockfile, NULL, 1))
+	if (!readonly && !inactive && platform_check_ismounted(path, path, NULL, 1))
 		return 0;
 
-	if (inactive && check_isactive(path, *blockfile, ((readonly|dangerously)?1:0)))
+	if (inactive && check_isactive(path, path, ((readonly|dangerously)?1:0)))
 		return 0;
 
 	return 1;
@@ -305,11 +293,9 @@ libxfs_close_devices(
 int
 libxfs_init(libxfs_init_t *a)
 {
-	char		*blockfile;
 	char		*dname;
 	int		fd;
 	char		*logname;
-	char		*rawfile;
 	char		*rtname;
 	int		rval = 0;
 	int		flags;
@@ -330,9 +316,9 @@ libxfs_init(libxfs_init_t *a)
 	radix_tree_init();
 
 	if (a->volname) {
-		if(!check_open(a->volname,flags,&rawfile,&blockfile))
+		if (!check_open(a->volname, flags))
 			goto done;
-		fd = open(rawfile, O_RDONLY);
+		fd = open(a->volname, O_RDONLY);
 		dname = a->dname = a->volname;
 		a->volname = NULL;
 	}
@@ -344,12 +330,12 @@ libxfs_init(libxfs_init_t *a)
 			platform_findsizes(dname, a->dfd, &a->dsize,
 					   &a->dbsize);
 		} else {
-			if (!check_open(dname, flags, &rawfile, &blockfile))
+			if (!check_open(dname, flags))
 				goto done;
-			a->ddev = libxfs_device_open(rawfile,
+			a->ddev = libxfs_device_open(dname,
 					a->dcreat, flags, a->setblksize);
 			a->dfd = libxfs_device_to_fd(a->ddev);
-			platform_findsizes(rawfile, a->dfd,
+			platform_findsizes(dname, a->dfd,
 					   &a->dsize, &a->dbsize);
 		}
 	} else
@@ -362,12 +348,12 @@ libxfs_init(libxfs_init_t *a)
 			platform_findsizes(dname, a->logfd, &a->logBBsize,
 					   &a->lbsize);
 		} else {
-			if (!check_open(logname, flags, &rawfile, &blockfile))
+			if (!check_open(logname, flags))
 				goto done;
-			a->logdev = libxfs_device_open(rawfile,
+			a->logdev = libxfs_device_open(logname,
 					a->lcreat, flags, a->setblksize);
 			a->logfd = libxfs_device_to_fd(a->logdev);
-			platform_findsizes(rawfile, a->logfd,
+			platform_findsizes(logname, a->logfd,
 					   &a->logBBsize, &a->lbsize);
 		}
 	} else
@@ -380,12 +366,12 @@ libxfs_init(libxfs_init_t *a)
 			platform_findsizes(dname, a->rtfd, &a->rtsize,
 					   &a->rtbsize);
 		} else {
-			if (!check_open(rtname, flags, &rawfile, &blockfile))
+			if (!check_open(rtname, flags))
 				goto done;
-			a->rtdev = libxfs_device_open(rawfile,
+			a->rtdev = libxfs_device_open(rtname,
 					a->rcreat, flags, a->setblksize);
 			a->rtfd = libxfs_device_to_fd(a->rtdev);
-			platform_findsizes(rawfile, a->rtfd,
+			platform_findsizes(rtname, a->rtfd,
 					   &a->rtsize, &a->rtbsize);
 		}
 	} else
-- 
2.39.2

