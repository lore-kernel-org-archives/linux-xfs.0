Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D31429CED
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 12:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785414328; cv=none; b=SniV/rfgcS4eujfQKeSOcpmzFrg+DJ1Dm8JZu1eH7SI2fa9aVqyo510D1v8Yzj0ZmV1h3OkeffxXgXKqz0caSz/hT71NfoGdFhcYt3lJktHTMruHEWYxGBAhazXrdk+m0+/+sS1nezrw+Jn9oc9gv49hImvBJA4Bv/J0ikWTU/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785414328; c=relaxed/simple;
	bh=Y8at3Ld1RB1CqeV241D4taiQ2H3szW26rxHxWzwMjok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKHyCCqJTi1isZiu+msHwJsQSlIS87+1yUKEx7kk1iCUGNKxQVnhbjhwKbpxhEZeWZ9UjXJcCg9rtyAlfTnZZLyyv0pfw/A4q3r8+NpyB7IsH7Z5eC9CNwr2UuiZXe6s8p6gvL+oIlRDV/A1l0kNoMNA1Iwe1MCZgr1mQ6ctuTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kngl+BWV; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kngl+BWV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=g+YVTj0ahWd/81G/5Bs+RsPBoRS013vpWrJMtgMMUoE=; b=kngl+BWVcI8ORhoPyYVvU1vvW0
	R9YteX3Tiba7pDPEsN9cscFUcU4PS310WDCysKPNRc44KL3uRDh5wpsN58e7LlDRZGnF0yGR/u4Q5
	2/G4wOeDVa3y3CuhijEKpmxdLOuZn9ALcYFv+3NwSzTo5IiG8vkiG/CAfGr2eVnwN3xlxqGgHzuGE
	FMB3YDvOWgyBfF3PJfu7FYLnwabuRrXlh8//iUqxamSVXRJ0OjEloA2ffrfkI6oq7EfGBXsZxYKuI
	fPak/MYZyrWTkE+KWrH+neMxXomS7MxaYQy/SJX8/J3sMsTwJjQs1DyaZBVN98t39CxFZEh9GrRt8
	Z69kIQLQ==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wpPpD-0000000DgiN-2g3D;
	Thu, 30 Jul 2026 12:25:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] growfs: support unit postfixes when specifying sizes
Date: Thu, 30 Jul 2026 14:25:13 +0200
Message-ID: <20260730122521.2578459-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260730122521.2578459-1-hch@lst.de>
References: <20260730122521.2578459-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Try using cvtnum to parse the sizes for the -D, -L and -R arguments,
and only fall back to plain integer parsing and interpreting it as
blocks when that fails.  This matches the mkfs UI and makes specifying
a size significantly easier.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 growfs/xfs_growfs.c   | 32 ++++++++++++++++++++++++++++----
 man/man8/xfs_growfs.8 | 39 +++++++++++++++++++++++++++++++--------
 2 files changed, 59 insertions(+), 12 deletions(-)

diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 0d0b2ae3e739..184631b1735b 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -5,6 +5,7 @@
  */
 
 #include "libxfs.h"
+#include "libfrog/convert.h"
 #include "libfrog/paths.h"
 #include "libfrog/fsgeom.h"
 
@@ -31,6 +32,19 @@ Options:\n\
 	exit(2);
 }
 
