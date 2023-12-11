Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zRviP7FD"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55A28E
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 08:38:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xNH5gDpy1OsXzX1OsQe1uFSC9CH6BfZVQdCD3xNioiQ=; b=zRviP7FDcp+ksZ/5JusqLw5eD+
	6PBT13pSHGrmu+j/HoZei6Qhp+JM0lYU88sUvCpxgAxAxp1f8922tckKHVN0NFjODXxQcoFdeuoNW
	hOa9ZVxOZAdgkPPKG8RehKKlzaIo50n/fiVhwowi70v7xbN8IHJ1fO8Ad8uBb+ycEaUiye4Pira8h
	PzByRsSyNddQ1gIfZ9qSMh+ZlfkmNvtg2jjmlXY9iksEvoO2Q/K+lkX86/fBN6+k66xxdtDm297Rl
	BpAz822+7B4EHyZ61/lDMwO8oat2aRGGA+k/PCRUteWjHWAnNBB9A1aHSo1sy6AJFyPyfODwdsebD
	E4rYPwng==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rCjIr-005tPi-19;
	Mon, 11 Dec 2023 16:38:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 21/23] xfs_repair: remove various libxfs_device_to_fd calls
Date: Mon, 11 Dec 2023 17:37:40 +0100
Message-Id: <20231211163742.837427-22-hch@lst.de>
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

A few places in xfs_repair call libxfs_device_to_fd to get the data
device fd from the data device dev_t stored in the libxfs_init
structure.  Just use the file descriptor stored right there directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 repair/xfs_repair.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 8a6cf31b4..cdbdbe855 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -724,13 +724,11 @@ static void
 check_fs_vs_host_sectsize(
 	struct xfs_sb	*sb)
 {
-	int	fd, ret;
+	int	ret;
 	long	old_flags;
 	struct xfs_fsop_geom	geom = { 0 };
 
-	fd = libxfs_device_to_fd(x.ddev);
-
-	ret = -xfrog_geometry(fd, &geom);
+	ret = -xfrog_geometry(x.dfd, &geom);
 	if (ret) {
 		do_log(_("Cannot get host filesystem geometry.\n"
 	"Repair may fail if there is a sector size mismatch between\n"
@@ -739,8 +737,8 @@ check_fs_vs_host_sectsize(
 	}
 
 	if (sb->sb_sectsize < geom.sectsize) {
-		old_flags = fcntl(fd, F_GETFL, 0);
-		if (fcntl(fd, F_SETFL, old_flags & ~O_DIRECT) < 0) {
+		old_flags = fcntl(x.dfd, F_GETFL, 0);
+		if (fcntl(x.dfd, F_SETFL, old_flags & ~O_DIRECT) < 0) {
 			do_warn(_(
 	"Sector size on host filesystem larger than image sector size.\n"
 	"Cannot turn off direct IO, so exiting.\n"));
@@ -986,10 +984,9 @@ main(int argc, char **argv)
 
 	/* -f forces this, but let's be nice and autodetect it, as well. */
 	if (!isa_file) {
-		int		fd = libxfs_device_to_fd(x.ddev);
 		struct stat	statbuf;
 
-		if (fstat(fd, &statbuf) < 0)
+		if (fstat(x.dfd, &statbuf) < 0)
 			do_warn(_("%s: couldn't stat \"%s\"\n"),
 				progname, fs_name);
 		else if (S_ISREG(statbuf.st_mode))
-- 
2.39.2

