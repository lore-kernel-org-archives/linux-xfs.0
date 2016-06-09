Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BFCB27CA0
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 07:26:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 37D1FAC002
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 05:26:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4RAApZqmFM1opQMg (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 09 Jun 2016 05:26:42 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 365CB4DB08
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 12:26:41 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH] mkfs: better error with incorrect b/s value suffix usage
Date: Thu,  9 Jun 2016 14:26:35 +0200
Message-Id: <1465475195-19149-1-git-send-email-jtulak@redhat.com>
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

Cheers,
Jan
---
 mkfs/xfs_mkfs.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 955dcfd..2870f7b 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3615,9 +3615,21 @@ cvtnum(
 		return -1LL;
 
 	if (*sp == 'b')
-		return i * blksize;
+		if (!blksize) {
+			fprintf(stderr,
+_("Blocksize must be explicitly provided when using 'b' suffix.\n"));
+			usage();
+		} else {
+			return i * blksize;
+		}
 	if (*sp == 's')
-		return i * sectsize;
+		if (!sectsize) {
+			fprintf(stderr,
+_("Sectorsize must be explicitly provided when using 's' suffix.\n"));
+			usage();
+		} else {
+			return i * sectsize;
+		}
 
 	c = tolower(*sp);
 	switch (c) {
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
