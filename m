Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EA7B97CA0
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 08:27:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 62A18AC002
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 06:27:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MyXXDvoVKc4jKK3P (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 09 Jun 2016 06:27:46 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 454E88F4F7
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 13:27:46 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH v2] mkfs: better error with incorrect b/s value suffix usage
Date: Thu,  9 Jun 2016 15:27:41 +0200
Message-Id: <1465478861-8714-1-git-send-email-jtulak@redhat.com>
In-Reply-To: <1465475195-19149-1-git-send-email-jtulak@redhat.com>
References: <1465475195-19149-1-git-send-email-jtulak@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Jan Tulak <jtulak@redhat.com>

If user writes a value using b or s suffix without explicitly stating the size
of blocks or sectors, mkfs ends with a not helpful error about the value being
too small. It happens because we read the physical geometry after all options
are parsed.

So, tell the user exactly what is wrong with the input.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---

While adding entries into the mkfs input test, I found this issue, though it
may be only a documentation thing. When I give some option block/sector suffix
without specifying explicitly its size (for example, -l su=10b without -b
size=4096), I get an error that value 10b is too small.  Of course it is,
because, at the time, mkfs did not read physical geometry yet, so blocksize is
0. And 10*0 = 0.

I think that this is not something we need to change, but it should be better
documented. Maybe not manpage (where it can be overlooked if not written to
every option using the size and it might be that it already is somewhere down
there), but an error message should warn the user in case of using b or s
suffix incorrectly.

I'm open to suggestions for a better solution, though.

UPDATE:
Add { and } to fix a gcc warning about ambigious else branch.

Cheers,
Jan
---
 mkfs/xfs_mkfs.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index ed7800f..455bf11 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3614,10 +3614,24 @@ cvtnum(
 	if (sp[1] != '\0')
 		return -1LL;
 
-	if (*sp == 'b')
-		return i * blksize;
-	if (*sp == 's')
-		return i * sectsize;
+	if (*sp == 'b') {
+		if (!blksize) {
+			fprintf(stderr,
+_("Blocksize must be explicitly provided when using 'b' suffix.\n"));
+			usage();
+		} else {
+			return i * blksize;
+		}
+	}
+	if (*sp == 's') {
+		if (!sectsize) {
+			fprintf(stderr,
+_("Sectorsize must be explicitly provided when using 's' suffix.\n"));
+			usage();
+		} else {
+			return i * sectsize;
+		}
+	}
 
 	c = tolower(*sp);
 	switch (c) {
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