+static long long
+parse_size(
+	struct xfs_fsop_geom	*geo,
+	const char		*size_str)
+{
+	long long		size;
+
+	size = cvtnum(geo->blocksize, geo->sectsize, size_str);
+	if (size == -1)
+		return strtoll(size_str, NULL, 10);
+	return size / geo->blocksize;
+}
+
 int
 main(int argc, char **argv)
 {
@@ -55,6 +69,9 @@ main(int argc, char **argv)
 	struct xfs_fsop_geom	ngeo;	/* new fs geometry */
 	int			rflag;	/* -r flag */
 	long long		rsize;	/* new rt size in fs blocks */
+	const char		*dsize_str = NULL;
+	const char		*lsize_str = NULL;
+	const char		*rsize_str = NULL;
 	int			xflag;	/* -x flag */
 	char			*fname;	/* mount point name */
 	char			*datadev; /* data device name */
@@ -77,7 +94,7 @@ main(int argc, char **argv)
 	while ((c = getopt(argc, argv, "dD:e:ilL:m:np:rR:t:xV")) != EOF) {
 		switch (c) {
 		case 'D':
-			dsize = strtoll(optarg, NULL, 10);
+			dsize_str = strdup(optarg);
 			fallthrough;
 		case 'd':
 			dflag = 1;
@@ -90,7 +107,7 @@ main(int argc, char **argv)
 			lflag = iflag = 1;
 			break;
 		case 'L':
-			lsize = strtoll(optarg, NULL, 10);
+			lsize_str = strdup(optarg);
 			fallthrough;
 		case 'l':
 			lflag = 1;
@@ -106,7 +123,7 @@ main(int argc, char **argv)
 			progname = optarg;
 			break;
 		case 'R':
-			rsize = strtoll(optarg, NULL, 10);
+			rsize_str = strdup(optarg);
 			fallthrough;
 		case 'r':
 			rflag = 1;
@@ -202,7 +219,7 @@ main(int argc, char **argv)
 			progname, fname);
 		exit(1);
 	}
-	if (rflag && (!xi.rt.dev && !geo.rtstart)) {
+	if (rflag && (!xi.rt.dev && !xi.nr_raid_devices & !geo.rtstart)) {
 		fprintf(stderr,
 			_("%s: failed to access realtime device for %s\n"),
 			progname, fname);
@@ -211,6 +228,13 @@ main(int argc, char **argv)
 
 	xfs_report_geom(&geo, datadev, logdev, rtdev);
 
+	if (dsize_str)
+		dsize = parse_size(&geo, dsize_str);
+	if (lsize_str)
+		lsize = parse_size(&geo, lsize_str);
+	if (rsize_str)
+		rsize = parse_size(&geo, rsize_str);
+
 	if (geo.rtstart) {
 		xfs_daddr_t rtstart = geo.rtstart * (geo.blocksize / BBSIZE);
 
diff --git a/man/man8/xfs_growfs.8 b/man/man8/xfs_growfs.8
index 2e329fa61758..d6e5fe13e943 100644
--- a/man/man8/xfs_growfs.8
+++ b/man/man8/xfs_growfs.8
@@ -57,6 +57,32 @@ The filesystem must be mounted to be grown (see
 .BR mount (8)).
 The existing contents of the filesystem are undisturbed, and the added space
 becomes available for additional file storage.
+The following lists possible multiplication suffixes for any argument specifying
+sizes.
+.RS
+.PD 0
+.HP
+.BR s "\ \-\ multiply by sector size (default = 512, see " \-s
+option below).
+.HP
+.BR b "\ \-\ multiply by filesystem block size (default = 4K, see " \-b
+option below).
+.HP
+.BR k "\ \-\ multiply by one kilobyte (1,024 bytes)."
+.HP
+.BR m "\ \-\ multiply by one megabyte (1,048,576 bytes)."
+.HP
+.BR g "\ \-\ multiply by one gigabyte (1,073,741,824 bytes)."
+.HP
+.BR t "\ \-\ multiply by one terabyte (1,099,511,627,776 bytes)."
+.HP
+.BR p "\ \-\ multiply by one petabyte (1,024 terabytes)."
+.HP
+.BR e "\ \-\ multiply by one exabyte (1,048,576 terabytes)."
+.PD
+.RE
+If no suffix is specified, the sizes are in file system blocks.
+.RE
 .SH OPTIONS
 .TP
 .BI "\-d | \-D " size
@@ -67,9 +93,8 @@ option is given, the data section is changed to that
 .IR size ,
 otherwise the data section is grown to the largest size possible with the
 .B \-d
-option. The size is expressed in filesystem blocks. A filesystem with only
-1 AG cannot be shrunk further, and a filesystem cannot be shrunk to the point
-where it would only have 1 AG.
+option. A filesystem with only 1 AG cannot be shrunk further, and a
+filesystem cannot be shrunk to the point where it would only have 1 AG.
 .B [NOTE: Only shrinking the last AG without removing it is implemented]
 .TP
 .B \-e
@@ -90,8 +115,7 @@ shrunk, or moved. If the
 .I size
 option is given, the log section is changed to be that
 .IR size ,
-if possible. The size is expressed in filesystem blocks.
-The size of an internal log must be smaller than the size
+if possible. The size of an internal log must be smaller than the size
 of an allocation group (this value is printed at
 .BR mkfs (8)
 time). If neither
@@ -124,9 +148,8 @@ Specifies that the real-time section of the filesystem should be grown. If the
 option is given, the real-time section is grown to that size, otherwise
 the real-time section is grown to the largest size possible with the
 .B \-r
-option. The size is expressed in filesystem blocks.
-The filesystem does not need to have contained a real-time section before
-the
+option. The filesystem does not need to have contained a real-time section
+before the
 .B xfs_growfs
 operation.
 .TP
-- 
2.53.0

